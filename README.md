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



### Next Steps
  - Delete Example folder
  - Create a folder named row
  - create a schema.yaml file

