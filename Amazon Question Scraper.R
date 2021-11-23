install.packages("purrr")
install.packages("beepr")


library(rvest)
library(purrr)
library(dplyr)
library(openxlsx)
library(beepr)


page_numbers <- 1:2

purrr::map_df(page_numbers, ~ { 
  
  url_reviews <- paste0("https://www.amazon.it/ask/questions/asin/B07GDBLY4Q/",.x,"/ref=ask_ql_psf_ql_hza?isAnswered=true")
  
  page <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Question
  page %>% html_nodes("[class='a-declarative']") %>% html_text() -> q
  
  data.frame(q) }) -> question

question_repulisti <- question

question_repulisti <- na.omit(question_repulisti) #remove NA rows

question_repulisti <- str_trim(question_repulisti$q, side = "both")

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <- unique(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Selezione delle preferenze",
                            question_repulisti$question_repulisti), ]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Tutto",
                            question_repulisti$question_repulisti), ]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Informazioni sul prodotto",
                            question_repulisti$question_repulisti), ]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Domande e risposte clienti.",
                            question_repulisti$question_repulisti), ]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Recensioni clienti",
                            question_repulisti$question_repulisti), ]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Visualizza tutte le",
                            question_repulisti$question_repulisti), ]

question_repulisti <- as.data.frame(question_repulisti)

beep()


