#!/usr/bin/env python
# coding: utf-8

# In[8]:


# Import Libraries 
import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create 


# Read in the data


df = pd.read_csv(r'C:\Users\oliva\OneDrive\Documents\Data for SQL\movies.csv')


# In[9]:


df.head()


# In[8]:


#let's see if there is any missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,pct_missing))


# In[9]:


# Data types for our columns 

df.dtypes


# In[ ]:


df['budget'] = df['budget'].astype('int64')

df['gross'] = df['gross'].astype('int64')


# In[14]:


df['yearcorrect'] = df['released'].astype(str).str[:4]
df


# In[15]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[19]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[20]:


pd.set_option('display.max_rows', None)


# In[25]:


#Drop any duplicates
df['company'].drop_duplicates()


# In[26]:


# Budget high correlation 
# company high correlation


# In[31]:


#Scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross Earnings')
plt.ylabel('Budget for Film')
plt.show()


# In[30]:


df.head()


# In[33]:


#Plot budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color":"red"}, line_kws={"color":"blue"})


# In[34]:


#Let's start looking at correlation 


# In[40]:


df.corr(method = 'pearson')    #Pearson, Kendall, Spearman correlations


# In[41]:


# High correlation between budget and gross


# In[42]:


correlation_matrix = df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True)
plt.show()


# In[ ]:


#looks at company 
df.head()


# In[11]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')  
        df_numerized[col_name] = df_numerized[col_name].cat.codes
df_numerized
    


# In[12]:


df


# In[13]:


df_numerized.corr()


# In[14]:


correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()
corr_pairs


# In[15]:


sorted_pairs = corr_pairs.sort_values()
sorted_pairs


# In[17]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5] 
high_corr


# In[ ]:


# Votes and budget have the highest correlation to gross earnings 

#Company has low correlation 

