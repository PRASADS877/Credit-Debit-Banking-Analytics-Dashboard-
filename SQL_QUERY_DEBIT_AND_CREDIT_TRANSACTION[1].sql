create database bank;
select * from creditdebit12;
-- Total Credit Amount
select sum(Amount) from creditdebit12 where Transactiontype ="Credit";
describe creditdebit;

-- Total Debit Amt
select sum(Amount) from creditdebit12 where Transactiontype ="Debit";

--- Credit to Debit_Ratio 
SELECT
  SUM(CASE WHEN Transactiontype = 'Credit' THEN amount ELSE 0 END) /
  NULLIF(SUM(CASE WHEN Transactiontype = 'Debit' THEN amount ELSE 0 END), 0) AS credit_to_debit_ratio
FROM creditdebit12;

--- Net Transaction Amount
SELECT
  SUM(CASE WHEN Transactiontype = 'Credit' THEN amount ELSE 0 END) -
  SUM(CASE WHEN Transactiontype = 'Debit' THEN amount ELSE 0 END)
  AS Nettransactionamount
FROM creditdebit12;

-- 5-Account Activity Ratio
select
  Customername,
  COUNT(*) AS num_transactions,
  SUM(CASE WHEN Transactiontype = 'Credit' THEN Balance ELSE -Balance END) AS total_transaction_value,
  AVG(Balance) AS average_balance,
  SUM(CASE WHEN Transactiontype = 'Debit' THEN Balance ELSE -Balance END) / AVG(Balance) AS account_activity_ratio
FROM 
  creditdebit12
GROUP BY 
  Customername;

SELECT 
  Customername,
  COUNT(*) AS num_transactions,
  AVG(Balance) AS average_balance,
  COUNT(*) / AVG(Balance) AS account_activity_ratio
FROM 
  creditdebit12
GROUP BY 
  Customername;

-- transaction per day
select 
date(transactiondate) as transaction_date,
count(*) as num_transactions
from creditdebit12
group by date(transactiondate)
order by transaction_date;

-- transaction per month
select
YEAR(transactiondate) AS year,
  MONTH(transactiondate) AS month,
  COUNT(*) AS num_transactions
FROM 
  creditdebit12
GROUP BY 
  YEAR(transactiondate),
  MONTH(transactiondate)
ORDER BY 
  year,
  month;
  
  -- transaction per week 
select
YEAR(transactiondate) AS year,
  WEEK(transactiondate) AS week,
  COUNT(*) AS num_transactions
FROM 
  creditdebit12
GROUP BY 
  YEAR(transactiondate),
  WEEK(transactiondate)
ORDER BY 
  year,
  week;
  
  -- 7 Total transaction amt by branch
  select
  branch,
  sum(Amount) as total_transaction_amount
  from creditdebit12 group by Branch;
  
  -- 08 Transaction Volume by bank
  SELECT 
  Bankname,
  COUNT(*) AS transaction_volume
FROM 
  creditdebit12
GROUP BY 
  Bankname;

-- 09 Transaction Method distribution
SELECT 
  Transactionmethod,
  COUNT(*) AS num_transactions,
  (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM creditdebit)) AS percentage
FROM 
  creditdebit12
GROUP BY 
  Transactionmethod
  order by percentage desc;

-- branch Transaction Growth
SELECT 
  Branch,
  COUNT(*) AS num_transactions,
  SUM(CASE WHEN Transactiontype = 'Credit' THEN 1 ELSE -1 END) AS growth
FROM 
  creditdebit12
GROUP BY 
  Branch
ORDER BY 
  growth DESC;

-- 11 high rish Transaction flag
SELECT 
  *,
  CASE 
    WHEN Amount >=4500 then "High Risk"
    ELSE 'Low-Risk'
  END AS risk_flag
FROM 
  creditdebit12;
  
  -- 12 Suspicious Transaction Frequency
  SELECT 
  COUNT(*) AS suspicious_transaction_count
FROM 
  creditdebit12
WHERE 
  Riskflag= "High_risk" ;

