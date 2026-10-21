CREATE OR REPLACE TABLE atlas.silver.claims AS
SELECT 
    claim_id, member_id, provider_id, service_date, billing_date, icd10_code, amount, status,
    CASE WHEN rn=1 THEN false ELSE true END AS is_duplicate,
    CASE WHEN rn!=1 THEN 'resubmission' END AS dedupe_reason
FROM (
    SELECT cl.*, 
    row_number() OVER (PARTITION BY member_id, provider_id, service_date, amount ORDER BY billing_date ASC) rn 
    FROM atlas.bronze.claims cl
    );


SELECT COUNT(*) FROM atlas.bronze.claims;
SELECT is_duplicate, COUNT(*) FROM atlas.silver.claims GROUP BY is_duplicate;
