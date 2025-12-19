# Поток данных (Data Flow)

## Основные сценарии загрузки

### 1. Snapshot / Incremental (batch)


- Snapshot используется для начальной загрузки
- Incremental — для регулярных обновлений
- STG всегда перезагружается целиком

---

### 2. CDC (near-real-time)


- Debezium читает WAL Postgres
- Kafka хранит события изменений
- Airflow управляет применением CDC в DWH

---

## SCD2

SCD2 применяется для:
- счетов (account)
- карт (card)

Причина:
- меняется статус
- важно хранить историю

Поля SCD2:
- _valid_from
- _valid_to
- _is_current
