# 경로 설정
getwd()
setwd("C:/Rwork/03")

## 해결 문제
# 치매환자현황분석
# ◦거주지역별 치매환자 빈도표를 구하고 그래프작성
#    qplot()
# ◦기준일자와 진단일자를 이용하여 진단일수를 계산하고 평균 진단일수 산출
#   날짜형으로 변환 : as.Date()
#   날짜사이 간격 : difftime(시작일, 종료일, units =＇days’)
#   units = 'mins’ 분단위, units = 'secs’ 초단위
# ◦연령대별 빈도수 그래프를 그려서 치매환자가 많은 연령대 분석
#   열 내용에 문자열 붙이기 : paste(열, “대“, sep=“”)
#   100세 이상은 90대에 포함

# 데이터 읽기
df <- read.csv("./03_치매환자현황.csv", sep = ",", header = TRUE, fileEncoding = "euc-kr")
head(df)

# 열 이름 확인
names(df)

# 거주지역 별 치매환자 확인
table(df$거주지역, df$번호)

install.packages("ggplot2")
library(ggplot2)

# 거주지역별 치매환자 그래프
qplot(거주지역, data=df, fill=거주지역)+
  ggtitle("거주지역별 치매환자")
  theme(plot.title = element_text(hjust = 0.5, size = 20, face = 'bold'))

# 날짜 형식 변환  
class(df$진단일자)
df$진단일자 <- as.Date(df$진단일자) 

# 진단일수를 계산하고 평균 진단일수 산출
head(df)
df$진단일수 <- difftime(df$데이터기준일자, df$진단일자, units='days')

# 연령대별 빈도수 그래프를 그려서 치매환자가 많은 연령대 분석
# year()함수 사용을 위한패키지
install.packages('lubridate')
library('lubridate')

# 연도
df$연도 <- year(df$진단일자)

# 나이
df$나이 <- df$연도 - df$출생년도

#연령대
df$연령대 <- ifelse(df$나이 >= 90, "90대", 
                ifelse(df$나이 >= 80, "80대",
                    ifelse(df$나이 >= 70, "70대",
                       ifelse(df$나이 >= 60, "60대",
                          ifelse(df$나이 >= 50, "50대",
                             ifelse(df$나이 >= 40, "40대",
                                ifelse(df$나이 >= 30, "30대",
                                   ifelse(df$나이 >= 20, "20대",
                                      ifelse(df$나이 >= 10, "10대","어린이")))))))))


# 시각화를 위한 ggplot2패키지
install.packages("ggplot2")
library(ggplot2)

# 시각화
qplot(연령대, data=df, fill=연령대)+
  ggtitle("연령대별 빈도수")

# 조금 다른 방식으로 해봄
# 나이대
df$나이대 <- paste((df$나이%/%10)*10, "대", sep="")

# 100세 이상은 90대에 넣음
df$나이대 <- paste(ifelse((df$나이%/%10)*10>=100,90,(df$나이%/%10)*10), "대", sep="")

#나이대로 시각화
barplot(table(df$나이대))


##빈도표
# 거주지역별 치매환자 빈도표
table(df$거주지역)
table(df$성별)
tb1 <- table(df$거주지역, df$성별)
tb1

# tb1은 테이블 형태
class(tb1)

# tb1을  데이터프레임형태로 형변환
tb1 <- as.data.frame(tb1)

# 시각화
qplot(Var1, Freq, data=tb1, fill=Var2)+
  ggtitle("거주지역별 치매환자")
  theme(plot.title = element_text(hjust = 0.5, size = 20, face = 'bold'))
