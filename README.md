# dbt_playground


## Tooling

- uv - [An extremely fast Python package and project manager, written in Rust.](https://github.com/astral-sh/uv)
  - Install:
    ```bash 
    brew install uv 
    # for alternative check https://github.com/astral-sh/uv
    ```
- gcloud - [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
- dbt - [DBT Core](https://github.com/dbt-labs/dbt-core)

  - Data Platform Connections
  - Amazon Redshift
  - Apache Spark
  - Azure Synapse
  - Databricks
  - Google BigQuery
  - Microsoft Fabric
  - PostgreSQL
  - Snowflake
  - Starburst or Trino



## Preparation Code

### Create Python project and environment

```bash
uv python list
uv python install cpython-3.11.12-macos-aarch64-none
uv python pin $HOME/.local/share/uv/python/cpython-3.11.12-macos-aarch64-none/bin/python3.11

uv venv

source .venv/bin/activate
uv init
```

### Authenticate in google cloud
```bash
  gcloud auth list
  gcloud auth login
  gcloud auth application-default login
```

### Add DBT for google as project dependency
```bash
uv add dbt-bigquery
uv add pandas
uv add --group dev sqlfluff yamllint isort black
#check dependencies
uv pip list
```

### initialize DBT projects (dbt_warehouse and dbt_prj)
```bash

dbt init
  # dbt project used -> dbt_warehouse
  # database used -> bigquery -> 1
  # authentication -> outsh -> 1
  # GCP Project -> playground-123
  # dataset ->  dbt_whouse
  # threads -> 1 (default)
  # job_execution_timeout_seconds -> 300 (default)
  # location -> EU

dbt init
  # dbt project used -> dbt_prj
  # database used -> bigquery -> 1
  # authentication -> outsh -> 1
  # GCP Project -> playground-123
  # dataset ->  playground_pydata
  # threads -> 1 (default)
  # job_execution_timeout_seconds -> 300 (default)
  # location -> EU

```

### Check newly created project dbt_warehouse and dbt_prj

### Simulate add static data in dbt_warehouse dataset

- Copy files in `dbt_warehouse/seeds` folder

```bash
cp ./data/marketing_campaign.csv ./dbt_warehouse/seeds/marketing_campaign_us.csv
cp ./data/marketing_campaign.csv ./dbt_warehouse/seeds/marketing_campaign_de.csv
cp ./data/marketing_campaign.csv ./dbt_warehouse/seeds/marketing_campaign_fr.csv

```

- Update `dbt_warehouse/dbt_project.yaml` seeds info with files column information

```yaml
seeds:
  dbt_warehouse:
    +enabled: true
    #    +schema: "temp"
    +column_types:
      ID: integer
      Year_Birth: integer
      Education: string
      Marital_Status: string
      Income: float
      Kidhome: integer
      Teenhome: integer
      Dt_Customer: string
      Recency: integer
      MntWines: integer
      MntFruits: integer
      MntMeatProducts: integer
      MntFishProducts: integer
      MntSweetProducts: integer
      MntGoldProds: integer
      NumDealsPurchases: integer
      NumWebPurchases: integer
      NumCatalogPurchases: integer
      NumStorePurchases: integer
      NumWebVisitsMonth: integer
      AcceptedCmp3: integer
      AcceptedCmp4: integer
      AcceptedCmp5: integer
      AcceptedCmp1: integer
      AcceptedCmp2: integer
      Complain: integer
      Z_CostContact: integer
      Z_Revenue: integer
      Response: integer
```
- Upload cvs file in BigQuery dataset using `dbt seeds` command

```bash
dbt dbt_warehouse
dbt seed --full-refresh
```

### Switch to dbt_prj
  - Create model raw folder with data from GCP data warehouse
     ```bash
    cd ../dbt_prj
    ```
  - Create a folder named row
  - create a schema.yaml file to point to "external" datasets
```yaml
---
version: 2

sources:
  - name: marketing_campaign_source_de
    description: 'DE Marketing campaign'
    database: 'playground-459513'
    schema: dbt_whouse
    loader: LOCAL_LOADER
    tags: ['source', 'de']
    tables:
      - name: mar_camp
        identifier: marketing_campaign_de

  - name: marketing_campaign_source_fr
    description: 'FR Marketing campaign'
    database: 'playground-459513'
    schema: dbt_whouse
    loader: LOCAL_LOADER
    tags: ['source', 'fr']
    tables:
      - name: mar_camp
        identifier: marketing_campaign_fr

  - name: marketing_campaign_source_us
    description: 'US Marketing campaign'
    database: 'playground-459513'
    schema: dbt_whouse
    loader: LOCAL_LOADER
    tags: ['source', 'us']
    tables:
      - name: mar_camp
        identifier: marketing_campaign_us
```
- create a row model file `country_raw_data.sql` pointing to data source
```sql
{{ config(
    materialized = 'table',
) }}


SELECT
    * EXCEPT (Dt_Customer),
    PARSE_DATE('%d-%m-%Y', Dt_Customer) as Dt_Customer,
    "{{ var("country") }}" AS Country
FROM {{ source('marketing_campaign_source_%s' % var("country"), 'mar_camp') }}
```
- create a staging transformation using previous generated table `country_raw_data`
- change materialization  to view 
```sql
{{ config(
    materialized = 'view',
) }}


SELECT MAX(Dt_Customer) AS Max_Dt_Customer
FROM {{ ref('country_raw_data') }}
```

### Switch to a more complex example

### DBT run specifying target (e.g. dev, pp, prod)
Note: profiles definition reside in `profiles.yaml`
```bash
dbt seed --target=prod
dbt run --full-refresh --target prod
```

### Use specific parameters for partial execution (all ancestors)

```bash
dbt run --vars '{country: fr}'  --select +stg_lambda_transf
```


### Use specific parameters for partial execution (all descendants - check DBT Graph operators) and exclude row model

```bash
dbt run --vars '{country: fr}'  --select stg_lambda_transf+ --exclude transform
```

### Generate documentation
```bash

dbt docs generate --vars '{country: fr}'
dbt docs serve --vars '{country: fr}'
```


### Code Formating Tools
- [Black Tool](https://github.com/psf/black)

```bash
   black  ./
```

### Imports organization Tools
- [Isort Tool](https://pycqa.github.io/isort/)

```bash
   isort  ./
```

### SQL Linter Tools
- uses `sqlfluff` configured for `dialect: bigquery` and `templater:dbt` to parse the SQL queries

- [SQLFluff Tool](https://github.com/sqlfluff/sqlfluff)
- [SQL Fluff Documentation](https://docs.sqlfluff.com/en/stable/gettingstarted.html)
- [SQL Fluff DBT Documentation](https://docs.sqlfluff.com/en/stable/configuration.html#dbt-project-configuration)

```bash
   sqlfluff fix -vv  ./
```

### Yaml Linter Tools
- [Yaml Tool](https://github.com/adrienverge/yamllint)

```bash
  cd dbt
  yamllint .github
```


## Data Sources

- https://www.kaggle.com/code/karnikakapoor/customer-segmentation-clustering/data
- https://www.kaggle.com/code/karnikakapoor/customer-segmentation-clustering/notebook
- https://thecleverprogrammer.com/2021/02/08/customer-personality-analysis-with-python/

