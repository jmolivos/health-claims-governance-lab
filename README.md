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

## Evidence

![Catalog Explorer](docs/images/catalog-explorer.png)

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

## Repository Structure

| Path | Description |
|---|---|
| `notebooks/ATL-01_Create_Catalog_and_Schemas.ipynb` | Creates the `atlas` catalog and the bronze/silver/gold schemas (ATL-01) |
| `notebooks/ATL-02_Create_Data_Raw.ipynb` | Generates synthetic data with PySpark/Faker and loads it to bronze (ATL-02) |
| `sql/ATL-03_Grant_Permissions.dbquery.ipynb` | User-level grants per layer (ATL-03) |
| `sql/ATL-05_Create_silver_claims.dbquery.ipynb` | Silver claims: flag duplicates instead of deleting (ATL-05) |
| `sql/ATL-06_Column_mask_silver_members.dbquery.ipynb` | Silver members: mask sensitive information (ATL-06) |
| `docs/images/` | Evidence screenshots |

## Column Masking (ATL-06)

Sensitive member data in `atlas.silver.members` is protected with Unity Catalog column masks.

| Column | Masked | Masked value | Reason |
|---|---|---|---|
| member_id | No | — | Needed to join with claims |
| national_id | Yes | `*****` + last 3 characters | Personal identifier |
| birth_date | Yes | `NULL` | Personal data |
| gender | No | — | Needed for health reporting |
| region | No | — | Needed for health reporting |

**How it works:** each mask is a SQL function that checks `current_user()`.
Authorized users (engineers) see the real value; everyone else sees the masked value.

**Functions:** `atlas.silver.mask_national_id`, `atlas.silver.mask_birth_date`

**Limitation:** Databricks Free Edition does not support account groups, so the masks
check individual user emails instead of group membership (e.g. `is_account_group_member()`).

**Evidence:** masked query results with an unauthorized user.
![Catalog Explorer](docs/images/silver_members_mask.png)

SQL: `sql/ATL-06_Column_mask_silver_members.dbquery.ipynb`


