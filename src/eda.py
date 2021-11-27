# Author: Jennifer Hoang, Nagraj Rao, Linhan Cai
# Date: Nov 26, 2021

"""Creates figures from EDA for Online News Popularity dataset:
https://archive.ics.uci.edu/ml/machine-learning-databases/00332/

Usage:
  eda.py --data_path=<data_path> --figures_path=<figures_path>
  
Options:
  --data_path=<data_path>         File path to data for EDA
  --figures_path=<figures_path>   File path for location to save figures
"""

from docopt import docopt
import os
import altair as alt
import numpy as np
import pandas as pd
from altair_saver import save

opt = docopt(__doc__)


def main(data_path, figures_path):
    # Read data
    ONP_csv = pd.read_csv(data_path)

    # Merge 'data channel' feature for visualization
    ONP_csv = merge_data_column(ONP_csv)

    # Create plot of shares per data channel topic
    plot_1 = (
        alt.Chart(ONP_csv)
        .mark_bar()
        .encode(
            y=alt.Y("data_channel", title="Data Channel"),
            x=alt.X(" shares", title="Shares"),
        )
    )
    file_path_1 = os.path.join(figures_path, "01_EDA-Bar-Plot-Data-Channel.png")
    plot_1.save(file_path_1)

    # Create histogram of distribution of shares plot
    plot_2 = (
        alt.Chart(ONP_csv)
        .mark_bar()
        .encode(
            x=alt.X(
                " shares",
                bin=alt.Bin(maxbins=3000),
                scale=alt.Scale(domain=(0, 25000), clamp=True),
                title="Shares",
            ),
            y=alt.Y("count()", title="Count"),
        )
    )
    file_path_2 = os.path.join(figures_path, "02_EDA-Shares-Histogram.png")
    plot_2.save(file_path_2)

    # Create correlation plot of features
    corr_df = (
        ONP_csv.select_dtypes("number")
        .corr("spearman")
        .stack()
        .reset_index(name="corr")
    )
    corr_df.loc[corr_df["corr"] == 1, "corr"] = 0  # Remove diagonal
    corr_df["abs"] = corr_df["corr"].abs()

    plot_3 = (
        alt.Chart(corr_df)
        .mark_circle()
        .encode(
            x=alt.X("level_0", title="Feature"),
            y=alt.Y("level_1", title = "Feature"),
            size="abs",
            color=alt.Color(
                "corr", scale=alt.Scale(scheme="blueorange", domain=(-1, 1))
            ),
        )
    )
    file_path_3 = os.path.join(figures_path, "03_EDA-Correlation-Plot.png")
    plot_3.save(file_path_3)


def merge_data_column(ONP_csv):
    """
    Function to merge 'data channel' column into one column.
    """
    DataChannelMerge = ONP_csv[
        [
            " data_channel_is_lifestyle",
            " data_channel_is_entertainment",
            " data_channel_is_bus",
            " data_channel_is_socmed",
            " data_channel_is_tech",
            " data_channel_is_world",
        ]
    ]

    DataChannel_arr = []
    for r in list(range(DataChannelMerge.shape[0])):
        if (
            ((DataChannelMerge.iloc[r, 0]) == 0)
            and ((DataChannelMerge.iloc[r, 1]) == 0)
            and ((DataChannelMerge.iloc[r, 2]) == 0)
            and ((DataChannelMerge.iloc[r, 3]) == 0)
            and ((DataChannelMerge.iloc[r, 4]) == 0)
            and ((DataChannelMerge.iloc[r, 5]) == 0)
        ):
            DataChannel_arr.append("Others")
        for c in list(range(DataChannelMerge.shape[1])):
            if (c == 0) and (DataChannelMerge.iloc[r, c]) == 1:
                DataChannel_arr.append("Lifestyle")
            elif (c == 1) and (DataChannelMerge.iloc[r, c]) == 1:
                DataChannel_arr.append("Entertainment")
            elif (c == 2) and (DataChannelMerge.iloc[r, c]) == 1:
                DataChannel_arr.append("Business")
            elif (c == 3) and (DataChannelMerge.iloc[r, c]) == 1:
                DataChannel_arr.append("Social Media")
            elif (c == 4) and (DataChannelMerge.iloc[r, c]) == 1:
                DataChannel_arr.append("Tech")
            elif (c == 5) and (DataChannelMerge.iloc[r, c]) == 1:
                DataChannel_arr.append("World")

    ONP_csv.insert(loc=12, column="data_channel", value=DataChannel_arr)

    ONP_csv.drop(
        labels=[
            " data_channel_is_lifestyle",
            " data_channel_is_entertainment",
            " data_channel_is_bus",
            " data_channel_is_socmed",
            " data_channel_is_tech",
            " data_channel_is_world",
        ],
        axis=1,
        inplace=True,
    )

    return ONP_csv


if __name__ == "__main__":
    main(opt["--data_path"], opt["--figures_path"])
