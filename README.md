# Carjackings2022
Analyzing America's carjacking spree and the extent to which young people were behind it.

# Description
In 2022, amid a sharp rise in carjacking in many parts of the country, some high-profile commentators sought to place the blame on youth. Kids, they alleged had grown restless and violent stuck at home during the remote learning era. In this blog post, I used open-source crime data from multiple cities to look more closely at this claim, and at the rise in carjackings more generally. First I assessed just how serious the national carjacking spike was; I also used the time of day during which carjackings occurred to assess the viability of the youth-carjacking-spree hypothesis. This is the code that I wrote to perform those analyses.

# Getting Started
To run or play with the code, you'll need R/R Studio with the following packages installed:
- tidyverse
- tidyquant
- RColorBrewer
- lubridate

# Methodology

## Data Sources
Data used in this analysis are incident-level crime data from city police departments, obtained from the following sources:
- Chicago, IL carjacking incident data
- New York, NY crime incident data[^1]
- Los Angeles, CA crime incident data
- Pittsburgh, PA crime incident data
- Denver, CO crime incident data
- Norfolk, VA crime incident data
- Chandler, AZ crime incident data

[^1]: In order to reduce download times/file sizes, data from NYC were filtered to include only carjacking incidents prior to downloading.

Note: Datasets from Los Angeles, Chandler, Norfolk, Denver, and Pittsburgh were filtered to exclude any non-carjacking offenses prior to upload, in order to accommodate GitHub file size constraints. However, the code should work perfectly fine with either the filtered datasets or the full datasets for these five cities.
