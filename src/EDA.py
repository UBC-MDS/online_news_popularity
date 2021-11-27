# Author: Jennifer Hoang, Nagraj Rao, Linhan Cai
# Date: Nov 26, 2021

"""Creates a Pandas Profiling report and visuals for exploratory data anaylsis using two datasets
Usage:
  eda.py --input=<local_path> --output=<figures_path>
  
Options:
  --input=<local_path>   All the paths needed for EDA including file name. EDA needed two different datasets needed in order of raw data 
                         followed by processed data separated by a semicolon ;.
                         example: "data/raw/dataset_ONP/diabetic_data.csv;data/processed/ONP_with_race.csv".
  --output=<figures_path>      Local path to where to save the figures into.
"""

from docopt import docopt
import os
import random
import numpy as np
import pandas as pd
#from pandas_profiling import ProfileReport
import altair as alt
import matplotlib.pyplot as plt
import mglearn
from imageio import imread
from sklearn.neighbors import KNeighborsClassifier, KNeighborsRegressor
from sklearn.metrics.pairwise import euclidean_distances
from sklearn.model_selection import cross_validate, train_test_split
from sklearn.svm import SVC
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import matplotlib
matplotlib.use('TkAgg')
import altair as alt
import seaborn as sns
from altair_saver import save
from pandas_profiling import ProfileReport
from sklearn.model_selection import train_test_split
# Save a vega-lite spec and a PNG blob for each plot in the notebook
alt.renderers.enable('mimetype')
# Handle large data sets without embedding them in the notebook
alt.data_transformers.enable('data_server')
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)

opt = docopt(__doc__)

string = opt["--input"]
datafile = string.split(";")



def main(opt):
    # Pandas Profiling 
    # 
    ONP_csv = pd.read_csv(datafile[0])
    profile = ProfileReport(ONP_csv)
    file_path1 = os.path.join(opt["--output"], "pandas_profiling.html")
    profile.to_file(output_file=file_path1)
    
   # Merging data channels into one column

    DataChannelMerge=ONP_csv[[' data_channel_is_lifestyle',' data_channel_is_entertainment' ,' data_channel_is_bus',
                        ' data_channel_is_socmed' ,' data_channel_is_tech',' data_channel_is_world' ]]
    DataChannel_arr=[]
    for r in list(range(DataChannelMerge.shape[0])):
        if (((DataChannelMerge.iloc[r,0])==0) and ((DataChannelMerge.iloc[r,1])==0) and ((DataChannelMerge.iloc[r,2])==0) and ((DataChannelMerge.iloc[r,3])==0) and ((DataChannelMerge.iloc[r,4])==0) and ((DataChannelMerge.iloc[r,5])==0)):
            DataChannel_arr.append('Others')
        for c in list(range(DataChannelMerge.shape[1])):
            if ((c==0) and (DataChannelMerge.iloc[r,c])==1):
                DataChannel_arr.append('Lifestyle')
            elif ((c==1) and (DataChannelMerge.iloc[r,c])==1):
                DataChannel_arr.append('Entertainment')
            elif ((c==2) and (DataChannelMerge.iloc[r,c])==1):
                DataChannel_arr.append('Business')
            elif ((c==3) and (DataChannelMerge.iloc[r,c])==1):
                DataChannel_arr.append('Social Media')
            elif ((c==4) and (DataChannelMerge.iloc[r,c])==1):
                DataChannel_arr.append('Tech')
            elif ((c==5) and (DataChannelMerge.iloc[r,c])==1):
                DataChannel_arr.append('World')
            
    ONP_csv.insert(loc=12, column='data_channel', value=DataChannel_arr)

    ONP_csv.drop(labels=[' data_channel_is_lifestyle',' data_channel_is_entertainment' ,' data_channel_is_bus',
                        ' data_channel_is_socmed' ,' data_channel_is_tech',' data_channel_is_world', 
                 ], axis = 1, inplace=True)


    # Merging the weekday columns as one single column

    publishdayMerge=ONP_csv[[' weekday_is_monday',' weekday_is_tuesday',' weekday_is_wednesday', 
                      ' weekday_is_thursday', ' weekday_is_friday',' weekday_is_saturday' ,' weekday_is_sunday' ]]
    temp_arr=[]
    for r in list(range(publishdayMerge.shape[0])):
        for c in list(range(publishdayMerge.shape[1])):
            if ((c==0) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Monday')
            elif ((c==1) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Tueday')
            elif ((c==2) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Wednesday')
            elif ((c==3) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Thursday')
            elif ((c==4) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Friday')
            elif ((c==5) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Saturday') 
            elif ((c==6) and (publishdayMerge.iloc[r,c])==1):
                temp_arr.append('Sunday')
            
    ONP_csv.insert(loc=11, column='weekdays', value=temp_arr)

    ONP_csv.drop(labels=[' weekday_is_monday',' weekday_is_tuesday',' weekday_is_wednesday', 
                      ' weekday_is_thursday', ' weekday_is_friday',' weekday_is_saturday' ,' weekday_is_sunday'], axis = 1, inplace=True)
    
    # Creating a correlation plot 
    
    corr_df = ONP_csv.select_dtypes('number').corr('spearman').stack().reset_index(name='corr')
    corr_df.loc[corr_df['corr'] == 1, 'corr'] = 0  # Remove diagonal
    corr_df['abs'] = corr_df['corr'].abs()
    corr_df

    plot1 = alt.Chart(corr_df).mark_circle().encode(
    x='level_0',
    y='level_1',
    size='abs',
    color=alt.Color('corr', scale=alt.Scale(scheme='blueorange', domain=(-1, 1))))

    file_path2 = os.path.join(opt["--output"], "figure1_numcattarget_eda.svg")
    plot1.save(file_path2)
    
    
    # Bar graph showing how number of shares vary based on topic

    plot2 = alt.Chart(ONP_csv).mark_bar().encode(
    y='data_channel',
    x=' shares')

    file_path3 = os.path.join(opt["--output"], "figure2_numhisttarget_eda.svg")
    plot2.save(file_path3)
        
    # Bar graph showing how number of shares vary based on day of the week

    plot3 = alt.Chart(ONP_csv).mark_bar().encode(
    y='weekdays',
    x=' shares')

    file_path4 = os.path.join(opt["--output"], "figure3_numcattarget_eda.svg")
    plot3.save(file_path4)

    # Histogram showing how number of shares vary based on day of the week

    plot4 = alt.Chart(ONP_csv).mark_bar().encode(
    x=alt.X(' shares', bin=alt.Bin(maxbins=3000),
           scale=alt.Scale(domain=(0, 25000),
            clamp=True)),
    y='count()')

    file_path5 = os.path.join(opt["--output"], "figure4_numscatter_eda.svg")
    plot4.save(file_path5)

    return print("Done! Check the folder!")

if __name__ == "__main__":
      main(opt)