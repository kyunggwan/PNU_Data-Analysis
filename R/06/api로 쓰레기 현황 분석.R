## 공공데이터로 쓰레기 현황 분석

trash <- function(year, month){
  
  apikey <- "VAoTrkbH%2FSGjNYtMCZRVCtF9WlsrxxLRPZLdsdfvO9hMFYfJG9OBW1sji%2FJ1jO%2B0xDHBrDHIDfR1jc3t9C0pQw%3D%3D"
  
  cityCode <- "W10"
  # year <- "2020"
  # month <- "08"
  url <- paste("http://apis.data.go.kr/B552584/RfidFoodWasteServiceNew/getTotalDateList?Service",
                "Key=",apikey,
                "&type=json&page=1&rowNum=30&dis",
                "Year=",year,
                "&disMonth=",month, sep="")
  
  # # Json 추출
  tr <- fromJSON(url)

  ## list 자료 출력
  answer <- tr$data$list
  return (answer)
}

## 2020년 8월 자료 출력
df2020 <- trash("2020", "08")
## 2021년 8월 자료 출력
df2021 <- trash("2021", "08")
## 2022년 8월 자료 출력
df2022 <- trash("2022", "08")

# 데이터 합치기
# df <- bind_rows(df2020, df2021, df2022)
df <- rbind(df2020, df2021, df2022)
df


###### 년도별 자료 추출
# 데이터 프레임 생성
dft2022 <- data.frame();
dft2021 <- data.frame();
dft2020 <- data.frame();

for (i in 1:12){
  if (i < 10) { m = paste("0", i, sep="")}
  else m = as.character(i);
  
  temp2022 <- trash("2022", m)
  temp2021 <- trash("2021", m)
  temp2020 <- trash("2020", m)
  
  dft2022 <- bind_rows(dft2022, temp2022)
  dft2021 <- bind_rows(dft2021, temp2021)
  dft2020 <- bind_rows(dft2020, temp2020)
}

head(dft2022)
head(dft2021)
head(dft2020)

library(dplyr)
dft <- bind_rows(dft2020, dft2021, dft2022)
head(dft)
dft <- rbind(dft2020, dft2021, dft2022)



####### 데이터 열 생성
# mutate = 열 생성
df %>% 
      mutate(disweek = case_when(disDay == 1 ~ "일",
                                 disDay == 2 ~ "월",
                                 disDay == 3 ~ "화",
                                 disDay == 4 ~ "수",
                                 disDay == 5 ~ "목",
                                 disDay == 6 ~ "금",
                                 disDay == 7 ~ "토"
      ))

######## 시각화
library(ggplot2)

# 8월의 쓰레기 배출량을 년도별로
ggplot(mapping =aes(x=disDate, y=disQuantity, fill=disYear), data=df) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("8월의 쓰레기 배출량")

# 년도별 쓰레기 배출량
ggplot(mapping =aes(x=disYear, y=disQuantity, fill=disYear), data=dft) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("년도별 배출량")

# 배출 요일 별 쓰레기 배출량
ggplot(mapping =aes(x=disDay, y=disQuantity, fill=disYear), data=dft) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("배출요일별 쓰레기 배출량")

# 월별 쓰레기 배출량
ggplot(mapping =aes(x=disMonth, y=disQuantity, fill=disYear), data=dft) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("월별 쓰레기 배출량")


# 월별 쓰레기 배출횟수
ggplot(mapping =aes(x=disMonth, y=disCount, fill=disYear), data=dft) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5,size=20,face='bold'))+
  ggtitle("월별 쓰레기 배출횟수")

# # 요일별 일평균 배출량 
ggplot(data=df, aes(x= disDay, y=disQuantity, group=disYear, col = disYear)) +
  geom_line()+
  geom_point()+
  ggtitle('요일별 일평균배출량')+
  theme(plot.title = element_text(hjust =0.5,size=20,face='bold'))+
  scale_x_discrete(limits=c('일','월','화','수','목','금','토'))
