FROM oraclelinux:7-slim

RUN yum -y install oracle-nodejs-release-el7 oracle-instantclient-release-el7 wget unzip && \
    yum-config-manager --disable ol7_developer_nodejs\* && \
    yum-config-manager --enable ol7_developer_nodejs16 && \
    yum-config-manager --enable ol7_optional_latest && \
    yum -y install nodejs node-oracledb-node16 && \
    rm -rf /var/cache/yum/*

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum install -y google-chrome-stable_current_x86_64.rpm

# Создайте рабочую директорию
WORKDIR /app

# Скопируйте зависимости
COPY package.json package-lock.json /app/

# Установите зависимости
RUN npm install

# Скопируйте исходный код
COPY server.js /app/

# Откройте порт 3000
EXPOSE 3000

# Запустите сервер
CMD ["node", "server.js"]