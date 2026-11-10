--Intermediate Question 16 to 30.

-- 16: Section wise revenue and profitability. : By sector, show FY2024 and FY2025 total revenue, total net income and net margin %.

--SELECT
--    c.sector,

--    SUM(
--        CASE
--            WHEN i.fiscal_year = 2024 THEN i.revenue
--            ELSE 0
--        END
--    ) AS revenue_2024,

--    SUM(
--        CASE
--            WHEN i.fiscal_year = 2025 THEN i.revenue
--            ELSE 0
--        END
--    ) AS revenue_2025,

--    SUM(
--        CASE
--            WHEN i.fiscal_year = 2024 THEN i.net_income
--            ELSE 0
--        END
--    ) AS net_income_2024,

--    SUM(
--        CASE
--            WHEN i.fiscal_year = 2025 THEN i.net_income
--            ELSE 0
--        END
--    ) AS net_income_2025,

--    (
--        100.0 * SUM(
--            CASE
--                WHEN i.fiscal_year = 2024 THEN i.net_income
--                ELSE 0
--            END
--        )
--        / NULLIF(
--            SUM(
--                CASE
--                    WHEN i.fiscal_year = 2024 THEN i.revenue
--                    ELSE 0
--                END
--            ), 0
--        )
--    ) AS net_margin_2024_pct,

--    (
--        100.0 * SUM(
--            CASE
--                WHEN i.fiscal_year = 2025 THEN i.net_income
--                ELSE 0
--            END
--        )
--        / NULLIF(
--            SUM(
--                CASE
--                    WHEN i.fiscal_year = 2025 THEN i.revenue
--                    ELSE 0
--                END
--            ), 0
--        )
--    ) AS net_margin_2025_pct

--FROM companies AS c

--INNER JOIN income_statements AS i
--ON c.company_id = i.company_id

--WHERE i.fiscal_year IN (2024, 2025)

--GROUP BY c.sector

--ORDER BY c.sector ASC;

--We use conditional aggregation because we need to calculate revenue separately for each financial year within  the sector. Case when separates the records by year, and SUM() calculates the total revenue for each year.







-- 17: Find companies that paid no dividends : Find company that declared no dividend (by ex-dividend date) at any point in 2024 - 2025


--SELECT 
--* 
--FROM companies AS C
--LEFT JOIN dividends AS d
--	ON c.company_id = d.company_id 
--	AND d.ex_dividend_date >= '2024-01-01'
--	AND d.ex_dividend_date < '2026-01-01'
--WHERE d.dividend_id IS NULL
--;



--18: Profitable companies with negative free cash flow : For FY2025, find companies with positive net income but negative cash flow (operating cash flow - capex). Show both figures.

--SELECT
--    c.company_id,
--    c.ticker,
--    c.company_name,

--    SUM(i.net_income) AS total_net_income,

--    SUM(cf.operating_cash_flow)
--        - SUM(cf.capital_expenditure) AS free_cash_flow

--FROM companies AS c

--INNER JOIN income_statements AS i
--    ON c.company_id = i.company_id

--INNER JOIN cash_flow_statements AS cf
--    ON i.company_id = cf.company_id
--    AND i.fiscal_year = cf.fiscal_year
--    AND i.fiscal_quarter = cf.fiscal_quarter

--WHERE i.fiscal_year = '2025'

--GROUP BY
--    c.company_id,
--    c.ticker,
--    c.company_name

--HAVING
--    SUM(i.net_income) > 0
--    AND (
--        SUM(cf.operating_cash_flow)
--        - SUM(cf.capital_expenditure)
--    ) < 0

--ORDER BY free_cash_flow ASC;





-- 19 : Banking financial ratios : For FY2025, calculate each banks credit-to-deposit ratio, gross NPA %, net NPA % and Tier - 1 capital ratio. Flag banks with gross NPA apove 5%. WHY(Analyse the financial health of every bank in FY2025, Calculate its lending ratio, bad-loan ratios and capital strength. Identify banks with high gross NPAs)

--SELECT
--    b.bank_name,

--    (100.0 * bf.total_advances)
--        / NULLIF(bf.total_deposits, 0) AS credit_to_deposit_pct,

--    (100.0 * bf.gross_npa)
--        / NULLIF(bf.total_advances, 0) AS gross_npa_pct,

--    (100.0 * bf.net_npa)
--        / NULLIF(bf.total_advances, 0) AS net_npa_pct,

--    (100.0 * bf.tier1_capital)
--        / NULLIF(bf.risk_weighted_assets, 0) AS tier1_capital_pct,

--    CASE
--        WHEN (100.0 * bf.gross_npa)
--             / NULLIF(bf.total_advances, 0) > 5
--        THEN 'HIGH NPA'
--        ELSE 'Normal'
--    END AS risk_flag

--FROM banks AS b

--INNER JOIN bank_financials AS bf
--    ON b.bank_id = bf.bank_id

--WHERE bf.fiscal_year = 2025;



-- 20 : Calculate open investment positions : Show each portfolio's open positions: net shares held per company (buys - sells), keeping only positions above zero.
--SELECT
--    pt.portfolio_id,
--    pt.company_id,
--    c.ticker,
--    c.company_name,

--    SUM(
--        CASE
--            WHEN pt.transaction_type = 'BUY' THEN pt.quantity
--            WHEN pt.transaction_type = 'SELL' THEN -pt.quantity
--            ELSE 0
--        END
--    ) AS net_shares

--FROM portfolios AS p

--INNER JOIN portfolio_transactions AS pt
--    ON p.portfolio_id = pt.portfolio_id

--INNER JOIN companies AS c
--    ON pt.company_id = c.company_id

--GROUP BY
--    pt.portfolio_id,
--    pt.company_id,
--    c.ticker,
--    c.company_name

--HAVING SUM(
--    CASE
--        WHEN pt.transaction_type = 'BUY' THEN pt.quantity
--        WHEN pt.transaction_type = 'SELL' THEN -pt.quantity
--        ELSE 0
--    END
--) > 0;



















































































































































































































































--.....--