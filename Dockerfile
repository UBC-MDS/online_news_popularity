# Dockerfile for Online News Popularity Project
# Authors: Jennifer Hoang, Nagraj Rao, Linhan Cai
# Date: December 10, 2021

# use rocker/tidyverse as the base image
FROM rocker/tidyverse@sha256:d0cd11790cc01deeb4b492fb1d4a4e0d5aa267b595fe686721cfc7c5e5e8a684

# install R packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  && install2.r --error \
    --deps TRUE \
    knitr \
    docopt \
    feather \
    caret \
    here \
    car \
    caret 

# install the anaconda distribution of python
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda update -n base -c defaults conda

# put anaconda python in path
ENV PATH="/opt/conda/bin:${PATH}"

# install python packages
RUN conda install -y -c anaconda \ 
    docopt \
    altair \
    pandas \
    numpy

# install altair-saver and dependencies to export to png
RUN pip install selenium
RUN apt-get update && apt-get install -y chromium-chromedriver
RUN conda install -c conda-forge altair_saver
RUN npm install -g --force vega-lite vega-cli canvas vega --unsafe-perm=true

# install package for Rmd report render
RUN apt-get install libxt6

