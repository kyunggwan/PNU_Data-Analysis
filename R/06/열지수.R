## 해결문제
# 열지수는 기온과 습도에 따라 사람이 실제로
# 느끼는 더위를 지수화한 것으로 다음과 같은
# 공식으로 계산된다.
#
# • 열지수 = HI = 0.5 * {T + 61.0 + [(T-68.0)*1.2]
#   + (RH*0.094)}
#   ◦ T : 기온(°C), RH : 상대습도(%)
#
# • 지점명이 ’서울‘,’부산‘,’제주‘인 자료를 추출
#   ◦ 일자별 기온그래프 : 평균기온을 수평선으로 표시
#   ◦ 일자별 열지수 그래프 : 열지수 5를 수평선으로 표시
#
# • 일자별로 그룹핑하여 열지수가 5이하인 자료를
# 추출하시오.

getwd()
setwd("C:/Rwork/06")

df <- read.csv("06_지상관측.csv", header = T, fileEncoding = 'euc-kr')
head(df)

## 칼럼 확인
names(df)

## 칼럼명 변경
names(df) = (c("지점", "지점명", "일시",            
               "기온", "풍속", "상대습도")) 

# • 열지수 = HI = 0.5 * {T + 61.0 + [(T-68.0)*1.2] + (RH*0.094)}
#   ◦ T : 기온(°C), RH : 상대습도(%)

df$열지수 <- 0.5 * {df$기온 + 61.0 + (df$기온-68.0)*1.2 + (df$상대습도*0.094) }
head(df)


# 시각화
library(ggplot2)
library(dplyr)
# • 지점명이 ’서울‘,’부산‘,’제주‘인 자료를 추출
df2 <- subset(df, df$지점명 == '서울' | df$지점명 == '부산' | df$지점명 == '제주')
df2

#   ◦ 일자별 기온그래프 : 평균기온을 수평선으로 표시
ggplot(mapping =aes(x=일시, y=기온, fill=지점명), data=df2) +
  geom_bar(stat="identity", position=position_dodge()) +
  geom_hline(yintercept = mean(df$기온), col='red')+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("일자별 기온그래프")

#   ◦ 일자별 열지수 그래프 : 열지수 5를 수평선으로 표시
ggplot(mapping =aes(x=일시, y=열지수, fill=지점명), data=df2) +
  geom_bar(stat="identity", position=position_dodge()) +
  # geom_line(linetype = "dashed", size = 2)+
  geom_hline(yintercept = (df$열지수=5), col='red')+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("일자별 열지수그래프")

# 일자별로 그룹핑하여 열지수가 5이하인 자료를 추출하시오
df3 <- df2
df3 <- subset(df3, df3$열지수 <=5)
df3

  