# Health Claims Governance Lab

## Project Overview
This project builds an end-to-end data pipeline on Databricks using synthetic health insurance data (members, providers, and claims). Data is cleaned and deduplicated through a medallion architecture (bronze, silver, and gold layers), with access governed by role.

## Data Model
Catalog: `atlas` — schemas: `bronze`, `silver`, `gold`

| Table | Rows (bronze) | Description |
|---|---|---|
| members | 10,000 | Insured members (demographics, plan, enrollment) |
| providers | 500 | Healthcare providers (specialty, location) |
| claims | 103,000 | Medical claims linked to members and providers (includes ~3% intentional duplicates) |

Data was generated with PySpark and Faker, with deliberate data quality issues to be fixed in the silver layer.

## Access Model
| Role | Bronze | Silver | Gold |
|---|---|---|---|
| Engineers | Read/Write + CREATE TABLE | Read/Write | Read/Write |
| Analysts | No access | Read only | Read only |
| Auditors | No access | Read only | Read only |

Evidence: `SHOW GRANTS` on each schema.

## Known Limitations
- Databricks Free Edition has no account console, so account groups cannot be created.
- Workaround: grants were applied at the user level using placeholder users (`engineers@email.com`, `analysts@email.com`, `auditors@email.com`) instead of groups.
- In a production workspace, these grants would be assigned to groups.
