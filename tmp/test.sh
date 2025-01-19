#!/bin/bash

source ../lib/var.env

tier=$(echo -e "$tiers" | gum choose --header="Choose a tier")

tank=$(yq -r ".[] | select(.tier == \"$tier\") | \"\(.name) (\(.nation)) (\(.type))\"" "$tanksfile" | gum choose --header="Filtered elements for tier: $tier")

nation=$(echo -e "$nations" | gum choose --header="Choose a nation")

tank=$(yq -r ".[] | select(.nation == \"$nation\")" "$tanksfile" | gum choose --header="Filtered elements for nation: $nation")

type=$(echo -e "$type" | gum choose --header="Choose a type of tank")

tank=$(yq -r ".[] | select(.type == \"$type\") | \"\(.name) (\(.tier)) (\(.nation))\"" "$tanksfile" | gum choose --header="Filtered elements for type: $type")