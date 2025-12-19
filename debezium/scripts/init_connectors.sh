#!/bin/bash
set -e

DEBEZIUM_HOST=${DEBEZIUM_HOST:-"debezium"}
DEBEZIUM_PORT=${DEBEZIUM_PORT:-8083}
CONNECTORS_DIR="/connectors"

echo "=== Проверка и подключение коннекторов Debezium ==="

for file in $CONNECTORS_DIR/*.json; do
    connector_name=$(basename "$file" .json)
    echo "Подключаем коннектор: $connector_name"

    # Проверяем, существует ли уже коннектор
    status_code=$(curl -s -o /dev/null -w "%{http_code}" http://$DEBEZIUM_HOST:$DEBEZIUM_PORT/connectors/$connector_name)
    
    if [ "$status_code" -eq 404 ]; then
        echo "Коннектор $connector_name не найден, создаем..."
        curl -X POST -H "Content-Type: application/json" --data @"$file" http://$DEBEZIUM_HOST:$DEBEZIUM_PORT/connectors
        echo "Коннектор $connector_name создан."
    else
        echo "Коннектор $connector_name уже существует, пропускаем."
    fi
done

echo "=== Все коннекторы подключены ==="
