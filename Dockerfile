# Используйте базовый образ Node.js
FROM node:18

RUN apt-get update && apt-get install -y libnss3 && apt-get install chromium-browser

# Создайте рабочую директорию
WORKDIR /app

# Скопируйте зависимости
COPY package.json package-lock.json /app/

# Установите зависимости
RUN npm install

# Скопируйте исходный код
COPY . /app/

# Откройте порт 3000
EXPOSE 3000

# Запустите сервер
CMD ["node", "server.js"]