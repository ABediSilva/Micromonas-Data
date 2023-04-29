# Micromonas-Data
This repository contains 1. plate reader data for Micromonas growth trials and 2. metadata for samples in each plate well and 3. R markdown files for analysis

Each markdown file extracts RFU data from plate-reader generated files. The RFUs are than merged with sample metadata to create data frames used in downstream analysis. This ananlysis takes has three steps 1) generate growth curves for each cell line, 2)extract data to identify dates of exponential growth, 3) use exponential growth information to feed into a generalized linear mixed model.

To run each markdown, one will need a folder contain plate reader data, a folder contain metadata (i.e. cell line name, whether it is resistant/susceptible, etch) for each plate, and a .csv file containing dates of exponential growth for each cell line.



