getwd()
setwd("C:/Rwork/06")

# # 해결문제
# 체감온도는 인간이 느끼는 더위나 추위를
# 수량적으로 나타낸 것으로 겨울철 체감온는
# 다음과 같은 공식으로 계산된다.
#
# • 체감온도 = 13.12 + 0.6215*T –
# 11.37*V*0.16 + 0.3965*V*0.16*T
# ◦T : 기온(°C), V : 풍속(km/h)
#
# • 열명을 '지점', '지점명', '일시', '기온', '풍속',
# '상대습도'로 변경하여 작성하시오.
#
# • 겨울철 체감온도는 기온 10°C 이하, 풍속 1.3
# m/s 이상인 날이다. 부산지역의 겨울철
# 체감온도에 해당되는 자료를 추출하여
# 그래프를 그리시오.

df <- read.csv("06_지상관측.csv", header = T, fileEncoding = 'euc-kr')
head(df)

## 칼럼 확인
names(df)

## 칼럼명 변경
names(df) = (c("지점", "지점명", "일시",            
               "기온", "풍속", "상대습도")) 

# 풍속 환산
df$풍속환산 <- round(df$풍속 * 3.6,2)

## 체감온도 공식
# 
# • 체감온도 = 13.12 + 0.6215*T –
# 11.37*V*0.16 + 0.3965*V*0.16*T
# ◦T : 기온(°C), V : 풍속(km/h)
df$체감온도 = 13.12 + 0.6215*df$기온 - 11.37*df$풍속*0.16 +
  0.3965*df$풍속*0.16*df$기온
# df$체감온도 <- round(df$체감온도 * 3.6,2)
head(df)


# • 겨울철 체감온도는 기온 10°C 이하, 풍속 1.3
# m/s 이상인 날이다.
library(dplyr)
dfb <- df %>%
          filter(지점명 == "부산" & 기온 <= 10 & 풍속 >= 13)  

df2 <- subset(df,df$일시 == df$일시  & df$지점명 == "부산" & df$기온 <= 10 & df$풍속 >= 1.3)
head(df2)


# 시각화
library(ggplot2)

# 부산지역 체감온도
ggplot(mapping =aes(x=일시, y=체감온도, fill=일시), data=df2) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("부산지역 체감온도")

ggplot(mapping =aes(x=일시, y=체감온도, fill=일시), data=dfb) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("부산지역 체감온도")

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

df3 <- df
df3$열지수 <- 0.5 * {df3$기온 + 61.0 + (df3$기온-68.0)*1.2 + (df3$상대습도*0.094) }
head(df3)


# 시각화
library(ggplot2)
library(dplyr)
# • 지점명이 ’서울‘,’부산‘,’제주‘인 자료를 추출
df4 <- subset(df3, df3$지점명 == '서울' | df3$지점명 == '부산' | df3$지점명 == '제주')
df4

#   ◦ 일자별 기온그래프 : 평균기온을 수평선으로 표시
ggplot(mapping =aes(x=일시, y=기온, fill=지점명), data=df4) +
  geom_bar(stat="identity", position=position_dodge()) +
  geom_hline(yintercept = mean(df$기온), col='red')+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("일자별 기온그래프")

#   ◦ 일자별 열지수 그래프 : 열지수 5를 수평선으로 표시
ggplot(mapping =aes(x=일시, y=열지수, fill=지점명), data=df4) +
  geom_bar(stat="identity", position=position_dodge()) +
  # geom_line(linetype = "dashed", size = 2)+
  geom_hline(yintercept = (df$열지수=5), col='red')+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("일자별 열지수그래프")

# 일자별로 그룹핑하여 열지수가 5이하인 자료를 추출하시오
df5 <- df4
df5 <- subset(df5, df5$열지수 <=5)
df5

