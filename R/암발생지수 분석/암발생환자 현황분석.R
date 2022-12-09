# 경로 설정
getwd()
setwd("C:/Rwork/03")

## 해결문제
# 연령대별 성별 암발생자 현황분석
# • 모든 암에 대한 자료만 추출
#    dplyr 패키지 filter
# • 연령대 별 그룹핑
#    dplyr 패키지 group_by
# • 행인덱스 초기화
#     rownames(df) <- NULL

# 데이터 읽기
df <- read.csv("./03_암발생자수_.csv", sep = ",", header = TRUE, fileEncoding = "euc-kr")
head(df)

## 데이터 추출, 암 발생자 수
#dplr 패키지 설치
install.packages("dplyr")
library(dplyr)

# 열명 변경
names(df) <- c("암종별", "성별", "연령별", "2019년", "2019년_1")

# 모든 암에 대한 정보 추출
df21 <- subset(df, df$암종별 == "모든 암(C00-C96)")
df21


df %>% filter(!(연령별 %in% c("계", "연령미상")))





# 연령대에 연령미상, 계  라고 되어 있는 것들을 안고 싶다
df22 <- df%>%filter(df$암종별 == '모든 암(C00-C96)' &
                      !(연령별 %in% c("계", "연령미상")))

df22
