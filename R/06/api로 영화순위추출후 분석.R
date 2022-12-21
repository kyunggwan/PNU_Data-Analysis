install.packages("jsonlite")
library(jsonlite)

apikey <- "f5eef3421c602c6cb7ea224104795888"
dt <- "20221220"
url <- paste("http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?",
               "key=",apikey,
               "&targetDt=" , dt, sep=""          
               )
url

mv <- fromJSON(url)
mv

class(mv)
mode(mv)

# 박스오피스 목록 추출
BoxOfficeList <- mv$boxOfficeResult$dailyBoxOfficeList
BoxOfficeList

# 데이터형 변환 : 수치데이터 변환
names(BoxOfficeList)
str(BoxOfficeList)

## 수치 데이터형이 아닌 부분을 제외해 준다
col <- c("rnum",      "rank",       "rankInten",  "rankOldAndNew", "movieCd",         
             "salesAmt",   "salesShare", "salesInten",    "salesChange", "salesAcc",   
          "audiCnt",  "audiInten",  "audiChange", "audiAcc",       "scrnCnt",     "showCnt")

## BoxOfficeList에서 수치형인 부분들을 가공하도록 unlist하고 numeric해준다
for (c in col){
  BoxOfficeList[c] <- as.numeric(unlist(BoxOfficeList[c]))
}

# 매출평균보다 매출이 높은 영화
library(dplyr)

# select는 선택, filter는 조건
BoxOfficeList %>% 
        filter(salesAmt > mean(salesAmt)) %>%
        select(rank, movieNm, salesAmt)

mean(BoxOfficeList$salesAmt)

# 날짜를 주면 해당 요일에 영화 목록을 추출해주는 함수
box <- function(dt){
  
  apikey <- "f5eef3421c602c6cb7ea224104795888"
  url <- paste("http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?",
               "key=",apikey,
               "&targetDt=" , dt, sep=""          
  )
  mv <- fromJSON(url)

  # 박스오피스 목록 추출
  BoxOfficeList <- mv$boxOfficeResult$dailyBoxOfficeList
  return(BoxOfficeList)
}

## 만든 함수 출력
box("20221210")
