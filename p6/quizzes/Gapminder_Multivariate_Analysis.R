DAND T2, EXPLORATORY DATA ANALYSIS: LESSON 8: QUIZ 11: GAPMINDER MULTIVARIATE ANALYSIS

## Import Necessary Packages
library(dplyr)
library(ggplot2)
library(tidyr)

## DATA WRANGLING
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
gov_percentage_gdp <- gov_spending_gdp_df[gov_percentage_gdp_df$Country %in% c('Australia', 'Japan', 'United States', 'United Kingdom'),]

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
