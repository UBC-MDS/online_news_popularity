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
For this project we aim to answer the following inferential research question: 
**What factors are associated with online news popularity, measured by the number of times an article has been shared?**. 

(Add information about results here.)

Our findings are relevant to news organizations that are interested in boosting traction of their online news articles and would help guide management decisions on the characteristics associated with more popular articles. 


## Report

The final report is linked: TBD

## Usage

```
# Download data
Rscript src/download_zip.R --url='https://archive.ics.uci.edu/ml/machine-learning-databases/00332/OnlineNewsPopularity.zip' --file_path='data/raw/'

# Process data
python src/onp_data_preprocess.py --raw_data='data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv' --out_dir='data/processed/'

# Create EDA plots
python src/eda.py --data_path='data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv' --figures_path='results/figures/'

```

## Dependencies

- 
- 
-

## References

Online News Popularity. (2015). UCI Machine Learning Repository. Available at: https://archive-beta.ics.uci.edu/ml/datasets/online+news+popularity.

## License:

The materials used for this project are under an open access article distributed under the Creative Commons Attribution License, which permits unrestricted use, distribution, and reproduction in any medium, provided the original work is properly cited. If reusing/referencing, please provide a link to this webpage.


