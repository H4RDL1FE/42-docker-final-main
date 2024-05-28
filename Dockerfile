# Официальный образ Go в качестве базового
FROM golang:1.22

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем go.mod и go.sum, загружаем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем остальные файлы проекта в контейнер
COPY . .

# Сборка Go приложения
RUN go build -o /main .

# Используем образ Ubuntu для финального контейнера
FROM ubuntu:22.04

# Устанавливаем библиотеки
RUN apt-get update && apt-get install -y \
    libc6

# Копируем скомпилированное Go приложение из предыдущего контейнера
COPY --from=0 /main /main
COPY --from=0 /app/tracker.db /tracker.db

# Указываем порт, который будет слушать приложение
EXPOSE 8080

# Указываем команду запуска приложения
ENTRYPOINT ["/main"]