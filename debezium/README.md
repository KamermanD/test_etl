# Debezium CDC

Этот каталог содержит конфигурации коннекторов Debezium для наших таблиц банка:

- `customer.json` — отслеживает изменения в таблице клиентов.
- `account.json` — отслеживает изменения в таблице счетов.
- `card.json` — отслеживает изменения в таблице карт.
- `transaction.json` — отслеживает изменения в таблице транзакций.

## Запуск

1. Убедитесь, что Kafka и Zookeeper запущены через `docker-compose`.
2. Запустите Debezium:
   ```bash
   docker-compose up -d debezium
