# 기상개황 자료를 이용하여 월별 불쾌지수를 계산하고 불쾌지수가 높음이상인 월을 구하시오.
# 
# https://kosis.kr/statHtml/statHtml.do?orgId=735&tblId=DT_A1040&vw_cd=MT_ZTITLE&list_id=215_215A_735_73503_A&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE
# 
# 불쾌지수 공식
# 
# DI = 0.81 * Ta + 0.01 * RH * (0.99 * Ta - 14.3) + 46.3
# DI: 불쾌지수
# Ta: 건구온도(평균기온)
# RH: 상대습도(평균상대습도)
# 불쾌지수 단계
# 
# 매우높음: 80이상
# 높음: 75이상 80미만
# 보통: 68이상 75미만
# 낮음: 68미만

getwd()

df <- read.csv("04_기상개황.csv", header = T, fileEncoding = 'euc-kr')
df

## 칼럼 확인
names(df)

## 칼럼명 변경
names(df) = (c(
 "월별", "평균기온", "평균최고기온", "최고극값기온", "평균최저기온", "최저극값기온",   
 "강수량", "평균상대습도", "최소상대습도", "해면기압", "이슬점", "평균운량",    
 "일조시간", "최심신적설", "평균풍속바람",  "최대풍속바람", "최대순간풍속")) 

## 필요한 칼럼 추출 => 건구온도, 상대습도
df <- df[c("월별", "평균기온", "평균상대습도")]
df 

## 불쾌지수 공식
# 
# DI = 0.81 * Ta + 0.01 * RH * (0.99 * Ta - 14.3) + 46.3
# DI: 불쾌지수
# Ta: 건구온도(평균기온)
# RH: 상대습도(평균상대습도)
df$불쾌지수 = (df$평균기온 * 0.81) + (0.01* df$평균상대습도 * (0.99 * df$평균기온 - 14.3)) +46.3
df

## 불쾌지수 단계 설정
# 
# 매우높음: 80이상
# 높음: 75이상 80미만
# 보통: 68이상 75미만
# 낮음: 68미만
df$단계 <- ifelse(df$불쾌지수 >= 80, "매우높음",
                ifelse(df$불쾌지수 >= 75, "높음", 
                       ifelse(df$불쾌지수 >= 68, "보통", "낮음")))

# 시각화
library(ggplot2)
table(df$월별, df$단계)

# 연간 데이터로 변환
df <- df[2:13, ]
df

# 단계 테이블
table(df$단계)
dft <- table(df$단계)

# barplot으로 출력
barplot(dft)

# 월별 불쾌지수 단계
ggplot(mapping =aes(x=월별, y=단계, fill=월별), data=df) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("월별 불쾌지수 단계")
