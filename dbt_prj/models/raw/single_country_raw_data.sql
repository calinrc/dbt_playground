{{ config(
    materialized = 'table',
) }}


SELECT
    * EXCEPT (Dt_Customer),
    PARSE_DATE('%d-%m-%Y', Dt_Customer) as Dt_Customer,
FROM {{ source('marketing_campaign_source_%s' % var("single_country"), 'mar_camp') }}

