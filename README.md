<h1 align="center">Hi 👋, I'm Karthik Pallamala</h1>
<h3 align="center">Data Analyst</h3>

- 👨‍💻 All of my projects are available at [https://karthikpallamala574-boop.github.io/Portfolio/](https://karthikpallamala574-boop.github.io/Portfolio/)

- 📫 How to reach me **Karthikpallamala574@gmail.com**

# Insurance Sales Performance Analytics Dashboard

A branch-level performance dashboard for an insurance brokerage. It compares each salesperson's **target**, **placed** revenue and **invoiced** revenue for new, cross-sell and renewal business, and adds a sales-pipeline and meeting-activity view.

The data was loaded into MySQL, the KPIs were calculated in SQL, and the dashboards were built in Excel and Tableau. SQL totals were checked against the Excel dashboard.

---

## Business question

How is each account executive performing against target on new, cross-sell and renewal business, and what does the open pipeline look like?

The dashboard is meant for a conversation between a corporate team and individual branch heads.

## Dashboard

**Excel dashboard.** Target, placed and invoiced revenue for each business type, achievement percentages, meetings and invoices per account executive, a stage funnel, product-group split and top opportunities, with slicers by employee and meeting year.

![Excel dashboard](https://github.com/karthikpallamala574-boop/Insurance-_Analysis_Project/blob/eb96dfddb91fd013c76a4c0da9c2b73bbedbdee4/Dashboard.png)

**Achievement summary sheet.** The pivot tables behind the placed and invoiced figures, with budget totals and achievement percentages.

![Achievement summary](https://github.com/karthikpallamala574-boop/Insurance-_Analysis_Project/blob/a0753a39e9d6f75d8fa3750e81d4c605df401afa/excel_achievement_summary.png)

## Data

Six Excel files, one branch (Ahmedabad):

| File | Contents | Rows |
|---|---|---|
| `brokerage.xlsx` | Policy-level brokerage income | 961 |
| `fees.xlsx` | Fee income | 9 |
| `invoice.xlsx` | Invoices raised | 204 |
| `Opportunity.xlsx` | Sales opportunities and stages | 49 |
| `meeting.xlsx` | Meetings by account executive | 34 |
| `Individual Budgets.xlsx` | New, cross-sell and renewal targets per person | 10 |

Column descriptions are in [`docs/`](docs/).

## KPI definitions

| KPI | Definition |
|---|---|
| Target | Sum of the budget column for the business type (New, Cross-sell, Renewal) |
| Placed | Brokerage amount + fees amount for the business type |
| Invoiced | Invoice amount for the business type |
| Placed % / Invoiced % | Placed (or invoiced) divided by target |
| Open opportunities | Stage is *Qualify Opportunity* or *Propose Solution* |
| Stage funnel | Sum of revenue amount by opportunity stage |
| Meetings | Count of meetings by account executive and by year |
| Invoices | Count of invoices by account executive |

## Approach

1. Loaded the six Excel files into MySQL.
2. Wrote SQL for each KPI. Brokerage and fees were combined with `UNION ALL`, so equal amounts are not collapsed into one row.
3. Converted text-formatted meeting dates with `STR_TO_DATE` so meetings could be grouped by year.
4. Built the dashboard in Excel (PivotTables, slicers) and in Tableau.
5. Reconciled the SQL totals against the Excel dashboard.

Example, placed amount for cross-sell:

```sql
SELECT SUM(amount) AS achieved_cross_sell
FROM (
    SELECT amount FROM brokerage WHERE income_class = 'cross sell'
    UNION ALL
    SELECT amount FROM fees      WHERE income_class = 'cross sell'
) AS combined_data;
```

## Results

| Business type | Target | Placed | Placed % | Invoiced | Invoiced % |
|---|---|---|---|---|---|
| Cross-sell | 20.08M | 13.04M | 64.94% | 2.85M | 14.21% |
| New | 19.67M | 3.53M | 17.95% | 0.57M | 2.90% |
| Renewal | 12.32M | 18.51M | 150.23% | 8.24M | 66.92% |

- Invoiced revenue is well below placed revenue in every category. New business is furthest from target.
- 49 opportunities in total, 44 open (42 Qualify, 2 Propose Solution) and 5 in Negotiate.
- 34 meetings: 3 in 2019 and 31 in 2020.
- The cause of the placed vs invoiced gap cannot be determined from this data.

## Validation

SQL results were compared with the Excel dashboard. The first comparison did not match: a filter written as `' renewal'` (with a leading space) was dropping renewal fee records. After correcting it to `'renewal'`, placed and invoiced totals matched for all three business types.

## Known limitations

- **Tableau workbook:** its figures do not yet match SQL and Excel. The New fees calculation uses the *Cross Sell* filter by mistake, and the tables are related through brokerage in a way that can distort totals. A fix is planned (see below).
- **Unclassified invoices:** 28 invoices (about 594K) have a blank income class, so they are not counted in any of the three categories.
- **Conversion ratio** (closed won / total opportunities) is defined in the KPI spec but is not implemented in the dashboards.
- Achievement percentages are calculated in Excel. The SQL produces target, placed and invoiced amounts.
- Data is sample data from a single branch.

## Planned improvements

- Correct the Tableau fee calculation and build each measure from its own table, then re-check against SQL.
- Add achievement percentages and conversion ratio in SQL.
- Group blank-income-class invoices as "Unclassified".
- Investigate the placed vs invoiced gap with billing data.

## Repository structure

```
.
├── data/        # six source Excel files
├── sql/         # MySQL queries for each KPI
├── excel/       # Excel dashboard workbook
├── tableau/     # Tableau packaged workbook (.twbx)
├── docs/        # KPI list and column descriptions
├── images/      # dashboard screenshots
└── README.md
```

## Tools

SQL (MySQL), Excel (PivotTables, Slicers), Tableau

## Author

**Karthik Pallamala**
[LinkedIn](https://www.linkedin.com/) | karthikpallamala074@gmail.com

