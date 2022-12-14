# 경로 세팅
getwd()
setwd( "C:/Rwork/02")

##해결 문제
# https://www.news1.kr/articles/?4695261
# 최근 3년간 역주행 교통사고의 치명률이 10.2%로 일반 교통사고(4.7%)
# 보다 2.3배 높은 것으로 나타났다고 한다. 다음 주어진 데이터를 활용하여
# 이를 분석해 본다.
# 년도별 치명률 구하기
# 3년 평균 사고건수, 사망자수, 치명률(사망자수/사고건수) 구하기

# 엑셀 파일 패키지 설치
install.packages("readxl")
library(readxl)

# 엑셀파일 불러오기
acident <- read_excel(path = "02_역주행사고.xlsx")
acident

# 테이블 분리 방법1
acident1 <- subset(acident,구분 == "역주행")
acident2 <- subset(acident,구분 == "전체")
acident1
acident2

# 테이블 분리 방법 2(인덱스로 분리)
acident4 <- acident[acident$구분 == "역주행",]
acident4

acident$치명률 <- (acident$사망 / acident$사고) * 100
acident

# 일반 교통사고
acident3 <- acident1
acident3$구분 <- "일반"
acident3

acident1[c("사고", "사망")]
acident2[c("사고", "사망")]
acident3[c("사고", "사망")] <-acident2[c("사고", "사망")] - acident1[c("사고", "사망")]

acident3

# 치명률 계산
acident1$치명률 <- round(acident1$사망 / acident1$사고 * 100, 2)
acident2$치명률 <- round(acident2$사망 / acident2$사고 * 100, 2)
acident3$치명률 <- round(acident3$사망 / acident3$사고 * 100, 2)

# 기초 통계
summary(acident1)
summary(acident2)
summary(acident3)
# 수치데이터와 범주데이터를 구분할 수 있어야 한다.
# 머신 러닝을 돌릴 때 수치 값을 예측하면 회귀분석, 범주면 분류데이터

mean(acident2$치명률)
mean(acident3$치명률)

cat("최근 3년간 역주행 교통사고의 치명률이",
round(mean(acident1$치명률),1),
"%로 일반 교통사고(",
round(mean(acident3$치명률),1),
"%)보다",
round(mean(acident1$치명률),1) / round(mean(acident3$치명률),1),
"배 높은 것으로 나타났다.")

# 시각화
install.packages("ggplot2")
library(ggplot2)

# position은 좀 떨어뜨려서 하나씩 잘 보게함
ggplot(mapping =aes(x=년도, y=사고, fill=구분), data=acident) +
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle('년도별 사고건수')+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))


