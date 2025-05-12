# import pandas as pd
from dbt.cli.main import dbtRunner, dbtRunnerResult
import logging
from pathlib import Path

logger = logging.getLogger(__file__)

def params_to_dbt(country:str, execution_id:str) -> str:
    return f"""{{
    id: {execution_id},
    country: {country},
    }}"""

def main():
    print("Hello from dbt-playground!")
    TARGET = "dev"
    dbt_runner = dbtRunner()
    local_path = Path(__file__)
    base_path = local_path.parent
    dbt_params = params_to_dbt()

    dbt_args_extra = [
        "--select",
        "+stg_lambda_transf",
    ]

    dbt_args = [
                   "run",
                   "--target",
                   f"{TARGET}",
                   "--vars",
                   f"{dbt_params}",
                   "--project-dir",
                   f"{base_path}/dbt_prj",
                   "--profiles-dir",
                   f"{base_path}/dbt_prj",
                   "--log-level",
                   "debug",
               ] + dbt_args_extra
    args_str = " ".join(dbt_args)
    logger.info(f"Running DBT base_plg with arguments: {args_str}")
    try:
        res: dbtRunnerResult = dbt_runner.invoke(dbt_args)
        logger.info(str(res))
        error_msg = []
        if res.result is not None:
            for r in res.result:
                logger.info(f"{r.node.name}: {r.status}")
                from dbt.contracts.results import RunStatus

                if r.status == RunStatus.Error:
                    logger.error(f"Fail on running DBT stage {r.node.name}")
                    error_msg.append(f"Node {r.node.name}: Failure reason: {r.message}")
            if len(error_msg) > 0:
                raise Exception(f"DBT Stages Failures: {error_msg}")
        elif res.exception is not None:
            str_args = " ".join(dbt_args_extra)
            logger.error(f"Fail on running DBT stage using dbt_args_extra={str_args}")
            logger.exception(res.exception)
            raise res.exception
    except Exception as ex:
        str_args = " ".join(dbt_args_extra)
        logger.error(f"Fail on running DBT stage using dbt_args_extra={str_args}")
        logger.exception(ex)
        raise ex

if __name__ == "__main__":
    logging.basicConfig(format="%(asctime)s:%(name)s - %(message)s",  level=logging.DEBUG, datefmt="%H:%M:%S")
    logging.debug("Hello world")

    main()
