install.packages("rvest")
install.packages("tidyverse")

library(rvest)
library(tidyverse)


reviews_url_test <- "https://www.amazon.it/product-reviews/B084QXG8GL/"

reviews_url_test_page_next <- "https://www.amazon.it/product-reviews/B084QXG8GL/ref=cm_cr_arp_d_paging_btm_next_5?pageNumber=5"

scrape_amazon <- function(ASIN, PAGE){ url_reviews <- paste0("https://www.amazon.it/product-reviews/",ASIN,"/ref=cm_cr_arp_d_paging_btm_next_", PAGE, "/?pageNumber=",PAGE)

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
page <-tibble(review_title,
       review_text,
       review_star,
       page = PAGE) %>% return()
}
