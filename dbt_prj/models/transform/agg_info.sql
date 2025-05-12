{{ config(
    materialized = 'table',
) }}

SELECT
    ID,
    Customer_For,
    Age,
    Spent,
    Purchases,
    AvgSpentPPurchase,
    Children,
    Marital_Status_Mapping AS Living_With,
    CASE
        WHEN Marital_Status_Mapping = 'Alone' THEN Children + 1
        ELSE Children + 2
    END AS Family_Size,
    Campaigns,
    Is_Parent
FROM {{ ref('stg_transf_step_2') }} AS sts2

INNER JOIN {{ ref('marital_status') }} AS ms ON ms.Marital_Status = sts2.Marital_Status
