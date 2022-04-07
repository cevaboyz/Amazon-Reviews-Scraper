#setting up the environment
if (!"pacman" %in% installed.packages()[, "Package"])
  install.packages("pacman")
pacman::p_load(rvest, dplyr, tidyr, stringr, purrr, openxlsx, beepr, svDialogs)


#insert Asin Code
prod_code <- dlgInput("Insert ASIN", Sys.info()["ASIN"])$res

#insert the number of pages that you want to scrape
page_number <-
  dlgInput("Insert the number of page of questions that you would like to scrape",
           Sys.info()["Page Number"])$res

#obtain the range from the page inserted
page_numbers <- 1:page_number

#iterate the function to get the html page and then extract the nodes containing the questions
purrr::map_df(page_numbers, ~ {
  url_reviews <-
    paste0(
      "https://www.amazon.it/ask/questions/asin/",
      prod_code,
      "/",
      .x,
      "/ref=ask_ql_psf_ql_hza?isAnswered=true"
    )
  
  page <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Question
  page %>% html_nodes("[class='a-declarative']") %>% html_text() -> q
  
  data.frame(q)
}) -> question


#cleaning and formatting the dataframe obtained from the scrape
#
question_repulisti <- question

#remove NA rows_remove na
question_repulisti <- na.omit(question_repulisti)

question_repulisti <- str_trim(question_repulisti$q, side = "both")

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <- unique(question_repulisti)

#remove the not uniques elements as the CTA copy and other amazon's side content
question_repulisti <-
  question_repulisti[!grepl("Selezione delle preferenze",
                            question_repulisti$question_repulisti),]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Tutto",
                            question_repulisti$question_repulisti),]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Informazioni sul prodotto",
                            question_repulisti$question_repulisti),]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Domande e risposte clienti.",
                            question_repulisti$question_repulisti),]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Recensioni clienti",
                            question_repulisti$question_repulisti),]

question_repulisti <- as.data.frame(question_repulisti)

question_repulisti <-
  question_repulisti[!grepl("Visualizza tutte le",
                            question_repulisti$question_repulisti),]

question_repulisti <- as.data.frame(question_repulisti)

#getting the name of the product from the ASIN
#obtain the text in the node, remove "\n" from the text, and remove white space
prod <- html_nodes(doc, "#productTitle") %>%
  html_text() %>%
  gsub("\n", "", .) %>%
  trimws()

names(question_repulisti)[1] <- "Domande"

write.xlsx(question_repulisti, file = paste0(prod, "_question.xlsx"))

beepr::beep(sound = 17)

