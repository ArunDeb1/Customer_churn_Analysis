
# Customer_churn_Analysis

## 📁 Project Overview

This project analyzes customer churn using Excel and SQL, aiming to reduce financial loss, understand customer attrition drivers, improve service offerings, and boost retention.

## 🎯 Core Business Objectives

1. 🔻 Reduce Financial Impact of Churn**
2. 🤔 Understand Why Customers Are Leaving**
3. 🧩 Optimize Service Offerings**
4. 🧲 Improve Customer Retention**

## 📊 Initial Dataset Summary


### 1. 🎯 Objective
To evaluate customer attrition patterns and identify key churn contributors across services, contracts, and demographics. This forms the foundation for deeper retention modeling and lifecycle strategies.

---

### 2. 📦 Dataset Composition

- **Total Observations**: 7,043 unique customer records
- **Target Variable**: `Churn` (Binary: Yes/No)
- **Key Features**:  
  - Demographics: Gender, Senior Citizen, Partner, Dependents  
  - Account Info: Tenure, Contract, Payment Method  
  - Services: PhoneService, MultipleLines, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies, Total Services  
  - Revenue: Monthly & Total Charges
 
## 📦 Dataset Structure

Tables used:  
- `customer`  
- `services`  
- `contract`  
- `charges`  

Each table is linked via `customer_ID`.

## 🛠️ Tools & Technologies
- Excel → Data cleaning, feature engineering, KPI dashboards
- SQL → Querying churn patterns, revenue analysis, retention insights

## 📊 Excel Deliverables

- Data Cleaning, Feature Engineering
- Pivot Tables: Churn by Payment, Tenure, Service Use
- Scenario Simulation: Retention impact of bundles
- KPI Cards: Churn %, Avg Tenure, High Risk %

## 🛢️ SQL Deliverables

- Churn by contract, tenure, payment
- Monthly revenue lost to churn
- Service bundle effect on retention
- LTV gap between churned and retained
- Demographic impact on churn

✅ What’s Working
📈 Long-term contracts retain customers effectively
🛡️ Value-added services (Tech support, Online security) reduce churn
💳 Auto-pay & Credit card payments improve retention
👨‍👩‍👧 Customers with partners & dependents are less likely to churn

⚠️ What’s Not Working
📉 Month-to-month contracts drive high churn (43%)
👴 Senior citizens churn almost twice as much as younger customers
💳 Electronic check users are the riskiest group
📶 Fiber optic customers show higher churn than DSL
💰 High monthly charges without loyalty benefits → higher churn risk

🔑 Key Insights

👥 26.5% overall churn rate – 1 in 4 customers left the company
📅 Month-to-month contracts show the highest churn (43%) vs. long-term (11%)
👴 Senior citizens churned at ~42%, nearly double non-seniors
🏠 Customers without partners or dependents churned more often than families
💳 Electronic check users churned the most compared to auto-pay/credit card
📶 Fiber optic customers had higher churn vs. DSL users
🛡️ Tech support & online security reduced churn risk by 50%
🎬 Streaming services boosted engagement but didn’t strongly cut churn
💰 Churned customers had higher monthly charges but shorter tenure
📉 Revenue loss due to churn: significant impact on recurring income

## 📝 Recommendations

- Promote Long-Term Contracts – Incentivize customers to move from month-to-month to yearly/two-year contracts to reduce high churn (43% in short contracts).
- Bundle Value-Added Services – Encourage adoption of Tech Support, Online Security, and Streaming services since these correlate strongly with lower churn.
- Target Early Tenure Customers – Build onboarding and engagement programs for customers in their first 12 months, as this group shows the highest churn.
- Improve Payment Experience – Reduce churn among electronic check users by promoting auto-pay and digital wallet options that show stronger retention.
- Focus on At-Risk Segments – Prioritize retention campaigns for senior citizens, single-service users, and high monthly charge customers who show elevated churn risk.
- Revenue Protection Strategy – Track "Revenue Lost to Churn" and focus recovery campaigns on high-value customers (tenure >24 months & top 25% monthly charges).

## 📌 Next Steps / Future Scope

POWER BI VISUALIZATION
PYTHON - Build a machine learning model to predict churn
Customer segmentation with RFM analysis
Integration with retention campaign simulations
