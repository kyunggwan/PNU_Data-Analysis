#인구 동향
library(dplyr)

getwd()
setwd("C:/Rwork/04")
#데이터 불러오기(인구동향)
df <- read.csv("04_인구동향.csv",header = T, fileEncoding = 'euc-kr')
df
# 열명 확인
names(df)

# "행정구역별","시점","출생아수","사망자수","혼인건수","이혼건수"
names(df)<-c("행정구역별","시점","출생아수","사망자수","혼인건수","이혼건수")

#데이터구조확인
str(df)

#범주형 변경 시점 int -> category
df$시점 <- as.factor(df$시점)
str(df) 
mode(df$시점)
class(df$시점)

#결측치 확인
summary(df)


#결측치 내용 확인
df2 <- df %>% filter( !is.na( df$출생아수) )
unique(df2$행정구역별)


#결측치 제거
df3 <- na.omit(df)
df3
summary(df3)


# 결측치 값 대체
df4 <- df
df4$출생아수 <- ifelse(is.na(df4$출생아수), 0, df$출생아수)
summary(df4)

df4 <- df4 %>% replace(is.na(df4), 0)
df4

#반복을 통한 na값 처리
#na값 0으로 변경 : 반복문
col <- names(df)[3:6]
col

for(c in col){
  temp <- df[,c]
  temp <- ifelse(is.na(temp), 0, temp)
  df[,c] <- temp
}

summary(df)


# 자연 증가 수 처리
df$자연증가수 <- df$출생아수 - df$사망자수
df
 
# 전국 자료와 지역자료 분리, 저출산
df %>% filter(df$행정구역별 == "전국" & df$자연증가수 < 0)
df %>% filter(df$행정구역별 == "부산광역시" & df$자연증가수 < 0)

df %>% filter(df$행정구역별 == "부산광역시" & df$자연증가수 < 0) %>% select('시점')

df[df$행정구역별 == "전국" & df$자연증가수 < 0,]
df[df$행정구역별 == "전국" & df$자연증가수 < 0,]['시점']

#데이터 분석
table(df$행정구역별) 
table(df$시점)

# 기술통계분석, 연속형자료 - 요약 통계량
summary(df$출생아수)

# 기술통계분석, 연속형자료 - 산점도 그래프
plot(df$출생아수, df$혼인건수)

# 자료 나누기
dft <- df %>% filter(df$행정구역별 == '전국')
dfa <- df %>% filter(df$행정구역별 != '전국')

# 전국데이터 자연 증가수 그래프
install.packages("ggplot2")
library(ggplot2)

ggplot(mapping =aes(x=혼인건수, y=자연증가수), data=df) +
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("혼인건수별 자연증가")+
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'), axis.text.x=element_text(angle=90, hjust=1))

