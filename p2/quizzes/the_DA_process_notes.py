## The Data Analysis Process- Drawing Conclusions Quiz ##
"""
This quiz was done on my own with research.
"""

# imports and load data
import pandas as pd
% matplotlib inline

df = pd.read_csv('store_data.csv')
df.head()

"""
This function selects specific rows in specific columns so that you can apply
statistical functions to them
"""
# total sales for the last month
print(sum(df.loc[196:, 'storeA']))
print(sum(df.loc[196:, 'storeB']))
print(sum(df.loc[196:, 'storeC']))
print(sum(df.loc[196:, 'storeD']))
print(sum(df.loc[196:, 'storeE']))

# average sales
print(sum(df.loc[:,'storeA'])/200)
print(sum(df.loc[:,'storeB'])/200)
print(sum(df.loc[:,'storeC'])/200)
print(sum(df.loc[:,'storeD'])/200)
print(sum(df.loc[:,'storeE'])/200)

"""
This function selects a certain row to be viewed within the dataframe
"""
# sales on march 13, 2016
df[df.week=='2016-03-13']

# worst week for store C
print(min(df.loc[:,'storeC']))
print(df.loc[df['storeC']==927])

# total sales during most recent 3 month period
print(sum(df.loc[187:, 'storeA']))
print(sum(df.loc[187:, 'storeB']))
print(sum(df.loc[187:, 'storeC']))
print(sum(df.loc[187:, 'storeD']))
print(sum(df.loc[187:, 'storeE']))

## Communicating Results Practice ##
"""
This quiz was done with trial and error then looking at the answers to see
what I did wrong.
"""
# imports and load data
import pandas as pd
% matplotlib inline

df = pd.read_csv('store_data.csv')

# explore data
df.tail(20)

# sales for the last month
df.iloc[196:, 1:].sum().plot(kind='bar');

# average sales
df.mean().plot(kind='pie');

# sales for the week of March 13th, 2016
sales = df[df['week'] == '2016-03-13']
sales.iloc[0, 1:].plot(kind='bar');

# sales for the lastest 3-month periods
last_three_months = df[df['week'] >= '2017-12-01']
last_three_months.iloc[:, 1:].sum().plot(kind='pie')
