# Author: Jennifer Hoang, Nagraj Rao, Linhan Cai
# Date: Nov 24, 2021

"""Cleans and preprocesses the Online News Popularity data from:
https://archive.ics.uci.edu/ml/machine-learning-databases/00332/

Usage:
onp_data_preprocess.py --raw_data=<raw> --out_dir=<out_dir>
    
Options:
--raw_data=<raw>       File path to raw data including file name
--out_dir=<out_dir>    File path to output processed data
"""

from docopt import docopt
import os
import numpy as np
import pandas as pd

opt = docopt(__doc__)


def main(raw_data, out_dir):
    # Read Input Data
    data = pd.read_csv(raw_data)
    
    # Clean up column names
    data.columns = data.columns.str.strip()
    
    # Create 'shares_per_day' and 'log_shares_per_day'
    data['shares_per_day'] = data['shares'] / data['timedelta']
    data['log_shares_per_day'] = np.log(data['shares_per_day'])
    
    # Remove outliers below 1% and above 99% quantile
    upper_cutoff = data['shares_per_day'].quantile(0.99)
    lower_cutoff = data['shares_per_day'].quantile(0.01)
    data = data.query("@lower_cutoff < shares_per_day < @upper_cutoff")
    
    # Write cleaned data file
    out_file = os.path.join(out_dir, 'OnlineNewsPopularity_clean.csv')
    try:
        data.to_csv(out_file, index=False)
    except:
        # Create output directory
        os.mkdir(out_dir)
        data.to_csv(out_file, index=False)

    print("File created in:", out_dir)
        
if __name__ == "__main__":
    main(opt["--raw_data"], opt["--out_dir"])
