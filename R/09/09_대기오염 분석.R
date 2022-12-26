#한국환경공단_에어코리아_대기오염통계 현황
#시도별 실시간 평균정보 조회 상세기능명세
#최근 한달간 지역별 일평균 대기오염 정보
#기준초과인경우 
#https://www.airkorea.or.kr/web/contents/contentView/?pMENU_NO=132&cntnts_no=6

#json처리
install.packages("jsonlite") 
library(jsonlite)

#자료처리
library(dplyr)

#데이터 가져오기함수
getData <- function(item, gubun) {
  
  apikey <- "VAoTrkbH%2FSGjNYtMCZRVCtF9WlsrxxLRPZLdsdfvO9hMFYfJG9OBW1sji%2FJ1jO%2B0xDHBrDHIDfR1jc3t9C0pQw%3D%3D"
  url <- paste("http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?",
               "itemCode=",item,
               "&dataGubun=",gubun,
               "&searchCondition=MONTH",
               "&pageNo=1&numOfRows=100&returnType=json&service",
               "Key=",apikey, sep=""
  )
 
  air <- fromJSON(url)
 
   # 도시별 수치 추출
  city<- air$response$body$items
  return(city)
}

#1. pm10, O3 데이터 추출하여 합치기
pm10 <- getData("pm10", "DAILY")
O3 <- getData("O3", "DAILY" )

df <- bind_rows(pm10, O3)
head(df)


#2. 지역명 벡터
area <- c("seoul", "busan", "daegu","incheon","gwangju",
          "daejeon", "ulsan", "gyeonggi", "gangwon",
          "chungbuk", "chungnam", "jeonbuk", "jeonnam",
          "gyeongbuk", "gyeongnam", "jeju", "sejong")
areaname <- c("서울","부산","대구","인천","광주","대전",
              "울산","경기","강원","충북","충남","전북",
              "전남","경북","경남","제주","세종")

length(area)
length(areaname)

#### 데이터 출력
dft <- data.frame()
for ( i in 1:length(area) ){
  t <- df[c("dataTime", "itemCode", area[i])]
  t$area <- areaname[i]
  names(t) <- c("dataTime", "itemCode", "item", "area")
  dft <- bind_rows(dft, t)
}
head(dft)
tail(dft)

##### 데이터 출력방식 연습
# for( i in 1:length(area)){
#  print(paste(i, area[i], areaname[i])) 
# }

#3. 통합데이터프레임 만들기
# dft <- data.frame()
# temp <- data.frame()

## unlist를 하면 스칼라 형태의 데이터를 벡터형태로 변환
## 열에 대한 정보들을 추가한다
#  for( i in 1:length(area)){
#     temp <- c()
#    temp$dataTime  <- unlist(df["dataTime"])
#    temp$itemCode <- unlist(df["itemCode"])
#    temp$area <- areaname[i]
#    temp$item <- unlist(df[area[i]])
#     }
# 
# dft <- bind_rows(dft, temp)


##########4.주의보
#https://www.airkorea.or.kr/web/dustForecast?pMENU_NO=113
# 예측 농도 PM10일때, 0~30 좋음, 31 ~ 80 보통, 81~150 나쁨, 151이상 매우나쁨
# 예측 농도 O3일때, 0~0.03 좋음, 0.031~0.090 보통, 0.091~0.150 나쁨, 0.151이상

str(dft)
## 데이터 분류 시에 데이터 타입 정리할것
## 숫자형인지 범주형인지
# factor가 아닌 상태에서 구분하라고 하면 숫자 계산하라는 줄 알고 
# 소수점 엄청 나오는 이상한 값을 반환하니까 이거 숫자 아니고 범주형이라고 구분해주는거
dft$item <- as.numeric(dft$item)

dft$기준 <- ifelse(dft$itemCode == "PM10",
                 ifelse(dft$item <= 30,"좋음",ifelse(dft$item <= 80,"보통",ifelse(dft$item <= 150, "나쁨","매우나쁨"))),
                 ifelse(dft$item <= 0.03,"좋음",ifelse(dft$item <= 0.09,"보통",ifelse(dft$item <= 0.15, "나쁨","매우나쁨"))))

#5.일자별 주의보정보
library(ggplot2)
names(dft)

dfn <- table(dft$dataTime, dft$기준)

dfn1 <- as.data.frame.matrix(dfn)
dfn2 <- as.data.frame(dfn)

names(dfn2) <- c("일자", "기준", "기준수")
ggplot(dfn2, aes(x=일자, y =기준수, group=기준, color=기준)) +
  geom_line() +
  geom_point() +
  labs(x="", y="")+
  theme(axis.text.x=element_text(angle=90, hjust=1))

#5.지역별 PM10이 좋음인 날 수 
names(dft)
str(dft)

###방법 group_by()를 이용한 방법
# group_by() 는 출력결과를 데이터프레임의 업그레이드 버전인 tibble 형태로 만들어줌
dfPM10 <- dft %>%    # dft자료를
    group_by(area) %>%   # area로 묶는다
        filter(itemCode=="PM10" & 기준 == "좋음") %>%  # 조건을 작성
              summarize(n=n())


ggplot(dfPM10, aes(x=area, y =n, fill=area)) +
  geom_bar(stat="identity") +
  labs(x="", y="")+
  theme(axis.text.x=element_text(angle=90, hjust=1))
