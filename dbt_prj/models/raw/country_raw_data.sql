{{ config(
    materialized = 'table',
) }}


SELECT
    * EXCEPT (Dt_Customer),
    PARSE_DATE('%d-%m-%Y', Dt_Customer) as Dt_Customer,
    "{{ var("country") }}" AS Country
FROM {{ source('marketing_campaign_source_%s' % var("country"), 'mar_camp') }}

