#암종류별 성별 분석
install.packages("dplyr")
library(dplyr)

#데이터 불러오기(암발생자수)
getwd()
setwd("C:/Rwork/04")

df <- read.csv("./03_암발생자수_.csv", sep = ",", header = TRUE, fileEncoding = "euc-kr")
head(df)

# 열명 변경
# "암종별", "성별", "연령별", "발생자수", "조발생률"
names(df) <- c("암종별", "성별", "연령별", "발생자수", "조발생률")
names(df) 

# 데이터셋 조회
# 1) 특정 변수 조회
# 벡터형식으로
t1 <- df$암종별
mode(t1)
class(t1)

# 2) 특정 열명을 사용하여 조회
t2 <- df['암종별']
mode(t2)
class(t2)

# 3) 특정 행 조회 :1행 조회
# 파이썬에서는 df[1,:]이고, R에서는 df[1,]이다
df[1,]

# 2, 4 행 조회
df[c(2,4),] 

# 4)특정행 제거 : 1행제거
# 파이썬에서는 -1하면 뒤에서 부터 봄, R에서는 -1하면 삭제함
df1 = df[-1,]
head(df1)

# 암 종류 확인
unique(df1$'암종별') # 중복제거

# 모든 암 제거하고, 연령별이 계인 데이터 추출
# 파이프 연산자(dplyr써야 쓸 수 있음) 
df2 <- df1 %>% 
          filter(암종별 != "모든 암(C00-C96)") %>%
          filter(연령별 == "계")

head(df2)
df3 = unique(df2$'암종별')

# 성별 분리
df21 <- df2 %>%
  filter(성별 == "계")

df22 <- df2 %>%
  filter(성별 != "계")

df21 <- df21[, c('암종별', '발생자수')]
df22 <- df22[, c('암종별', '성별', '발생자수')]

# 5) 특정행 열 조회
df1[1:3, c('암종별', '발생자수')]
df3[1:3, '암종별'] 
df3[1:3, c('암종별','발생자수')] 

# 열 데이터 타입 확인
# 파이썬에서는 df.info()
 str(df1)

# 값 변경 : - => 0
df1$발생자수 <- ifelse(df1$발생자수 == "-", 0, df1$발생자수)
df1$조발생률 <- ifelse(df1$조발생률 == "-", 0, df1$조발생률)
 
  
# 열 데이터타입 변경
df1$발생자수 <- as.numeric(df1$발생자수)
df1$조발생률 <- as.numeric(df1$조발생률)

# 필요한 부분만 보임
df21 <- df21[, c('암종별', '발생자수')]
df22 <- df22[, c('암종별', '성별', '발생자수')]


# 그래프 
library(ggplot2)
df22$발생자수 <- as.numeric(df22$발생자수)

qplot(y= 발생자수, data = df22)

 
ggplot(mapping =aes(x=암종별, y=발생자수, fill=발생자수), data=df21) +
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("암종별 발생자수")+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'), axis.text.x=element_text(angle=90, hjust=1))

ggplot(mapping =aes(x=암종별, y=발생자수, fill=성별), data=df22) +
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("암종별 성별 발생자수")+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'), axis.text.x=element_text(angle=90, hjust=1))
