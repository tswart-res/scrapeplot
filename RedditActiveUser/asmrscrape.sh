#!/bin/bash
cd /home/pi/
PATH=$PATH:/usr/local/bin
export PATH
scrapy crawl ASMR_getter
