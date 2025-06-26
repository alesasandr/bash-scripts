#!/bin/bash

count_words() {
    local dir=$1
    local ext=$2
    local top_n=$3
    declare -A word_freq

    if [ ! -d "$dir" ]; then
        echo "Ошибка: Директория '$dir' не существует."
        exit 1
    fi

    while IFS= read -r file; do
        if [ ! -s "$file" ]; then
            echo "Пропущен пустой файл: $file"
            continue
        fi
        while IFS= read -r word; do
            if [ -z "$word" ]; then
                continue
            fi
            ((word_freq[$word]++))
        done < <(grep -ohE "[a-zA-Z0-9]+" "$file" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]')
    done < <(find "$dir" -type f -name "*.$ext")

    if [ ${#word_freq[@]} -eq 0 ]; then
        echo "Ошибка: Не найдено слов для обработки."
        exit 1
    fi

    for word in "${!word_freq[@]}"; do
        echo "$word: ${word_freq[$word]}"
    done | sort -t: -k2,2nr | head -n "$top_n"

}

if [ $# -ne 3 ]; then
    echo "Использование: $0 <директория> <расширение> <top_n>"
    exit 1
fi

count_words "$1" "$2" "$3"
