# FROM apache/airflow:2.7.2-python3.11

# USER root

# # Устанавливаем Python-зависимости
# COPY requirements.txt /requirements.txt
# RUN pip install --no-cache-dir -r /requirements.txt

# USER airflow
FROM apache/airflow:2.7.2-python3.11

# Копируем requirements
COPY requirements.txt .

# Устанавливаем пакеты через официальный скрипт Airflow
USER airflow
RUN pip install --no-cache-dir -r requirements.txt
