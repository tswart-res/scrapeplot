# -*- coding: utf-8 -*-
"""
Created on Wed Mar 13 11:57:50 2019

@author: liltimmy
"""

from bs4 import BeautifulSoup as bs
import time
import re
from datetime import datetime
import sys
import glob
import os
import csv
import pandas as pd
import subprocess

# how to get list of filenames matching regex pattern, make sure filenames are also sorted
filenames = [f for f in os.listdir(r"C:/Users/Administrator/OneDrive - Goldsmiths College/PyASMR/RedditActiveUser␍/") if re.match('ASMR_response', f)]
sorted(filenames)

activity = []
timeall = []
dateall = []
datetimeall = []
for i, filename in enumerate(filenames):
    page = open(r"C:/Users/Administrator/OneDrive - Goldsmiths College/PyASMR/RedditActiveUser␍/"+filename, "r", encoding="utf-8")
    pagecontent=""
    for line in page:
        pagecontent+=line+"\n"
    soup=bs(pagecontent, 'html.parser') 
    
    # redditcontent = soup.findAll(attrs={'class':'s110fg59-10 kpiEC'})       

    redditcontent = soup.findAll(attrs={'class':'_3XFx6CfPlg-4Usgxm0gK8R'})   
    if len(redditcontent) > 0 :
            
        # print(redditcontent)
        activeusercode = redditcontent[1]
        activeuser2 = re.split('>',str(activeusercode))[1]
        # activeusersformat = str(activeusercode)[29:]
        activeusers = re.sub('[^0-9]', '', activeuser2)
        # activeusers = re.sub('[^0-9]', '', activeusersformat)
    
        # print(i, filename, activeusers, sep='\t')
        time = (filename[24:26])
        time += ":"
        time += (filename[27:29])
        # print (filename[24:29])
        date = (filename[13:23])
        # print (filename[18:23])
        datetimehere = date + " " + time 
    
    
        # print (activeusers)
        activity.append(activeusers)
        timeall.append(time)
        dateall.append(date)
        datetimeall.append(datetimehere)
    
data = {'Date': dateall,
        'Time': timeall,
        'ActiveUsers': activity,
        'DateTime': datetimeall
        }
df = pd.DataFrame(data, columns = ['Date', 'Time', 'ActiveUsers', 'DateTime'])

# print (df)

path = "C:\\Users\\Administrator\\OneDrive - Goldsmiths College\\PyASMR"
os.chdir(path)

df.to_csv("ActiveUsersSummary.csv", mode='a', index=False, header=None)

path = "C:\\Users\\Administrator\\OneDrive - Goldsmiths College\\PyASMR\\RedditActiveUser␍"
os.chdir(path)
for f in filenames:
    os.remove(f)
    
    
subprocess.call(['C:\\Program Files\\R\\R-4.0.3\\bin\\Rscript.exe',  '--vanilla', 'C:\\Users\\Administrator\\OneDrive - Goldsmiths College\\PyASMR\PlotActiveUsers.R'])