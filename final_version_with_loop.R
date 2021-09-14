install.packages("purr")

library(rvest)
library(purr)

page_numbers <- 1:500

purrr::map_df(page_numbers, ~{ 
  
  url_reviews <- paste0("https://www.amazon.it/Princess-182075-Acciaio-Inossidabile-Friggitrice/product-reviews/B088P8JSSZ/ref=cm_cr_getr_d_paging_btm_next_",.x,"?ie=UTF8&reviewerType=all_reviews&pageNumber=", .x)
  
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
  
