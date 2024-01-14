#Micromonas-Data

This repository contains plate reader data for Micromonas growth trials, metadata for samples in each plate well, R markdown files for analysis. This data contained in this repository is associated with the study “Resisting viral infection leads to transient, light-dependent fitness costs in a microalga.”

#Markdown Files
Each markdown file extracts RFU data for each Micromonas cell line from plate-reader generated files. The RFUs are than merged with sample metadata to create data frames used in downstream analysis. This analysis has three steps 1) generate growth curves for each cell line, 2) use curves to identify dates of exponential growth, 3) use exponential growth information to feed into a generalized linear mixed model.


To run each markdown, one will need a folder containing plate reader data (i.e., ‘May2018PlateReaderData’ or ‘September2019PlateReaderData’), a folder contain labels for each well in each plate (i.e., ‘May2018PlateMetaData/platelabels’ or ‘September2019PlateMetaData/MRSRLabels’), and .csv files containing dates of exponential growth for each cell line under high and low light (‘May2018PlateMetaData/hidatelist.csv’,  ‘May2018PlateMetaData/lodatelist.csv’; September2019PlateMetaData/HiMRSRDates.csv, September2019PlateMetaData/LoMRSRDates.csv)


#May 2018 vs. September 2019
The May 2018 growth experiments contained only susceptible and resistant cell lines. The September 2019 growth experiments contained an additional phenotype of multiply resistant, or "MR", lines. Labelling between the two experiments is somewhat different because of the additional phenotype and one will see that the September 2019 experiments often have “MRSR” directory and filenames. 

#Further label notes
Furthermore, the manuscript for this study uses slightly different names for each Micromonas and virus strain for precision and brevity. With this in mind, the following are equivalent labels for each sample: 
Host strain equivalents 
FL13 = M1 = U61 FL42 = M2 = U65
Virus strain equivalents 
FL13V = V1 FL22V = V2 FL28V = V3 FL42V = V4
Phenotype equivalents S= Per (susceptible descendants) Res = SR (resistant to one virus or "singly resistant"

Each growth experiment used replicate plates grown at either high or low light. Directory and file names concatenate light level (hi or lo), plate number (plate 1, 2, 3, etc.), a letter indicating which replicate (a, b), and the number of transfer (often corresponds since week since start of experiment; T1, T2, T3).
An example of a plate label is ‘Hi1aT2’, indicate plate 1, replicate a grown in high light after its first transfer.

![image](https://github.com/ABediSilva/Micromonas-Data/assets/43560811/7fd78436-157b-4047-a861-eac4e4423972)

