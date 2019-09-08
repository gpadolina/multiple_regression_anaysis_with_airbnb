library(dplyr)
library(ggplot2)
library(ggpubr)
library(tidyr)

remove(list = ls())

bostonAirbnb <- read.csv("~/Desktop/listings.csv", header = T, stringsAsFactors = F)

# Data exploration
View(bostonAirbnb)

# Summary provides summary statistics of the dataset
summary(bostonAirbnb)

# Some amenities are more important than others so I'll split them
airbnbAmenities <- strsplit(bostonAirbnb$amenities, ",")

# Remove url related variables because they are not needed for analysis
bostonAirbnb[, names(bostonAirbnb)[grep("url", names(bostonAirbnb))]] <- NULL
grep("url", names(bostonAirbnb))

# Remove variables with duplicated values
bostonAirbnb[, names(bostonAirbnb[(duplicated(t(bostonAirbnb)))])] <- NULL

# Create dummy variables for important amenities
dummyAmenities <- bostonAirbnb$amenities
bostonAirbnb$TV <- ifelse(grepl("TV", dummyAmenities,
                                ignore.case = T) == T, 1, 0)
bostonAirbnb$Internet <- ifelse(grepl("Internet", dummyAmenities,
                                      ignore.case = T) == T, 1, 0)
bostonAirbnb$AirCondition <- ifelse(grepl("Conditioning", dummyAmenities,
                                          ignore.case = T) == T, 1, 0)
