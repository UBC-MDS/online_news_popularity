# Online News Popularity

# Authors: 

Nagraj Rao, Linhan Cai, Jennifer Hoang

# Project Abstract: 

A project assessing factors associated with online news popularity in accordance with DSCI 522 (Data Science Workflows) for the Master of Data Science Program at the University of British Columbia.

## Introduction 

For this project we aim to answer the following inferential research question: **What factors are associated with online news popularity, measured by the number of times an article has been shared?**. This question is relevant for news organizations that are interested in boosting traction of their news articles and would help guide management decisions on the characteristics associated with more popular articles. 

The question is inferential in nature since we cannot attribute causality since we cannot confirm if the dataset is a random sample or the full population. We are also not attempting any quasi-experimental methods since that is beyond the scope of the content covered thus far in the Data Science Program. We are also not attempting to predict the number of shares since the goal of our research project is to gain an understanding of the relative contributions of each feature on the number of shares in our dataset. 

## Importance

The market space for online news has grown manifold, with traditional news outlets also providing an online version of their articles. This growth has been complemented with increased competition, particularly from non-traditional news outlets (such as small-scale digital news companies) who can reach a wider audience through social-media. For players in the market to remain competitive, it is critical to understand what factors are associated with popularity of articles so that news agencies can make optimal decisions to increase news traction. 

## Dataset

The public dataset our team is using for conducting this analysis called "Online News Popularity", and is available on University of California's Machine Learning Repository (Online News Popularity, 2015). The website includes the following statement: "This dataset is licensed under a Creative Commons Attribution 4.0 International (CC BY 4.0) license. This allows for the sharing and adaptation of the datasets for any purpose, provided that the appropriate credit is given." (Online News Popularity, 2015). This grants us permission to utilize the dataset for our project.

The Online News Popularity Dataset 36,644 observations (examples) and 61 columns (attributes), summarizing a range of characteristics about articles that were published by Mashable between 1 January, 2013 and 31 December, 2014. There is a mix of categorical, continuous, and binary features, which will require careful examination for applying appropriate transformations.


## Choice of model to be estimated

We plan to analyze the data using a **multiple linear regression model**, where our dependent variable (target) is the number of shares and our independent variables (features) will be appropriately selected from the dataset. The choice of a linear regression model is driven by the nature of our question which is inferential. We also recognize that there are multiple factors that can be associated with the number of shares, so analyzing this problem using a multiple linear regression framework makes logical sense.

## Exploratory Data Analysis (EDA)

Before building and estimating our model, we will have to perform EDA to understand the underlying characteristics of our data. 

A starting point would be to understand our data structure - which variables are continuous, categorical, or other formats. If we find any textual data, we will need to assess if that variable can be a useful feature, and if yes, how best to quantify it. 

Next, we will undertake any specific transformations needed to scale our features. While we do not intend to use any standard or normalization since we want to have a quantitative estimate of each feature's association, we will encode variables as dummy where it makes sense, or change the scale of values if needed (for example if there are too many leading zeroes).  

The third step would be to generate **summary statistics** for our data, particularly looking the distribution of our features to check for outliers. We will corroborate the presence of outliers using graphs such as **histograms**. These two methods can help us understand the **interquartile range (IQR)**, which can be multiplied by 1.5 to determine a statistical threshold for outliers for each feature. 

The fourth step is to undertake **correlation analysis** to guide our feature selection and its functional form. Pearson's correlation coefficient can give us a sense of the strength of the association between our features. This would also tell us if our model suffers from **multicollinearity**, i.e. pairs of two features being strongly correlated, so that we can find appropriate ways to address the problem. This analysis will also give us a sense of whether some of the features are linearly or non-linearly related. As a hypothetical example, extremely wordy articles or very short articles may be less desirable than those that fall in the middle. R's correlation analysis also provides us a preliminary indication of the functional form of that feature in our model.   

Our final step is to develop a linear regression model, with our dependent variable as the number of shares and our features selected from the remaining columns available in our dataset. In the first round, the choice of the variable will be driven by the analysis conducted above, and economic rationale for inclusion of specific variables. We may consider **interaction terms** where it makes logical sense. As we undertake the exercise of estimating our multiple linear regression, we will heavily rely on the output of the model, where we may consider dropping features that are **not statistically significant**, determined by the **p-value**. To ensure our standard errors are robust, we plan on conducting tests of **heteroskedasticity** and run a robust model if need be. We will also test the other assumptions that are made while estimating our linear regression model (such as independence and normality of the residuals etc.) using appropirate **scatter-plots** or other formal statistical tests, when possible. 

Here are the links to the EDA we have conducted thus far:
https://github.com/UBC-MDS/online_news_popularity/blob/main/results/EDA_First_Attempt.ipynb
https://github.com/UBC-MDS/online_news_popularity/blob/main/results/EDA_initial.ipynb

## Sharing Our Results

Our results will be shared in the form of a final document which will embed a range of analyses conducted (which has been referenced above). Our base comparison would be to a linear regression with one feature, and we will explore different combinations of features to optimize a model that minimizes the sum of squared residuals and maximizes the R-Squared. 

## References

Online News Popularity. (2015). UCI Machine Learning Repository. Available at: https://archive-beta.ics.uci.edu/ml/datasets/online+news+popularity.

## License:

The materials used for this project are under an open access article distributed under the Creative Commons Attribution License, which permits unrestricted use, distribution, and reproduction in any medium, provided the original work is properly cited. If reusing/referencing, please provide a link to this webpage.


