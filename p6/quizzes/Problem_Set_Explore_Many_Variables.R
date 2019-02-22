library(ggplot2)

# Create a histogram of diamond prices.
# Facet the histogram by diamond color
# and use cut to color the histogram bars.
ggplot(data=diamonds, aes(x=log(price))) + 
  geom_histogram(aes(fill = cut, bindwidth = 30)) + facet_wrap(~color) +
  scale_fill_brewer(type="qual")

# Create a scatterplot of diamond price vs.
# table and color the points by the cut of
# the diamond.
ggplot(aes(x=table, y=price), data=diamonds) + 
  geom_point(aes(color=cut)) + scale_fill_brewer(type="qual") + 
  scale_x_continuous(seq(50, 80, 2), limits = c(50,80))

# Create a scatterplot of diamond price vs.
# volume (x * y * z) and color the points by
# the clarity of diamonds. Use scale on the y-axis
# to take the log10 of price. You should also
# omit the top 1% of diamond volumes from the plot.
# Note: Volume is a very rough approximation of
# a diamond's actual volume.
ggplot(aes(x=(x * y * z), y=price), data=diamonds) + geom_point(aes(color=clarity)) +
  scale_color_brewer(type = 'div') +
  scale_x_continuous(breaks= seq(0, 300, 100), limits = c(0, 300)) + 
  scale_y_continuous(breaks = seq(0, 10000, 5000), limits = c(0, 12000)) +
  scale_y_log10()
# Your task is to create a new variable called 'prop_initiated'
# in the Pseudo-Facebook data set. The variable should contain
# the proportion of friendships that the user initiated.
names(pf)
pf$prop_initiated <- with(pf, friendships_initiated / friend_count)

# Create a line graph of the median proportion of
# friendships initiated ('prop_initiated') vs.
# tenure and color the line segment by
# year_joined.bucket.
pf$year_joined <- floor(2014 - (pf$tenure / 365))
pf$year_joined.bucket <- cut(pf$year_joined, breaks= c(2004, 2009, 2011, 2012, 2014))
names(pf)
ggplot(aes(x= tenure, y = prop_initiated), data=pf) + 
  geom_line(aes(color= year_joined.bucket), stat= 'summary', fun.y= median) +
  scale_y_continuous(limits = c(0, 0.87))

# Smooth the last plot you created of
# of prop_initiated vs tenure colored by
# year_joined.bucket. You can bin together ranges
# of tenure or add a smoother to the plot.
ggplot(aes(x= tenure, y = prop_initiated), data=pf) + 
  geom_smooth(aes(color= year_joined.bucket), stat= 'summary', fun.y= median) +
  scale_y_continuous(limits = c(0, 0.87))

# What is the mean of the largest group of friendships_initiated?
with(subset(pf, year_joined.bucket= 2012), summary(friendships_initiated/friend_count))

# Create a scatter plot of the price/carat ratio
# of diamonds. The variable x should be
# assigned to cut. The points should be colored
# by diamond color, and the plot should be
# faceted by clarity.
ggplot(aes(x=cut, y=price/carat), data=diamonds) + 
  geom_point(aes(color = color), pch = 20, position = "jitter") + 
  facet_wrap(~clarity) + scale_color_brewer(type = 'div')

# The Gapminder website contains over 500 data sets with information about
# the world's population. Your task is to continue the investigation you did at the
# end of Problem Set 4 or you can start fresh and choose a different
# data set from Gapminder.

# If you’re feeling adventurous or want to try some data munging see if you can
# find a data set or scrape one from the web.

# In your investigation, examine 3 or more variables and create 2-5 plots that make
# use of the techniques from Lesson 5.

# You can find a link to the Gapminder website in the Instructor Notes.

# Once you've completed your investigation, create a post in the discussions that includes:
#       1. the variable(s) you investigated, your observations, and any summary statistics
#       2. snippets of code that created the plots
#       3. links to the images of your plots

## Import Necessary Packages
library(dplyr)
library(ggplot2)
library(tidyr)
library("readxl")

## DATA WRANGLING
getwd()
setwd("~/Downloads")
gov_spending_int_df <- read_excel("~/Downloads/indicator_per capita government expenditure on health (ppp int. $).xlsx")
gov_spending_us_df <- read_excel("~/Downloads/indicator_per capita government expenditure on health at average exchange rate (us$).xlsx")
gov_percentage_tot_df <- read_excel("~/Downloads/indicator_government share of total health spending.xlsx")
gov_percentage_gdp_df <- read_excel("~/Downloads/indicator total health expenditure perc of GDP.xlsx")

names(gov_spending_int_df) <- c("Country", seq(1995, 2010))
names(gov_spending_us_df) <- c("Country", seq(1995, 2010))
names(gov_percentage_tot_df) <- c("Country", seq(1995, 2010))
names(gov_percentage_gdp_df) <- c("Country", seq(1995, 2010))

head(gov_spending_int_df)
head(gov_spending_us_df)
head(gov_percentage_tot_df)
head(gov_percentage_gdp_df)

gov_spending_int <- gov_spending_int_df[gov_spending_int_df$Country %in% c('Australia', 'Japan', 'United States', 'United Kingdom'),]
gov_spending_us <- gov_spending_us_df[gov_spending_us_df$Country %in% c('Australia', 'Japan', 'United States', 'United Kingdom'),]
gov_percentage_tot <- gov_percentage_tot_df[gov_percentage_tot_df$Country %in% c('Australia', 'Japan', 'United States', 'United Kingdom'),]
gov_percentage_gdp <- gov_percentage_gdp_df[gov_percentage_gdp_df$Country %in% c('Australia', 'Japan', 'United States', 'United Kingdom'),]

head(gov_spending_int)
head(gov_spending_us)
head(gov_percentage_tot)
head(gov_percentage_gdp)

merged_gov_spending <- merge(gov_spending_int, gov_spending_us, by = c('Country'))
merged_gov_spending <- merged_gov_spending %>% 
  gather('Classification', 'Spending', 2:ncol(merged_gov_spending))
gov_spending_country <- merged_gov_spending[order(merged_gov_spending$Country),]
gov_spending_country <- separate(gov_spending_country, Classification, into= c('Year', 'Classification'))
gov_spending_country$Classification[gov_spending_country$Classification == 'x'] <- 'International'
gov_spending_country$Classification[gov_spending_country$Classification == 'y'] <- 'US'
head(gov_spending_country, 25)

merged_gov_percentage_units <- merge(gov_percentage_tot, gov_percentage_gdp, by= c('Country'))
merged_gov_percentage_units <- merged_gov_percentage_units %>%
  gather('Classification', 'Percentage', 2:ncol(merged_gov_percentage_units))
gov_percentage_units <- merged_gov_percentage_units[order(merged_gov_percentage_units$Country),]
gov_percentage_units <- separate(gov_percentage_units, Classification, into= c('Year', 'Classification'))
gov_percentage_units$Classification[gov_percentage_units$Classification == 'x'] <- 'Total'
gov_percentage_units$Classification[gov_percentage_units$Classification == 'y'] <- 'GDP'
gov_percentage_classification <- spread(gov_percentage_units, Classification, Percentage)
head(gov_percentage_classification, 20)

## VISUALIZATIONS
gov_spending_country$Year <- as.numeric(as.character(gov_spending_country$Year))
gov_percentage_units$Year <- as.numeric(as.character(gov_percentage_units$Year))
gov_percentage_classification$Year <- as.numeric(gov_percentage_classification$Year)


ggplot(aes(x= Year, y= Spending, color= Country, group=Country), data= gov_spending_country) +
  geom_line() + facet_wrap(~Classification) + 
  scale_x_continuous(breaks = seq(1995, 2010, 5)) +
  ggtitle('Per Capita Government Spending on Healthcare Over Time')
ggsave('Per Capita Government Spending on Healthcare Over Time.jpeg')
ggplot(aes(x= Year, y= GDP, color= Country, group= Country), data= gov_percentage_classification) +
  geom_line() + ylab('GDP Percentage') +
  scale_x_continuous(breaks = seq(1995, 2010, 5)) +
  ggtitle('Percentage of Spendings on Healthcare out of GDP')
ggsave('Percentage of Spendings on Healthcare out of GDP.jpeg')
ggplot(aes(x= Year, y= Total, color= Country, group= Country), data= gov_percentage_classification) +
  geom_line() + ylab('Total Healthcare Spending Percentage') +
  scale_x_continuous(breaks = seq(1995, 2010, 5)) +
  ggtitle('Percentage of Spendings on Healthcare out of Total Spendings on Healthcare')
ggsave('Percentage of Spendings on Healthcare out of Total Spendings on Healthcare.jpeg')
ggplot(aes(x=Country, y=Spending), data= gov_spending_country) +
  geom_boxplot() +
  ggtitle('Per Capita Government Spending on Healthcare by Country')
ggsave('Per Capita Government Spending on Healthcare by Country.jpeg')

