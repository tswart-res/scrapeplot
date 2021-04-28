# scrapeplot
Python Scrape Reddit /r/ASMR and plot interactively in R

Intended for use on a raspberry pi running Raspbian, with the possibility to then sync the scraped data to onedrive using Rclone. Python-based scraping using scrapy & BeautifulSoup. It can be configured to scrape every x minutes the number of active users + date/time from the /r/ASMR subreddit using crontabs (using asmrscrape.sh). The

The data are then processed and plotted in R.
