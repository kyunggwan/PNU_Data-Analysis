## 해결문제
# 국민건강보험 자료를 이용하여 대사 증후군을 구분하시오.
# • 높은 혈압(130/85mmHg 이상)
# • 높은 혈당(공복 혈당 100mg/dL 이상)
# • 높은 중성지방(150mg/dL 이상)
# • 낮은 HDL 콜레스테롤 수치(남성은 40mg/dL
#                   미만, 여성은 50mg/dL 미만)
# • 복부 비만(남성 90cm 이상, 여성 85cm 이상)

getwd()
setwd("C:/Rwork/06")


df <- read.csv("06_국민건강보험공단500.csv", header = T, fileEncoding = 'euc-kr')
head(df)

## 칼럼 확인
names(df)

## 칼럼명 변경
names(df) = (c("년도"  ,       "일련번호" ,         "시도코드" ,            "성별코드"  ,           "연령대코드",
               "신장" ,         "체중" ,            "허리둘레" ,            "시력좌"  ,         "시력우" ,           
                "청력좌" ,      "청력우" ,            "수축기혈압"   ,       "이완기혈압" ,      "공복혈당",  
                "총.콜레스테롤" ,  "트리글리세라이드" ,   "HDL콜레스테롤" ,      "콜레스테롤" ,      "혈색소"  ,            
                "요단백"  ,       "혈청크레아티닌" ,      "X.혈청지오티.AST" ,    "X.혈청지오티.ALT" ,    "감마.지티피" ,        
                "흡연상태"  ,      "음주여부",            "수검여부",   "치아우식증유무" ,      "치석" ,               
                "공개일자"     )) 

  ## 필요한 칼럼 추출 => 건구온도, 상대습도
df <- df[c("시도코드", "성별코드", "수축기혈압", "이완기혈압", "공복혈당",
           "트리글리세라이드", "HDL콜레스테롤", "허리둘레")]
  head(df)



## 결측치 자료가 있는 행을 모두 삭제
str(df)
is.na(df$트리글리세라이드)
df<- na.omit(df)

summary(df)
# 대사증후군을 판별
# 대사증후군을 판별하는 지도학습모델을 만들고 정확도
# • 높은 혈압(130/85mmHg 이상)
# • 높은 혈당(공복 혈당 100mg/dL 이상)
# • 높은 중성지방(150mg/dL 이상)
# • 낮은 HDL 콜레스테롤 수치(남성은 40mg/dL
#                   미만, 여성은 50mg/dL 미만)
# • 복부 비만(남성 90cm 이상, 여성 85cm 이상)


library(dplyr)

# • 높은 혈압(130/85mmHg 이상)
df$높은혈압 <- ((df$수축기혈압 >= 130) | (df$이완기혈압 >= 85 ))

# • 높은 혈당(공복 혈당 100mg/dL 이상)
df$높은혈당 <- (df$공복혈당 >= 100)

# • 높은 중성지방(트리글리세라이드 150mg/dL 이상)
df$높은중성지방 <- df$트리글리세라이드 >= 150

# • 낮은 HDL 콜레스테롤 수치(남성은 40mg/dL 미만, 여성은 50mg/dL 미만)
df$낮은콜레스테롤 <- ((df$성별코드 == 1) & (df$HDL콜레스테롤 < 40)) | ((df$성별코드 == 2) & (df$HDL콜레스테롤 < 50))

# • 복부 비만(남성 90cm 이상, 여성 85cm 이상)
df$복부비만 <- ((df$성별코드 == 1) & (df$허리둘레 >= 90)) | ((df$성별코드 == 2) & (df$허리둘레 >= 85))

## • 대사증후군을 판별
df$대사증후군 = df$높은혈압+
                df$높은혈당+
                df$높은중성지방+
                df$낮은콜레스테롤+
                df$복부비만
df$판별 <- ifelse(df$대사증후군 == 0, 1, 
               ifelse(df$대사증후군 <= 2, 2, 3) )

# 팩터 변경
names(df)
df$성별코드 <- as.factor(df$성별코드)
df$대사증후군 <- as.factor(df$대사증후군)
df$판별 <- as.factor(df$판별)
is.factor(df$판별)
head(df)

## • 대사증후군을 판별하는 지도학습모델을 만들고 정확도
#########모델 학습
#트리 모델 
install.packages("party")
library(party)
names(df1)

# 학습데이터 분리
df2 <- df
1:nrow(df2)
head(df2)

x <- sample(1:nrow(df2), 0.7 * nrow(df2))

train <- df2[x, ]
test <- df2[-x, ]

nrow(df2)
nrow(test)
nrow(train)


# 학습
model1 <- ctree(판별 ~  수축기혈압 + 이완기혈압 + 
                  공복혈당 + 트리글리세라이드 + 허리둘레, data=train)
model2 <- ctree(판별 ~  수축기혈압 + 이완기혈압 + 성별코드 +
                  공복혈당 + 트리글리세라이드 + 허리둘레, data=train)
plot(model1)

#예측 
pred1 <- predict(model1, test)
pred2 <- predict(model2, test)
# pred3 <- predict(model3, test)

#혼돈행렬
t1 <- table(test$대사증후군, pred1) 
t2 <- table(test$판별, pred2) 
t1
# 정확도
acc1 <- (t1[1,1] + t1[2,2] + t1[3,3]) / sum(t1)
acc2 <- (t2[1,1] + t2[2,2] + t2[3,3]) / sum(t2)

acc1
acc2

