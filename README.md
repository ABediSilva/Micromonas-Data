# Micromonas-Data
This repository contains 1. plate reader data for Micromonas growth trials and 2. metadata for samples in each plate well and 3. R markdown files for analysis

#Markdown Files
Each markdown file extracts RFU data from plate-reader generated files. The RFUs are than merged with sample metadata to create data frames used in downstream analysis. This ananlysis takes has three steps 1) generate growth curves for each cell line, 2)extract data to identify dates of exponential growth, 3) use exponential growth information to feed into a generalized linear mixed model.

To run each markdown, one will need a folder contain plate reader data, a folder contain metadata (i.e. cell line name, whether it is resistant/susceptible, etch) for each plate, and a .csv file containing dates of exponential growth for each cell line.


#May 2018 vs. September 2019

The May 2018 growth experiments contained only susceptible and resistant cell lined. 
The September 2019 growth experiements contained an additional phenotypr of multiply resistant, or "MR", lines. Labelling between the two experiments is somewhat different because of the additional phenotype. Futhermore, the manuscript for this study uses slightly differnt names for each Micromonas and virus strain for precision and brevity.
With this in mind, the following are equivalent labels for each sample:
Host strain equivalents
FL13 = M1 = U61
FL42 = M2 = U65

Virus strain equivalents
FL13V = V1
FL22V = V2
FL28V = V3
FL42V = V4

Phenotype equivalents
S= Per (susceptible descebdants)
Res = SR (resistant to one virus or "singly resistant"
