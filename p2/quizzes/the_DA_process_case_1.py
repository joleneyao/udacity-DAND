### The Data Analysis Process - Case Study 1 ###

## Assessing Data ##

import pandas as pd

df_red = pd.read_csv('winequality-red.csv', sep=';')
df_white = pd.read_csv('winequality-white.csv', sep=';')

#How many samples of red wine are there?#
#How many samples of white wine are there?#
#How many columns are in each dataset?#
#Which features have missing values?#
df_red.info()
df_white.info()

#How many duplicate rows are in the white wine dataset?#
#Are duplicate rows in these datasets significant/ need to be dropped?#
sum(df_white.duplicated())

#How many unique values of quality are in the red wine dataset?#
#How many unique values of quality are in the white wine dataset?#
df_red.nunique()
df_white.nunique()

#What is the mean density in the red wine dataset?#
mean = df_red['density'].mean()
print(mean)
--------------------------------------------------------------------------------
## Appending Data ##
# import numpy and pandas
import pandas as pd
import numpy as np

# load red and white wine datasets
red_df = pd.read_csv('winequality-red.csv', sep=';')
white_df = pd.read_csv('winequality-white.csv', sep=';')
red_df.info()
white_df.info()

# create color array for red dataframe
color_red = np.repeat("red",1599)

# create color array for white dataframe
color_white = np.repeat("white", 4898)

red_df['color'] = color_red
red_df.head()
white_df['color'] = color_white
white_df.head()

# append dataframes
wine_df = red_df.append(white_df, ignore_index=True)

# view dataframe to check for success
wine_df.head()

wine_df.to_csv('winequality_edited.csv', index=False)

--------------------------------------------------------------------------------
## Appending Data (cont'd)##
"""
Add a new cell below the first code cell (where you imported packages and
loaded data) to fix the problematic column label in the red dataframe.

Use Pandas' rename function to change the total_sulfur-dioxide column label
to total_sulfur_dioxide. You can check out this Stack Overflow page to help
you.
(https://stackoverflow.com/questions/20868394/changing-a-specific-column-name-
in-pandas-dataframe)

Then, rerun all the cells below that to append the dataframes and save your
successfully combined dataset!
"""

red_df.rename(columns={'total_sulfur-dioxide':'total_sulfur_dioxide'},
inplace=True)
--------------------------------------------------------------------------------
## Exploring with Visuals ##
"""
Use the notebook below to perform exploratory data analysis on your newly
combined dataframe. Create some visuals to answer these quiz questions below
the notebook.
-   Based on histograms of columns in this dataset, which of the following feature
    variables appear skewed to the right? Fixed Acidity, Total Sulfur Dioxide, pH,
    Alcohol
-   Based on scatterplots of quality against different feature variables, which
    of the following is most likely to have a positive impact on quality?
    Volatile Acidity, Residual Sugar, pH, Alcohol
"""
# Load dataset
import pandas as pd
% matplotlib inline

wine_df = pd.read_csv('winequality_edited.csv')
wine_df.head()

# Histograms for Various Features
wine_df['fixed_acidity'].plot(kind='hist');
wine_df['total_sulfur_dioxide'].plot(kind='hist');
wine_df['pH'].plot(kind='hist');
wine_df['alcohol'].plot(kind='hist');

# Scatterplots of Quality Against Various Features
wine_df.plot(x='quality', y='volatile_acidity', kind='scatter');
wine_df.plot(x='quality', y='residual_sugar', kind='scatter');
wine_df.plot(x='quality', y='pH', kind='scatter');
wine_df.plot(x='quality', y='alcohol', kind='scatter');
--------------------------------------------------------------------------------
## Conclusions Using Groupby ##
"""
In the notebook below, you're going to investigate two questions about this
data using Pandas' groupby function. Here are tips for answering each
question:
Q1: Is a certain type of wine (red or white) associated with higher quality?
Q2: What level of acidity (pH value) receives the highest average rating?
Acidity Levels:
High: Lowest 25% of pH values
Moderately High: 25% - 50% of pH values
Medium: 50% - 75% of pH values
Low: 75% - max pH value
"""
# Load `winequality_edited.csv`
import pandas as pd
wine_df = pd.read_csv('winequality_edited.csv')
wine_df.info()
wine_df.head()

# Is a certain type of wine associated with higher quality?
# Find the mean quality of each wine type (red and white) with groupby
wine_df.groupby(['color']).mean()

# What level of acidity receives the highest average rating?
# View the min, 25%, 50%, 75%, max pH values with Pandas describe
wine_df.describe()

# Bin edges that will be used to "cut" the data into groups
bin_edges = [2.27, 3.11, 3.21, 3.32, 4.01] # Fill in this list with five values
you just found
# Labels for the four acidity level groups
bin_names = ['High', 'Moderately_High', 'Medium', 'Low'] # Name each acidity
level category
# Creates acidity_levels column
df['acidity_levels'] = pd.cut(df['pH'], bin_edges, labels=bin_names)

# Checks for successful creation of this column
df.head()

# Find the mean quality of each acidity level with groupby
wine_df.groupby([df['acidity_levels']]).mean()

# Save changes for the next section
df.to_csv('winequality_edited.csv', index=False)
--------------------------------------------------------------------------------
## Pandas Query ##

# selecting malignant records in cancer data
df_m = df[df['diagnosis'] == 'M']
df_m = df.query('diagnosis == "M"')

# selecting records of people making over $50K
df_a = df[df['income'] == ' >50K']
df_a = df.query('income == " >50K"')
--------------------------------------------------------------------------------
## Drawing Conclusions Using Query ##
"""
Q1: Do wines with higher alcoholic content receive better ratings?
To answer this question, use query to create two groups of wine samples:

Low alcohol (samples with an alcohol content less than the median)
High alcohol (samples with an alcohol content greater than or equal to the
median)
Then, find the mean quality rating of each group.

Q2: Do sweeter wines (more residual sugar) receive better ratings?
Similarly, use the median to split the samples into two groups by residual
sugar and find the mean quality rating of each group.
"""
# Load `winequality_edited.csv`
import pandas as pd
df = pd.read_csv('winequality_edited.csv')
df.head()
df.info()

# get the median amount of alcohol content
df['alcohol'].median()

# select samples with alcohol content less than the median
low_alcohol = df.query('alcohol < 10.3')

# select samples with alcohol content greater than or equal to the median
high_alcohol = df.query('alcohol >= 10.3')

# ensure these queries included each sample exactly once
# print(num_samples)
num_samples = df.shape[0]
num_samples == low_alcohol['quality'].count() + high_alcohol['quality'].count()
# should be True

# get mean quality rating for the low alcohol and high alcohol groups
print(low_alcohol.mean())
print(high_alcohol.mean())

# Do sweeter wines receive better ratings?
# get the median amount of residual sugar
df['residual_sugar'].median()

# select samples with residual sugar less than the median
low_sugar = df.query('residual_sugar < 3.0')

# select samples with residual sugar greater than or equal to the median
high_sugar = df.query('residual_sugar >= 3.0')

# ensure these queries included each sample exactly once
num_samples == low_sugar['quality'].count() + high_sugar['quality'].count()
# should be True

# get mean quality rating for the low sugar and high sugar groups
print(low_sugar.mean())
print(high_sugar.mean())
--------------------------------------------------------------------------------
## Matplotlib Example ##
"""
Before we jump into the making of this plot, let's walk through a simple example
using Matplotlib to create a bar chart.
"""
import matplotlib.pyplot as plt
% matplotlib inline

plt.bar([1, 2, 3], [224, 620, 425]);

# plot bars
plt.bar([1, 2, 3], [224, 620, 425])

# specify x coordinates of tick labels and their labels
plt.xticks([1, 2, 3], ['a', 'b', 'c']);

# plot bars with x tick labels
plt.bar([1, 2, 3], [224, 620, 425], tick_label=['a', 'b', 'c']);

plt.bar([1, 2, 3], [224, 620, 425], tick_label=['a', 'b', 'c'])
plt.title('Some Title')
plt.xlabel('Some X Label')
plt.ylabel('Some Y Label');
--------------------------------------------------------------------------------
## Plotting with Matplotlib ##
# Import necessary packages and load `winequality_edited.csv`
import matplotlib.pyplot as plt
% matplotlib inline
import pandas as pd

df = pd.read_csv('winequality_edited.csv')

#1: Do wines with higher alcoholic content receive better ratings?
# Create a bar chart with one bar for low alcohol and one bar for high alcohol
# wine samples. This first one is filled out for you.

# Use query to select each group and get its mean quality
median = df['alcohol'].median()
low = df.query('alcohol < {}'.format(median))
high = df.query('alcohol >= {}'.format(median))

mean_quality_low = low['quality'].mean()
mean_quality_high = high['quality'].mean()

# Create a bar chart with proper labels
locations = [1, 2]
heights = [mean_quality_low, mean_quality_high]
labels = ['Low', 'High']
plt.bar(locations, heights, tick_label=labels)
plt.title('Average Quality Ratings by Alcohol Content')
plt.xlabel('Alcohol Content')
plt.ylabel('Average Quality Rating');

#2: Do sweeter wines receive higher ratings?
# Create a bar chart with one bar for low residual sugar and one bar for high
# residual sugar wine samples.

# Use query to select each group and get its mean quality
median = df['residual_sugar'].median()
low = df.query('residual_sugar < {}'.format(median))
high = df.query('residual_sugar >={}'.format(median))

mean_quality_low = low['quality'].mean()
mean_quality_high = high['quality'].mean()

# Create a bar chart with proper labels
locations = [1,2]
heights = [mean_quality_low, mean_quality_high]
labels = ['Low', 'High']
plt.bar(locations, heights, tick_label=labels)
plt.title('Average Quality Ratings by Residual Sugar')
plt.xlabel('Residual Sugar Content')
plt.ylabel('Average Quality Rating');

#3: What level of acidity receives the highest average rating?
# Create a bar chart with a bar for each of the four acidity levels.

# Use groupby to get the mean quality for each acidity level
mean_acidity= df.groupby(['acidity_levels']).mean()
mean_acidity_quality= mean_acidity['quality']
print(mean_acidity_quality)

# Create a bar chart with proper labels
locations = [1,2,3,4]
heights = [5.78, 5.86, 5.85, 5.78]
labels = ['High', 'Low', 'Medium', 'Moderately_High']
plt.bar(locations, heights, tick_label=labels)

plt.title('Average Quality Ratings by Acidity Levels')
plt.xlabel('Acidity Levels')
plt.ylabel('Average Quality Rating');

# Bonus: Create a line plot for the data in #3
# You can use pyplot's plot function for this.
# https://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.plot

plt.plot(labels, heights, color='green', linestyle='solid', marker='o',
markerfacecolor='blue', markersize=12);
--------------------------------------------------------------------------------
