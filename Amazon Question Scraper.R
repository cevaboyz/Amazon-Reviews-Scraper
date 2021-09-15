install.packages("purrr")

library(rvest)
library(purrr)
library(dplyr)
library(openxlsx)


page_numbers <- 1:100

purrr::map_df(page_numbers, ~ { 
  
  url_reviews <- paste0("https://www.amazon.it/ask/questions/asin/B07WTHVQZH/",.x,"/ref=ask_ql_psf_ql_hza?isAnswered=true") #change the ASIN according to the product
  
  page <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Question
  page %>% html_nodes("[class='a-declarative']") %>% html_text() -> q
  
  data.frame(q) }) -> question
