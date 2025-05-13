{{ config(
    materialized = 'view',
) }}

SELECT
    slt.*,
    CASE
        WHEN Purchases > 0 THEN Spent / Purchases
        ELSE 0
    END AS AvgSpentPPurchase,
    CASE
        WHEN Children > 0 THEN 1
        ELSE 0
    END AS Is_Parent

FROM {{ ref('stg_lambda_transf') }} AS slt
