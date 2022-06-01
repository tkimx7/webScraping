library(dplyr)
library(rvest)

rm(list = ls())

options(digits.secs = 6)

run_ <- function() {

  df_ <- data.frame()
  
  for (i in 1:length(LETTERS)) {
    
    url1_        <-  paste0("http://www.eoddata.com/stocklist/NASDAQ/", 
                     LETTERS[i], ".htm")
    url2_        <-  paste0("http://www.eoddata.com/stocklist/NYSE/", 
                     LETTERS[i], ".htm")
    url3_        <-  paste0("http://www.eoddata.com/stocklist/OTCBB/", 
                     LETTERS[i], ".htm")
    
    print(paste0("PRINTING ", LETTERS[i], " FROM NASDAQ"))
    
    temp1_       <-  url1_       %>%
                     read_html() %>%
                     html_table()
    temp1_       <-  as.data.frame(temp1_[[6]]) 
    names(temp1_)<-  c("ticker", "name", "hi", "lo", "close", "vol", "diff", 
                       "na1"   , "ret" , "na2")
    temp1_       <-  temp1_ %>% select(c(1:2))
    temp1_       <-  temp1_ %>% mutate(exchange = "NASDAQ")
    
    print(paste0("PRINTING ", LETTERS[i], " FROM NYSE"))
    
    temp2_       <-  url2_       %>%
                     read_html() %>%
                     html_table()
    temp2_       <-  as.data.frame(temp2_[[6]]) 
    names(temp2_)<-  c("ticker", "name", "hi", "lo", "close", "vol", "diff", 
                       "na1"   , "ret" , "na2")
    temp2_       <-  temp2_ %>% select(c(1:2))
    temp2_       <-  temp2_ %>% mutate(exchange = "NYSE")

    print(paste0("PRINTING ", LETTERS[i], " FROM OTC"))
    
    temp3_       <-  url3_       %>%
                     read_html() %>%
                     html_table()
    temp3_       <-  as.data.frame(temp3_[[6]]) 
    names(temp3_)<-  c("ticker", "name", "hi", "lo", "close", "vol", "diff", 
                       "na1"   , "ret" , "na2")
    temp3_       <-  temp3_ %>% select(c(1:2))
    temp3_       <-  temp3_ %>% mutate(exchange = "OTC")
    
    df_          <-  bind_rows(df_, temp1_, temp2_, temp3_)
  }
  tickers_       <<- df_
  time_          <-  as.character(Sys.time())
  
  write.csv(tickers_, 
  paste0("C:\\Users\\kim_t\\Desktop\\algo\\tickers_", 
  substr(time_, 1,  10), "_", gsub("[[:punct:]]", "", substr(time_, 12, 22)), 
  ".csv"))
  
  existent_    <- vector()
  nonexistent_ <- vector()
  for (i in 1:dim(tickers_)[1]) {
    
    skip_ <- FALSE
    print(paste0(i, " out of ", dim(tickers_)[1]))
    
    tryCatch(
      
      temp_ <- quantmod::getQuote(tickers_$ticker[i]),
      
      error = function(e) { skip_ <<- TRUE}
    )
    if (skip_) { 
      
      print(paste0("Error at ", i))
      nonexistent_ <- c(nonexistent_, tickers_$ticker[i])
      next 
    }
    else {
      
      existent_ <- c(existent_, tickers_$ticker[i])
    }
  }
  existent_    <<- existent_
  nonexistent_ <<- nonexistent_
  
  write.csv(tickers_ %>% filter(ticker %in% existent_), 
  paste0("C:\\Users\\kim_t\\Desktop\\algo\\yahooTickers_", 
  substr(time_, 1,  10), "_", gsub("[[:punct:]]", "", substr(time_, 12, 22)), 
  ".csv"))
  
  write.csv(tickers_ %>% filter(ticker %in% nonexistent_), 
  paste0("C:\\Users\\kim_t\\Desktop\\algo\\yahooTickersMissing_", 
  substr(time_, 1,  10), "_", gsub("[[:punct:]]", "", substr(time_, 12, 22)), 
  ".csv"))
}
run_()
