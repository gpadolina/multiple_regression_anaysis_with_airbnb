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
bostonAirbnb$Kitchen <- ifelse(grepl("Kitchen", dummyAmenities,
                                     ignore.case = T) == T, 1, 0)
bostonAirbnb$AirCondition <- ifelse(grepl("Conditioning", dummyAmenities,
                                          ignore.case = T) == T, 1, 0)
bostonAirbnb$TV <- ifelse(grepl("TV", dummyAmenities,
                                ignore.case = T) == T, 1, 0)
bostonAirbnb$Internet <- ifelse(grepl("Internet", dummyAmenities,
                                      ignore.case = T) == T, 1, 0)
bostonAirbnb$Pets <- ifelse(grepl("Pet", dummyAmenities,
                                  ignore.case = T) == T, 1, 0)
bostonAirbnb$Pets <- ifelse(grepl("Dog", dummyAmenities,
                                  ignore.case = T) == T, 1, bostonAirbnb$Pets)
bostonAirbnb$Pets <- ifelse(grepl("Cat", dummyAmenities,
                                  ignore.case = T) == T, 1, bostonAirbnb$Pets)
bostonAirbnb[, c("amenities")] <- NULL

# Convert variables to appropriate data types
bostonAirbnb$price <- sub("\\$", " ", bostonAirbnb$price)
bostonAirbnb$price <- sub(",", " ", bostonAirbnb$price)
bostonAirbnb$price <- as.integer(bostonAirbnb$price)

# Convert categorical variables into factors
bostonAirbnb$cancellation_policy <- as.factor(bostonAirbnb$cancellation_policy)
bostonAirbnb$host_is_superhost <- as.factor(bostonAirbnb$host_is_superhost)
bostonAirbnb$instant_bookable <- as.factor(bostonAirbnb$instant_bookable)
bostonAirbnb$neighbourhood_cleansed <- as.factor(
  bostonAirbnb$neighbourhood_cleansed)
bostonAirbnb$property_type <- as.factor(bostonAirbnb$property_type)
bostonAirbnb$room_type <- as.factor(bostonAirbnb$room_type)

# Convert characters that should be numeric
bostonAirbnb$extra_people <- as.numeric(sub("\\$", " ", bostonAirbnb$extra_people))

# Replace missing values with the median value
bostonAirbnb$bathrooms <- ifelse(is.na(bostonAirbnb$bathrooms) == T,
                                 1, bostonAirbnb$bathrooms)
bostonAirbnb$beds <- ifelse(is.na(bostonAirbnb$beds) == T, 1, bostonAirbnb$beds)
bostonAirbnb$bedrooms <- ifelse(is.na(bostonAirbnb$bedrooms) == T,
                                1, bostonAirbnb$bedrooms)
bostonAirbnb$review_scores_rating <- ifelse(is.na(bostonAirbnb$
                                                  review_scores_rating) == T, 91.9,
                                            bostonAirbnb$review_scores_rating)
bostonAirbnb$reviews_per_month <- ifelse(is.na(bostonAirbnb$
                                               reviews_per_month) == T, 1.98,
                                         bostonAirbnb$reviews_per_month)

# Count room type
count(bostonAirbnb, "room_type")

roomType <- roomType %>% 
  mutate(room_type = factor(room_type, levels = c("Entire home/apt",
                                                  "Private room",
                                                  "Shared room")),
         cumulative = cumsum(freq),
         midpoint = cumulative - freq / 2,
         label = paste0(room_type, " ", round(freq / sum(freq) * 100, 1) "%"))

ggplot(roomType, aes(x = 1, weight = freq, fill = room_type)) +
  geom_bar(width = 1, position = "stack") +
  coord_polar(theta = "y") +
  geom_text(aes(x = 1.3, y = midpoint, label = label)) +
  labs(
    title = "Room Type Distribution",
    x = NULL,
    y = NULL,
    fill = "Room Type"
  )

# Count property type
ggplot(bostonAirbnb, aes(property_type)) +
  geom_bar() +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 2500, by = 500)) +
  labs(
    x = "Property Type",
    y = "Number of Listings"
    )

# Average price by bed type
ggplot(bostonAirbnb, aes(x = factor(bed_type), y = price, fill = bed_type)) +
  stat_summary(fun.y = "mean", geom = "bar") +
  labs(
    title = "Average price by bed type",
    x = "Bed Type",
    y = "Average Price",
    fill = "Bed Type"
    )

# Average price by neighborhood
ggplot(bostonAirbnb, aes(x = factor(neighbourhood), y = price,
                         fill = neighbourhood)) +
  stat_summary(fun.y = "mean", geom = "bar", show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Average price by neighbourhood",
    x = "Neighborhood",
    y = "Average Price"
    )

# Average price by bed type & cancellation policy
ggplot(bostonAirbnb, aes(cancellation_policy, price, fill = cancellation_policy)) +
  stat_summary(fun.y = "mean", geom_bar = "bar", show.legend = FALSE) +
  labs(
    title = "Average Price by Cancellation Policy",
    x = "Cancellation Policy",
    y = "Average Price"
    )

# Average price by property type
ggplot(bostonAirbnb, aes(x = factor(property_type), y = price,
                         fill = property_type)) +
  stat_summary(fun.y = "mean", geom = "bar", show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Average Price by Property Type",
    x = "Property Type",
    y = "Average Price"
    )

# Outliers
ggplot(bostonAirbnb, aes(price)) +
  geom_histogram() +
  labs(
    title = "Price Histogram",
    x = "Price",
    y = "Count"
    )

# Box-plot
ggboxplot(bostonAirbnb, x = "cancellation_policy",
          y = "reviews_per_month", color = "cancellation_policy",
          ylab = "Bookings Per Month", xlab = "Cancellation Policy")

ggplot(bostonAirbnb, aes(cancellation_policy, reviews_per_month)) +
  geom_boxplot(aes(color = cancellation_policy)) +
  labs(
    title = "Cancellation Policy Per Month",
    y = "Bookings Per Month",
    x = "Cancellation Policy"
    )

# Analysis of variance (ANOVA)
anova <- aov(reviews_per_month ~ cancellation_policy, bostonAirbnb)

summary(anova)
