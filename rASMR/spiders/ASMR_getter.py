# -*- coding: utf-8 -*-
import scrapy
import time
import re
from datetime import datetime
import sys


class AsmrGetterSpider(scrapy.Spider):
    name = 'ASMR_getter'
    allowed_domains = ['reddit.com/r/ASMR']
    start_urls = ['http://reddit.com/r/ASMR/']


    def start_requests(self):
        self.index = 0
        urls = [
            'http://reddit.com/r/ASMR',
        ]
        for url in urls:
            # We make a request to each url and call the parse function on the http response.
            yield scrapy.Request(url=url, callback=self.parse)
    
    def parse(self, response):
        filename = "ASMR_response" + datetime.now().strftime("%Y-%m-%d-%H-%M")+".txt"
        with open(filename, 'wb') as f:
            #All we'll do is save the whole response as a huge text file.
            f.write(response.body)
        self.log('Saved file %s' % filename)
