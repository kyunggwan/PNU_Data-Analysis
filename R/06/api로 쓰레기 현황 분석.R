## 공공데이터로 쓰레기 현황 분석

trash <- function(year){
  
  apikey <- "VAoTrkbH%2FSGjNYtMCZRVCtF9WlsrxxLRPZLdsdfvO9hMFYfJG9OBW1sji%2FJ1jO%2B0xDHBrDHIDfR1jc3t9C0pQw%3D%3D"
  
  cityCode <- "W10"
  # year <- "2020"
  month <- "08"
  url <- paste("http://apis.data.go.kr/B552584/RfidFoodWasteServiceNew/getTotalDateList?Service",
                "Key=",apikey,
                "&type=json&page=1&rowNum=2&dis",
                "Year=",year,
                "&disMonth=",month, sep="")
  
  # # Json 추출
  tr <- fromJSON(url)

  ## list 자료 출력
  answer <- tr$data$list
  return (answer)
}

## 2020년 8월 자료 출력
trash("2020")
## 2021년 8월 자료 출력
trash("2021")
## 2022년 8월 자료 출력
trash("2022")


