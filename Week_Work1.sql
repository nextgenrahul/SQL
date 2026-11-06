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


--11: For each borrower segment, show number of loans, total principal and average interest rate. Why( The is management understand the composition of it's loan portfolio).
--SELECT 
--	borrower_segment,
--	COUNT(*) AS number_of_loans,
--	SUM(principal_amount) AS total_principal,
--	AVG(interest_rate) AS average_interest_rate
--FROM loans
--GROUP BY borrower_segment;

--I used GROUP BY to organize the loan records based on borrower segments. This allows me to perform aggregate calculations separately for each segments. I used COUNT() to calculate the number of loans, SUM() calculate the total principal amount, and AVG() to calculate the average interest rate.
--This approach helps the bank understand its lending distribution across different borrower segments.


--12: As of FY2025 Q4, calculate each company's current ratio and debt-to-equity(long-term debt / equity), highest debt-to-equity first.
--SELECT 
--	c.ticker,
--	c.company_name,
--	i.current_assets / i.current_liabilities AS current_ratio,
--	1.0 * i.long_term_debt / NULLIF(i.shareholders_equity, 0) AS debt_to_equity
--FROM balance_sheets AS i
--INNER JOIN companies AS c
--ON i.company_id = c.company_id
--WHERE fiscal_year = '2025' AND fiscal_quarter = '4'
--ORDER BY debt_to_equity DESC;


-- 13: Which fund house manages more than two funds? Show fund count and average expense ratio.

--SELECT 
--	fund_house,
--	COUNT(*) AS fund_count,
--	AVG(expense_ratio) AS average_expense_ratio
--FROM funds
--GROUP BY fund_house
--HAVING COUNT(*) > 2.0;

--GROUP BY is used to organize rows that have the same values in a specified column. It allows us to perform aggregate calculations, such as COUNT(), SUM(), and AVG(), separately for each group.

--HAVING is used to filter groups based on aggregate conditions. In this problem, I use HAVING COUNT(*) > 2 to identify fund houses managing more than two funds.

--Group by is used to collect data from differenet tables and combine them using common column. It is basically groups rows based on specific condition related to column. In fact, group by helps perform mathematic calculations using different function. On the other hand , we use HAVING part of group by, helps filter group level data. HAVING is commonly used for filter aggregate result.



-- 14: For ticker NOVT, show monthly average close and total volume for 2025, with month names, in calendar order.
--select * from stock_prices;

--SELECT 
--    MONTH(s.trade_date) AS month_number,
--    DATENAME(MONTH, s.trade_date) AS month_name,
--    AVG(s.close_price) AS monthly_avg_close,
--    SUM(s.volume) AS total_volume
--FROM companies AS c
--INNER JOIN stock_prices AS s
--    ON c.company_id = s.company_id
--WHERE c.ticker = 'NOVT'
--  AND s.trade_date >= '2025-01-01'
--  AND s.trade_date < '2026-01-01'
--GROUP BY
--    MONTH(s.trade_date),
--    DATENAME(MONTH, s.trade_date)
--ORDER BY month_number ASC;



-- 15: Dividend classification -> classify each dividend as small(< 5), Medium(5-20), or large(> 20) per share, and count dividends in each class by dividend type. 
--SELECT * FROM dividends;

--SELECT 
--    dividend_type,
--    CASE
--        WHEN dividend_per_share < 5 THEN 'Small'
--        WHEN dividend_per_share <= 20 THEN 'Medium'
--        ELSE 'Large'
--    END AS dividend_category,
--    COUNT(*) AS dividend_count
--FROM dividends
--GROUP BY
--    dividend_type,
--    CASE
--        WHEN dividend_per_share < 5 THEN 'Small'
--        WHEN dividend_per_share <= 20 THEN 'Medium'
--        ELSE 'Large'
--    END;





































