install.packages("purrr")

library(rvest)
library(purrr)
library(dplyr)
library(openxlsx)
library(tidyr)


page_numbers <- 1:100

purrr::map_df(page_numbers, ~ { 
  
  url_reviews <- paste0("https://www.amazon.it/ask/questions/asin/B07WTHVQZH/",.x,"/ref=ask_ql_psf_ql_hza?isAnswered=true") #change the ASIN according to the product
  
  page <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Question
  page %>% html_nodes("[class='a-declarative']") %>% html_text() -> q
  
  data.frame(q) }) -> question

question <- questions_philips %>% rename( domanda = q)


question <- question %>% drop_na()

question <- distinct(question)

cols_to_be_rectified <- names(question)[vapply(question, is.character, logical(1))]

question[,cols_to_be_rectified] <- lapply(question[,cols_to_be_rectified], trimws)

question <- distinct(question)

question <- question %>% mutate(domanda = gsub("Visualizza tutte le", "", domanda))

question <- question %>% mutate(domanda = gsub("risposte", "", domanda))

question <- question %>% mutate(domanda = gsub("Domande e clienti", "", domanda))

