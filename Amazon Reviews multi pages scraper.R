install.packages("purrr")

library(rvest)
library(purrr)
library(dplyr)
library(openxlsx)
library(tidyr)


page_numbers <- 1:100

purrr::map_df(page_numbers, ~ { 
  
  url_reviews <- paste0("https://www.amazon.it/ask/questions/asin/B088P8JSSZ/",.x,"/ref=ask_ql_psf_ql_hza?isAnswered=true") #change the ASIN according to the product
  
  page <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Question
  page %>% html_nodes("[class='a-declarative']") %>% html_text() -> q
  
  data.frame(q) }) -> question

question <- question %>% rename( domanda = q)


question <- question %>% drop_na()

question <- distinct(question)

question <- data.frame(lapply(question, trimws), stringsAsFactors = FALSE)

question <- distinct(question)

question <- question %>% rename(domanda = question)

question <- question %>% mutate(domanda = gsub("Visualizza tutte le", "", domanda))

question <- question %>% mutate(domanda = gsub("risposte", "", domanda))

question <- question %>% mutate(domanda = gsub("Domande e clienti", "", domanda))
