# Carjackings2022
Analyzing America's carjacking spree and the extent to which young people were behind it.

# Description
In 2022, amid a sharp rise in carjacking in many parts of the country, some [high-profile commentators](https://chicago.suntimes.com/crime/2022/2/7/22922606/carjacking-wave-violence-lori-lightfoot-remote-learning-teens-ctu-teachers-union) sought to place the blame on youth. Kids, they alleged, had grown restless and violent stuck at home during the remote learning era. 

In a [blog post](https://medium.com/@jakejeromesmith/fact-vs-fiction-americas-carjacking-spree-250733f3bbc2) published that year, I used open-source crime data from multiple cities to look more closely at this claim, and at the rise in carjackings more generally. First I assessed just how serious the national carjacking spike was; I also used the time of day during which carjackings occurred to assess the viability of the youth-carjacking-spree hypothesis. This is the code that I wrote to perform those analyses.

# Getting Started
To run or play with the code, you'll need R/R Studio with the following packages installed:
- tidyverse
- tidyquant
- RColorBrewer
- lubridate

# Methodology
This script accomplishes the following:
1. Reads in, cleans, standardizes, and combines police data on carjacking incidents from seven large U.S. cities; 
2. Plots general carjacking trends (for the largest three cities individually, and also for four smaller cities in aggregate) through March 2022;
3. Visualizes how the timing of carjackings has changed over time in one large city (Chicago), as an informal test of the central hypothesis that remote learning drove the increase in carjackings.

Note that the blog post also includes a variety of less data-intensive analysis, such as the discussion of motivations for carjacking (which cites news reports, anecdotes, and ethnographic research) and  estimates of the number of youth carjackings per year in Chicago (calculated by applying simple arithmetic to a small number of discrete data points). Those analyses/calculations are not captured in the code.

# Data Sources
At the time of analysis, only a small number of cities published crime reports that included "carjacking" as a discrete subcategory of robbery. The analysis uses data from the following cities, all of which published incident-level crime report data that include carjackings:
- Chicago, IL [carjacking incident data](https://data.cityofchicago.org/Public-Safety/Chicago-crime-incidents-carjackings-VEHICULAR-HIJA/t66u-yzsn/data)
- New York, NY crime incident data[^1] ([historic](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i) and [current](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Current-Year-To-Date-/5uac-w243))
- Los Angeles, CA crime incident data ([pre-2020](https://data.lacity.org/Public-Safety/Crime-Data-from-2010-to-2019/63jg-8b9z/about_data) and [2020 onward](https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-Present/2nrs-mtv8))
- Pittsburgh, PA [police incident data](https://data.wprdc.org/dataset/uniform-crime-reporting-data)
- Denver, CO [crime incident data](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-crime)
- Norfolk, VA [police incident data](https://data.norfolk.gov/Public-Safety/Police-Incident-Reports/r7bn-2egr)
- Chandler, AZ [general offense reports data](https://data.chandlerpd.com/catalog/general-offenses/)

[^1]: In order to reduce download times/file sizes, data from NYC were filtered to include only carjacking incidents prior to downloading.

Note: Datasets from Los Angeles, Chandler, Norfolk, Denver, and Pittsburgh were filtered to exclude any non-carjacking offenses prior to upload, in order to accommodate GitHub file size constraints. However, the code should work perfectly fine with either the filtered datasets or the full datasets for these five cities.
