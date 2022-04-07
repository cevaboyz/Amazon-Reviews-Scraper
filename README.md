# Amazon Scraper R 

A Web Scraping project to analyze product reviews in Amazon.com

This is a Web Scraping project to analyze product reviews in Amazon.com. Once you provide the Product ASIN and the number of pages of reviews you want to scrape you can obtain in a neat dafarame all of the reviews ready to be analyzed manually or with other scripts

In this repository you can find:

1. 📍 A function to get the name of the product based on its ASIN ID;
2. 📍 A function to get the reviews of a product given an ASIN and a number of pages to scrape;
3. 📍 A function to get the question of the customers/prospects about the product given the ASIN and a number of pages to scrape;
4. 📍 A more refined function to obtain the reviews based on the work of Surya Murali(https://github.com/Surya-Murali).


The output of the functions are .xlsx files with a dynamic name corresponding with its product name.

## Disclaimer 
**If you are going to scrape many pages and many products in a session remember to use a proxy to avoid problems with Amazon Bot detector and the ban of your ip**
