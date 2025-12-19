<!-- # Bank DWH — учебный Data Warehouse с CDC, dbt и Airflow

## 1. Цель проекта

Цель проекта — построить учебный Data Warehouse (DWH) для банковских данных с использованием современных инструментов Data Engineering:

- реального PostgreSQL как источника данных (OLTP),
- Change Data Capture (CDC) через Debezium и Kafka,
- аналитического хранилища ClickHouse,
- трансформаций данных с помощью dbt,
- оркестрации пайплайнов через Apache Airflow.

Проект реализован в учебных целях и демонстрирует полный цикл построения DWH: от источника данных до аналитических метрик.

---

## 2. Архитектура решения


PostgreSQL (OLTP, источник данных)
|
| CDC (WAL)
v
Debezium
|
v
Kafka (topics per table)
|
v
ClickHouse (RAW layer)
|
| dbt (incremental + snapshots)
v
ClickHouse (ODS layer)
|
v
Аналитические метрики



Airflow используется для:
- оркестрации загрузок,
- запуска dbt моделей,
- мониторинга CDC.

---

## 3. Используемые технологии

| Компонент     | Назначение |
|---------------|-----------|
| PostgreSQL    | OLTP-источник данных |
| Debezium      | Захват изменений (CDC) |
| Kafka         | Транспорт CDC-событий |
| ClickHouse    | Аналитическое хранилище |
| dbt           | SQL-трансформации |
| Airflow       | Оркестрация |
| Docker Compose| Локальное развёртывание |

---

## 4. Структура проекта

bank_dwh/
├── docker-compose.yml
├── .env
├── README.md
│
├── debezium/
│ └── connectors/
│ ├── customer.json
│ ├── account.json
│ ├── card.json
│ └── transaction.json
│
├── airflow/
│ ├── Dockerfile
│ ├── requirements.txt
│ └── dags/
│ ├── pg_to_ch_dbt_incremental_dwh.py
│ ├── cdc_to_dwh.py
│ └── cdc_monitoring.py
│
├── dbt/
│ ├── dbt_project.yml
│ ├── profiles.yml
│ ├── models/
│ │ ├── stg/
│ │ ├── raw/
│ │ └── ods/
│ ├── snapshots/
│ │ ├── snap_account.sql
│ │ └── snap_card.sql
│ └── macros/
│ └── scd2.sql
│
├── clickhouse/
│ ├── Dockerfile
│ └── init/
│ ├── 01_stg.sql
│ ├── 02_raw.sql
│ └── 03_ods.sql
│
└── docs/
├── architecture.md
├── data_flow.md
└── metrics.md


---

## 5. Источник данных (PostgreSQL)

Используется реальная учебная база данных PostgreSQL, предоставленная преподавателем.

Основные таблицы источника:
- `customer`
- `account`
- `card`
- `terminal`
- `transaction`

Подключение осуществляется по SSL.  
PostgreSQL используется **только как источник**, данные из него не изменяются.

---

## 6. CDC (Change Data Capture)

### Зачем нужен CDC

CDC позволяет:
- получать только изменения, а не полные таблицы,
- обрабатывать INSERT / UPDATE / DELETE,
- сохранять историю изменений.

### Реализация CDC

- Debezium читает WAL PostgreSQL
- Для каждой таблицы создаётся Kafka topic
- Формат событий — JSON
- События затем загружаются в RAW слой ClickHouse

Используемые топики Kafka:
- `customer`
- `account`
- `card`
- `transaction`

---

## 7. Слои DWH

### STG (Staging)

- Зеркало источника
- Минимальные преобразования
- Используется для первичной загрузки из PostgreSQL

### RAW

- Сырые данные
- Append-only
- Добавляется техническое поле `loaded_at`
- Используется как источник для SCD2 и фактов

### ODS

- Подготовленные аналитические таблицы
- Размерности и факты
- Используются для расчёта метрик

---

## 8. Snapshot и Incremental

### Snapshot (dbt snapshots)

Используется для медленно меняющихся измерений (SCD2).

Позволяет:
- отслеживать изменения атрибутов,
- хранить историю значений,
- знать, какие значения были актуальны в конкретный момент времени.

Snapshot реализован для:
- `account`
- `card`

Почему именно они:
- у счетов и карт меняются статусы, лимиты, сроки,
- это критично для аналитики.

---

### Incremental (dbt incremental models)

Используется для:
- фактов транзакций,
- загрузки только новых записей,
- уменьшения нагрузки на систему.

Работает по монотонно растущему ключу `txn_id`.

---

## 9. SCD2 (Slowly Changing Dimension Type 2)

SCD2 позволяет хранить историю изменений размерностей.

Пример структуры:


Реализация:
- dbt snapshots
- стратегия `check`
- собственный макрос SCD2

---

## 10. dbt

dbt используется для:

- STG → RAW
- RAW → ODS
- Snapshot (SCD2)
- Подготовки витрин под аналитические метрики

### Макрос SCD2

```sql
{% macro scd2_snapshot(unique_key, updated_at, tracked_columns) %}
{{
    config(
        unique_key=unique_key,
        strategy='check',
        check_cols=tracked_columns,
        updated_at=updated_at,
        invalidate_hard_deletes=True
    )
}}
{% endmacro %} -->

# Bank DWH — учебный проект по подсчету метрик

## Цель проекта
Проект создан исключительно для **подсчета ключевых метрик банковских данных**:
1. Количество транзакций по клиенту (`customer_id`)
2. Сумма транзакций по карте (`card_id`)
3. Количество активных счетов по городу (`city`)

---

## Что делает проект
- Получает данные из PostgreSQL (OLTP)  
- Отслеживает изменения через **CDC (Debezium + Kafka)**  
- Сохраняет данные и историю изменений в **ClickHouse**  
- Применяет трансформации через **dbt** (STG → RAW → ODS)  
- Оркестрирует процессы и мониторит коннекторы через **Airflow**

---

## Используемые технологии
- PostgreSQL — источник данных  
- Debezium + Kafka — CDC (отслеживание изменений)  
- ClickHouse — аналитическое хранилище  
- dbt — трансформации и SCD2  
- Airflow — DAG-и и мониторинг процессов  
- Docker Compose — локальное развертывание всех сервисов  

---

## Как запускать
1. Создать `.env` с параметрами подключения к PostgreSQL и ClickHouse.
2. Запустить все сервисы:
```bash
docker-compose up -d

Airflow доступен на http://localhost:8080

Debezium автоматически подключает коннекторы для таблиц customer, account, card, transaction.

DAG-и:

pg_to_ch_dbt_incremental_dwh — первичная загрузка и трансформации

cdc_to_dwh — обработка CDC и обновление ODS

cdc_monitoring — мониторинг Debezium и Kafka lag

Проект полностью построен вокруг расчета указанных метрик, других функций или аналитики не реализует.