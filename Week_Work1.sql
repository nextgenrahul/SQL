--1: List the ticker, company name and listing date of all Technology companies listed on or after 1 January 2015, newest listing first. Why (Because investment research team might use this information to build a list of companies for further research.).

--SELECT
--    ticker,
--    company_name,
--    listing_date
--FROM companies
--WHERE sector = 'Technology'
--  AND listing_date >= '2015-01-01'
--ORDER BY listing_date DESC;


--2 Find the 10 highest-volume trading days in 2025 across all stocks. Show company_id, trade_date, close_price and volume. Why(Trading volume tells us how many shares were traded during a particular trading session. Analysts may examine unusually high-volume days to investigate market activity).

--SELECT TOP (10)
--company_id, trade_date, close_price, volume
--FROM stock_prices
--WHERE trade_date >= '2025-01-01' AND trade_date < '2026-01-01'
--ORDER BY volume DESC;

-- List every combination of fund house and fund category on offer, sorted by fund house.(Show me all the different fund house and fund category combinations available in our datebase. Don't show duplicate combination.)

--SELECT DISTINCT
--	fund_house, 
--	category
--FROM funds
--ORDER BY fund_house ASC;

-- 4 : Find expense ratio between 0.10% and 0.60%, cheapest first, showing fund type and category. Why (Investors pay expenses for managing their funds. Analysts may compare expense ratios to understand the costs associated with different investment products);

--SELECT
--	fund_name,
--	fund_type,
--	category,
--	expense_ratio
--FROM funds
--WHERE expense_ratio BETWEEN 0.10 AND 0.60
--ORDER BY expense_ratio ASC;


-- 5 List Home, Auto and Personal loans disbursed in 2024 that are now in Default, highest principal first. Why (Identify loans belonging to Home, Auto and Personal categories that were disbured during 2024 and currently have Default status. Show the loans with the highest principal amount first.)

--SELECT
--    loan_id,
--    loan_type,
--    principal_amount,
--    disbursement_date,
--    loan_status
--FROM loans
--WHERE loan_type IN ('Home', 'Auto', 'Personal')
--  AND disbursement_date >= '2024-01-01'
--  AND disbursement_date < '2025-01-01'
--  AND loan_status = 'Default'
--ORDER BY principal_amount DESC;


-- 6: Find companies whose name contains "Energy" or "Power", or Whose ticker starts with 'S';(An analyst may need to identify companies belonging to a particular business theme or sector for further research.)

--SELECT
--*
--FROM companies
--WHERE ticker LIKE 'S%' OR company_name LIKE '%Energy%' OR company_name LIKE '%Power%' ;


-- 7: FY2025 Q4 Show each company revenue, gross profit( revenue - cost of revenue) and gross margin %, highest margin first.
--SELECT 
--    c.ticker,
--    c.company_name,
--    i.revenue,
--    i.revenue - i.cost_of_revenue AS gross_profit,
--    ((i.revenue - i.cost_of_revenue) * 100) / NULLIF(i.revenue, 0) AS gross_margin_pct
--FROM income_statements AS i
--INNER JOIN companies AS c
--    ON c.company_id = i.company_id
--WHERE i.fiscal_year = 2025
--  AND i.fiscal_quarter = 4
--ORDER BY gross_margin_pct DESC;
/* (**
Analysts use gross margin because it shows how effectivel a company manages its production and purchasing cost relative to its margin. It allows us to compare the profitability of company of different sizes.
**) */

-- 8: For dividends with ex-divided date in 2025, show each company's number of payouts and total divided per share. 

--SELECT 
--    c.ticker,
--    c.company_name,
--    SUM(d.dividend_per_share) AS total_dividend_per_share,
--    COUNT(*) AS number_of_payouts
--FROM dividends AS d
--INNER JOIN companies AS c
--    ON d.company_id = c.company_id
--WHERE d.ex_dividend_date >= '2025-01-01'
--  AND d.ex_dividend_date < '2026-01-01'
--GROUP BY 
--    c.company_id,
--    c.ticker,
--    c.company_name;

-- 9: For each company, show lowest price, highest close and average daily volume in 2025. 

--SELECT
--    company_id,
--    MIN(close_price) AS lowest_close,
--    MAX(close_price) AS highest_close,
--    AVG(volume) AS average_daily_volume
--FROM stock_prices
--WHERE trade_date >= '2025-01-01'
--  AND trade_date < '2026-01-01'
--GROUP BY company_id;


-- 10: Find months when india's CPI inflation was above its policy rate (negative real interest rate.), with gap in percentage point.

--SELECT
--    indicator_month,
--    cpi_inflation_pct,
--    policy_rate_pct,
--    cpi_inflation_pct - policy_rate_pct AS gap_percentage_points
--FROM economic_indicators
--WHERE country = 'India'
--  AND cpi_inflation_pct > policy_rate_pct;