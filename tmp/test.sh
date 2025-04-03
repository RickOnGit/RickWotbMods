#!/bin/bash

# Imposta la stringa di input
input="BZ-75, Divine Valor"
IFS=','

# Leggi gli elementi in un array
read -ra elements <<< "$input"

# Stampa gli elementi rimuovendo gli spazi
for element in "${elements[@]}"; do
    # Usa 'xargs' per rimuovere gli spazi all'inizio e alla fine
    trimmed_element=$(echo "$element" | xargs)
    echo "$trimmed_element"
done
