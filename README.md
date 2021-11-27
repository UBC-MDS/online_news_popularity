# Online News Popularity

# Authors: 

Nagraj Rao, Linhan Cai, Jennifer Hoang

A project assessing factors associated with online news popularity in accordance with DSCI 522 
(Data Science Workflows) for the Master of Data Science Program at the University of British Columbia.

## Project Abstract

The market space for online news has grown manifold, with traditional news outlets 
also providing an online version of their articles. This growth has been complemented 
with increased competition, particularly from non-traditional news outlets 
(such as small-scale digital news companies) who can reach a wider audience through social-media. 
For this project we aimed to answer the following inferential research question: 
**What factors are associated with online news popularity, measured by the number of times an article has been shared?**. 
Our findings will be relevant to news organizations that are interested in boosting traction of their online news articles 
and may help guide management decisions on the characteristics associated with more popular articles. 

Using a multiple linear regression analysis with 'log shares per day' as our response variable, our model achieved an R-squared score of 0.2132. This indicates that additional features not included in our current model explain a large portion of variability in the data. Future steps for our analysis include exploring the contribution of interaction effects in our model, as well as other regression models such as random forest regression. 

## Report

The final report is linked: 

## Usage

```
# Download data
Rscript src/download_zip.R --url='https://archive.ics.uci.edu/ml/machine-learning-databases/00332/OnlineNewsPopularity.zip' --file_path='data/raw/'

# Process data
python src/onp_data_preprocess.py --raw_data='data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv' --out_dir='data/processed/'

# Create EDA plots
python src/eda.py --data_path='data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv' --figures_path='results/figures/'

# Run R regression analysis


# Create report

```

## Dependencies
- Python version 3.9.5 and Python packages:
  - docopt=0.6.2
  - altair=4.1.0
  - altair-data-server=0.4.1
  - altair-saver=0.5.0
  - pandas=1.3.4
  - numpy=1.21.4
R version 4.1.1 and R packages:
  - knitr=1.33
  - tidyverse=1.3.1
  - docopt=0.7.1

## References

Online News Popularity. (2015). UCI Machine Learning Repository. Available at: https://archive-beta.ics.uci.edu/ml/datasets/online+news+popularity.

## License:

The materials used for this project are under an open access article distributed under the Creative Commons Attribution License, which permits unrestricted use, distribution, and reproduction in any medium, provided the original work is properly cited. If reusing/referencing, please provide a link to this webpage.


