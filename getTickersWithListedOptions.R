#.rs.restartR()
rm(list = ls())

library(tictoc)
library(quantmod)
library(tidyverse)
library(data.table)

dir_    <- "C:\\Users\\kim_t\\Desktop\\algo\\yahooTickers_2022-03-21_00093884.csv"
tickers <- as.vector(unlist(read.csv(dir_) %>% select(ticker)))
miss    <- c()
exist   <- c()

tic(); for (i in 1:length(tickers)) {
  
  tic(); 
  
  err1 <- FALSE
  err2 <- FALSE
  
  tryCatch(
    
    temp <<- quantmod::getOptionChain(tickers[i]),
    
    error = function(e) { err1 <<- TRUE }
  )
  if (err1 == TRUE) { 
    
    print(paste0("Error at ", i, ": ", tickers[i]))
    miss <- c(miss, tickers[i]); next 
  }
  else if (length(temp) != 2) {
    
    print(paste0("Error at ", i, ": ", tickers[i]))
    miss <<- c(miss, tickers[i]); next
  }
  print(paste0("All good at ", i, ": ", tickers[i]))
  exist <<- c(exist, tickers[i])
  
  # options_ <<- rbindlist(list(
  # 
  # quantmod::getOptionChain(tickers[i])[[1]]                 %>% 
  # rownames_to_column("contract")                            %>%
  # mutate(ticker = tickers[i])                               %>%
  # rename(k   = Strike, last = Last, chg    = Chg, 
  #        bid = Bid   , ask  = Ask , volume = Vol, oi  = OI,
  #        timestamp = LastTradeTime, iv     = IV , itm = ITM),
  # 
  # quantmod::getOptionChain(tickers[i])[[2]]                 %>% 
  # rownames_to_column("contract")                            %>%
  # mutate(ticker = tickers[i])                               %>%
  # rename(k   = Strike, last = Last, chg    = Chg, 
  #        bid = Bid   , ask  = Ask , volume = Vol, oi  = OI,
  #        timestamp = LastTradeTime, iv     = IV , itm = ITM)
  # ))
  # tryCatch(
  #   
  #   write.csv(options_, paste0("C:\\Users\\kim_t\\Desktop\\data\\options\\", tickers[i], "\\options_", Sys.time(), ".csv")),
  #   error = function(e) { err2 <<- TRUE }
  # )
  # if (err2 == TRUE) {
  #  
  #   dir.create(file.path("C:\\Users\\kim_t\\Desktop\\data\\options\\", tickers[i]), showWarnings = FALSE)  
  # }
  toc()

}; toc()

write.csv(data.frame(exist) %>% rename(ticker = names(.)[1]), paste0("C:\\Users\\kim_t\\Desktop\\algo\\ListedOptions_" , gsub(" ", "_", gsub(":", "", as.character(Sys.time()))), ".csv"))
write.csv(data.frame(miss) %>% rename(ticker = names(.)[1]),  paste0("C:\\Users\\kim_t\\Desktop\\algo\\MissingOptions_", gsub(" ", "_", gsub(":", "", as.character(Sys.time()))), ".csv"))

