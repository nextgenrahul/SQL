/* =====================================================================
   FinanceLab: answer key for the 50 T-SQL practice questions
   Run FinanceLab_setup.sql first. Every query runs on its own.
   Units: statements, bank financials and AUM in INR crore;
   prices, DPS and loan amounts in INR. 1 crore = 10,000,000.
   Many questions have more than one correct answer. If your result
   matches, your query is right even when it is written differently.
   ===================================================================== */
USE FinanceLab;
GO

/* ===================================================== BEGINNER (1-15) */

-- ===== Q1
-- Expected result: 2 rows
SELECT ticker, company_name, listing_date
FROM companies
WHERE sector = 'Technology'
  AND listing_date >= '2015-01-01'
ORDER BY listing_date DESC;

-- ===== Q2
-- Expected result: 10 rows
SELECT TOP 10 company_id, trade_date, close_price, volume
FROM stock_prices
WHERE trade_date >= '2025-01-01' AND trade_date < '2026-01-01'
ORDER BY volume DESC;

-- ===== Q3
-- Expected result: 12 rows
SELECT DISTINCT fund_house, category
FROM funds
ORDER BY fund_house, category;

-- ===== Q4
-- Expected result: 5 rows
SELECT fund_name, fund_type, category, expense_ratio
FROM funds
WHERE expense_ratio BETWEEN 0.10 AND 0.60
ORDER BY expense_ratio;

-- ===== Q5
-- Expected result: 8 rows
SELECT loan_id, bank_id, loan_type, principal_amount, disbursement_date, days_past_due
FROM loans
WHERE loan_type IN ('Home', 'Auto', 'Personal')
  AND disbursement_date >= '2024-01-01' AND disbursement_date < '2025-01-01'
  AND loan_status = 'Default'
ORDER BY principal_amount DESC;

-- ===== Q6
-- Expected result: 5 rows
-- Brackets matter only if you add AND conditions later; OR needs care.
SELECT ticker, company_name, sector
FROM companies
WHERE company_name LIKE '%Energy%'
   OR company_name LIKE '%Power%'
   OR ticker LIKE 'S%';

-- ===== Q7
-- Expected result: 20 rows
SELECT c.ticker,
       i.revenue,
       i.revenue - i.cost_of_revenue                                   AS gross_profit,
       ROUND(100.0 * (i.revenue - i.cost_of_revenue) / i.revenue, 2)   AS gross_margin_pct
FROM income_statements i
JOIN companies c ON c.company_id = i.company_id
WHERE i.fiscal_year = 2025 AND i.fiscal_quarter = 4
ORDER BY gross_margin_pct DESC;

-- ===== Q8
-- Expected result: 17 rows
SELECT company_id,
       COUNT(*)                AS payouts,
       SUM(dividend_per_share) AS total_dps
FROM dividends
WHERE ex_dividend_date >= '2025-01-01' AND ex_dividend_date < '2026-01-01'
GROUP BY company_id
ORDER BY total_dps DESC;

-- ===== Q9
-- Expected result: 20 rows
-- AVG on a BIGINT column returns a BIGINT in SQL Server (decimals are cut off),
-- so cast volume first.
SELECT c.ticker,
       MIN(sp.close_price)                              AS lowest_close,
       MAX(sp.close_price)                              AS highest_close,
       ROUND(AVG(CAST(sp.volume AS DECIMAL(18,2))), 0)  AS avg_daily_volume
FROM stock_prices sp
JOIN companies c ON c.company_id = sp.company_id
WHERE sp.trade_date >= '2025-01-01' AND sp.trade_date < '2026-01-01'
GROUP BY c.ticker
ORDER BY c.ticker;

-- ===== Q10
-- Expected result: 24 rows
SELECT indicator_month,
       cpi_inflation_pct,
       policy_rate_pct,
       cpi_inflation_pct - policy_rate_pct AS gap_pp
FROM economic_indicators
WHERE country = 'India'
  AND cpi_inflation_pct > policy_rate_pct
ORDER BY indicator_month;

-- ===== Q11
-- Expected result: 4 rows
SELECT borrower_segment,
       COUNT(*)                     AS loan_count,
       SUM(principal_amount)        AS total_principal,
       ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loans
GROUP BY borrower_segment
ORDER BY total_principal DESC;

-- ===== Q12
-- Expected result: 20 rows
SELECT c.ticker,
       ROUND(b.current_assets / b.current_liabilities, 2)   AS current_ratio,
       ROUND(b.long_term_debt / b.shareholders_equity, 2)   AS debt_to_equity
FROM balance_sheets b
JOIN companies c ON c.company_id = b.company_id
WHERE b.fiscal_year = 2025 AND b.fiscal_quarter = 4
ORDER BY debt_to_equity DESC;

-- ===== Q13
-- Expected result: 3 rows
SELECT fund_house,
       COUNT(*)                     AS fund_count,
       ROUND(AVG(expense_ratio), 2) AS avg_expense_ratio
FROM funds
GROUP BY fund_house
HAVING COUNT(*) > 2
ORDER BY fund_count DESC;

-- ===== Q14
-- Expected result: 12 rows
SELECT MONTH(sp.trade_date)              AS month_no,
       DATENAME(MONTH, sp.trade_date)    AS month_name,
       ROUND(AVG(sp.close_price), 2)     AS avg_close,
       SUM(sp.volume)                    AS total_volume
FROM stock_prices sp
JOIN companies c ON c.company_id = sp.company_id
WHERE c.ticker = 'NOVT'
  AND sp.trade_date >= '2025-01-01' AND sp.trade_date < '2026-01-01'
GROUP BY MONTH(sp.trade_date), DATENAME(MONTH, sp.trade_date)
ORDER BY month_no;

-- ===== Q15
-- Expected result: 5 rows
SELECT size_class, dividend_type, COUNT(*) AS dividend_count
FROM (
    SELECT dividend_type,
           CASE WHEN dividend_per_share < 5   THEN 'Small'
                WHEN dividend_per_share <= 20 THEN 'Medium'
                ELSE 'Large' END AS size_class
    FROM dividends
) d
GROUP BY size_class, dividend_type
ORDER BY dividend_type, size_class;

/* ================================================= INTERMEDIATE (16-30) */

-- ===== Q16
-- Expected result: 20 rows
SELECT c.sector,
       i.fiscal_year,
       SUM(i.revenue)                                       AS total_revenue,
       SUM(i.net_income)                                    AS total_net_income,
       ROUND(100.0 * SUM(i.net_income) / SUM(i.revenue), 2) AS net_margin_pct
FROM income_statements i
JOIN companies c ON c.company_id = i.company_id
WHERE i.fiscal_year IN (2024, 2025)
GROUP BY c.sector, i.fiscal_year
ORDER BY c.sector, i.fiscal_year;

-- ===== Q17
-- Expected result: 3 rows
-- The date filter goes in the ON clause. In WHERE it would turn the LEFT JOIN
-- into an INNER JOIN and return nothing.
SELECT c.ticker, c.company_name
FROM companies c
LEFT JOIN dividends d
       ON d.company_id = c.company_id
      AND d.ex_dividend_date BETWEEN '2024-01-01' AND '2025-12-31'
WHERE d.dividend_id IS NULL;

-- ===== Q18
-- Expected result: 3 rows
-- Both tables have one row per company per quarter, so joining on all three
-- keys does not duplicate rows.
SELECT c.ticker,
       SUM(i.net_income)                                   AS net_income_fy25,
       SUM(cf.operating_cash_flow - cf.capital_expenditure) AS free_cash_flow_fy25
FROM income_statements i
JOIN cash_flow_statements cf
  ON cf.company_id = i.company_id
 AND cf.fiscal_year = i.fiscal_year
 AND cf.fiscal_quarter = i.fiscal_quarter
JOIN companies c ON c.company_id = i.company_id
WHERE i.fiscal_year = 2025
GROUP BY c.ticker
HAVING SUM(i.net_income) > 0
   AND SUM(cf.operating_cash_flow - cf.capital_expenditure) < 0;

-- ===== Q19
-- Expected result: 10 rows
-- Net NPA % here = net NPA / total advances (a simple version of the ratio).
SELECT b.bank_name,
       ROUND(100.0 * f.total_advances / f.total_deposits, 2)       AS credit_deposit_pct,
       ROUND(100.0 * f.gross_npa / f.total_advances, 2)            AS gross_npa_pct,
       ROUND(100.0 * f.net_npa / f.total_advances, 2)              AS net_npa_pct,
       ROUND(100.0 * f.tier1_capital / f.risk_weighted_assets, 2)  AS tier1_ratio_pct,
       CASE WHEN 100.0 * f.gross_npa / f.total_advances > 5
            THEN 'High NPA' ELSE 'OK' END                           AS npa_flag
FROM bank_financials f
JOIN banks b ON b.bank_id = f.bank_id
WHERE f.fiscal_year = 2025
ORDER BY gross_npa_pct DESC;

-- ===== Q20
-- Expected result: 40 rows
SELECT p.investor_name,
       c.ticker,
       SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.quantity ELSE -t.quantity END) AS net_shares
FROM portfolio_transactions t
JOIN portfolios p ON p.portfolio_id = t.portfolio_id
JOIN companies c  ON c.company_id = t.company_id
GROUP BY p.investor_name, c.ticker
HAVING SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.quantity ELSE -t.quantity END) > 0
ORDER BY p.investor_name, c.ticker;

-- ===== Q21
-- Expected result: 4 rows
SELECT f.fund_house,
       SUM(n.aum_crore) AS aum_crore,
       ROUND(100.0 * SUM(n.aum_crore) /
             (SELECT SUM(aum_crore) FROM fund_nav
              WHERE nav_date = (SELECT MAX(nav_date) FROM fund_nav)), 2) AS aum_share_pct
FROM fund_nav n
JOIN funds f ON f.fund_id = n.fund_id
WHERE n.nav_date = (SELECT MAX(nav_date) FROM fund_nav)
GROUP BY f.fund_house
ORDER BY aum_crore DESC;

-- ===== Q22
-- Expected result: 5 rows
SELECT TOP 5
       c.ticker,
       d.total_dps,
       sp.close_price,
       ROUND(100.0 * d.total_dps / sp.close_price, 2) AS dividend_yield_pct
FROM companies c
JOIN (
    SELECT company_id, SUM(dividend_per_share) AS total_dps
    FROM dividends
    WHERE dividend_type = 'Regular'
      AND ex_dividend_date >= '2025-01-01' AND ex_dividend_date < '2026-01-01'
    GROUP BY company_id
) d ON d.company_id = c.company_id
JOIN stock_prices sp ON sp.company_id = c.company_id AND sp.trade_date = '2025-12-31'
ORDER BY dividend_yield_pct DESC;

-- ===== Q23
-- Expected result: 10 rows
SELECT country,
       YEAR(indicator_month)                                     AS yr,
       ROUND(AVG(cpi_inflation_pct), 2)                          AS avg_cpi_pct,
       ROUND(AVG(policy_rate_pct), 2)                            AS avg_policy_rate_pct,
       SUM(CASE WHEN cpi_inflation_pct > 6 THEN 1 ELSE 0 END)    AS months_above_6pct
FROM economic_indicators
GROUP BY country, YEAR(indicator_month)
ORDER BY country, yr;

-- ===== Q24
-- Expected result: 20 rows
SELECT bank_type, dpd_bucket,
       COUNT(*)                AS loan_count,
       SUM(outstanding_amount) AS outstanding_amount
FROM (
    SELECT b.bank_type, l.outstanding_amount,
           CASE WHEN l.days_past_due = 0  THEN '0'
                WHEN l.days_past_due <= 30 THEN '1-30'
                WHEN l.days_past_due <= 60 THEN '31-60'
                WHEN l.days_past_due <= 90 THEN '61-90'
                ELSE '90+' END AS dpd_bucket,
           CASE WHEN l.days_past_due = 0  THEN 1
                WHEN l.days_past_due <= 30 THEN 2
                WHEN l.days_past_due <= 60 THEN 3
                WHEN l.days_past_due <= 90 THEN 4
                ELSE 5 END AS bucket_order
    FROM loans l
    JOIN banks b ON b.bank_id = l.bank_id
    WHERE l.loan_status <> 'Closed'
) x
GROUP BY bank_type, dpd_bucket, bucket_order
ORDER BY bank_type, bucket_order;

-- ===== Q25
-- Expected result: 7 rows
SELECT c.ticker,
       ROUND(AVG(sp.close_price * sp.volume) / 10000000.0, 2) AS avg_traded_value_crore
FROM stock_prices sp
JOIN companies c ON c.company_id = sp.company_id
WHERE sp.trade_date >= '2025-01-01' AND sp.trade_date < '2026-01-01'
GROUP BY c.ticker
HAVING AVG(sp.close_price * sp.volume) >
       (SELECT AVG(close_price * volume)
        FROM stock_prices
        WHERE trade_date >= '2025-01-01' AND trade_date < '2026-01-01')
ORDER BY avg_traded_value_crore DESC;

-- ===== Q26
-- Expected result: 9 rows
-- Sector margin = total sector net income / total sector revenue.
SELECT c.ticker, c.sector,
       ROUND(100.0 * SUM(i.net_income) / SUM(i.revenue), 2) AS net_margin_pct
FROM income_statements i
JOIN companies c ON c.company_id = i.company_id
WHERE i.fiscal_year = 2025
GROUP BY c.ticker, c.sector
HAVING SUM(i.net_income) / SUM(i.revenue) >
       (SELECT SUM(i2.net_income) / SUM(i2.revenue)
        FROM income_statements i2
        JOIN companies c2 ON c2.company_id = i2.company_id
        WHERE c2.sector = c.sector AND i2.fiscal_year = 2025)
ORDER BY c.sector, net_margin_pct DESC;

-- ===== Q27
-- Expected result: 7 rows
SELECT f.fund_name, f.category, f.expense_ratio,
       (SELECT ROUND(AVG(f2.expense_ratio), 2) FROM funds f2
        WHERE f2.category = f.category) AS category_avg
FROM funds f
WHERE f.expense_ratio > (SELECT AVG(f2.expense_ratio) FROM funds f2
                         WHERE f2.category = f.category)
ORDER BY f.category;

-- ===== Q28
-- Expected result: 2 rows
SELECT c.ticker,
       b24.long_term_debt AS debt_q4_2024,
       b25.long_term_debt AS debt_q4_2025,
       ROUND(100.0 * (b25.long_term_debt - b24.long_term_debt) / b24.long_term_debt, 1) AS debt_change_pct,
       ROUND(100.0 * (b25.cash_and_equivalents - b24.cash_and_equivalents) / b24.cash_and_equivalents, 1) AS cash_change_pct
FROM balance_sheets b24
JOIN balance_sheets b25
  ON b25.company_id = b24.company_id AND b25.fiscal_year = 2025 AND b25.fiscal_quarter = 4
JOIN companies c ON c.company_id = b24.company_id
WHERE b24.fiscal_year = 2024 AND b24.fiscal_quarter = 4
  AND b25.long_term_debt > b24.long_term_debt * 1.20
  AND b25.cash_and_equivalents < b24.cash_and_equivalents;

-- ===== Q29
-- Expected result: 80 rows
SELECT c.ticker,
       DATEPART(QUARTER, sp.trade_date)                                  AS qtr,
       COUNT(*)                                                          AS trading_days,
       SUM(CASE WHEN sp.close_price > sp.open_price THEN 1 ELSE 0 END)   AS up_days,
       ROUND(100.0 * SUM(CASE WHEN sp.close_price > sp.open_price THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                              AS up_day_pct
FROM stock_prices sp
JOIN companies c ON c.company_id = sp.company_id
WHERE sp.trade_date >= '2025-01-01' AND sp.trade_date < '2026-01-01'
GROUP BY c.ticker, DATEPART(QUARTER, sp.trade_date)
ORDER BY c.ticker, qtr;

-- ===== Q30
-- Expected result: 20 rows
-- Market cap in crore = price x shares / 1 crore. EPS in rupees = net income
-- (crore) x 1 crore / shares. A negative P/E has no meaning, so show N/A.
SELECT c.ticker,
       sp.close_price,
       ROUND(sp.close_price * c.shares_outstanding / 10000000.0, 2)    AS market_cap_crore,
       e.net_income_fy25,
       ROUND(e.net_income_fy25 * 10000000.0 / c.shares_outstanding, 2) AS eps,
       CASE WHEN e.net_income_fy25 <= 0 THEN 'N/A'
            ELSE CAST(CAST(sp.close_price / (e.net_income_fy25 * 10000000.0 / c.shares_outstanding)
                      AS DECIMAL(10,2)) AS VARCHAR(20)) END             AS pe_ratio
FROM companies c
JOIN (SELECT company_id, SUM(net_income) AS net_income_fy25
      FROM income_statements WHERE fiscal_year = 2025
      GROUP BY company_id) e ON e.company_id = c.company_id
JOIN stock_prices sp ON sp.company_id = c.company_id AND sp.trade_date = '2025-12-31'
ORDER BY market_cap_crore DESC;

/* ===================================================== ADVANCED (31-45) */

-- ===== Q31
-- Expected result: 20 rows
-- LAG runs on the full table first, so 2 Jan 2025 compares with 31 Dec 2024.
WITH r AS (
    SELECT company_id, trade_date,
           100.0 * (close_price - LAG(close_price) OVER (PARTITION BY company_id ORDER BY trade_date))
                 / LAG(close_price) OVER (PARTITION BY company_id ORDER BY trade_date) AS ret_pct
    FROM stock_prices
),
ranked AS (
    SELECT r.*,
           ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY ret_pct DESC) AS best_rn,
           ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY ret_pct ASC)  AS worst_rn
    FROM r
    WHERE trade_date >= '2025-01-01' AND ret_pct IS NOT NULL
)
SELECT c.ticker,
       MAX(CASE WHEN best_rn = 1  THEN trade_date END)         AS best_day,
       ROUND(MAX(CASE WHEN best_rn = 1  THEN ret_pct END), 2)  AS best_return_pct,
       MAX(CASE WHEN worst_rn = 1 THEN trade_date END)         AS worst_day,
       ROUND(MAX(CASE WHEN worst_rn = 1 THEN ret_pct END), 2)  AS worst_return_pct
FROM ranked
JOIN companies c ON c.company_id = ranked.company_id
WHERE best_rn = 1 OR worst_rn = 1
GROUP BY c.ticker
ORDER BY c.ticker;

-- ===== Q32
-- Expected result: 320 rows
SELECT c.ticker, i.fiscal_year, i.fiscal_quarter, i.revenue,
       ROUND(100.0 * (i.revenue - LAG(i.revenue, 1) OVER (PARTITION BY i.company_id ORDER BY i.fiscal_year, i.fiscal_quarter))
             / LAG(i.revenue, 1) OVER (PARTITION BY i.company_id ORDER BY i.fiscal_year, i.fiscal_quarter), 2) AS qoq_growth_pct,
       ROUND(100.0 * (i.revenue - LAG(i.revenue, 4) OVER (PARTITION BY i.company_id ORDER BY i.fiscal_year, i.fiscal_quarter))
             / LAG(i.revenue, 4) OVER (PARTITION BY i.company_id ORDER BY i.fiscal_year, i.fiscal_quarter), 2) AS yoy_growth_pct
FROM income_statements i
JOIN companies c ON c.company_id = i.company_id
ORDER BY c.ticker, i.fiscal_year, i.fiscal_quarter;

-- ===== Q33
-- Expected result: 18 rows
WITH m AS (
    SELECT c.ticker, c.sector,
           100.0 * SUM(i.revenue - i.cost_of_revenue - i.operating_expenses - i.depreciation)
                 / SUM(i.revenue) AS op_margin_pct
    FROM income_statements i
    JOIN companies c ON c.company_id = i.company_id
    WHERE i.fiscal_year = 2025
    GROUP BY c.ticker, c.sector
),
r AS (
    SELECT m.*, DENSE_RANK() OVER (PARTITION BY sector ORDER BY op_margin_pct DESC) AS sector_rank
    FROM m
)
SELECT sector, sector_rank, ticker, ROUND(op_margin_pct, 2) AS op_margin_pct
FROM r
WHERE sector_rank <= 2
ORDER BY sector, sector_rank;

-- ===== Q34
-- Expected result: 5 rows
WITH ret AS (
    SELECT f.fund_name, f.category,
           100.0 * (n25.nav - n24.nav) / n24.nav AS one_year_return_pct
    FROM funds f
    JOIN fund_nav n24 ON n24.fund_id = f.fund_id AND n24.nav_date = '2024-12-31'
    JOIN fund_nav n25 ON n25.fund_id = f.fund_id AND n25.nav_date = '2025-12-31'
),
r AS (
    SELECT ret.*, ROW_NUMBER() OVER (PARTITION BY category ORDER BY one_year_return_pct DESC) AS rn
    FROM ret
)
SELECT category, fund_name, ROUND(one_year_return_pct, 2) AS one_year_return_pct
FROM r
WHERE rn = 1
ORDER BY one_year_return_pct DESC;

-- ===== Q35
-- Expected result: 12 rows
-- Dec 2023 NAV is included so January 2024 has a return. 24 monthly returns per fund.
WITH m AS (
    SELECT fund_id, nav_date,
           (nav - LAG(nav) OVER (PARTITION BY fund_id ORDER BY nav_date))
               / LAG(nav) OVER (PARTITION BY fund_id ORDER BY nav_date) AS monthly_ret
    FROM fund_nav
    WHERE nav_date >= '2023-12-31' AND nav_date <= '2025-12-31'
),
s AS (
    SELECT fund_id,
           AVG(CAST(monthly_ret AS FLOAT))   AS avg_ret,
           STDEV(CAST(monthly_ret AS FLOAT)) AS volatility
    FROM m
    WHERE monthly_ret IS NOT NULL
    GROUP BY fund_id
)
SELECT f.fund_name, f.category,
       ROUND(100 * s.avg_ret, 3)                      AS avg_monthly_return_pct,
       ROUND(100 * s.volatility, 3)                   AS monthly_volatility_pct,
       ROUND(s.avg_ret / NULLIF(s.volatility, 0), 3)  AS return_to_vol,
       RANK() OVER (ORDER BY s.avg_ret / NULLIF(s.volatility, 0) DESC) AS rnk
FROM s
JOIN funds f ON f.fund_id = s.fund_id
ORDER BY rnk;

-- ===== Q36
-- Expected result: 65 rows
WITH monthly AS (
    SELECT portfolio_id,
           DATEFROMPARTS(YEAR(transaction_date), MONTH(transaction_date), 1) AS month_start,
           SUM(CASE WHEN transaction_type = 'BUY'
                    THEN quantity * price + brokerage_fee
                    ELSE -(quantity * price) + brokerage_fee END)           AS net_cash_invested
    FROM portfolio_transactions
    GROUP BY portfolio_id, DATEFROMPARTS(YEAR(transaction_date), MONTH(transaction_date), 1)
)
SELECT p.investor_name, m.month_start, m.net_cash_invested,
       SUM(m.net_cash_invested) OVER (PARTITION BY m.portfolio_id ORDER BY m.month_start
                                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM monthly m
JOIN portfolios p ON p.portfolio_id = m.portfolio_id
ORDER BY p.investor_name, m.month_start;

-- ===== Q37
-- Expected result: 40 rows
-- Average cost method: average cost = total buy value / total shares bought.
-- Selling does not change the average cost of the shares left. Fees excluded.
WITH pos AS (
    SELECT portfolio_id, company_id,
           SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS open_qty,
           SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price END)
             / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity END)           AS avg_cost
    FROM portfolio_transactions
    GROUP BY portfolio_id, company_id
    HAVING SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) > 0
),
last_close AS (
    SELECT company_id, close_price
    FROM stock_prices
    WHERE trade_date = (SELECT MAX(trade_date) FROM stock_prices WHERE trade_date <= '2025-12-31')
)
SELECT p.investor_name, c.ticker, pos.open_qty,
       ROUND(pos.avg_cost, 2)                                         AS avg_cost,
       lc.close_price,
       pos.open_qty * lc.close_price                                  AS market_value,
       ROUND(pos.open_qty * (lc.close_price - pos.avg_cost), 2)      AS unrealized_gain,
       ROUND(100.0 * (lc.close_price - pos.avg_cost) / pos.avg_cost, 2) AS unrealized_gain_pct
FROM pos
JOIN last_close lc ON lc.company_id = pos.company_id
JOIN portfolios p  ON p.portfolio_id = pos.portfolio_id
JOIN companies c   ON c.company_id = pos.company_id
ORDER BY p.investor_name, unrealized_gain_pct DESC;

-- ===== Q38a  (payout history)
-- Expected result: 90 rows
WITH d AS (
    SELECT c.ticker, d.company_id, d.ex_dividend_date, d.dividend_per_share AS dps,
           LAG(d.ex_dividend_date)   OVER (PARTITION BY d.company_id ORDER BY d.ex_dividend_date) AS prev_ex_date,
           LAG(d.dividend_per_share) OVER (PARTITION BY d.company_id ORDER BY d.ex_dividend_date) AS prev_dps
    FROM dividends d
    JOIN companies c ON c.company_id = d.company_id
    WHERE d.dividend_type = 'Regular'
)
SELECT ticker, ex_dividend_date, dps,
       DATEDIFF(DAY, prev_ex_date, ex_dividend_date)   AS days_since_prev,
       ROUND(100.0 * (dps - prev_dps) / prev_dps, 2)   AS dps_change_pct
FROM d
ORDER BY ticker, ex_dividend_date;

-- ===== Q38b  (DPS rose at every payout)
-- Expected result: 5 rows
-- A CTE only lives for one statement in SQL Server, so it is written again here.
WITH d AS (
    SELECT c.ticker, d.dividend_per_share AS dps,
           LAG(d.dividend_per_share) OVER (PARTITION BY d.company_id ORDER BY d.ex_dividend_date) AS prev_dps
    FROM dividends d
    JOIN companies c ON c.company_id = d.company_id
    WHERE d.dividend_type = 'Regular'
)
SELECT ticker
FROM d
GROUP BY ticker
HAVING COUNT(prev_dps) > 0
   AND SUM(CASE WHEN dps <= prev_dps THEN 1 ELSE 0 END) = 0;

-- ===== Q39
-- Expected result: 7 rows
WITH w AS (
    SELECT company_id, trade_date, close_price,
           MAX(high_price) OVER (PARTITION BY company_id ORDER BY trade_date
                                 ROWS BETWEEN 251 PRECEDING AND CURRENT ROW) AS high_52w,
           MIN(low_price)  OVER (PARTITION BY company_id ORDER BY trade_date
                                 ROWS BETWEEN 251 PRECEDING AND CURRENT ROW) AS low_52w
    FROM stock_prices
)
SELECT c.ticker, w.close_price, w.high_52w, w.low_52w,
       ROUND(100.0 * (w.high_52w - w.close_price) / w.high_52w, 2) AS pct_below_high
FROM w
JOIN companies c ON c.company_id = w.company_id
WHERE w.trade_date = (SELECT MAX(trade_date) FROM stock_prices)
  AND w.close_price >= 0.95 * w.high_52w
ORDER BY pct_below_high;

-- ===== Q40a  (YoY growth)
-- Expected result: 50 rows
SELECT b.bank_name, f.fiscal_year,
       ROUND(100.0 * (f.total_deposits - LAG(f.total_deposits) OVER (PARTITION BY f.bank_id ORDER BY f.fiscal_year))
             / LAG(f.total_deposits) OVER (PARTITION BY f.bank_id ORDER BY f.fiscal_year), 2) AS deposit_growth_pct,
       ROUND(100.0 * (f.total_advances - LAG(f.total_advances) OVER (PARTITION BY f.bank_id ORDER BY f.fiscal_year))
             / LAG(f.total_advances) OVER (PARTITION BY f.bank_id ORDER BY f.fiscal_year), 2) AS advances_growth_pct,
       ROUND(100.0 * (f.net_profit - LAG(f.net_profit) OVER (PARTITION BY f.bank_id ORDER BY f.fiscal_year))
             / ABS(LAG(f.net_profit) OVER (PARTITION BY f.bank_id ORDER BY f.fiscal_year)), 2) AS profit_growth_pct
FROM bank_financials f
JOIN banks b ON b.bank_id = f.bank_id
ORDER BY b.bank_name, f.fiscal_year;

-- ===== Q40b  (profit grew every year FY2022-FY2025)
-- Expected result: 7 rows
WITH g AS (
    SELECT bank_id, fiscal_year, net_profit,
           LAG(net_profit) OVER (PARTITION BY bank_id ORDER BY fiscal_year) AS prev_profit
    FROM bank_financials
)
SELECT b.bank_name
FROM g
JOIN banks b ON b.bank_id = g.bank_id
WHERE g.fiscal_year BETWEEN 2022 AND 2025
GROUP BY b.bank_name
HAVING SUM(CASE WHEN g.net_profit > g.prev_profit THEN 1 ELSE 0 END) = 4;

-- ===== Q41
-- Expected result: 24 rows
WITH e AS (
    SELECT country, indicator_month, policy_rate_pct, cpi_inflation_pct,
           LAG(policy_rate_pct)      OVER (PARTITION BY country ORDER BY indicator_month) AS prev_rate,
           LEAD(cpi_inflation_pct, 3) OVER (PARTITION BY country ORDER BY indicator_month) AS cpi_3m_later
    FROM economic_indicators
)
SELECT country, indicator_month, prev_rate, policy_rate_pct,
       policy_rate_pct - prev_rate                              AS change_pp,
       CASE WHEN policy_rate_pct > prev_rate THEN 'Hike' ELSE 'Cut' END AS action,
       cpi_inflation_pct,
       cpi_3m_later
FROM e
WHERE policy_rate_pct <> prev_rate
ORDER BY country, indicator_month;

-- ===== Q42
-- Expected result: 4 rows
WITH v AS (
    SELECT c.ticker,
           sp.close_price * c.shares_outstanding / 10000000.0 AS market_cap_crore,
           b.shareholders_equity,
           ni.net_income_fy25
    FROM companies c
    JOIN stock_prices sp   ON sp.company_id = c.company_id AND sp.trade_date = '2025-12-31'
    JOIN balance_sheets b  ON b.company_id = c.company_id AND b.fiscal_year = 2025 AND b.fiscal_quarter = 4
    JOIN (SELECT company_id, SUM(net_income) AS net_income_fy25
          FROM income_statements WHERE fiscal_year = 2025
          GROUP BY company_id) ni ON ni.company_id = c.company_id
),
q AS (
    SELECT v.*,
           market_cap_crore / shareholders_equity           AS price_to_book,
           100.0 * net_income_fy25 / shareholders_equity    AS roe_pct,
           NTILE(4) OVER (ORDER BY market_cap_crore / shareholders_equity) AS pb_quartile
    FROM v
)
SELECT pb_quartile,
       COUNT(*)                     AS companies,
       ROUND(MIN(price_to_book), 2) AS min_pb,
       ROUND(MAX(price_to_book), 2) AS max_pb,
       ROUND(AVG(roe_pct), 2)       AS avg_roe_pct
FROM q
GROUP BY pb_quartile
ORDER BY pb_quartile;

-- ===== Q43
-- Expected result: 20 rows
WITH p AS (
    SELECT company_id, trade_date, close_price,
           MAX(close_price) OVER (PARTITION BY company_id ORDER BY trade_date
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_peak
    FROM stock_prices
    WHERE trade_date >= '2025-01-01' AND trade_date < '2026-01-01'
),
d AS (
    SELECT p.*,
           100.0 * (close_price - running_peak) / running_peak AS drawdown_pct,
           ROW_NUMBER() OVER (PARTITION BY company_id
                              ORDER BY (close_price - running_peak) / running_peak) AS rn
    FROM p
)
SELECT c.ticker, d.trade_date AS trough_date, d.running_peak AS peak_close,
       d.close_price AS trough_close, ROUND(d.drawdown_pct, 2) AS max_drawdown_pct
FROM d
JOIN companies c ON c.company_id = d.company_id
WHERE d.rn = 1
ORDER BY max_drawdown_pct;

-- ===== Q44
-- Expected result: 20 rows
WITH ni AS (
    SELECT company_id, SUM(net_income) AS net_income
    FROM income_statements WHERE fiscal_year = 2025
    GROUP BY company_id
),
cf AS (
    SELECT company_id,
           SUM(operating_cash_flow)                       AS ocf,
           SUM(operating_cash_flow - capital_expenditure) AS fcf,
           SUM(dividends_paid)                            AS dividends_paid
    FROM cash_flow_statements WHERE fiscal_year = 2025
    GROUP BY company_id
)
SELECT c.ticker, ni.net_income, cf.ocf, cf.fcf, cf.dividends_paid,
       ROUND(cf.ocf / NULLIF(ni.net_income, 0), 2)                        AS cash_conversion,
       CASE WHEN cf.fcf > 0 THEN ROUND(100.0 * cf.dividends_paid / cf.fcf, 1) END AS dividends_pct_of_fcf,
       CASE WHEN cf.fcf < 0                  THEN 'Negative FCF'
            WHEN cf.dividends_paid > cf.fcf  THEN 'Payout above FCF'
            ELSE 'OK' END                                                  AS flag
FROM ni
JOIN cf ON cf.company_id = ni.company_id
JOIN companies c ON c.company_id = ni.company_id
ORDER BY flag, cash_conversion DESC;

-- ===== Q45
-- Expected result: 11 rows
-- n200 = 200 makes sure a full 200 days exist before the average is used.
WITH ma AS (
    SELECT company_id, trade_date,
           AVG(close_price) OVER (PARTITION BY company_id ORDER BY trade_date
                                  ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)  AS sma50,
           AVG(close_price) OVER (PARTITION BY company_id ORDER BY trade_date
                                  ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma200,
           COUNT(*)         OVER (PARTITION BY company_id ORDER BY trade_date
                                  ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS n200
    FROM stock_prices
),
x AS (
    SELECT ma.*,
           LAG(sma50)  OVER (PARTITION BY company_id ORDER BY trade_date) AS prev_sma50,
           LAG(sma200) OVER (PARTITION BY company_id ORDER BY trade_date) AS prev_sma200
    FROM ma
    WHERE n200 = 200
)
SELECT c.ticker, x.trade_date AS golden_cross_date,
       ROUND(x.sma50, 2) AS sma50, ROUND(x.sma200, 2) AS sma200
FROM x
JOIN companies c ON c.company_id = x.company_id
WHERE x.trade_date >= '2025-01-01'
  AND x.sma50 > x.sma200
  AND x.prev_sma50 <= x.prev_sma200
ORDER BY x.trade_date;

/* ======================================================= EXPERT (46-50) */

-- ===== Q46
-- Expected result: 20 rows
-- DuPont: ROE = (NI / Revenue) x (Revenue / Avg assets) x (Avg assets / Avg equity).
WITH fy AS (
    SELECT company_id,
           CAST(SUM(revenue) AS FLOAT)    AS revenue,
           CAST(SUM(net_income) AS FLOAT) AS net_income
    FROM income_statements WHERE fiscal_year = 2025
    GROUP BY company_id
),
bal AS (
    SELECT company_id,
           AVG(CAST(total_assets AS FLOAT))        AS avg_assets,
           AVG(CAST(shareholders_equity AS FLOAT)) AS avg_equity
    FROM balance_sheets
    WHERE fiscal_quarter = 4 AND fiscal_year IN (2024, 2025)
    GROUP BY company_id
),
d AS (
    SELECT c.ticker, c.sector,
           fy.net_income / fy.revenue      AS net_margin,
           fy.revenue / bal.avg_assets     AS asset_turnover,
           bal.avg_assets / bal.avg_equity AS equity_multiplier,
           fy.net_income / bal.avg_equity  AS roe_direct
    FROM fy
    JOIN bal ON bal.company_id = fy.company_id
    JOIN companies c ON c.company_id = fy.company_id
)
SELECT ticker, sector,
       ROUND(100 * net_margin, 2)                                       AS net_margin_pct,
       ROUND(asset_turnover, 3)                                         AS asset_turnover,
       ROUND(equity_multiplier, 2)                                      AS equity_multiplier,
       ROUND(100 * net_margin * asset_turnover * equity_multiplier, 2)  AS roe_dupont_pct,
       ROUND(100 * roe_direct, 2)                                       AS roe_direct_pct,
       RANK() OVER (PARTITION BY sector ORDER BY roe_direct DESC)       AS sector_rank
FROM d
ORDER BY sector, sector_rank;

-- ===== Q47
-- Expected result: 6 rows
-- Monthly return = (value this month - value last month - net cash added) / value last month.
-- Removing the cash added stops a big purchase looking like a big gain.
WITH month_ends AS (
    SELECT DISTINCT nav_date AS month_end
    FROM fund_nav
    WHERE nav_date BETWEEN '2024-12-31' AND '2025-12-31'
),
last_trade AS (
    SELECT m.month_end, MAX(sp.trade_date) AS last_trade_date
    FROM month_ends m
    JOIN stock_prices sp ON sp.trade_date <= m.month_end
    GROUP BY m.month_end
),
positions AS (
    SELECT t.portfolio_id, t.company_id, m.month_end,
           SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.quantity ELSE -t.quantity END) AS qty
    FROM month_ends m
    JOIN portfolio_transactions t ON t.transaction_date <= m.month_end
    GROUP BY t.portfolio_id, t.company_id, m.month_end
),
port_values AS (
    SELECT p.portfolio_id, p.month_end,
           SUM(CAST(p.qty AS FLOAT) * sp.close_price) AS port_value
    FROM positions p
    JOIN last_trade lt   ON lt.month_end = p.month_end
    JOIN stock_prices sp ON sp.company_id = p.company_id AND sp.trade_date = lt.last_trade_date
    GROUP BY p.portfolio_id, p.month_end
),
flows AS (
    SELECT v.portfolio_id, v.month_end,
           ISNULL(SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.quantity * t.price
                           ELSE -t.quantity * t.price END), 0) AS net_flow
    FROM port_values v
    LEFT JOIN portfolio_transactions t
           ON t.portfolio_id = v.portfolio_id
          AND YEAR(t.transaction_date)  = YEAR(v.month_end)
          AND MONTH(t.transaction_date) = MONTH(v.month_end)
    GROUP BY v.portfolio_id, v.month_end
),
port_returns AS (
    SELECT v.portfolio_id, v.month_end, v.port_value, f.net_flow,
           LAG(v.port_value) OVER (PARTITION BY v.portfolio_id ORDER BY v.month_end) AS prev_value
    FROM port_values v
    JOIN flows f ON f.portfolio_id = v.portfolio_id AND f.month_end = v.month_end
),
bench AS (
    SELECT p.portfolio_id, n.nav_date,
           CAST(n.nav AS FLOAT) / LAG(n.nav) OVER (PARTITION BY p.portfolio_id ORDER BY n.nav_date) - 1 AS bench_ret
    FROM portfolios p
    JOIN fund_nav n ON n.fund_id = p.benchmark_fund_id
    WHERE n.nav_date BETWEEN '2024-12-31' AND '2025-12-31'
),
monthly AS (
    SELECT r.portfolio_id, r.month_end,
           (r.port_value - r.prev_value - r.net_flow) / r.prev_value AS port_ret,
           b.bench_ret
    FROM port_returns r
    JOIN bench b ON b.portfolio_id = r.portfolio_id AND b.nav_date = r.month_end
    WHERE r.prev_value IS NOT NULL
)
SELECT p.investor_name, f.fund_name AS benchmark,
       COUNT(*)                                            AS months,
       SUM(CASE WHEN m.port_ret > m.bench_ret THEN 1 ELSE 0 END) AS months_beat_benchmark,
       ROUND(100 * AVG(m.port_ret), 2)                     AS avg_monthly_return_pct,
       ROUND(100 * AVG(m.bench_ret), 2)                    AS avg_benchmark_return_pct,
       ROUND(100 * AVG(m.port_ret - m.bench_ret), 2)       AS avg_excess_return_pct
FROM monthly m
JOIN portfolios p ON p.portfolio_id = m.portfolio_id
JOIN funds f      ON f.fund_id = p.benchmark_fund_id
GROUP BY p.investor_name, f.fund_name
ORDER BY avg_excess_return_pct DESC;

-- ===== Q48
-- Expected result: 12 rows
-- Pearson r = (n*Sxy - Sx*Sy) / (SQRT(n*Sxx - Sx^2) * SQRT(n*Syy - Sy^2))
WITH r AS (
    SELECT company_id, trade_date,
           CAST(close_price AS FLOAT)
             / LAG(close_price) OVER (PARTITION BY company_id ORDER BY trade_date) - 1 AS ret
    FROM stock_prices
),
y AS (
    SELECT * FROM r WHERE trade_date >= '2025-01-01' AND ret IS NOT NULL
),
pairs AS (
    SELECT c1.sector, c1.ticker AS stock_a, c2.ticker AS stock_b, a.ret AS x, b.ret AS y
    FROM y a
    JOIN y b         ON b.trade_date = a.trade_date AND a.company_id < b.company_id
    JOIN companies c1 ON c1.company_id = a.company_id
    JOIN companies c2 ON c2.company_id = b.company_id
    WHERE c1.sector = c2.sector
)
SELECT sector, stock_a, stock_b,
       COUNT(*) AS days,
       ROUND((COUNT(*) * SUM(x * y) - SUM(x) * SUM(y))
             / (SQRT(COUNT(*) * SUM(x * x) - SQUARE(SUM(x)))
              * SQRT(COUNT(*) * SUM(y * y) - SQUARE(SUM(y)))), 3) AS correlation
FROM pairs
GROUP BY sector, stock_a, stock_b
ORDER BY correlation DESC;

-- ===== Q49
-- Expected result: 20 rows
-- Gaps and islands: for rows in the same streak, (row number over all days)
-- minus (row number over up days only) stays constant, so it can be grouped.
WITH r AS (
    SELECT company_id, trade_date,
           CASE WHEN close_price > LAG(close_price) OVER (PARTITION BY company_id ORDER BY trade_date)
                THEN 1 ELSE 0 END AS is_up
    FROM stock_prices
),
y AS (
    SELECT r.*,
           ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY trade_date)        AS rn_all,
           ROW_NUMBER() OVER (PARTITION BY company_id, is_up ORDER BY trade_date) AS rn_grp
    FROM r
    WHERE trade_date >= '2025-01-01'
),
streaks AS (
    SELECT company_id, rn_all - rn_grp AS grp,
           MIN(trade_date) AS start_date,
           MAX(trade_date) AS end_date,
           COUNT(*)        AS streak_days
    FROM y
    WHERE is_up = 1
    GROUP BY company_id, rn_all - rn_grp
),
ranked AS (
    SELECT streaks.*,
           ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY streak_days DESC, start_date) AS rn
    FROM streaks
)
SELECT c.ticker, ranked.start_date, ranked.end_date, ranked.streak_days
FROM ranked
JOIN companies c ON c.company_id = ranked.company_id
WHERE ranked.rn = 1
ORDER BY ranked.streak_days DESC, c.ticker;

-- ===== Q50
-- Expected result: 17 rows
-- Altman Z = 1.2*X1 + 1.4*X2 + 3.3*X3 + 0.6*X4 + 1.0*X5 (original model for
-- non-financial companies, so Banking and Financial Services are excluded).
WITH fy AS (
    SELECT company_id,
           SUM(revenue)                                                          AS revenue,
           SUM(revenue - cost_of_revenue - operating_expenses - depreciation)    AS ebit
    FROM income_statements WHERE fiscal_year = 2025
    GROUP BY company_id
),
mc AS (
    SELECT sp.company_id, sp.close_price * c.shares_outstanding / 10000000.0 AS market_cap_crore
    FROM stock_prices sp
    JOIN companies c ON c.company_id = sp.company_id
    WHERE sp.trade_date = '2025-12-31'
),
x AS (
    SELECT c.ticker, c.sector,
           CAST(b.current_assets - b.current_liabilities AS FLOAT) / b.total_assets AS x1,
           CAST(b.retained_earnings AS FLOAT) / b.total_assets                     AS x2,
           CAST(fy.ebit AS FLOAT) / b.total_assets                                 AS x3,
           CAST(mc.market_cap_crore AS FLOAT) / b.total_liabilities                AS x4,
           CAST(fy.revenue AS FLOAT) / b.total_assets                              AS x5
    FROM companies c
    JOIN balance_sheets b ON b.company_id = c.company_id AND b.fiscal_year = 2025 AND b.fiscal_quarter = 4
    JOIN fy ON fy.company_id = c.company_id
    JOIN mc ON mc.company_id = c.company_id
    WHERE c.sector NOT IN ('Banking', 'Financial Services')
),
z AS (
    SELECT x.*, 1.2 * x1 + 1.4 * x2 + 3.3 * x3 + 0.6 * x4 + 1.0 * x5 AS z_score
    FROM x
)
SELECT ticker, sector,
       ROUND(x1, 3) AS x1, ROUND(x2, 3) AS x2, ROUND(x3, 3) AS x3,
       ROUND(x4, 3) AS x4, ROUND(x5, 3) AS x5,
       ROUND(z_score, 2) AS z_score,
       CASE WHEN z_score > 2.99  THEN 'Safe'
            WHEN z_score >= 1.81 THEN 'Grey'
            ELSE 'Distress' END AS zone
FROM z
ORDER BY z_score DESC;
