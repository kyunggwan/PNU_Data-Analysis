## 해결문제
# 1. BMI 지수 산출
# 2. 비만도 판별
# 3. 지도학습 모델 • BMI 예측 • 비만도 예측
# BMI = 체중(kg) / (키(m) x키(m))


getwd()
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

## 칼럼 추출
df <- df[c("년도", "성별코드", "신장", "체중")]
summary(df) # 빈칸이 없군

## 1. BMI 수치 생성
df$BMI <- df$체중/(df$신장/100 * df$신장/100) 

## 2. 비만도 생성, 판별
# 저체중 :	20미만
# 정상 :	20이상 24미만
# 과체중 :	25이상 29미만
# 비만 :	30이상
df$비만도 <- ifelse(df$BMI < 20 , "저체중",
                 ifelse(df$BMI < 24, "정상",
                 ifelse(df$BMI < 29, "과체중", "비만")))


## 3.지도학습 모델 • BMI 예측 • 비만도 예측
# 팩터 변경
# df$성별코드 <- as.factor(df$성별코드)
df$비만도 <- as.factor(df$비만도)

is.factor(df$비만도)

#학습데이터와 테스트데이터 분리
df2 <- df
x <- sample(1:nrow(df2), 0.7 * nrow(df2))

train <- df2[x, ]
test <- df2[-x, ]

nrow(df2)
nrow(test)

##########회귀모델 
names(df2)

#학습
model1 <- lm(formula = BMI ~  성별코드 + 신장 + 체중, data=train)

#예측
pred1 <- predict(model1, test)


#평가
#RMSE : sqrt((실제 - 예측)^2의 평균)
RMSE1 <- sqrt(mean((test$BMI - pred1)^2))

cat("예측1: ",RMSE1)

# ############# 분류모델
# # install.packages("party")
library(party)

# # 학습
model4 <- ctree(비만도 ~  BMI +신장 + 체중 + 성별코드, data=train)
plot(model4)
 
# #예측 
pred <- predict(model4, test)

# #혼돈행렬
t1 <- table(test$비만도, pred) 
t1

# # 정확도 
acc <- (t1[1,1] + t1[2,2] + t1[3,3]) / sum(t1)

acc
