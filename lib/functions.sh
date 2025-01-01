selector() {
    local category="$1"
    string=""
    case "$category" in
        "Sounds🔊"|"Hangars🛖")
            arg1=$(yq "."$category" | keys | .[]" ../config/mods.yaml | gum choose)
            string="$category.$arg1"
            get_links "$string"
            ;;
        "Tanks🚜")
            arg1=$(yq "."$category" | keys | .[]" ../config/mods.yaml | gum choose)
            arg2=$(yq "."$category"."$arg1" | keys | .[]" ../config/mods.yaml | gum choose) 
            arg3=$(yq "."$category"."$arg1"."$arg2" | keys | .[]" ../config/mods.yaml | gum choose)
            arg4=$(yq "."$category"."$arg1"."$arg2"."$arg3" | keys | .[]" ../config/mods.yaml | gum choose)
            string="$category.$arg1.$arg2.$arg3.$arg4"
            get_links "$string"
            ;;
        *)
            get_links "$category"
    esac
}

get_links() {
    local string="$1"

    remodels=()
    local choosen=$(yq ".$string | keys | .[]" ../config/mods.yaml | gum choose --no-limit --ordered)
    mapfile -t remodels <<< "$choosen" 

    links=()
    sources=()

    for elem in "${remodels[@]}"; do
        links+=("$(yq ".$string.$elem.download" ../config/mods.yaml)")
        sources+=("$(yq ".$string.$elem.source" ../config/mods.yaml)")
    done
    
    print_info
}

print_info() {
    echo "Remodel selected,Take a look at the remodel 👇" > ../tmp/temp_info.csv
    for i in ${!links[@]}; do
        model="${remodels[$i]}"
        source="${sources[$i]}"
        echo "$model,$source" >> ../tmp/temp_info.csv
    done
    column -t -s "," < ../tmp/temp_info.csv
}





