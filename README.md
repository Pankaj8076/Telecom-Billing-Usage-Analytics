📝 Project Overview

The Telecom Billing & Usage Analytics project is designed to manage and analyze customer call and data usage while generating accurate monthly bills. It helps telecom companies track usage, detect anomalies, and rank customers based on consumption. The project demonstrates practical SQL skills and the use of advanced analytics techniques like window functions, CTEs, and aggregate functions.

📂 Database Structure

The project consists of three main tables:

1. Customers

Stores customer details.

Column	Type	Description
customer_id	INT	Primary Key
customer_name	VARCHAR(100)	Full name
region	VARCHAR(50)	Geographic region
activation_date	DATE	Account activation date
2. Usage Details

Stores daily call and data usage.

Column	Type	Description
usage_id	INT	Primary Key
customer_id	INT	Foreign Key
usage_date	DATE	Usage date
call_minutes	INT	Call minutes used
data_mb	INT	Data used in MB
3. Billing

Stores monthly billing information.

Column	Type	Description
bill_id	INT	Primary Key
customer_id	INT	Foreign Key
bill_month	VARCHAR(7)	Billing month (YYYY-MM)
call_charge	DECIMAL(10,2)	Call charge
data_charge	DECIMAL(10,2)	Data charge
total_charge	DECIMAL(10,2)	Total billed amount
⚡ Key Features

Track total call minutes and data usage per customer.

Identify inactive customers or missing usage.

Classify data usage into High, Medium, and Low tiers.

Rank customers based on data consumption and revenue.

Reconcile billed vs calculated charges to detect discrepancies.

Generate running totals and monthly revenue insights.

🔍 Analytics Highlights

Determine top data consumers per month.

Detect missing bills and inactive accounts.

Identify customers with above-average usage.

Find months with highest revenue.

💡 Potential Enhancements

Implement dynamic tariffs by plan or region.

Support prepaid/postpaid billing logic.

Integrate with BI tools like Power BI or Tableau for visualization.

Add automated alerts for high usage or unpaid bills.

📚 Learning Outcomes

Hands-on SQL experience with joins, CTEs, and window functions.

Relational database design for real-world applications.

Telecom billing and usage analysis for actionable business insights.

🔗 Technologies Used

SQL / MySQL

Relational Database Management

Data Analytics & Reporting
