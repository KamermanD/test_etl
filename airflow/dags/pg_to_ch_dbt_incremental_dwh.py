import pendulum
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import psycopg2
from clickhouse_driver import Client as CHClient

import os
from psycopg2.extras import DictCursor

# ENV
PG_HOST = os.getenv("PG_HOST", "localhost")
PG_PORT = int(os.getenv("PG_PORT", "5432"))
PG_DB   = os.getenv("PG_DB", "bank_src")
PG_USER = os.getenv("PG_USER", "bank")
PG_PASS = os.getenv("PG_PASS", "bank")

CH_HOST = os.getenv("CH_HOST", "clickhouse")
CH_PORT = int(os.getenv("CH_PORT", "9000"))
CH_USER = os.getenv("CH_USER", "airflow")
CH_PASS = os.getenv("CH_PASS", "airflow")

def pg_conn():
    return psycopg2.connect(host=PG_HOST, port=PG_PORT, dbname=PG_DB, user=PG_USER, password=PG_PASS)

def ch_client():
    return CHClient(host=CH_HOST, port=CH_PORT, user=CH_USER, password=CH_PASS, database="bank_dwh")

def load_stg_from_pg():
    pg = pg_conn()
    ch = ch_client()
    
    tables = ["customer", "account", "card", "terminal", "transaction"]
    for t in tables:
        with pg.cursor(cursor_factory=DictCursor) as cur:
            cur.execute(f"SELECT * FROM bank.{t}")
            rows = cur.fetchall()

        stg_table = f"stg_{t}"
        ch.execute(f"TRUNCATE TABLE bank_dwh.{stg_table}")
        if rows:
            cols = rows[0].keys()
            values = [tuple(r[col] for col in cols) for r in rows]
            placeholders = ", ".join(["%s"] * len(cols))
            ch.execute(f"INSERT INTO bank_dwh.{stg_table} ({','.join(cols)}) VALUES", values)

    pg.close()

with DAG(
    dag_id="pg_to_ch_dbt_incremental_dwh",
    start_date=pendulum.datetime(2025,1,1,tz="UTC"),
    schedule_interval="*/20 * * * *",
    catchup=False,
    max_active_runs=1,
    tags=["dbt","postgres","clickhouse"],
) as dag:

    load_stg = PythonOperator(
        task_id="load_stg_from_pg",
        python_callable=load_stg_from_pg
    )

    dbt_run = BashOperator(
        task_id="dbt_run_raw_ods",
        bash_command="cd /opt/airflow/dbt && dbt run --select path:models/raw path:models/ods"
    )

    load_stg >> dbt_run
