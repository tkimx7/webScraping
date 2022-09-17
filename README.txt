############################################################################################################
###### --- README --- ######################################################################################
############################################################################################################
# 
# --- The "getTickers.R" file consists of an R function that scrapes all tickers listed on all major 
# --- exchanges, i.e. Nasdaq, NYSE and OTC. These tickers are then tested to see if they can be imported from 
# --- Yahoo Finance through the widely used "quantmod" R library. The reason for this step is that tickers
# --- across various financial data providers have either different syntax or different names entirely, 
# --- unique to each provider. To filter out stocks with trading options (there are 5,000 such stocks out of 
# --- 18,000 stocks listed in the U.S., the "getTickersWithListedOptions.R" file does this based on the results 
# --- from the "getTickers.R" file.
# 
# --- The equivalent libraries in Python would be the "yfinance" and "yahooquery" packages. I ocassionally 
# --- use these packages to import fundamental data such as market capitalzation and sector for each and 
# --- every stock.
