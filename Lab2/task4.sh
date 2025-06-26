#!/bin/bash

# Проверка параметров
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Использование: $0 <путь_к_директории> <путь_к_папке_резервных_копий>"
  exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
ARCHIVE_NAME="backup_$DATE.tar.gz"


# Проверка, что исходная директория существует
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Ошибка: Директория $SOURCE_DIR не существует."
  exit 1
fi

# Проверка, что директория для резервных копий существует, если нет, создать ее
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
  echo "Создана директория для резервных копий: $BACKUP_DIR"
fi

# Создание архива со всем содержимым директории
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$SOURCE_DIR" .

# Проверка успеха
if [ $? -eq 0 ]; then
  echo "Резервная копия успешно создана: $BACKUP_DIR/$ARCHIVE_NAME"
else
  echo "Ошибка при создании резервной копии."
  exit 1
fi

# Удаление архивов старше 7 дней
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +7 -exec rm -f {} \;
echo "Удалены старые архивы старше 7 дней."

