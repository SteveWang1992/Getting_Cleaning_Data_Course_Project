run_analysis <- function(feature_path,
                         train_x_path,
                         test_x_path,
                         train_y_path,
                         test_y_path,
                         activity_labels_path,
                         subject_train_path,
                         subject_test_path, 
                         output_path) {
    library(readr)
    library(tidyr)
    library(dplyr)
    feature_df <- read_delim(
        feature_path,
        delim = "-",
        col_names = c("feature_name", "summary_calcac", "additional"),
        trim_ws = TRUE
    )
    # Part 1: import feature.txt and build the feature tidy dataframe
    
    feature_df <-
        separate(feature_df, feature_name, c("rowid", "feature_name"), sep = " ")
    feature_df$summary_calcac <-
        str_remove(feature_df$summary_calcac, pattern = "\\(\\)")
    feature_df_sel <-
        feature_df %>% filter(summary_calcac == "mean" |
                                  summary_calcac == "std")
    feature_df_sel <-
        feature_df_sel %>% unite(combined_feature_name,
                                 c("feature_name", "summary_calcac", "additional"),
                                 remove = FALSE)
    
    feature_df_sel$combined_feature_name <-
        tolower(feature_df_sel$combined_feature_name)
    feature_df_sel$combined_feature_name <-
        str_replace(feature_df_sel$combined_feature_name,
                    pattern = "^t",
                    replacement = "time")
    feature_df_sel$combined_feature_name <-
        str_replace(feature_df_sel$combined_feature_name,
                    pattern = "^f",
                    replacement = "frequency")
    feature_df_sel$combined_feature_name <-
        str_replace(feature_df_sel$combined_feature_name,
                    pattern = "_na$",
                    replacement = "")

    # Part 2: import X_train.txt and X_test.txt, and combined them into one dataframe
    train_x_df <- read_delim(train_x_path, " ", col_names = FALSE, trim_ws = TRUE)
    test_x_df <- read_delim(test_x_path, " ", col_names = FALSE, trim_ws = TRUE)
    
    x_df <- bind_rows(train_x_df, test_x_df)
    ind <- as.integer(feature_df_sel$rowid)
    x_df <- x_df[, ind]
    names(x_df) <- feature_df_sel$combined_feature_name
    # Part 3: import y_train.txt and y_test.txt, and combined them into one dataframe
    train_y_df <-
        read_table(train_y_path,
                   col_names = "activity",
                   col_types = list(col_factor(levels = c(
                       "1", "2", "3", "4", "5", "6"
                   ))))
    test_y_df <-
        read_table(test_y_path,
                   col_names = "activity",
                   col_types = list(col_factor(levels = c(
                       "1", "2", "3", "4", "5", "6"
                   ))))
    y_df <- bind_rows(train_y_df, test_y_df)
    activity_labels_df <-
        read_table(activity_labels_path, col_names = c("rowid", "labels"))
    levels(y_df$activity) <- c(activity_labels_df$labels)
    # Part 4: import subject_train.txt and subject_test.txt and combined them into one dataframe
    subject_train_df <- read_table(subject_train_path, col_names = "subject")
    subject_test_df <- read_table(subject_test_path, col_names = "subject")
    subject_df <- bind_rows(subject_train_df, subject_test_df)
    
    analysis_df <- bind_cols(x_df, y_df, subject_df)
    # Using pipe operation to summarize and gather the final tidy dataframe and output it to the specific path
    ready_df <- (
        analysis_df
        %>% group_by(activity, subject)
        %>% summarise_all(mean)
        %>% gather(key = "variablename", value = "avgvalue", -c("activity", "subject"))
    )
    write.table(ready_df, file = output_path, row.names = FALSE)
}

# Following code are used for myself test
# run_analysis("Downloads/UCI HAR Dataset/features.txt", 
#              "Downloads/UCI HAR Dataset/train/X_train.txt", 
#              "Downloads/UCI HAR Dataset/test/X_test.txt", 
#              "Downloads/UCI HAR Dataset/train/y_train.txt", 
#              "Downloads/UCI HAR Dataset/test/y_test.txt", 
#              "Downloads/UCI HAR Dataset/activity_labels.txt", 
#              "Downloads/UCI HAR Dataset/train/subject_train.txt", 
#              "Downloads/UCI HAR Dataset/test/subject_test.txt", 
#              "/Users/steve/Desktop/datascience-JHU/Getting_And_Cleaning_Data_Project/tidy_dataset.txt")