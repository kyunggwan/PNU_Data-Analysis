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

# 연령대에 연령미상, 계  라고 되어 있는 것들을 안고 싶다
df %>% filter(!(연령별 %in% c("계", "연령미상")))

# 필요한 자료 추출
df22 <- df%>%filter(df$암종별 == '모든 암(C00-C96)' &
                      !(연령별 %in% c("계", "연령미상")))
df22

# 목록 중복제거해서 보기
unique(df22$연령별)



# 계 만듦
df22g <- df22 %>%
          group_by(연령대, 성별) %>%
          summarize(계 = sum(y2019년))

df22$y2019년 <- as.numeric(df22$y2019년)

# 연령대 생성
df22$연령대 <- ifelse(df22$연령별 %in% c("0-4세","5-9세","10-14세","15-19세","20-24세",
                                   "25-29세", "30-34세", "35-39세"), "30대 이하",
                    ifelse(df22$연령별 %in% c("40-44세", "45-49세", 
                                           "50-54세",  "55-59세"), "50대 이하",
                           ifelse(df22$연령별 %in% c("60-64세", "65-69세", "70-74세", 
                                                  "75-79세"), "60대이상", "80대이상")))
                           
# 시각화
qplot(연령대, data = df22, fill=성별)+
  ggtitle("연령대별 암환자수")
  theme(plot.title = element_text(hjust = 0.5, size = 20, face = 'bold'))
                       
  
      
