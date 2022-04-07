#setting up the environment
if(!"pacman" %in% installed.packages()[,"Package"]) install.packages("pacman")
pacman::p_load(rvest, dplyr, tidyr, stringr, purrr, openxlsx, beepr, svDialogs)

#insert Asin Code
prod_code <- dlgInput("Insert ASIN", Sys.info()["ASIN"])$res

#insert the number of pages that you want to scrape
page_number <- as.numeric(dlgInput("Insert the number of page of questions that you would like to scrape", Sys.info()["Page Number"])$res)

#obtain the range from the page inserted
page_numbers <- 1:page_number

#iterate the function to get the html page and then extract the nodes containing the questions 
purrr::map_df(page_numbers, ~ {
  url_reviews <-
    paste0(
      "https://www.amazon.it/product-reviews/",prod_code,"/ref=cm_cr_arp_d_paging_btm_next_",
      .x,
      "?ie=UTF8&reviewerType=all_reviews&pageNumber=",
      .x
    )
  
  doc <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Title
  doc %>%
    html_nodes(
      "[class='a-size-base a-link-normal review-title a-color-base review-title-content a-text-bold']"
    ) %>%
    html_text() -> review_title
  
  # Review Text
  doc %>%
    html_nodes("[class='a-size-base review-text review-text-content']") %>%
    html_text() -> review_text
  
  # Number of stars in review
  doc %>%
    html_nodes("[data-hook='review-star-rating']") %>%
    html_text() -> review_star
  
  # Return a tibble
  data.frame(review_title,
             review_text,
             review_star,
             page = .x)
  
}) -> result

#remove whitespace from the data frame
cols_to_be_rectified <-
  names(result)[vapply(result, is.character, logical(1))]

result[, cols_to_be_rectified] <-
  lapply(result[, cols_to_be_rectified], trimws)

#remove the extra space in the star reviews column
result <- result %>% mutate(review_star = str_sub(review_star, 1, 1))

#getting the name of the product from the ASIN
#obtain the text in the node, remove "\n" from the text, and remove white space
prod <- html_nodes(doc, "#productTitle") %>% 
  html_text() %>% 
  gsub("\n", "", .) %>% 
  trimws()

write.xlsx(result, file = paste0(prod, "_recensioni.xlsx"))

beepr::beep(sound = 8)
