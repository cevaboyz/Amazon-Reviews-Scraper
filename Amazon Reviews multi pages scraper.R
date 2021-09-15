install.packages("purr")

library(rvest)
library(purrr)
library(dplyr)
library(openxlsx)


page_numbers <- 1:29 #modify to the number of total pages of the reviews

purrr::map_df(page_numbers, ~{ 
  
  url_reviews <- paste0("https://www.amazon.it/product-reviews/B07WTHVQZH/ref=cm_cr_arp_d_paging_btm_next_",.x,"?ie=UTF8&reviewerType=all_reviews&pageNumber=", .x) #change the link according to the product ASIN
  
  doc <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Title
  doc %>% 
    html_nodes("[class='a-size-base a-link-normal review-title a-color-base review-title-content a-text-bold']") %>%
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
             page =.x) 

  }) -> result

#remove left and right whitespace and write the file in a xlsx format

cols_to_be_rectified <- names(result)[vapply(result, is.character, logical(1))]

result[,cols_to_be_rectified] <- lapply(result[,cols_to_be_rectified], trimws)
  
result <- result %>% mutate(review_star = str_sub(review_star, 1,1))

write.xlsx(result, file = "reviews.xlsx")

