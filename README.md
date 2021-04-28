# scrapeplot
Python Scrape Reddit /r/ASMR and plot interactively in R

Intended for use on a raspberry pi running Raspbian, with the possibility to then sync the scraped data to onedrive using Rclone. Python-based scraping using scrapy & BeautifulSoup. It can be configured to scrape every x minutes the number of active users + date/time from the /r/ASMR subreddit using crontabs (using asmrscrape.sh). The

The data are then processed and plotted in R.

Instructions:

1)  scrapy spider (e.g., with Raspberry Pi using asmrscrape.sh with crontabs) using the ASMR_getter spider. e.g., :
scrapy crawl ASMR_getter

2) Use Python script 'Extract ASMR Activeusers.py' to collapse all scraped data into one csv (note the CSV is appended to by default so as to facilitate subsequent scraping without deleting prior data).

3) PlotActiveUsers.R can then be used to clean the data (remove outliers) and plot on a weekday/time scale. Plot is interactive so individual data points (e.g., peaks) can be selected.
