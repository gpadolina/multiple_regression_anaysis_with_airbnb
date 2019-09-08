## Multiple Regression Analysis Using Airbnb Data

The objective of this project is to make onboarding process for Boston homeowners easier by suggesting to them how much they should charge for their property.

The dataset is from Airbnb, which includes about 37 features and 3,586 observations. To give an overview of this data, some features are the following:
- neighbourhood
- property type
- room type
- bed type
- amenities
- reviews rating

This project is done using R and I will follow Google's R style guide.

---

### Analysis 1
#### What causes the diffence between prices in listings?
*Data Wrangling*: Please see the following [data](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/priceModel.R) transformation that I made by leveraging dplyr and tidyr libraries using R. I will use the cleaned data for the rest of the analysis.

Here, I categorized the listings based on their room type.

| Room Type | Frequency |
| --- | --- |
| Entire home/apt | 2127 |
| Private room | 1378 |
| Shared room | 80 |

![Image of Room Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/roomType.png)

Using ggplot, I graphed the property type frequency.

![Image of Property Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/propertyType.png)

#### Result
It can be concluded that people are more inclined towards listing a private room or an entire home. Perhaps a lot of people have extra rooms that they would rather put to use than be empty. In contrast, shared rooms has the least frequency. It's safe to assume that owners and guests wouldn't want to share a room with people they don't know.

As for the property type, apartments and houses take up the majority of the listings as one would expect compared the uncommon ones such as a camper or an RV and a boat.

---

I will analyze the average price by a variety of categorical variables.

![Image of Average Price by Bed Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/avgPriceByBedType..png)

Comfort is one of the most important factors when choosing a bed type. As can be expected, real beds have the highest average price amongst all bed types and airbeds has the lowest.  Couches and pull-out sofas almost has the same average price because they're quiet similar. However, couches might be a better choice for comfort while pull-out sofa can fit more but tend to be on the firm side to conceal the bed frame.
