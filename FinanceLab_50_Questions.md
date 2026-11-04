# FinanceLab: 50 T-SQL Practice Questions (Finance)

**Setup:** run `FinanceLab_setup.sql` in SSMS or Azure Data Studio (SQL Server 2016+). It creates the `FinanceLab` database and loads the sample data.

**Data notes**
- All companies, banks, funds and investors are fictional. Prices and indicators are synthetic, made for practice only.
- Financial statement amounts, bank financials and AUM are in **INR crore** (1 crore = 10,000,000). Share prices, DPS and loan amounts are in **INR**.
- `fiscal_year` matches the calendar year (Q1 = Jan–Mar ... Q4 = Oct–Dec). Statements cover FY2022–FY2025.
- Stock prices: daily trading days, Jan 2024 – Dec 2025. Fund NAVs: month-end, Jan 2023 – Dec 2025.

---

## Database schema

| Table | Columns | Grain |
|---|---|---|
| `companies` | company_id (PK), ticker, company_name, sector, country, listing_date, shares_outstanding | 1 row per company (20) |
| `income_statements` | company_id, fiscal_year, fiscal_quarter, period_end_date, revenue, cost_of_revenue, operating_expenses, depreciation, interest_expense, tax_expense, net_income | company × quarter |
| `balance_sheets` | company_id, fiscal_year, fiscal_quarter, period_end_date, total_assets, current_assets, cash_and_equivalents, inventory, total_liabilities, current_liabilities, long_term_debt, retained_earnings, shareholders_equity | company × quarter |
| `cash_flow_statements` | company_id, fiscal_year, fiscal_quarter, period_end_date, operating_cash_flow, capital_expenditure (+ = spent), investing_cash_flow, financing_cash_flow, dividends_paid (+ = paid) | company × quarter |
| `stock_prices` | company_id, trade_date, open_price, high_price, low_price, close_price, volume | company × trading day |
| `dividends` | dividend_id (PK), company_id, ex_dividend_date, record_date, payment_date, dividend_per_share, dividend_type ('Regular' / 'Special') | 1 row per declaration |
| `funds` | fund_id (PK), fund_name, fund_type ('Mutual Fund' / 'ETF'), category, fund_house, expense_ratio (% p.a.), inception_date | 1 row per fund (12) |
| `fund_nav` | fund_id, nav_date (month-end), nav, aum_crore | fund × month |
| `fund_holdings` | fund_id, company_id, as_of_date (2025-06-30, 2025-12-31), weight_pct | fund × stock × snapshot |
| `portfolios` | portfolio_id (PK), investor_name, risk_profile, start_date, benchmark_fund_id → funds | 1 row per portfolio (6) |
| `portfolio_transactions` | transaction_id (PK), portfolio_id, company_id, transaction_date, transaction_type ('BUY' / 'SELL'), quantity, price, brokerage_fee | 1 row per trade |
| `banks` | bank_id (PK), bank_name, bank_type (Public / Private / Foreign / Small Finance), headquarters_city, established_year | 1 row per bank (10) |
| `bank_financials` | bank_id, fiscal_year (2021–2025), total_deposits, total_advances, gross_npa, net_npa, net_interest_income, operating_profit, provisions, net_profit, tier1_capital, risk_weighted_assets | bank × year |
| `loans` | loan_id (PK), bank_id, borrower_segment, loan_type, principal_amount, outstanding_amount, interest_rate, tenure_months, disbursement_date, loan_status (Active / Closed / Default / Restructured), days_past_due | 1 row per loan (900) |
| `economic_indicators` | indicator_month (1st of month), country ('India' / 'United States'), cpi_inflation_pct, policy_rate_pct, gdp_growth_pct (quarter-end months only, else NULL), unemployment_pct, bond_yield_10y_pct, currency_per_usd | month × country |

---

## Questions

| # | Difficulty | Financial domain | SQL concept | Business problem |
|---|---|---|---|---|
| 1 | Beginner | Company financial statements | SELECT, WHERE, ORDER BY | List the ticker, company name and listing date of all Technology companies listed on or after 1 Jan 2015, newest listing first. |
| 2 | Beginner | Stock market | TOP, ORDER BY | Find the 10 highest-volume trading days in 2025 across all stocks. Show company_id, trade_date, close_price and volume. |
| 3 | Beginner | Mutual funds & ETFs | DISTINCT | List every unique combination of fund house and fund category on offer, sorted by fund house. |
| 4 | Beginner | Mutual funds & ETFs | BETWEEN | Find funds with an expense ratio between 0.10% and 0.60%, cheapest first, showing fund type and category. |
| 5 | Beginner | Banking | IN, date filter | List Home, Auto and Personal loans disbursed in 2024 that are now in Default, highest principal first. |
| 6 | Beginner | Company financial statements | LIKE | Find companies whose name contains "Energy" or "Power", or whose ticker starts with "S". |
| 7 | Beginner | Revenue & profitability | Calculated columns | For FY2025 Q4, show each company's revenue, gross profit (revenue − cost of revenue) and gross margin %, highest margin first. |
| 8 | Beginner | Dividends | COUNT, SUM, GROUP BY | For dividends with an ex-dividend date in 2025, show each company's number of payouts and total dividend per share. |
| 9 | Beginner | Stock market | MIN, MAX, AVG | For each company, show the lowest close, highest close and average daily volume in 2025. |
| 10 | Beginner | Economics | WHERE, comparison | Find the months when India's CPI inflation was above its policy rate (a negative real interest rate), with the gap in percentage points. |
| 11 | Beginner | Banking | GROUP BY | For each borrower segment, show the number of loans, total principal and average interest rate. |
| 12 | Beginner | Balance sheets | Ratio calculation | As of FY2025 Q4, calculate each company's current ratio and debt-to-equity (long-term debt ÷ equity), highest debt-to-equity first. |
| 13 | Beginner | Mutual funds & ETFs | GROUP BY, HAVING | Which fund houses manage more than two funds? Show their fund count and average expense ratio. |
| 14 | Beginner | Stock market | Date functions, JOIN | For ticker NOVT, show the monthly average close and total volume for 2025, with month names, in calendar order. |
| 15 | Beginner | Dividends | CASE WHEN | Classify each dividend as Small (< ₹5), Medium (₹5–20) or Large (> ₹20) per share, and count dividends in each class by dividend type. |
| 16 | Intermediate | Revenue & profitability | INNER JOIN, GROUP BY | By sector, show FY2024 and FY2025 total revenue, total net income and net margin %. |
| 17 | Intermediate | Dividends | LEFT JOIN | Find the companies that declared no dividend (by ex-dividend date) at any point in 2024–2025. |
| 18 | Intermediate | Cash flow | JOIN, aggregation | For FY2025, find companies with positive net income but negative free cash flow (operating cash flow − capex). Show both figures. |
| 19 | Intermediate | Banking | Financial ratios, CASE | For FY2025, calculate each bank's credit-to-deposit ratio, gross NPA %, net NPA % and Tier-1 capital ratio. Flag banks with gross NPA above 5%. |
| 20 | Intermediate | Investment portfolios | SUM with CASE | Show each portfolio's open positions: net shares held per company (buys − sells), keeping only positions above zero. |
| 21 | Intermediate | Mutual funds & ETFs | JOIN, % of total | On the latest NAV date, show total AUM per fund house and each house's share of total AUM in the dataset. |
| 22 | Intermediate | Dividends | JOIN, yield | Calculate each company's 2025 dividend yield: total 2025 regular DPS ÷ close on 31 Dec 2025. Return the top 5. |
| 23 | Intermediate | Economics | Conditional aggregation | For each country and year, show average CPI inflation, average policy rate and the number of months inflation was above 6%. |
| 24 | Intermediate | Banking | CASE buckets, JOIN | For loans that are not Closed, bucket by days past due (0, 1–30, 31–60, 61–90, 90+). Show loan count and outstanding amount per bucket for each bank type. |
| 25 | Intermediate | Stock market | Subquery | Which stocks had a 2025 average daily traded value (close × volume) above the average for all stocks? |
| 26 | Intermediate | Revenue & profitability | Correlated subquery | Find companies whose FY2025 net margin is above the average net margin of their own sector. |
| 27 | Intermediate | Mutual funds & ETFs | Correlated subquery | Find funds whose expense ratio is above the average expense ratio of their own category. |
| 28 | Intermediate | Balance sheets | Self-join across periods | Comparing FY2024 Q4 with FY2025 Q4, find companies whose long-term debt rose more than 20% while cash fell. |
| 29 | Intermediate | Stock market | Date functions, conditional aggregation | For each company and quarter of 2025, count trading days and the % of up days (close > open). |
| 30 | Intermediate | Financial ratios & valuation | JOIN, CASE | As of 31 Dec 2025, calculate market cap (₹ crore), FY2025 EPS and P/E for every company. Show 'N/A' for P/E when earnings are negative. |
| 31 | Advanced | Stock market | LAG | Calculate each stock's daily return %, then find its best and worst single day in 2025. |
| 32 | Advanced | Revenue & profitability | LAG | For every company and quarter, calculate QoQ and YoY revenue growth %. |
| 33 | Advanced | Revenue & profitability | DENSE_RANK | Rank companies by FY2025 operating margin within their sector ((revenue − cost of revenue − opex − depreciation) ÷ revenue). Return the top 2 per sector. |
| 34 | Advanced | Mutual funds & ETFs | CTE, ROW_NUMBER | Calculate each fund's 1-year return (NAV on 31 Dec 2025 vs 31 Dec 2024) and return the best-performing fund in each category. |
| 35 | Advanced | Mutual funds & ETFs | LAG, STDEV | Using 2024–2025 month-end NAVs, calculate each fund's average monthly return, monthly volatility and return-to-volatility ratio. Rank funds by that ratio. |
| 36 | Advanced | Investment portfolios | Running total (SUM OVER) | For each portfolio, show net cash invested per month (buys + fees − sells) and the running total since its first trade. |
| 37 | Advanced | Investment portfolios | CTE, valuation | For each open position, calculate average buy cost, market value at the last 2025 close, and unrealized gain in ₹ and %. |
| 38 | Advanced | Dividends | LAG, DATEDIFF | For regular dividends, show days since the company's previous ex-dividend date and the DPS change %. List companies whose DPS rose at every payout. |
| 39 | Advanced | Stock market | Window frame (ROWS BETWEEN) | Calculate a rolling 52-week (252 trading days) high and low per stock. List stocks whose last 2025 close is within 5% of their 52-week high. |
| 40 | Advanced | Banking | LAG | For each bank, show YoY growth in deposits, advances and net profit. Return banks whose net profit grew every year from FY2022 to FY2025. |
| 41 | Advanced | Economics | LAG, LEAD | Find every month the policy rate changed in each country (hike or cut, and the size), with CPI inflation that month and 3 months later. |
| 42 | Advanced | Financial ratios & valuation | NTILE | Split companies into 4 groups by price-to-book (market cap ÷ FY2025 Q4 equity) on 31 Dec 2025. Show the average ROE (FY2025 net income ÷ Q4 equity) for each group. |
| 43 | Advanced | Stock market | Running MAX | Calculate each stock's maximum drawdown in 2025 (largest % fall from a running peak close) and the date it happened. |
| 44 | Advanced | Cash flow | Multiple CTEs | For FY2025, calculate cash conversion (operating cash flow ÷ net income) and dividends as % of free cash flow. Flag companies with negative FCF or paying out more than their FCF. |
| 45 | Advanced | Stock market | Moving averages, LAG | Compute 50-day and 200-day simple moving averages and list every golden cross (50-day moving above 200-day) in 2025. |
| 46 | Expert | Financial ratios & valuation | Multiple CTEs, RANK | Run a DuPont analysis for FY2025: ROE = net margin × asset turnover × equity multiplier, using the average of FY2024 Q4 and FY2025 Q4 assets and equity. Confirm the product equals direct ROE and rank companies within their sector. |
| 47 | Expert | Investment portfolios & funds | CTEs, windows, month-end logic | Build each portfolio's month-end value for 2025 (holdings × month-end close). Calculate monthly return after removing that month's net cash flow, compare it with the benchmark fund's NAV return, and count the months the portfolio beat its benchmark. |
| 48 | Expert | Stock market | Self-join, statistics | Calculate the correlation of 2025 daily returns between every pair of stocks in the same sector (Pearson formula), highest first. |
| 49 | Expert | Stock market | Gaps & islands | Find each stock's longest run of consecutive up days (close above previous close) in 2025, with start date, end date and length. |
| 50 | Expert | Company financial statements & valuation | Multiple CTEs, CASE | Calculate the FY2025 Altman Z-score for all non-financial companies: Z = 1.2·(Working capital ÷ TA) + 1.4·(Retained earnings ÷ TA) + 3.3·(EBIT ÷ TA) + 0.6·(Market cap ÷ Total liabilities) + 1.0·(Revenue ÷ TA). Use FY2025 Q4 balances, full-year FY2025 EBIT and revenue, and market cap on 31 Dec 2025. Classify as Safe (> 2.99), Grey (1.81–2.99) or Distress (< 1.81). |
