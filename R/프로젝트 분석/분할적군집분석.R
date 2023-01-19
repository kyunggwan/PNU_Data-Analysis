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
data <- data[c("평균운행속도", "최고속도", "급감속건수") ]

# 데이터 확인
head(data)

### 단계 2: 유클리디안 거리 계산
idist <- dist(data)
head(idist)  ## 평균이 0인 데이터에 대해 오류가 발생

### 단계 3: 비계층적 군집분석
result <- kmeans(data, 3)
names(result)

### 단계 4: 군집분석 시각화
plot(hc, hang = -1)

### 단계 5: 군집 단위 테두리 생성
rect.hclust(hc, k = 3, border ="red")
