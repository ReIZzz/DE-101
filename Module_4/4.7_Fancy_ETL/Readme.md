# Модуль 4.7: Fancy ETL

В рамках данного модуля:
- произведена локальная установка _Apache Airflow_ с базой данных _PostgreSQL_ и исполнителем задач _LocalExecutor_
- скачены исходные данные – файл [sample-super-store.xls](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.7_Fancy_ETL/data/sample-super-store.xls)
- сконвертирована, каждая страница книги _excel_, в отдельный файл формата _csv_ ([orders_.csv](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.7_Fancy_ETL/data/orders_.csv), [people_.csv](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.7_Fancy_ETL/data/people_.csv), [returns_.csv](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.7_Fancy_ETL/data/returns_.csv))
- данные загружены в локально развернутую БД _PostgreSQL_
- объединены данные в одну таблицу [orders_people_returns_joined.csv](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.7_Fancy_ETL/data/orders_people_returns_joined.csv)


## Общий вид DAGа на Airflow
Использованы оперторы ```Bash```, ```Python```, ```Postgres```

![Общий вид DAG](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.7_Fancy_ETL/img/dag_superstore_airflow.png)


## Код DAGа

```python
from airflow.models import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator

from airflow.utils.dates import days_ago

from datetime import timedelta
from datetime import datetime

import pandas as pd
import os


dag = DAG(
    "super_store",
    description='get_excel_data_convert_to_csv_load_to_postgres_db',
    start_date=days_ago(0, 0, 0, 0, 0)
)


# load data
download_data = BashOperator(
    bash_command="curl 'https://raw.githubusercontent.com/Data-Learn/data-engineering/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls'\
     --output /Users/ZN/Documents/GitHub/DE-101/Module_4/4.7_Fancy_ETL/Airflow/.venv/app/sample-super-store.xls",
    dag=dag,
    task_id='download_xls'
)


# convert 1st sheet of excel contains Orders to csv
def first_sheet_xls_to_csv(**kwargs):
    ti = kwargs['ti']

    df = pd.read_excel("sample-super-store.xls", sheet_name=0)
    print(df)
    orders_csv = df.to_csv("orders_sample-super-store.csv", index=False)

    ti.xcom_push(key='orders', value=orders_csv)


xls_orders_to_csv = PythonOperator(
    task_id='orders_csv',
    python_callable=first_sheet_xls_to_csv,
    dag=dag
)

# convert 2nd sheet of excel contains People to csv
def second_sheet_xls_to_csv(**kwargs):
    ti = kwargs['ti']

    df = pd.read_excel("sample-super-store.xls", sheet_name=1)
    people_row_count = df.shape[0]
    print('Row count is: ', people_row_count)
    people_csv = df.to_csv("people_sample-super-store.csv", index=False)

    ti.xcom_push(key='people', value=people_csv)
    ti.xcom_push(key='people_row_count', value=people_row_count)


xls_people_to_csv = PythonOperator(
    task_id='people_csv',
    python_callable=second_sheet_xls_to_csv,
    dag=dag
)


# convert 3th sheet of excel contains Returns to csv
def third_sheet_xls_to_csv():
    df = pd.read_excel("sample-super-store.xls", sheet_name=2)
    df.to_csv("returns_sample-super-store.csv", index=False)


xls_returns_to_csv = PythonOperator(
    task_id='returns_csv',
    python_callable=third_sheet_xls_to_csv,
    dag=dag
)


# merging all converted data to one table on key value
def orders_join_people_join_returns():
    df_1 = pd.read_csv("orders_sample-super-store.csv")
    df_2 = pd.read_csv("people_sample-super-store.csv")
    df_3 = pd.read_csv("returns_sample-super-store.csv")
    df_merge_1 = pd.merge(df_1, df_2, on="Region", how="inner")
    df_merge_2 = pd.merge(df_merge_1, df_3, on="Order ID", how="inner")
    df_merge_2.to_csv("orders_people_returns_joined.csv")


orders_people_returns_joined = PythonOperator(
    task_id='orders_people_returns_joined',
    python_callable=orders_join_people_join_returns,
    dag=dag
)


# creating an Orders table in the DB (schema Staging Postgresql)
create_orders_table = PostgresOperator(
    task_id='create_orders_table',
    postgres_conn_id='postgre_sql',
    sql="""
        CREATE TABLE IF NOT EXISTS stg_airflow.orders_airflow (
        id SERIAL PRIMARY KEY,
        order_row_id INTEGER,
        order_id VARCHAR NOT NULL,
        order_date DATE NOT NULL,
        ship_date DATE NOT NULL,
        ship_mode VARCHAR NOT NULL,
        customer_id VARCHAR NOT NULL,
        customer_name VARCHAR NOT NULL,
        segment VARCHAR NOT NULL,
        country VARCHAR NOT NULL,
        city VARCHAR NOT NULL,
        state VARCHAR NOT NULL,
        postal_code VARCHAR,
        region VARCHAR NOT NULL,
        product_id VARCHAR NOT NULL,
        category VARCHAR NOT NULL,
        sub_category VARCHAR NOT NULL,
        product_name VARCHAR NOT NULL,
        sales NUMERIC(9,4) NOT NULL,
        quantity INTEGER NOT NULL,
        discount NUMERIC(4,2) NOT NULL,
        profit NUMERIC(21,16) NOT NULL);
    """,
)


# loading data into Orders table (schema Staging Postgresql)
load_orders_data_to_db_stg = PostgresOperator(
    task_id='load_orders_data_to_db_stg',
    postgres_conn_id='postgre_sql',
    sql="""
        COPY stg_airflow.orders_airflow(order_row_id, order_id, order_date, ship_date, ship_mode, customer_id,\
        customer_name, segment, country, city, state, postal_code, region, product_id, category, sub_category,\
        product_name, sales, quantity, discount, profit)
        
        FROM '/Users/ZN/Documents/GitHub/DE-101/Module_4/4.7_Fancy_ETL/Airflow/.venv/app/orders_sample-super-store.csv'
        DELIMITER ','
        CSV HEADER;
    """,
)


# creating an People table in the DB (schema Staging Postgresql)
create_people_table = PostgresOperator(
    task_id='create_people_table',
    postgres_conn_id='postgre_sql',
    sql="""
        CREATE TABLE IF NOT EXISTS stg_airflow.people_airflow (
        id SERIAL PRIMARY KEY,
        person VARCHAR NOT NULL,
        region VARCHAR NOT NULL);
    """,
)


# loading data into People table (schema Staging Postgresql)
load_people_data_to_db_stg = PostgresOperator(
    task_id='load_people_data_to_db_stg',
    postgres_conn_id='postgre_sql',
    sql="""
        COPY stg_airflow.people_airflow(person, region)
        FROM '/Users/ZN/Documents/GitHub/DE-101/Module_4/4.7_Fancy_ETL/Airflow/.venv/app/people_sample-super-store.csv'
        DELIMITER ','
        CSV HEADER;
    """,
)


# creating an Returns table in the DB (schema Staging Postgresql)
create_returns_table = PostgresOperator(
    task_id='create_returns_table',
    postgres_conn_id='postgre_sql',
    sql="""
        CREATE TABLE IF NOT EXISTS stg_airflow.returns_airflow (
        id SERIAL PRIMARY KEY,
        returned VARCHAR NOT NULL,
        order_id VARCHAR NOT NULL);
    """,
)


# loading data into Returns table (schema Staging Postgresql)
load_returns_data_to_db_stg = PostgresOperator(
    task_id='load_returns_data_to_db_stg',
    postgres_conn_id='postgre_sql',
    sql="""
        COPY stg_airflow.returns_airflow(returned, order_id)
        FROM '/Users/ZN/Documents/GitHub/DE-101/Module_4/4.7_Fancy_ETL/Airflow/.venv/app/returns_sample-super-store.csv'
        DELIMITER ','
        CSV HEADER;
    """,
)


os.chdir("/Users/ZN/Documents/GitHub/DE-101/Module_4/4.7_Fancy_ETL/Airflow/.venv/app")


download_data >> [xls_orders_to_csv, xls_people_to_csv, xls_returns_to_csv] >> orders_people_returns_joined
xls_orders_to_csv >> create_orders_table >> load_orders_data_to_db_stg
xls_people_to_csv >> create_people_table >> load_people_data_to_db_stg
xls_returns_to_csv >> create_returns_table >> load_returns_data_to_db_stg

  ```
