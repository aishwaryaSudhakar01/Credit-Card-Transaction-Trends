# Credit Card Transactions Analysis

![Project Image](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/8af2c6ad-6f10-473c-98e0-0f7f0a4e8724)
Dataset Link: [Credit Card Transactions](https://lnkd.in/d6ZTY2fQ)

IDE: BigQuery

### 1. Top 5 Cities with Highest Spends and Their Percentage Contribution

**Problem Statement:**
Identify the top 5 cities with the highest spends and their percentage contribution to total credit card spends.

**Business Purpose:**
Understanding which cities contribute the most to credit card spends helps businesses allocate marketing resources more effectively and target high-value markets. This insight can drive strategic decisions in expanding services or promotions in these top-performing cities.

**SQL Functions and Steps:**
- **SUM()**: Calculate the total spend for each city to understand the overall contribution.
- **RANK()**: Rank cities based on their total spend to identify the top 5 cities.
- **ROUND()**: Round the percentage contribution for clarity in presentation.
- **Explanation**: 
  1. **Aggregation**: First, aggregate the spend per city using the SUM() function.
  2. **Ranking**: Next, rank these cities by their total spend with the RANK() function.
  3. **Percentage Calculation**: Finally, calculate the percentage contribution of these top cities relative to the total spend using a combination of SUM() and ROUND().

![credit_card_2](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/0824fcae-22c0-4432-b3dc-9953131c27c2)

### 2. Highest Spend Month and Amount Spent for Each Card Type

**Problem Statement:**
Determine the highest spend month and the amount spent in that month for each card type.

**Business Purpose:**
Identifying peak spending periods for different card types helps in planning promotional activities and understanding customer spending behaviors. This can lead to targeted marketing and improved customer engagement during high spend periods.

**SQL Functions and Steps:**
- **FORMAT_DATE()**: Extract the month and year from transaction dates to group transactions by month.
- **SUM()**: Calculate the total spend for each card type per month to find the highest spend month.
- **RANK()**: Rank the monthly spends to identify the peak month for each card type.
- **Explanation**:
  1. **Date Formatting**: Convert transaction dates to a month-year format using FORMAT_DATE().
  2. **Aggregation**: Aggregate the spend per card type per month using SUM().
  3. **Ranking**: Rank these sums with the RANK() function and identify the month with the highest spend for each card type.

![credit_card_3](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/73140261-4a53-4d58-9354-f58030b664a2)

### 3. Transaction Details When a Card Reaches a Cumulative Sum of 1,000,000

**Problem Statement:**
Retrieve the transaction details for each card type when it reaches a cumulative spend of 1,000,000.

**Business Purpose:**
Analyzing transaction details at significant spend milestones helps in understanding customer behavior and spending patterns. This information can be useful for loyalty programs and detecting fraudulent activities.

**SQL Functions and Steps:**
- **SUM() OVER()**: Compute a running total of spends to track when the cumulative amount reaches 1,000,000.
- **ROW_NUMBER()**: Assign a sequential number to each transaction to identify the first one that hits the milestone.
- **Explanation**:
  1. **Running Total Calculation**: Use the SUM() OVER() function to calculate a running total of transaction amounts per card type.
  2. **Sequential Numbering**: Assign a row number to each transaction with ROW_NUMBER() to help identify the transaction that pushes the cumulative total over 1,000,000.
  3. **Filtering**: Filter for transactions where the running total is at least 1,000,000 and select the first such transaction for each card type.

![credit_card_4](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/d3b9f6d9-1a82-4900-9142-feb14eb8d302)

### 4. City with Lowest Gold Card Spend Percentage

**Problem Statement:**
Find the city which had the lowest percentage spend for the gold card type.

**Business Purpose:**
Determining where the gold card is underutilized can guide targeted marketing strategies to increase gold card adoption and usage in those areas.

**SQL Functions and Steps:**
- **SUM()**: Calculate total and gold-specific spends.
- **ROUND()**: Round the percentage for clarity.
- **RANK()**: Rank cities by gold spend percentage.
- **Explanation**:
  1. **Spend Calculation**: Calculate both the total spend and the gold card-specific spend per city.
  2. **Percentage Calculation**: Compute the percentage of gold card spends relative to the total spend using SUM() and ROUND().
  3. **Ranking**: Rank cities based on this percentage and identify the city with the lowest percentage.

![credit_card_5](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/135b6998-2804-4f73-9319-5610fae9784d)

### 5. Citywise Expense Types

**Problem Statement:**
Determine the highest and lowest expense types for each city.

**Business Purpose:**
Understanding the most and least common expense types in each city helps businesses tailor their offerings and promotions to better match consumer behavior and preferences in different regions.

**SQL Functions and Steps:**
- **SUM()**: Aggregate total spend per expense type.
- **RANK()**: Rank expense types within each city.
- **Explanation**:
  1. **Aggregation**: Calculate total spend per expense type for each city using SUM().
  2. **Ranking**: Rank these expense types within each city using RANK() to identify the highest and lowest spend categories.
  3. **Selection**: Select the highest and lowest ranked expense types for each city.

![credit_card_6](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/131441f1-bd58-4c00-8f44-570eab03faa2)

### 6. Percentage Contribution by Females for Each Expense Type

**Problem Statement:**
Find the percentage contribution of spends by females for each expense type.

**Business Purpose:**
Understanding gender-specific spending patterns helps in designing targeted marketing campaigns and gender-inclusive products or services.

**SQL Functions and Steps:**
- **SUM()**: Calculate total and female-specific spends.
- **ROUND()**: Round the percentage for clarity.
- **Explanation**:
  1. **Spend Calculation**: Calculate total spend and female-specific spend per expense type.
  2. **Percentage Calculation**: Compute the percentage of female spends relative to the total spend using SUM() and ROUND().

![credit_card_7](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/b4c89eb0-6865-456a-8525-f033b8db82ac)

### 7. Highest Month-over-Month Growth of (Card + Expense Type) in Jan-2014

**Problem Statement:**
Determine which card and expense type combination saw the highest month-over-month growth in January 2014.

**Business Purpose:**
Identifying significant growth trends in specific card and expense type combinations can inform marketing strategies and promotional offers tailored to high-growth segments.

**SQL Functions and Steps:**
- **FORMAT_DATE()**: Extract the month and year from transaction dates.
- **SUM()**: Calculate total spend for each combination.
- **LAG()**: Calculate the previous month's spend.
- **Explanation**:
  1. **Date Formatting**: Convert transaction dates to a month-year format using FORMAT_DATE().
  2. **Aggregation**: Aggregate total spend per card type and expense type combination per month using SUM().
  3. **Growth Calculation**: Use LAG() to find the previous month's spend and calculate the month-over-month growth.
  4. **Ranking**: Rank the growth rates and identify the highest growth combination for January 2014.

![credit_card_8](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/7c74d8f3-e85c-4612-9afa-f4957860d734)

### 8. Spend to Transactions Ratio on Weekends for Each City

**Problem Statement:**
Determine which city has the highest total spend to total number of transactions ratio during weekends.

**Business Purpose:**
Understanding weekend spending behavior helps in optimizing weekend-specific offers and promotions, enhancing customer engagement during peak times.

**SQL Functions and Steps:**
- **FORMAT_DATE()**: Identify weekend transactions.
- **SUM() and COUNT()**: Calculate total spend and number of transactions.
- **ROUND()**: Calculate and round the spend to transactions ratio.
- **Explanation**:
  1. **Weekend Identification**: Identify transactions that occurred on weekends using FORMAT_DATE().
  2. **Calculation**: Calculate total spend and the number of transactions per city during weekends using SUM() and COUNT().
  3. **Ratio Calculation**: Compute the spend to transactions ratio and round it using ROUND().

![credit_card_9](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/2cfbee96-29e4-4e21-bf06-1f4969bcf41c)

### 9. City That Took the Least Amount of Time to Reach Its 500th Transaction

**Problem Statement:**
Identify the city that took the least number of days to reach its 500th transaction from its first transaction.

**Business Purpose:**
Understanding transaction growth rates in different cities helps in identifying fast-growing markets and tailoring strategies to support and capitalize on this growth.

**SQL Functions and Steps:**
- **ROW_NUMBER()**: Track transaction sequence.
- **MIN() and DATE_DIFF()**: Calculate the difference in days between the first and 500th transaction.
- **RANK()**: Rank cities by the time taken to reach 500 transactions.
- **Explanation**:
  1. **Transaction Sequence**: Use ROW_NUMBER() to assign a sequence number to transactions per city.
  2. **Date Calculation**: Use MIN() and DATE_DIFF() to find the time difference between the first and 500th transaction.
  3. **Ranking**: Rank cities by this time difference to find the city that reached 500 transactions the fastest.

![credit_card_10](https://github.com/aishwaryaSudhakar01/Credit-Card-Transaction-Trends/assets/126569607/020eeec1-8720-4b2e-bf70-7cfaee9f5327)
