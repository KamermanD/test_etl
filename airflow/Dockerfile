FROM apache/airflow:2.7.2-python3.11

USER root

# Устанавливаем Python-зависимости
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

USER airflow
