{{ config(
    materialized = 'table',
) }}


WITH last_seen_date AS (
    SELECT MAX(Dt_Customer) AS Max_Dt_Customer
    FROM {{ ref('country_raw_data') }}
)


SELECT
    acrd.*,
    DATE_DIFF(Max_Dt_Customer, Dt_Customer, DAY) AS Customer_For,
    2025 - Year_Birth AS Age,
    MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntGoldProds AS Spent,
    NumDealsPurchases + NumWebPurchases + NumCatalogPurchases + NumStorePurchases AS Purchases,
    Kidhome + Teenhome AS Children,
    AcceptedCmp5 + AcceptedCmp4 + AcceptedCmp3 + AcceptedCmp2 + AcceptedCmp1 AS Campaigns

FROM {{ ref('country_raw_data') }} AS acrd
CROSS JOIN last_seen_date
