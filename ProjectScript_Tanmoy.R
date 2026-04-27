## Import Dataset
Cost_of_Living_and_Income_Extended <- read.csv("~/Documents/MSBA_Mercy/Spring 2025/Fundamental Modeling/wd/Project/Cost_of_Living_and_Income_Extended.csv")
View(Cost_of_Living_and_Income_Extended)
## Install Packages
install.packages(c("tidyverse", "ggplot2", "readr", "dplyr", "ggthemes", "scales", "lubridate", "corrplot"))

# Load the libraries
library(tidyverse)
library(ggplot2)
library(readr)
library(dplyr)
library(ggthemes)
library(scales)
library(lubridate)
library(corrplot)

## Data Understanding
raw_data <- Cost_of_Living_and_Income_Extended

glimpse(raw_data)
str(raw_data)
summary(raw_data)

## Clean Dataset

# Calculate actual costs from percentage fields
data_with_costs <- raw_data %>%
  mutate(Housing_Cost_Amount = Average_Monthly_Income * Housing_Cost_Percentage / 100,
    Healthcare_Cost_Amount = Average_Monthly_Income * Healthcare_Cost_Percentage / 100,
    Education_Cost_Amount = Average_Monthly_Income * Education_Cost_Percentage / 100,
    Transportation_Cost_Amount = Average_Monthly_Income * Transportation_Cost_Percentage / 100,
    Tax_Amount = Average_Monthly_Income * Tax_Rate / 100)
View(data_with_costs)

# Group by Country, Year, Region and average the numeric values
clean_data <- data_with_costs %>%
  group_by(Region, Country, Year) %>%
  summarise(
    Average_Monthly_Income = mean(Average_Monthly_Income, na.rm = TRUE),
    Cost_of_Living = mean(Cost_of_Living, na.rm = TRUE),
    Housing_Cost_Amount = mean(Housing_Cost_Amount, na.rm = TRUE),
    Healthcare_Cost_Amount = mean(Healthcare_Cost_Amount, na.rm = TRUE),
    Education_Cost_Amount = mean(Education_Cost_Amount, na.rm = TRUE),
    Transportation_Cost_Amount = mean(Transportation_Cost_Amount, na.rm = TRUE),
    Tax_Amount = mean(Tax_Amount, na.rm = TRUE),  # <-- Average tax amount
    .groups = 'drop'
  )
View(clean_data) ## We have different numbers of observations for each country.


## Let's have a look at the the Average Monthly Income over time in Australia

# Filter the data for Australia
australia_data <- clean_data %>%
  filter(Country == "Australia")

# Create the time series line plot for Average Monthly Income
ggplot(australia_data, aes(x = Year, y = Average_Monthly_Income)) +
  geom_line(color = "red", linewidth = 1.2) +
  geom_point(color = "blue", size = 2) +
  geom_text(aes(label = round(Average_Monthly_Income, 0)), 
            vjust = -0.8, size = 3) +              
  labs(
    title = "Australia: Average Monthly Income Over Time",
    x = "Year",
    y = "Average Monthly Income (USD)"
  ) +
  theme_clean(base_size = 12) +
  scale_y_continuous(labels = scales::comma)

## Odd fluctuations of average monthly income in consecutive years for a country!
## It might happened due to the poor data quality.
## Therefore, It will be better to set the business questions at the Regional level.


## Research Questions

## 1. Which regions offer the highest disposable income after accounting for living costs and taxes?
## Calculate Disposable Income
Data_with_Disposable_Income <- clean_data %>%
  mutate(
    Disposable_Income = Average_Monthly_Income - (Cost_of_Living + Tax_Amount)
  )
View(Data_with_Disposable_Income)

## Calculate Average Disposable Income by Region
region_disposable_income <- Data_with_Disposable_Income %>%
  group_by(Region) %>%
  summarise(
    Avg_Disposable_Income = mean(Disposable_Income, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(Avg_Disposable_Income))  # Sort highest to lowest

View(region_disposable_income)

# Create a bar plot for regional disposable income
ggplot(region_disposable_income, aes(x = reorder(Region, Avg_Disposable_Income), 
                                     y = Avg_Disposable_Income, fill = Region)) +
  geom_col(show.legend = FALSE) +     # Bar plot without a legend
  coord_flip() +                      # Flip axes for better readability
  labs(
    title = "Average Disposable Income by Region",
    x = "Region",
    y = "Average Disposable Income (USD)"
  ) +
  theme_clean(base_size = 12) +
  geom_text(aes(label = round(Avg_Disposable_Income, 1)), 
            hjust = -0.1, size = 3) +
  scale_fill_brewer(palette = "Set3")

## Findings:
## Across all regions, average disposable income after accounting for taxes and living costs is negative.
## South America shows the least financial strain, while Europe faces the highest deficit.
## The data highlights a widespread affordability challenge across global regions.



## 2. Are some regions disproportionately affected by housing costs?

# Summarize Average Housing Burden by Region (calculated directly)
region_housing_burden <- Data_with_Disposable_Income %>%
  group_by(Region) %>%
  summarise(
    Avg_Housing_Burden = mean(Housing_Cost_Amount / Average_Monthly_Income * 100, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(Avg_Housing_Burden))
View(region_housing_burden)

## Question 2 Visualization
ggplot(region_housing_burden,
       aes(x = Avg_Housing_Burden, 
           y = reorder(Region, Avg_Housing_Burden),
           fill = Region)) +  # Changed to fill aesthetic
  geom_point(size = 6, shape = 21, color = "black") +  # shape 21 = filled circle
  geom_text(aes(label = paste0(round(Avg_Housing_Burden, 1), "%")),
            hjust = -0.5, size = 3) +
  scale_fill_brewer(palette = "Set3") +  # Changed to scale_fill_brewer
  labs(title = "Regional Housing Burden Comparison",
       x = "% of Income", 
       y = "Regions") +
  theme_clean(base_size = 12) +
  xlim(min(region_housing_burden$Avg_Housing_Burden)*0.95, 
       max(region_housing_burden$Avg_Housing_Burden)*1.05) +
  guides(fill = "none")  # Remove fill legend

## Findings:
# The graph compares the average housing cost burden across different regions, showing what percentage of income is spent on housing.
# South America faces the highest burden at 36.2%, followed closely by North America and Europe at around 35.9%.
# Overall, all regions spend approximately one-third of their income on housing, indicating a widespread affordability pressure.

## 3. Which regions offer better opportunities for savings based on income and expenses?

# Calculate Savings Opportunity Percentage
Data_with_Savings_Opportunity <- Data_with_Disposable_Income %>%
  mutate(
    Savings_Opportunity_Percentage = (Disposable_Income / Average_Monthly_Income) * 100
  )

# Summarize by Region
region_savings_opportunity <- Data_with_Savings_Opportunity %>%
  group_by(Region) %>%
  summarise(
    Avg_Savings_Opportunity = mean(Savings_Opportunity_Percentage, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(Avg_Savings_Opportunity))  # Sort from best to worst

View(region_savings_opportunity)


## Question 3 Visualization

# Create a Bar Plot for Regional Savings Opportunity
ggplot(region_savings_opportunity, aes(x = reorder(Region, Avg_Savings_Opportunity),
                                       y = Avg_Savings_Opportunity,
                                       fill = Region)) +
  geom_col(show.legend = FALSE) +   # Hide legend if not needed
  geom_text(aes(label = paste0(round(Avg_Savings_Opportunity, 1), "%")),
            vjust = -0.5, size = 3) +
  scale_fill_brewer(palette = "Set3") +  # Use Set3 palette
  labs(
    title = "Average Savings Opportunity by Region",
    x = "Region",
    y = "Savings Opportunity (% of Income)"
  ) +
  theme_minimal(base_size = 12) +
  scale_y_continuous(labels = scales::percent_format(scale = 1))

##Findings
# The bar chart shows the average savings opportunity across different regions, measured as the percentage of income remaining after taxes and living costs.
# All regions display negative savings opportunities, meaning expenses exceed income on average.
# North America has the smallest deficit at –24.1%, indicating relatively better conditions for saving compared to other regions, while Oceania faces the largest shortfall at –47.5%.

## Followup Business Questions:
# Are high housing costs related to high healthcare or education costs?

# Select only the relevant columns
cost_relationship_data <- Data_with_Disposable_Income %>%
  select(Housing_Cost_Amount, Healthcare_Cost_Amount, Education_Cost_Amount)

# Calculate correlation matrix
cost_correlation_matrix <- cor(cost_relationship_data, use = "complete.obs")

# View correlation values
print(cost_correlation_matrix)

# Visualize the correlation matrix
corrplot(cost_correlation_matrix,
         method = "color",         # Color-filled squares
         type = "upper",           # Show only upper triangle
         addCoef.col = "white",    # Show correlation coefficients
         number.cex = 1.2,         # Increase font size of correlation coefficients
         tl.col = "black",         # Label color
         tl.cex = 1.2,             # Increase axis label size
         tl.srt = 45)              # Rotate labels

# Predict Healthcare Cost based on Housing Cost
model_healthcare <- lm(Healthcare_Cost_Amount ~ Housing_Cost_Amount,
                       data = Data_with_Disposable_Income)
summary(model_healthcare)

# Findings_healthcare:
# The model shows a positive and statistically significant relationship between housing costs and healthcare costs.
# For every additional $1 increase in housing cost, healthcare costs are expected to rise by about $0.27 on average.
# The model explains approximately 54.8% of the variation in healthcare costs (R² = 0.5482), indicating a moderately strong fit.
# The relationship is highly significant with a p-value less than 0.001.

# Predict Education Cost based on Housing Cost
model_education <- lm(Education_Cost_Amount ~ Housing_Cost_Amount,
                      data = Data_with_Disposable_Income)
summary(model_education)


# Findings_education:
# The model analyzes the relationship between housing costs and education costs.
# It shows a positive and statistically significant relationship: for every $1 increase in housing cost, education costs are expected to increase by about $0.19 on average.
# The model explains approximately 44.2% of the variation in education costs (R² = 0.4419), indicating a moderate relationship.
# The relationship is highly significant with a p-value less than 0.001, suggesting it is very unlikely to be due to random chance.

## Create word cloud for Thank you slide 
# Install required packages
install.packages(c("tm", "wordcloud", "RColorBrewer"))

# Load libraries
library(tm)
library(wordcloud)
library(RColorBrewer)

# Define project-specific terms and their frequency
keywords <- c("Thank You!", "Questions?", "Disposable Income", "Housing Cost",
              "Education", "Healthcare", "Savings", "CRISP-DM", "Analysis", 
              "Living Cost", "Region", "Income", "Evaluation", "Modeling", 
              "R Programming", "Tax", "Conclusion", "Affordability", 
              "Data Ethics", "Insight", "Visualization")

# Assign relative frequencies (adjust for emphasis)
frequencies <- c(15, 15, 8, 8, 4, 4, 7, 7, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2)

# Create a data frame
df <- data.frame(word = keywords, freq = frequencies)

# Generate the word cloud
set.seed(123)
wordcloud(words = df$word,
          freq = df$freq,
          min.freq = 1,
          max.words = 100,
          random.order = FALSE,
          rot.per = 0.2,
          colors = brewer.pal(8, "Set1"))
