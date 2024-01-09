# Analyzing prevalence and timing of carjackings in U.S. cities
# BY: Jake J. Smith
# DATE: April 2022

setwd("raw-data/")
rm(list = ls())

library(tidyverse)
library(ggplot2)
library(tidyquant)
library(RColorBrewer)
library(lubridate)

## Part 1: Carjacking Trends in Three Largest U.S. Cities ---------

# Read in Chicago data, clean dates, generate city variable
Chicago <- read.csv("Chicago_carjackings.csv") %>% 
  transmute(date = date(mdy_hms(Date)), 
            time = hour(mdy_hms(Date)),
            city = "Chicago")

# Read in LA data (in two separate datasets, pre- and post-2020) and filter carjacking offenses
LA_new <- read.csv("LA_2020_Present.csv") %>% filter(grepl("0916| 916$| 916 |^916 ", Mocodes))
LA_old <- read.csv("LA_2010_2019.csv") %>% filter(grepl("0916| 916$| 916 |^916 ", Mocodes))

# Bind LA data, clean dates, generate city variable
LA <- bind_rows(LA_old, LA_new) %>% 
  transmute(date = date(mdy_hms(DATE.OCC)), 
            time = substr(TIME.OCC, 1, nchar(TIME.OCC) - 2),
            city = "LA"
            )  
  LA$time[LA$time == ""] <- 0
  LA$time <- as.double(LA$time)

# Read in and bind NYC data, clean dates, generate city variable
NYC <- bind_rows(read.csv("NYPD_Historic.csv"), read.csv("NYC_Current.csv")) %>% 
  transmute(date = lubridate::date(lubridate::mdy(CMPLNT_FR_DT)), 
            time = lubridate::hour(lubridate::hms(CMPLNT_FR_TM)),
            city = "NYC"
            )

# Bind 3 largest cities and generate daily counts per-city
ALL_large <- bind_rows(NYC, LA, Chicago) %>% 
  filter(date > "2010-01-31") %>% 
  group_by(city, date) %>% 
  summarise(n_date_city = n())

# Plotting carjackings over time in the largest 3 cities (separate lines on a single plot)
ALL_large_by_city <- ALL_large %>% 
  filter(date <= as.Date(mdy("4-1-2022"))) %>% 
  ggplot(aes(x = date, y = n_date_city, 
   group = city, colour = city)) +
  labs(
    x = "", 
    y = "Daily Carjackings", 
    title = "Carjackings in NYC, LA, Chicago",
    subtitle = "(30-Day Moving Averages)",
    caption = "Data sources: NYPD, LAPD, Chicago PD") + 
  geom_ma(ma_fun = SMA, n = 30, linetype = "solid") + 
  theme_minimal() + 
  scale_color_brewer(palette = "Set2")+
  theme(
    text = element_text(size = 15),
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    legend.title = element_blank(),
    legend.position = c(0.5,0.88),
    legend.direction = "horizontal",
    legend.text = element_text(size = 14)) +
  scale_x_date(breaks = seq.Date(from = as.Date("2010-01-01"), 
                                  to = as.Date("2022-4-1"),
                                  by = "2 years"),
               minor_breaks = "1 year", 
               date_labels = "%Y") +
  expand_limits(y = c(0, 6))

ggsave("plots/carjackings-in-NYC-LA-Chicago.png", ALL_large_by_city, width = 8, height = 3)
  
# Plotting Chicago only since 2001
Chicago_only <- Chicago %>% 
  group_by(city, date) %>% 
  summarise(n_date_city = n())

Chicago_plot <- ggplot(Chicago_only, aes(x = date, y = n_date_city, 
                      group = city, colour = city)) +
  labs(
    x = "", 
    y = "Daily Carjackings", 
    title = "Carjackings in Chicago",
    subtitle = "(30-Day Moving Averages)",
    caption = "Data source: Chicago PD") + 
  geom_ma(ma_fun = SMA, n = 30, linetype = "solid") + 
  theme_minimal() + 
  scale_color_brewer(palette = "Set2")+
  theme(
    text = element_text(size = 15),
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    legend.title = element_blank(),
    legend.position = c(0.5,0.88),
    legend.direction = "horizontal",
    legend.text = element_text(size = 14)) +
  scale_x_date(breaks = seq.Date(from = as.Date("2001-01-01"), 
                                 to = as.Date("2022-10-31"),
                                 by = "4 years"),
               minor_breaks = "1 year", 
               date_labels = "%Y") +
  expand_limits(y = c(0, 6))

ggsave("plots/carjackings-in-Chicago-since-2001.png", Chicago_plot, width = 8, height = 3)

## Part 2: Carjacking Trends in Smaller Cities -------

# Read in Pittsburgh data, filter out non-carjacking offenses, clean dates, generate city variable
Pittsburgh <- read.csv("Pittsburgh.csv") %>% 
  filter(grepl("CARJACK", INCIDENTHIERARCHYDESC)) %>% 
  transmute(date = date(ymd_hms(INCIDENTTIME)),
            time = hour(ymd_hms(INCIDENTTIME)),
            city = "Pittsburgh"
            )

# Read in Norfolk data, filter out non-carjacking offenses, clean dates, generate city variable
Norfolk <- read.csv("Norfolk.csv") %>% 
  filter(grepl("CARJACK", Offense))  %>% 
  transmute(date = date(mdy(Date.of.Occurrence)), 
            time = substr(Hour.of.Occurrence, 1, nchar(Hour.of.Occurrence) - 2),
            city = "Norfolk")
  Norfolk$time[Norfolk$time == ""] <- 0
  Norfolk$time <- as.double(Norfolk$time)

# Read in Chandler data, filter out non-carjacking offenses, clean dates, generate city variable
Chandler <- read.csv("Chandler.csv") %>% 
  filter(grepl("Carjack", report_primary_offense_description)) %>% 
  transmute(date = date(mdy(report_event_date)),
            time = lubridate::hour(hms(report_event_time)),
            city = "Chandler")

# Read in Denver data, filter out non-carjacking offenses, clean dates, generate city variable
Denver <- read.csv("Denver.csv") %>% 
  filter(grepl("car-jack", OFFENSE_TYPE_ID)) %>% 
  transmute(date = date(mdy_hm(FIRST_OCCURRENCE_DATE)),
            time = hour(mdy_hm(FIRST_OCCURRENCE_DATE)),
            city = "Denver")

# Bind all 'smaller' cities and tabulate total N of carjackings by day
ALL_small <- bind_rows(Chandler, Norfolk, Pittsburgh, Denver) %>% 
  group_by(date) %>% 
  summarise(n_date_city = n()) %>% 
  filter(date > "2017-04-30")

# Plotting carjacking trends in smaller cities (aggregated across all four cities)
ALL_small_plot <- ggplot(ALL_small, aes(x = date, y = n_date_city)) +
  labs(
    x = "", 
    y = "Daily Carjackings (combined)", 
    title = "Combined Daily Carjackings: Chandler, Denver, Norfolk, Pittsburgh",
    subtitle = "(30-Day Moving Average)",
    caption = "Data sources: Denver PD, Pittsburgh PD, Norfolk PD, Chandler PD") + 
  geom_ma(ma_fun = SMA, n = 30, linetype = "solid") + 
  theme_minimal() + 
  scale_color_brewer()+
  theme(
    text = element_text(size = 15),
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    legend.title = element_blank(),
    legend.position = c(0.5,0.88),
    legend.direction = "horizontal",
    legend.text = element_text(size = 14)) +
  scale_x_date(breaks = seq.Date(from = as.Date("2018-01-01"), 
                                 to = as.Date("2022-10-31"),
                                 by = "2 years"),
               minor_breaks = "1 year", 
               date_labels = "%Y") +
  expand_limits(y = c(0, 2))

ggsave("plots/carjackings-in-4-smaller-cities.png", ALL_small_plot, width = 8, height = 3)

## Part 3: Trends in Time of Day When Carjacking Offenses Occur ---

# Bind all cities together
ALL_time <- bind_rows(NYC, LA, Chicago, Chandler, Norfolk, Pittsburgh, Denver) %>% 
  filter(date > "2017-12-31" & date < "2022-01-01") %>% 
  mutate(weekday = lubridate::wday(date, label = TRUE))

# Generate dummy indicating whether offense occurred between hours of 8am and 5pm on a weekday
ALL_time$school_hours <- ifelse(ALL_time$time >= 8 & ALL_time$time <= 17 & ALL_time$weekday != "Sat" & ALL_time$weekday != "Sun", 1, 0)
ALL_time$school_hours <- as.factor(ALL_time$school_hours)

# Summarize number of school hour vs. non-school-hour offenses on each day in Chicago only
Chicago_school <- ALL_time %>% 
  group_by(school_hours, date) %>% 
  filter(city == "Chicago") %>% 
  summarise(n_school_hours = n()) 

# Define lookup table to be used in labeling following plot
school.labs <- c(
  "0" = "Non-School Hours", 
  "1" = "School Hours"
  )

# Plot trends in school-hours vs. non-school hours carjackings over time
Chicago_school_hours_plot <- ggplot(Chicago_school, aes(x = date, y = n_school_hours,
                       group = school_hours, color = school_hours)) +
  labs(
    x = "", 
    y = "Daily Carjackings", 
    title = "Daily Carjackings in Chicago: School vs. Non-School Hours",
    subtitle = "(30-Day Moving Average)",
    caption = "Data source: Chicago PD") + 
  geom_ma(ma_fun = SMA, n = 30, linetype = "solid") + 
  theme_minimal() + 
  scale_color_brewer(palette = "Paired")+
  theme(
    text = element_text(size = 15),
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "none") +
  scale_x_date(breaks = seq.Date(from = as.Date("2018-01-01"), 
                                 to = as.Date("2022-10-31"),
                                 by = "2 years"),
               minor_breaks = "1 year", 
               date_labels = "%Y") +
  expand_limits(y = c(0, 2)) +
  facet_wrap(~ school_hours, labeller = labeller(school_hours = school.labs))

ggsave("plots/Chicago-carjackings-school-hours-vs-not.png", Chicago_school_hours_plot, width = 8, height = 3)

# Histograms showing the number of carjackings occurring across all cities, by time of day and day of week
time_and_weekday_plot <- ALL_time %>% ggplot(aes(x = time, fill = "orange")) + 
  geom_bar() + facet_wrap(~weekday, nrow = 2, scales = "free") +
  labs(x = "Hour of Day", 
       y = element_blank(),
       title = "Daily Carjackings Across 7 U.S. Cities by Weekday and Time",
       subtitle = "All Carjacking Incidents, 2018-2021",
       caption = "Data sources: NYPD, LAPD, Chicago PD, Denver PD, Pittsburgh PD, Norfolk PD, Chandler PD") +
  theme_minimal() + 
  theme(legend.position = "none",
        text = element_text(size = 15),
        plot.subtitle = element_text(hjust = 0.5),
        plot.title = element_text(hjust = 0.5)) 

ggsave("plots/carjackings-by-time-and-weekday.png", time_and_weekday_plot, width = 8, height = 3)
