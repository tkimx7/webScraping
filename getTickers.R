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
}
run_()
