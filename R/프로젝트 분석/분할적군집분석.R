## 경로 설정
getwd()
setwd("C:/Git/Data_analysis/R/프로젝트 분석")

## 군집분석(Clustering)을 위한 패키지 설치
install.packages("cluster")
library(cluster)

### 단계 1: 데이터셋 가져오기
data <- read.csv("상관분석R.csv", header = TRUE)
head(data)

## 필요 칼럼만 호출
# 칼럼 보기
names(data)

# 필요 칼럼만 호출
data <- data[c("평균운행속도", "최고속도", "급가속건수", "급출발건수", "급감속건수", "급좌회전건수") ]
data$평균운행속도 <- as.numeric(data$평균운행속도)

# 데이터 확인
head(data)

### 단계 2: 유클리디안 거리 계산
idist <- dist(data)
  head(idist)  ## 평균이 0인 데이터에 대해 오류가 발생

# 단계 3: 계층적 군집분석
hc <- hclust(idist)
hc

# 단계 4: 군집분석 시각화
plot(hc, hang = -1)

# 단계 5: 군집 단위 테두리 생성
rect.hclust(hc, k = 6, border ="red")




summary(idist)
### 단계 3: 비계층적 군집분석
result <- kmeans(data, 3)
names(result)
str(data)
result$cluster

# 변수 간의 상관계수 보기 
cor(data, method = "pearson")

### 단계 4: 군집분석 시각화
plot(result, hang = -1)

plot(data$평균운행속도, data$급좌회전건수, col = result$cluster)

### 단계 5: 군집 단위 테두리 생성
rect.hclust(result, k = 1, border ="red")
