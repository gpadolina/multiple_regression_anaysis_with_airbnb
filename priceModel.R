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
