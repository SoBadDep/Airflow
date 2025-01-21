# Базовый образ
FROM python:3.8-slim-buster

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        libsasl2-dev \
        ldap-utils \
        python3-pip \
        && \
    rm -rf /var/lib/apt/lists/*

# Копирование файлов конфигурации
COPY airflow.cfg /etc/airflow/

# Создание директории для хранения данных
RUN mkdir -p /data

# Настройка пользователя
ARG AIRFLOW_UID=50000
ENV AIRFLOW_USER airflow
RUN useradd -ms /bin/bash -u $AIRFLOW_UID $AIRFLOW_USER
USER $AIRFLOW_USER
WORKDIR /home/$AIRFLOW_USER

# Установка Airflow
RUN pip install apache-airflow[all]

# Запуск контейнера
CMD ["airflow", "webserver"]
