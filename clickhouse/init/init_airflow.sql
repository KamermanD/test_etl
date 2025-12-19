CREATE DATABASE IF NOT EXISTS bank_dwh;

CREATE USER IF NOT EXISTS airflow IDENTIFIED BY 'airflow_password';

GRANT ALL ON bank_dwh.* TO airflow;

-- Если нужно создать таблицу сразу
CREATE TABLE IF NOT EXISTS bank_dwh.ctl_monitoring
(
    metric String,
    value String,
    labels String
) ENGINE = MergeTree()
ORDER BY metric;

