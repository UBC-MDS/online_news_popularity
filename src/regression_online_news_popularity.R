# author: Nagraj Rao, Jennifer Hoang, Linhan Cai
# date: 2021-11-25

"This script performs an analysis on the features associated with Online News Popularity
Usage: regression_online_news_popularity.R --in_file=<in_file> --out_dir=<out_dir> --figures_dir=<figures_dir>
Options:
--in_file=<in_file>           Path including filename of processed data
--out_dir=<out_dir>           Directory of where to locally write the
                              tables
--figures_dir=<figures_dir>   Directory of where to locally write the
                              figures
" -> doc

# Rscript src/regression_online_news_popularity.R --in_file='data/processed/OnlineNewsPopularity_clean.csv' --out_dir='results/tables' --figures_dir='results/figures'

library(feather)
library(tidyverse)
library(caret)
library(docopt)
library(here)
library(broom)
library(car)

opt <- docopt(doc)

main <- function(opt) {
  data <- read_csv(opt$in_file)


# CREATING LOG OF SHARES PER DAY TO STANDARDIZE DEPENDENT VARIABLE ACROSS OBSERVATIONS

data <- data %>%
        mutate(shares_per_day = shares/timedelta) 
  
# MODEL 0: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7 AND DEPENDENT
#VARIABLE AS SHARES PER DAY.
  
linear_model0 = lm(shares_per_day ~  n_tokens_title	+
                       n_tokens_content +	
                       n_unique_tokens +	
                       num_hrefs	 +
                       num_self_hrefs	 +
                       num_imgs	+ 
                       num_videos	+ 
                       average_token_length +	
                       num_keywords	+ 
                       data_channel_is_lifestyle +	
                       data_channel_is_entertainment +
                       data_channel_is_bus +	
                       data_channel_is_socmed +	
                       data_channel_is_tech +	
                       data_channel_is_world +	
                       kw_min_min +	
                       kw_max_min +	
                       kw_min_max +	
                       kw_avg_max +	
                       kw_min_avg +	
                       kw_max_avg +	
                       self_reference_min_shares +	
                       self_reference_max_shares +	
                       is_weekend +
                       LDA_01	+
                       LDA_03	+
                       global_subjectivity	+
                       global_sentiment_polarity +	
                       global_rate_positive_words +	
                       global_rate_negative_words +	
                       avg_positive_polarity	+
                       min_positive_polarity	+
                       avg_negative_polarity	+
                       max_negative_polarity	 +
                       title_subjectivity	+
                       title_sentiment_polarity +	
                       abs_title_subjectivity,
                     data = data)

mlr_tidy0 <- linear_model0 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance0 <- linear_model0 |>
               glance() 

saveRDS(mlr_tidy0, file = here(opt$out_dir, "mlr_model0.rds"))
saveRDS(mlr_glance0, file = here(opt$out_dir, "mlr_glance0.rds"))

# FIRST MODEL: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7

linear_model1 = lm(log_shares_per_day ~  n_tokens_title	+
                     n_tokens_content +	
                     n_unique_tokens +	
                     num_hrefs	 +
                     num_self_hrefs	 +
                     num_imgs	+ 
                     num_videos	+ 
                     average_token_length +	
                     num_keywords	+ 
                     data_channel_is_lifestyle +	
                     data_channel_is_entertainment +
                     data_channel_is_bus +	
                     data_channel_is_socmed +	
                     data_channel_is_tech +	
                     data_channel_is_world +	
                     kw_min_min +	
                     kw_max_min +	
                     kw_min_max +	
                     kw_avg_max +	
                     kw_min_avg +	
                     kw_max_avg +	
                     self_reference_min_shares +	
                     self_reference_max_shares +	
                     is_weekend +
                     LDA_01	+
                     LDA_03	+
                     global_subjectivity	+
                     global_sentiment_polarity +	
                     global_rate_positive_words +	
                     global_rate_negative_words +	
                     avg_positive_polarity	+
                     min_positive_polarity	+
                     avg_negative_polarity	+
                     max_negative_polarity	 +
                     title_subjectivity	+
                     title_sentiment_polarity +	
                     abs_title_subjectivity,
                   data = data)
summary(linear_model1)

mlr_tidy1 <- linear_model1 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance1 <- linear_model1 |>
  glance() 

saveRDS(mlr_tidy1, file = here(opt$out_dir, "mlr_model1.rds"))
saveRDS(mlr_glance1, file = here(opt$out_dir, "mlr_glance1.rds"))

# SECOND MODEL: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7, 
# DROPPING n_unique_tokens SINCE IT IS NOT STATISTICALLY SIGNIFICANT
linear_model2 = lm(log_shares_per_day ~  n_tokens_title	+
                     n_tokens_content +	
                     num_hrefs	 +
                     num_self_hrefs	 +
                     num_imgs +
                     num_videos	+ 
                     average_token_length +	
                     num_keywords	+ 
                     data_channel_is_lifestyle +	
                     data_channel_is_entertainment +
                     data_channel_is_bus +	
                     data_channel_is_socmed +	
                     data_channel_is_tech +	
                     data_channel_is_world +	
                     kw_min_min +	
                     kw_max_min +	
                     kw_min_max +	
                     kw_avg_max +	
                     kw_min_avg +	
                     kw_max_avg +	
                     self_reference_min_shares +	
                     self_reference_max_shares +	
                     is_weekend +
                     LDA_01	+
                     LDA_03	+
                     global_subjectivity	+
                     global_sentiment_polarity +	
                     global_rate_positive_words +	
                     global_rate_negative_words +	
                     avg_positive_polarity	+
                     min_positive_polarity	+
                     avg_negative_polarity	+
                     max_negative_polarity	 +
                     title_subjectivity	+
                     title_sentiment_polarity +	
                     abs_title_subjectivity,
                   data = data)

mlr_tidy2 <- linear_model2 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance2 <- linear_model2 |>
  glance() 

saveRDS(mlr_tidy2, file = here(opt$out_dir, "mlr_model2.rds"))
saveRDS(mlr_glance2, file = here(opt$out_dir, "mlr_glance2.rds"))

# THIRD MODEL: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7, 
# DROPPING n_unique_tokens, num_imgs SINCE IT IS NOT STATISTICALLY SIGNIFICANT
linear_model3 = lm(log_shares_per_day ~  n_tokens_title	+
                     n_tokens_content +	
                     num_hrefs	 +
                     num_self_hrefs	 +
                     num_videos	+ 
                     average_token_length +	
                     num_keywords	+ 
                     data_channel_is_lifestyle +	
                     data_channel_is_entertainment +
                     data_channel_is_bus +	
                     data_channel_is_socmed +	
                     data_channel_is_tech +	
                     data_channel_is_world +	
                     kw_min_min +	
                     kw_max_min +	
                     kw_min_max +	
                     kw_avg_max +	
                     kw_min_avg +	
                     kw_max_avg +	
                     self_reference_min_shares +	
                     self_reference_max_shares +	
                     is_weekend +
                     LDA_01	+
                     LDA_03	+
                     global_subjectivity	+
                     global_sentiment_polarity +	
                     global_rate_positive_words +	
                     global_rate_negative_words +	
                     avg_positive_polarity	+
                     min_positive_polarity	+
                     avg_negative_polarity	+
                     max_negative_polarity	 +
                     title_subjectivity	+
                     title_sentiment_polarity +	
                     abs_title_subjectivity,
                   data = data)

mlr_tidy3 <- linear_model3 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance3 <- linear_model3 |>
  glance() 

saveRDS(mlr_tidy3, file = here(opt$out_dir, "mlr_model3.rds"))
saveRDS(mlr_glance3, file = here(opt$out_dir, "mlr_glance3.rds"))

# FOURTH MODEL: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7, 
# DROPPING n_unique_tokens, num_imgs, self_reference_max_shares SINCE IT IS NOT STATISTICALLY SIGNIFICANT
linear_model4 = lm(log_shares_per_day ~  n_tokens_title	+
                     n_tokens_content +	
                     num_hrefs	 +
                     num_self_hrefs	 +
                     num_videos	+ 
                     average_token_length +	
                     num_keywords	+ 
                     data_channel_is_lifestyle +	
                     data_channel_is_entertainment +
                     data_channel_is_bus +	
                     data_channel_is_socmed +	
                     data_channel_is_tech +	
                     data_channel_is_world +	
                     kw_min_min +	
                     kw_max_min +	
                     kw_min_max +	
                     kw_avg_max +	
                     kw_min_avg +	
                     kw_max_avg +	
                     self_reference_min_shares +	
                     is_weekend +
                     LDA_01	+
                     LDA_03	+
                     global_subjectivity	+
                     global_sentiment_polarity +	
                     global_rate_positive_words +	
                     global_rate_negative_words +	
                     avg_positive_polarity	+
                     min_positive_polarity	+
                     avg_negative_polarity	+
                     max_negative_polarity	 +
                     title_subjectivity	+
                     title_sentiment_polarity +	
                     abs_title_subjectivity,
                   data = data)
summary(linear_model4)

mlr_tidy4 <- linear_model4 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance4 <- linear_model4 |>
  glance() 

saveRDS(mlr_tidy4, file = here(opt$out_dir, "mlr_model4.rds"))
saveRDS(mlr_glance4, file = here(opt$out_dir, "mlr_glance4.rds"))

# FIFTH MODEL: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7, 
# DROPPING n_unique_tokens, num_imgs, self_reference_max_shares, LDA_03 SINCE IT IS NOT STATISTICALLY SIGNIFICANT
linear_model5 = lm(log_shares_per_day ~  n_tokens_title	+
                     n_tokens_content +	
                     num_hrefs	 +
                     num_self_hrefs	 +
                     num_videos	+ 
                     average_token_length +	
                     num_keywords	+ 
                     data_channel_is_lifestyle +	
                     data_channel_is_entertainment +
                     data_channel_is_bus +	
                     data_channel_is_socmed +	
                     data_channel_is_tech +	
                     data_channel_is_world +	
                     kw_min_min +	
                     kw_max_min +	
                     kw_min_max +	
                     kw_avg_max +	
                     kw_min_avg +	
                     kw_max_avg +	
                     self_reference_min_shares +	
                     is_weekend +
                     LDA_01	+
                     global_subjectivity	+
                     global_sentiment_polarity +	
                     global_rate_positive_words +	
                     global_rate_negative_words +	
                     avg_positive_polarity	+
                     min_positive_polarity	+
                     avg_negative_polarity	+
                     max_negative_polarity	 +
                     title_subjectivity	+
                     title_sentiment_polarity +	
                     abs_title_subjectivity,
                   data = data)
summary(linear_model5)

mlr_tidy5 <- linear_model5 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance5 <- linear_model5 |>
  glance() 

saveRDS(mlr_tidy5, file = here(opt$out_dir, "mlr_model5.rds"))
saveRDS(mlr_glance5, file = here(opt$out_dir, "mlr_glance5.rds"))

# SIXTH MODEL: BASIC LINEAR MODEL WITH ONLY VARIABLES WHOSE ABSOLUTE VALUE OF 
# CORRELATION ACROSS INDEPENDENT VARIABLES IS LESS THAN 0.7, 
# DROPPING n_unique_tokens, num_imgs, self_reference_max_shares, LDA_03, global_sentiment_polarity SINCE IT IS NOT STATISTICALLY SIGNIFICANT

linear_model6 = lm(log_shares_per_day ~  n_tokens_title	+
                     n_tokens_content +	
                     num_hrefs	 +
                     num_self_hrefs	 +
                     num_videos	+ 
                     average_token_length +	
                     num_keywords	+ 
                     data_channel_is_lifestyle +	
                     data_channel_is_entertainment +
                     data_channel_is_bus +	
                     data_channel_is_socmed +	
                     data_channel_is_tech +	
                     data_channel_is_world +	
                     kw_min_min +	
                     kw_max_min +	
                     kw_min_max +	
                     kw_avg_max +	
                     kw_min_avg +	
                     kw_max_avg +	
                     self_reference_min_shares +	
                     is_weekend +
                     LDA_01	+
                     global_subjectivity	+
                     global_rate_positive_words +	
                     global_rate_negative_words +	
                     avg_positive_polarity	+
                     min_positive_polarity	+
                     avg_negative_polarity	+
                     max_negative_polarity	 +
                     title_subjectivity	+
                     title_sentiment_polarity +	
                     abs_title_subjectivity,
                   data = data)
summary(linear_model6)

mlr_tidy6 <- linear_model6 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_glance6 <- linear_model6 |>
  glance() 

saveRDS(mlr_tidy6, file = here(opt$out_dir, "mlr_model6.rds"))
saveRDS(mlr_glance6, file = here(opt$out_dir, "mlr_glance6.rds"))

# TABLE 1. CALCULATING VARIANCE INFLATION FACTOR AS A MEASURE OF MULTICOLLINEARITY. VALUES <5 INDICATES NO SIGNIFICANT PRESENCE OF MULTICOLLINEARITY
VIF_6 <- vif(linear_model6) %>%
  tidy() 

saveRDS(VIF_6, file = here(opt$out_dir, "Table1.rds"))

#BACKWARD MODEL SELECTION (MODEL 7)
socfull <- lm(log_shares_per_day ~ n_tokens_title  + 
                n_tokens_content + 
                n_unique_tokens + 
                n_non_stop_words + 
                n_non_stop_unique_tokens +	
                num_hrefs +	
                num_self_hrefs +	
                num_imgs +	
                num_videos + 
                average_token_length + 
                num_keywords +	
                data_channel_is_lifestyle +	
                data_channel_is_entertainment +	
                data_channel_is_bus	+
                data_channel_is_socmed +	
                data_channel_is_tech	+ 
                data_channel_is_world	 +
                kw_min_min	+
                kw_max_min	+
                kw_avg_min	+
                kw_min_max	+
                kw_max_max	+
                kw_avg_max	+
                kw_min_avg	+
                kw_max_avg	+
                kw_avg_avg	+
                self_reference_min_shares +	
                self_reference_max_shares +	
                self_reference_avg_sharess + 	
                is_weekend	+
                LDA_00	 +
                LDA_01	+
                LDA_02	 +
                LDA_03	+
                LDA_04 +
                global_subjectivity +	
                global_sentiment_polarity +	
                global_rate_positive_words +	
                global_rate_negative_words +	
                rate_positive_words	+
                rate_negative_words	+ 
                avg_positive_polarity	+
                min_positive_polarity	+
                max_positive_polarity	+
                avg_negative_polarity	+
                min_negative_polarity	+
                max_negative_polarity	+
                title_subjectivity	+
                title_sentiment_polarity +	
                abs_title_subjectivity	+
                abs_title_sentiment_polarity 
              , data=data) 
backstep <- step(socfull, direction= "backward", trace = 0)
backstep_1 <- lm(formula(backstep), data=data)

mlr_backstep_tidy <- backstep_1 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_backstep_glance <- backstep_1 |>
  glance() 

saveRDS(mlr_backstep_tidy, file = here(opt$out_dir, "mlr_backstep_tidy.rds"))
saveRDS(mlr_backstep_glance, file = here(opt$out_dir, "mlr_backstep_glance.rds"))


#FORWARD MODEL SELECTION (MODEL 8)
minfit <- lm(log_shares_per_day ~ 1, data=data)
forstep <- step(minfit, scope = formula(socfull), direction = "forward", trace = 0)
forstep_1 <- lm(formula(forstep), data=data)

mlr_forstep_tidy <- forstep_1 |>
  tidy(conf.int = TRUE) |>
  arrange(desc(estimate)) |>
  mutate(is_sig = p.value < 0.05)

mlr_forstep_glance <- forstep_1 |>
  glance() 

saveRDS(mlr_forstep_tidy, file = here(opt$out_dir, "mlr_forstep_tidy.rds"))
saveRDS(mlr_forstep_glance, file = here(opt$out_dir, "mlr_forstep_glance.rds"))

#COMPARING COEFFICIENTS BETWEEN BACKWARD AND FORWARD MODELS
backward_coefficients <- names(backstep_1$coefficients)
forward_coefficients <- names(forstep_1$coefficients)
compare_coefficients <- unique(c(backward_coefficients, forward_coefficients))
bcind <- compare_coefficients %in% backward_coefficients
fcind <- compare_coefficients %in% forward_coefficients

#TABLE 2
varcompare <- data.frame("Variables"=compare_coefficients, "backward"=bcind, "forward"=fcind)

saveRDS(varcompare, file = here(opt$out_dir, "Table2"))

#TABLE 3: VIF OF BACKWARD SELECTION MODEL

vif_backward_selection <- vif(lm(formula(backstep), data=data)) %>%
  tidy() 

saveRDS(vif_backward_selection, file = here(opt$out_dir, "Table3.rds"))

#TABLE 4: VIF OF FORWARD SELECTION MODEL
vif_forward_selection <- vif(lm(formula(forstep), data=data)) %>%
  tidy()

saveRDS(vif_forward_selection, file = here(opt$out_dir, "Table4.rds"))

#FIGURE 1: PLOTTING RESIDUALS OF BACKWARD MODEL - 
residuals = resid(lm(formula(backstep), data=data))

Figure_1 <- plot(fitted(lm(formula(backstep), data=data)), residuals)
abline(0,0) #adding the abline

ggsave(here(opt$figures_dir, "Figure_1.png"), width = 7, height = 3)

#FIGURE 2: CREATE Q-Q PLOT FOR RESIDUALS 
Figure_2 <- qqnorm(residuals)
qqline(residuals)  #add a straight diagonal line to the plot 

ggsave(here(opt$figures_dir, "Figure_2.png"), width = 7, height = 3)


# FIGURE 3: CREATING HISTOGRAM PLOT FOR RESIDUALS 
Figure_3 <- ggplot(data, aes(x = residuals)) +
  geom_histogram(bins = 50, color = 'white') +
  ggtitle("Histogram of Residuals")
ggsave(here(opt$figures_dir, "Figure_3.png"), width = 4, height = 3)


}

main(opt)