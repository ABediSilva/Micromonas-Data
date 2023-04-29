# Micromonas-Data
This repository contains 1. plate reader data for Micromonas growth trials and 2. code used to analyze said data.

Two R markdown files are included in this release: 1) "May2018LightTrials.Rmd" and 2)"Sept2019LightTrials.Rmd"
Each markdown files takes plate reader data, in the form of Raw Flourescence Units (RFUs), merges it with sample information, plots growth curves for each sample, and then feeds exponential phase growth rate information into a generalized linear mixed model (glmm).

To run code in each markdown file, one will need 
1) a folder of raw plate reader data found in the appropriately named repository 
2) a folder contain sample metadata found in the appropriately named repository 
3) files containing dates of exponential growth for both high and low light cultures


