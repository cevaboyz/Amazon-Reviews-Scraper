


#Manual Scraping

#change the number prev_XX and pageNumber = XX with the corret page number 

url_reviews <- "https://www.amazon.it/product-reviews/B084QXG8GL/ref=cm_cr_getr_d_paging_btm_prev_27?pageNumber=27"
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
page_XX<-tibble(review_title,
       review_text,
       review_star,
       page = XX) %>% return()
