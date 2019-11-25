### Introduction

This code project repository include fllowing four different files:

1. README.md
2. tidy_dataset.txt
3. run_analysis.R
4. Codebook.md

The purpose of this project is getting and cleaning the dataset acuquired from UCI HAR Dataset. The run_analysis.R is the script for creating a tidy summary dataset from separated datasets in the original UCI HAR Dataset folder. As a result, the tidy_dataset.txt is tidy dataset created by run_analysis.R. Codebook.md file is the companion codebook for explaining each variable in tidy_dataset.txt.

The R version used in this project is shown as following:

<!-- -->
    platform       x86_64-apple-darwin13.4.0   
    arch           x86_64                      
    os             darwin13.4.0                
    system         x86_64, darwin13.4.0        
    status                                     
    major          3                           
    minor          6.1                         
    year           2019                        
    month          07                          
    day            05                          
    svn rev        76782                       
    language       R                           
    version.string R version 3.6.1 (2019-07-05)
    nickname       Action of the Toes  

Because the run_analysis.R relys on four different packages from tidyverse, so the package version of four packages added in the run_analysis.R are listed as below:
1. readr: 1.3.1
2. tidyr: 0.8.3
3. dplyr: 0.8.0.1
4. stringr: 1.4.0

#### README.md

README.md file include the explanations of all files inside the project repository, including the self explanation for README.md itself. README.md includes the introduction of this project, present the purpose of each file existance.

#### tidy_dataset.txt

This is the dataset created by the run_analysis.R script, using the run_analysis.R script. The dataset include summrize the mean value of the extracted variable from the original dataset, group by acivity and subjects.

#### run_analysis.R

The script build up `run_analysis` function, and the function will take nine parameters listed as below:
1. feature_path: the file path of feature.txt
2. train_x_path: the file path of X_train.txt
3. test_x_path: the file path of X_test.txt
4. train_y_path: the file path of y_train.txt
5. test_y_path: the file path of y_test.txt
6. activity_labels_path: the file path of activity_labels.txt
7. subject_train_path: the file path of subject_train.txt
8. subject_test_path: the file path of subject_test.txt
9. output_path: the file path you would like to store the tidy dataset created by the `run_analysis`

The structure of `run_analysis` function code mainly have four different parts

1. Part 1: Using `read_delim()` from readr package
    Loading feature file, and then cleaning, tidying the feature dataframe. Extracting the specific features info from the features dataframe.

2. Part 2: Using `read_delim()` from readr package
    Load the X_train.txt and X_test.txt, and merge the two imported data files as one dataframe, and extract the specific columns from it. Use the extracted specific feature info we get from part 1 name the merged dataframe. 

3. Part 3: Using `read_table()` from readr package
    Load the y_train.txt and y_test.txt, and merge the two imported data files into one dataframe. And then load the activity_labels.txt file into the dataframe, using activity labels data to transform the activity data from double into factor.

4. Part 4:
    