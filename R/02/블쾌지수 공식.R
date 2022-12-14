# 기상개황 자료를 분석하여 월별 불쾌지수와 단계
# https://kosis.kr/statHtml/statHtml.do?orgId=735&tblId=DT_A1040&vw_cd=MT_ZTITLE&list_id=215_215A_735_73503_A&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE
# 불쾌지수 공식
# DI = 0.81 * Ta + 0.01 * RH(0.99 * Ta - 14.3) + 46.3
# DI: 불쾌지수
# Ta: 건구온도(평균기온)
# RH: 상대습도(평균상대습도)
# 불쾌지수 단계
# 매우높음: 80이상
# 높음: 75이상 80미만
# 보통: 68이상 75미만
# 낮음: 68미만

getwd()

df <- read.csv("./02_기상개황.csv", header = TRUE, fileEncoding = "euc-kr")
df

# 항목 보기
names(df)

# 필요한 열 추출
df <- df[c("월별.1.", "평균기온....", "평균상대습도....")]

# 열 이름 바꾸기
names(df) <- c("월별", "기온", "상대습도")

# 불쾌지수 공식
df$불쾌지수 <- (0.81*df$기온)+(0.01*df$상대습도*(0.99*df$기온-14.3))+46.3

df$단계 <- ifelse(df$불쾌지수 >= 80, "매우높음",
                ifelse(df$불쾌지수 >=75, "높음",
                       ifelse(df$불쾌지수 >= 68, "보통", "낮음")))


# 시각화
install.packages("ggplot2")
library(ggplot2)


#연간 자료 이므로 작년 데이터인 10, 11, 12월 자료를 빼줌
df <- df[2:13, ]
df

# 단계 테이블
table(df$단계)
dft <- table(df$단계)

# barplot으로 출력
barplot(dft)

# 데이터 프레임
dft2 <- as.data.frame(dft)
class(dft2)
dft2

# 단계별
ggplot(mapping =aes(x=Var1, y=Freq, fill=Var1), data=dft2) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))

# 월별 불쾌지수
ggplot(mapping =aes(x=월별, y=불쾌지수, fill=월별), data=df) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))
