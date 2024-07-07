SELECT *
FROM `credit_card_case_study.credit_card_transactions`;

-- top 5 cities with highest spend and their % contribution
WITH top_cities AS (
  SELECT 
    City AS city_name,
    SUM(Amount) AS total_amount,
    RANK() OVER (ORDER BY SUM(Amount) DESC) AS rn
  FROM `credit_card_case_study.credit_card_transactions`
  GROUP BY City
)

SELECT
  city_name,
  total_amount,
  ROUND(total_amount * 100.0 / (SELECT SUM(Amount) FROM `credit_card_case_study.credit_card_transactions` ), 2) 
    AS spend_perc
FROM top_cities
WHERE rn <= 5
ORDER BY rn;

-- highest spend month and amount spent in that month for each card type
WITH top_spends AS (
  SELECT 
    `Card Type` AS card_type,
    FORMAT_DATE('%Y-%m', `Date`) AS transaction_month,
    SUM(Amount) AS total_spend
  FROM `credit_card_case_study.credit_card_transactions`
  GROUP BY 
    `Card Type`,
    FORMAT_DATE('%Y-%m', `Date`)
),

spend_ranking AS (
  SELECT *,
    RANK() OVER (PARTITION BY card_type ORDER BY total_spend DESC) AS rn
  FROM top_spends
)

SELECT 
  card_type,
  transaction_month,
  total_spend
FROM spend_ranking
WHERE rn = 1;

-- transaction details when a card reaches a cumulative sum of 1,000,000 
WITH details AS (
  SELECT 
    `index`,
    `Card Type` AS card_type,
    City AS city_name,
    `Date` AS payment_date,
    `Exp Type` AS expense_type,
    Gender AS gender,
    Amount AS amount,
    SUM(Amount) OVER (PARTITION BY `Card Type` ORDER BY `Date` ROWS BETWEEN
      UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
  FROM `credit_card_case_study.credit_card_transactions`
),

first_million AS (
  SELECT 
    `index`,
    card_type,
    city_name,
    payment_date,
    expense_type,
    gender,
    amount,
    running_total,
    ROW_NUMBER() OVER (PARTITION BY card_type ORDER BY payment_date) AS rn
  FROM details
  WHERE running_total >= 1000000
)

SELECT 
  `index`, 
  card_type,
  city_name,
  payment_date,
  expense_type,
  gender,
  amount
FROM first_million
WHERE rn = 1;

-- city with lowest gold card spend percentage 
WITH gold_trend AS (
  SELECT 
    City AS city_name,
    SUM(CASE WHEN `Card Type` = 'Gold' THEN Amount ELSE 0 END) AS gold_spend,
    SUM(Amount) AS total_spend,
    ROUND(SUM(CASE WHEN `Card Type` = 'Gold' THEN Amount ELSE 0 END) * 100.0 / SUM(Amount), 2) AS gold_perc
  FROM `credit_card_case_study.credit_card_transactions`
  GROUP BY City
),

perc_rank AS (
  SELECT
    city_name,
    gold_perc,
    RANK() OVER (ORDER BY gold_perc) AS rn
  FROM gold_trend
  WHERE gold_perc <> 0.00
)

SELECT 
  city_name,
  gold_perc
FROM perc_rank
WHERE rn = 1;

-- citywise expense types
WITH expense_trends AS (
  SELECT 
    City AS city_name,
    `Exp Type` AS expense_type,
    SUM(Amount) AS total_amount
  FROM `credit_card_case_study.credit_card_transactions`
  GROUP BY 
    City,
    `Exp Type`
),

expense_ranking AS (
  SELECT 
    city_name,
    expense_type,
    total_amount,
    RANK() OVER (PARTITION BY city_name ORDER BY total_amount DESC) AS rn1,
    RANK() OVER (PARTITION BY city_name ORDER BY total_amount) AS rn2
  FROM expense_trends
)

SELECT 
  city_name,
  MAX(CASE WHEN rn1 = 1 THEN expense_type END) AS highest_expense_type,
  MAX(CASE WHEN rn2 = 1 THEN expense_type END) AS lowest_expense_type
FROM expense_ranking
GROUP BY city_name;

-- percentage contribution by females for each expense type
SELECT
  `Exp Type` AS expense_type,
  SUM(CASE WHEN gender = 'F' THEN Amount ELSE 0 END) AS female_total_amount,
  SUM(Amount) AS total_amount,
  ROUND(SUM(CASE WHEN gender = 'F' THEN Amount ELSE 0 END) * 100.0 / SUM(Amount), 2) AS female_perc
FROM `credit_card_case_study.credit_card_transactions`
GROUP BY `Exp Type`
ORDER BY female_perc DESC;

-- highest month-over-month growth of (card + expense type) in jan 2014
WITH expense_trend AS (
  SELECT 
    FORMAT_DATE('%Y-%m', `Date`) AS transaction_month,
    `Card Type` AS card_type,
    `Exp Type` AS expense_type,
    SUM(Amount) AS total_amount
  FROM `credit_card_case_study.credit_card_transactions`
  GROUP BY 
    FORMAT_DATE('%Y-%m', `Date`),
    `Card Type`,
    `Exp Type`
  ORDER BY transaction_month
),

growth_trends AS (
  SELECT 
    transaction_month,
    CONCAT(card_type, ' + ', expense_type) AS purchase_combination,
    total_amount,
    LAG(total_amount, 1) OVER (PARTITION BY CONCAT(card_type, ' + ', expense_type) ORDER BY transaction_month) 
      AS prev_total_amount
  FROM expense_trend
),

growth_ranking AS (
  SELECT 
    purchase_combination,
    ROUND((total_amount - prev_total_amount) * 100.0 / prev_total_amount, 2) AS month_over_month_growth,
    RANK() OVER (ORDER BY ROUND((total_amount - prev_total_amount) * 100.0 / 
      prev_total_amount, 2) DESC) AS rn
  FROM growth_trends
  WHERE transaction_month = '2014-01'
)

SELECT 
  purchase_combination,
  month_over_month_growth
FROM growth_ranking
WHERE rn = 1;

-- Spend to transactions ratio on weekends for each city
WITH transaction_ratio AS (
  SELECT 
    City AS city_name,
    CASE WHEN FORMAT_DATE('%A', `Date`) IN ('Saturday', 'Sunday') THEN 'Weekend' END AS day_type,
    SUM(Amount) AS total_amount,
    COUNT(*) AS transactions_count,
    ROUND(SUM(Amount) / COUNT(*), 2) AS ratio
  FROM `credit_card_case_study.credit_card_transactions`
  WHERE FORMAT_DATE('%A', `Date`) IN ('Saturday', 'Sunday')
  GROUP BY 
    City,
    CASE WHEN FORMAT_DATE('%A', `Date`) IN ('Saturday', 'Sunday') THEN 'Weekend' END
),

ratio_ranking AS (
  SELECT 
    city_name,
    ratio,
    RANK() OVER (ORDER BY ratio DESC) AS rn
  FROM transaction_ratio
  WHERE day_type = 'Weekend'
)

SELECT 
  city_name,
  ratio
FROM ratio_ranking
WHERE rn = 1;

-- City that took the least amount of time to reach its 500th transaction
WITH transactions AS (
  SELECT 
    City AS city_name,
    `Date`,
    COUNT(*) OVER (PARTITION BY City ORDER BY `Date` ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS transaction_count
  FROM `credit_card_case_study.credit_card_transactions`
),

filtered_transactions AS (
  SELECT 
    city_name,
    MIN(CASE WHEN transaction_count = 1 THEN `Date` END) AS first_transaction,
    MIN(CASE WHEN transaction_count = 500 THEN `Date` END) AS fivehundredth_transaction
  FROM transactions
  WHERE transaction_count <= 500
  GROUP BY city_name
),

days_diff AS (
  SELECT 
    city_name,
    first_transaction,
    fivehundredth_transaction,
    DATE_DIFF(fivehundredth_transaction, first_transaction, DAY) AS difference,
    RANK() OVER (ORDER BY DATE_DIFF(fivehundredth_transaction, first_transaction, DAY)) AS rn
  FROM filtered_transactions
  WHERE fivehundredth_transaction IS NOT NULL
)

SELECT 
  city_name,
  first_transaction,
  fivehundredth_transaction,
  difference
FROM days_diff
WHERE rn = 1;
















