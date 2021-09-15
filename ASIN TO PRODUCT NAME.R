
# Install / Load relevant packages
if(!"pacman" %in% installed.packages()[,"Package"]) install.packages("pacman")
pacman::p_load(rvest, dplyr, tidyr, stringr)

# ASIN product code
prod_code <- "###" #insert Asin Code

url <- paste0("https://www.amazon.it/dp/", prod_code) #change the url to match the domain

doc <- read_html(url)

#obtain the text in the node, remove "\n" from the text, and remove white space
prod <- html_nodes(doc, "#productTitle") %>% 
  html_text() %>% 
  gsub("\n", "", .) %>% 
  trimws()

prod
