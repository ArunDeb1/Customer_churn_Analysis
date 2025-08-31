-- ==========================================================
-- Telecom Customer Churn Analysis using MYSQL
-- Description about the dataaset.
-- This is an IBM Telecom churn analysis dataset which consists of a total of 7043 rows. There are 4 tables naming: -
-- 1. Customer with column CustomerID, Gender, SeniorCitizen,Partner, Dependents, tenure, Tenure Group, Churn 
-- 2. Charges with column customerID, MonthlyCharges, TotalCharges, Avg Monthly Spend, Revenure loss to churn
-- 3. Contract with column CustomerID, Contract, PaperlessBilling, PaymentMethod, High Value Customer Flag
-- 4. Services with column CustomerID, PhoneService, MultipleLines, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies, Total Services

-- The dataset is an One to Many type where the primary key is CustomerID which connects with the tables and each Customer is unique to many

-- Problem statement
-- The company is experiencing a high rate of customer churn, which is leading to significant revenue loss and customer value decline. 
-- Management seeks a data-driven approach to identify why customers are leaving, who is most at risk, 
-- and what strategic actions can be taken to improve retention, optimize service offerings, and reduce financial impact.

use Telecom_churn;

-- ============================================================
-- SECTION 1: Basic Data Exploration
-- ============================================================

-- Preview Customers Table
SELECT * FROM customer LIMIT 5;

-- Count total customers
SELECT COUNT(*) FROM customer;

-- Describe table structure
DESCRIBE customer;
DESCRIBE services;
DESCRIBE contract;
DESCRIBE charges;

-- ============================================================
-- SECTION 2: KPI
-- ============================================================

-- churn rate 
SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer;

-- MRR
SELECT
    ROUND(SUM(ch.monthly_charges), 2) AS MRR
FROM charges ch
JOIN customer c ON c.customer_ID = ch.customer_ID
WHERE c.churn = 'No';

-- Churn by Gender
SELECT 
  gender,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer
GROUP BY gender
ORDER BY churn_rate_percent DESC;

-- Senior Citizen Churn
SELECT 
  senior_citizen,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer
GROUP BY senior_citizen
ORDER BY churn_rate_percent DESC;

-- Average Tenure by churn
SELECT 
  churn,
  ROUND(AVG(tenure), 2) AS avg_tenure_in_months
FROM customer
GROUP BY churn;

-- ============================================================
-- SECTION 3: Advanced Segmentation Analysis
-- ============================================================

-- Churn by Tenure Group
SELECT 
  tenure_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer
GROUP BY tenure_group
ORDER BY churn_rate_percent DESC;

-- churn by contract 
SELECT 
  ct.contract_type,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS churn_rate_percent
FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID
GROUP BY ct.contract_type
ORDER BY churn_rate_percent DESC;

-- churn by payment method
SELECT 
  ct.payment_method,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS churn_rate_percent
FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID
GROUP BY ct.payment_method
ORDER BY churn_rate_percent DESC;

-- Churn by Total Services
SELECT 
  svc.total_services,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS churn_rate_percent
FROM (
  SELECT 
    s.customer_ID,
    (
      CASE WHEN s.online_security = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.online_backup = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.device_protection = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.tech_support = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.streaming_tv = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.streaming_movies = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.phone_services = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.internet_services = 'Yes' THEN 1 ELSE 0 END +
      CASE WHEN s.multiple_lines = 'Yes' THEN 1 ELSE 0 END
    ) AS total_services
  FROM services s
) AS svc
JOIN customer c ON svc.customer_ID = c.customer_ID
GROUP BY svc.total_services
ORDER BY churn_rate_percent DESC;

-- ============================================================
-- SECTION 4: Business Questions
-- ============================================================

-- 1. What is the total revenue lost due to churn, and how does it vary by contract type?
SELECT 
  ct.contract_type,
  ROUND(SUM(ch.monthly_charges), 2) AS total_revenue_lost
FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID
JOIN charges ch ON c.customer_ID = ch.customer_ID
WHERE c.churn = 'Yes'
GROUP BY ct.contract_type
ORDER BY total_revenue_lost DESC;

-- 2. Which tenure segments contribute the most to revenue loss from churned customers?
SELECT 
  c.tenure_group,
  ROUND(SUM(ch.monthly_charges), 2) AS total_revenue_lost
FROM customer c
JOIN charges ch ON c.customer_ID = ch.customer_ID
WHERE c.churn = 'Yes'
GROUP BY c.tenure_group
ORDER BY total_revenue_lost DESC;

-- 3. What is the monthly revenue at risk from high-value customers currently on month-to-month contracts?
SELECT 
  COUNT(c.customer_ID) AS high_value_customers_at_risk,
  ROUND(SUM(ch.monthly_charges), 2) AS monthly_revenue_at_risk
FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID
JOIN charges ch ON c.customer_ID = ch.customer_ID
WHERE ct.contract_type = 'Month-to-month'
  AND ct.high_value_customer_flag = 'High'
  AND c.churn = 'No';
  
-- 4. What is the lifetime value gap between churned and retained customers?
SELECT 
  c.churn,
  ROUND(AVG(ch.monthly_charges * c.tenure), 2) AS avg_lifetime_value
FROM customer c
JOIN charges ch ON c.customer_ID = ch.customer_ID
GROUP BY c.churn;

-- 5. What is the churn rate by contract type and payment method combination?
SELECT 
  ct.contract_type,
  ct.payment_method,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS churn_rate_percent
FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID
JOIN charges ch ON c.customer_ID = ch.customer_ID
GROUP BY ct.contract_type, ct.payment_method
ORDER BY churn_rate_percent DESC;

-- 6. Are customers who use electronic check more likely to churn than others?
SELECT 
  ct.payment_method,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID
GROUP BY ct.payment_method
ORDER BY churn_rate_percent DESC;

-- 7. What is the impact of tenure group on churn—do newer or older customers churn more?
SELECT 
  c.tenure_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer c
GROUP BY c.tenure_group
ORDER BY churn_rate_percent DESC;

-- 8. How do demographic factors like senior citizen, partner, and dependent status affect churn?
SELECT 
  senior_citizen,
  partner,
  dependents,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer
GROUP BY senior_citizen, partner, dependents
ORDER BY churn_rate_percent DESC;

-- 9. How does churn vary with the total number of services subscribed?
SELECT 
  s.total_services,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
GROUP BY s.total_services
ORDER BY churn_rate_percent DESC;

-- 10. Which individual services (like streaming TV, tech support, etc.) are most commonly associated with churn?
SELECT 
  'online_security' AS service,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
WHERE s.online_security IS NOT NULL
GROUP BY s.online_security

UNION ALL

SELECT 
  'online_backup',
  COUNT(*),
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
WHERE s.online_backup IS NOT NULL
GROUP BY s.online_backup

UNION ALL

SELECT 
  'device_protection',
  COUNT(*),
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
WHERE s.device_protection IS NOT NULL
GROUP BY s.device_protection

UNION ALL

SELECT 
  'tech_support',
  COUNT(*),
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
WHERE s.tech_support IS NOT NULL
GROUP BY s.tech_support

UNION ALL

SELECT 
  'streaming_tv',
  COUNT(*),
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
WHERE s.streaming_tv IS NOT NULL
GROUP BY s.streaming_tv

UNION ALL

SELECT 
  'streaming_movies',
  COUNT(*),
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END),
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM services s
JOIN customer c ON s.customer_ID = c.customer_ID
WHERE s.streaming_movies IS NOT NULL
GROUP BY s.streaming_movies;

-- 11. Are service bundles (e.g., Internet + TV + Phone) more likely to retain customers than single services?
SELECT 
  total_services,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customer c
JOIN services s ON c.customer_ID = s.customer_ID
GROUP BY total_services
ORDER BY total_services;

-- 12. Is there a pattern between inactive service usage (like having a service but not using it) and churn?
SELECT 
  CASE 
    WHEN s.online_backup = 'No' AND s.online_security = 'No' AND s.tech_support = 'No' 
         AND s.streaming_tv = 'No' AND s.streaming_movies = 'No' 
         THEN 'Inactive User'
    ELSE 'Active User'
  END AS user_activity_status,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percent
FROM customer c
JOIN services s ON c.customer_ID = s.customer_ID
WHERE s.internet_services IN ('DSL', 'Fiber optic')
GROUP BY user_activity_status;





-- 13. What is the churn rate among customers with long-term contracts versus short-term?
SELECT 
  CASE 
    WHEN ct.contract_type = 'Month-to-month' THEN 'Short-Term'
    ELSE 'Long-Term'
  END AS contract_duration_group,
  
  COUNT(*) AS total_customers,
  
  SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  
  ROUND(
    SUM(CASE WHEN c.churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS churn_rate_percent

FROM customer c
JOIN contract ct ON c.customer_ID = ct.customer_ID

GROUP BY contract_duration_group;

-- 14. Do high-value customers (based on charges and tenure) churn less than low-value ones?
-- First, calculating average tenure and average monthly charges
WITH avg_metrics AS (
  SELECT 
    AVG(tenure) AS avg_tenure,
    AVG(ch.monthly_charges) AS avg_charges
  FROM customer c
  JOIN charges ch ON c.customer_ID = ch.customer_ID
),

-- Categorizing customers into High-Value and Low-Value
customer_value_classification AS (
  SELECT 
    c.customer_ID,
    c.churn,
    ch.monthly_charges,
    c.tenure,
    
    CASE 
      WHEN c.tenure > (SELECT avg_tenure FROM avg_metrics) 
           AND ch.monthly_charges > (SELECT avg_charges FROM avg_metrics)
      THEN 'High-Value'
      ELSE 'Low-Value'
    END AS value_segment
  FROM customer c
  JOIN charges ch ON c.customer_ID = ch.customer_ID
)

-- Now calculating churn rate for each group
SELECT 
  value_segment,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS churn_rate_percent
FROM customer_value_classification
GROUP BY value_segment;

-- 15. What is the retention rate of customers who have partners and dependents compared to those who don’t?
SELECT
  CASE 
    WHEN c.partner = 'Yes' AND c.dependents = 'Yes' THEN 'Partner & Dependent'
    WHEN c.partner = 'Yes' AND c.dependents = 'No' THEN 'Partner Only'
    WHEN c.partner = 'No' AND c.dependents = 'Yes' THEN 'Dependent Only'
    ELSE 'No Partner or Dependent'
  END AS family_status,

  COUNT(*) AS total_customers,

  SUM(CASE WHEN c.churn = 'No' THEN 1 ELSE 0 END) AS retained_customers,

  ROUND(
    SUM(CASE WHEN c.churn = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS retention_rate_percent

FROM customer c
GROUP BY family_status;