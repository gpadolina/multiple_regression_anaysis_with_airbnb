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

![Image of Room Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/Room%20Type%20Rental.jpg)

Using ggplot, I graphed the property type frequency.

![Image of Property Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/Property%20Type%20Frequency.jpg)

#### Result
It can be concluded that people are more inclined towards listing a private room or an entire home. Perhaps a lot of people have extra rooms that they would rather put to use than be empty. In contrast, shared rooms has the least frequency. It's safe to assume that owners and guests wouldn't want to share a room with people they don't know.

As for the property type, apartments and houses take up the majority of the listings as one would expect compared the uncommon ones such as a camper or an RV and a boat.

---

I will analyze the average price by a variety of categorical variables.

![Image of Average Price by Bed Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/Average%20price%20by%20bed%20type.jpg)

Comfort is one of the most important factors when choosing a bed type. As can be expected, real beds have the highest average price amongst all bed types and airbeds has the lowest.  Couches and pull-out sofas almost has the same average price because they're quiet similar. However, couches might be a better choice for comfort while pull-out sofa can fit more but tend to be on the firm side to conceal the bed frame.

![Image of Average Price by Neighborhood](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/avgPriceByNeighborhood.png)

If you're familiar with Boston, you would know that Mattapan has been constantly ranked as one of the not so nice neighborhoods. Consequently, it has one of the lowest average price by neighborhood. Unsurpringly, Harvard Square and Financial District has some of the highest due to being a tourist attraction and a business district.

Back Bay and Allston-Brighton both each have an outlier almost or reaching the maximum listing price.

---

![Image of Average Price by Cancellation Policy](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/avgPricebyCancellationPolicy.png)

Trivially, properties with super strict cancellation policy has the highest average price which makes them positively correlated.

![Image of Average Price by Property Type](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/avgPriceByPropertyType.png)

As expected, an entire home such as a guesthouse would have one of the highest listing price. Dorms & campers/RVs would have the lowest evidently. But what really stands out in this visual is a boat having the second highest average listing price. Maybe it's a really nice boat.

---

![Image of Price Histogram](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/priceHistogram.png)

It can be concluded that this histogram is skewed to the right with some outliers listed between $750 and $1000. It's bulked is right around $100 and $250 however as what one would expect.

---

### Analysis 2
#### Is booking rate different for different cancellation policies?

I will use hypothesis testing here. Here we have:
* H0: Cancellation policy doesn't affect the average booking rate.
* H1: Cancellation policy affects the booking rate.

When a place is booked, it can be expected that it would then have a review following the stay. Thus, I will use reviews per month to measure the booking rate of a listing.

![Image of Cancellation Policy on Booking](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/cancellationPolicyonBookings.png)

This is almost similar to the visual of cancellation policy on average price. It can be seen that the cancellation policy has an effect on booking rates. Super strict has the lowest mean booking rate while moderate and strict has the highest. To further support this claim, I will run an analysis of variance (ANOVA).
```
anova <- aov(reviews_per_month ~ cancellation_policy, bostonAirbnb)

summary(anova)
```

| | Df | Sum Sq | Mean Sq | F value |
| --- | --- | --- | --- | --- |
| cancellation_policy | 3 | 294 | 98.02 | 28.25 |
| Residuals | 3581 | 12423 | 3.47 | |
| | Pr(>F) | | | |
| cancellation_policy | <2e-16 | *** |
| Residuals | | | | |

Signif. codes:
0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Since the p-value is less than the significance level of 0.05, it can be concluded that there are significant differences in differen cancellation policies. Therefore, null hypothesis can be rejected.

---

### Analysis 3
#### Does the bed type affect the review scores?

As already known, bed type has an effect on average price of listings. But lets see if it also affects the review scores. Here we have:
* H0: Bed type doesn't affect the review scores.
* H1: Bed type affects the review scores.

As stated earlier, comfort is one of the most important factors when choosing a bed type. Therefore, lets assume that bed type should have affect the review scores.

![Image of Bed Type on Review Scores Rating](https://github.com/gpadolina/multipleRegressionAnaysisWithAirbnb/blob/master/plots/bedTypeonReviewScoresRating.png)

As the graph suggests, there is almost no differences in review score ratings for different bed types. But some outliers are very surprising. Lets run an analysis of variance.
```
anova <- aov(review_scores_rating ~ bed_type, bostonAirbnb)

summary(anova)
```
| | Df | Sum Sq | Mean Sq | F value | Pr(>F) |
| --- | --- | --- | --- | --- | --- |
| bed_type | 4 | 83 | 20.67 | 0.294 | 0.882 |
| Residuals | 3580 | 251671 | 70.30 | | |

Since the p-value is larger than 0.05, null hypothesis can be accepted that the bed type doesn't affect the review scores contradicting what was expected. However, it just goes to show that review scores are not only based on bed types but on a variety of factors.

---

### Analysis 4
#### Build a price model that would make onboarding easier for property owners.
```
priceModel <- lm(price ~ AirCondition + bathrooms + beds + guests_included +
                 host_since + Internet + Kitchen + Pets + TV + 
                 reviews_per_month + review_scores_rating + 
                 as.factor(bed_type) + as.factor(cancellation_policy) +
                 as.factor(neighbourhood_cleansed) + as.factor(property_type) +
                 as.factor(room_type), bostonAirbnb)

summary(priceModel)
```
The model is fairly long but some important statistics are the following:

Residuals:

| Min | 1Q | Median | 3Q | Max
| --- | --- | --- | --- | --- |
| -316.89 | -22.16 | 0.00 | 17.81 | 611.80 |

Residual standard error: 65.13 on 2236 degrees of freedom

Multiple R-squared: 0.7871, Adjusted R-squared: 0.66

F-statistic: 6.191 on 1335 and 2236 DF, p-value: < 2.2e-16
