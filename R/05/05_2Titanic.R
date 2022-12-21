#타이타닉 데이터
#https://www.kaggle.com/c/titanic/overview

#데이터불러오기
getwd()
setwd("C:\Rwork\05")

df <- read.csv("./05_titanic.csv", 
                  header = T, 
                  stringsAsFactors = F, 
                  fileEncoding = 'euc-kr') 
head(df)
#데이터구조
str(df)

names(df)
# PassengerID	승객을 구별하는 고유 ID number	Int
# Survived	승객의 생존 여부를 나타내며 생존은 1, 사망은 0 입니다.	Factor
df$Survived <- as.factor(ifelse(df$Survived == 0, df$Survived <- "NO", "YES"))

# Pclass	선실의 등급으로서 1등급(1)부터 3등급(3)까지 3개 범주입니다.	Ord.Factor
df$Pclass <- as.factor(df$Pclass)

# Name	승객의 이름	Factor
df$Name <- as.factor(df$Name)

# Sex	승객의 성별	Factor
df$Sex <- as.factor(df$Sex)

# Age	승객의 나이	Numeric
df$Age <- as.numeric(df$Age)

# SibSp	각 승객과 동반하는 형제 또는 배우자의 수를 설명하는 변수이며 0부터 8까지 존재합니다.	Integer
df$SibSp <- as.integer(df$SibSp)

# Parch	각 승객과 동반하는 부모님 또는 자녀의 수를 설명하는 변수이며 0부터 9까지 존재합니다.	Integer
df$Parch <- as.integer(df$Parch)

# Ticket	승객이 탑승한 티켓에 대한 문자열 변수	Factor
df$Ticket <- as.factor(df$Ticket)

# Fare	승객이 지금까지 여행하면서 지불한 금액에 대한 변수	Numeric
df$Fare <- as.numeric(df$Fare)

# Cabin	각 승객의 선실을 구분하는 변수이며 범주와 결측치가 너무 많습니다.	Factor
df$Cabin <- as.factor(df$Cabin)

# Embarked	승선항, 출항지를 나타내며 C, Q, S 3개 범주이다.	Factor
df$Embarked <- as.factor(df$Embarked)

# 결측치 확인
str(df)

sapply(df, FUN = function(x) {
  sum(is.na(x))
}) 
 
# 결측치 처리
# 평균값으로 대체
df$Age <- ifelse(is.na(df$Age) == TRUE, mean(df$Age, na.rm = TRUE), df$Age) 

# 성별에 따른 생존여부
library(ggplot2)
class(df$Survived)
mode(df$Survived)

ggplot_sex <- ggplot(df, aes(x = Survived,fill = Sex, width = .8)) + 
  geom_bar()
ggplot_sex

#Pclass	선실의 등급에 따른 생존여부
ggplot_Pclass <- ggplot(df, aes(x = Survived,fill = Pclass)) + 
  geom_bar()

ggplot_Pclass

#분류모델
names(df)
ta <- df[,c("Pclass", "Sex", "Age", "Survived")]
1:nrow(ta)
x <- sample(1:nrow(ta), 0.7 * nrow(ta))

train <- ta[x, ]
test <- ta[-x, ]

#학습
library(party)
model <- ctree(Survived ~ Pclass + Sex + Age, data = train)

#예측
pred <- predict(model, test)
 
#혼돈행렬
t <- table(test$Survived, pred)
t

#Accuracy
acc <- (t[1,1] + t[2,2]) /sum(t)
acc

