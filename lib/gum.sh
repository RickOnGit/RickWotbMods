welcome_logo="
   ┳┓• ┓ ┓ ┏   ┓ ┳┳┓   ┓    
   ┣┫┓┏┃┏┃┃┃┏┓╋┣┓┃┃┃┏┓┏┫┏   
   ┛┗┗┗┛┗┗┻┛┗┛┗┗┛┛ ┗┗┛┗┻┛   
   "
avaiable_logo="
         •  ┓ ┓          ┓    
   ┏┓┓┏┏┓┓┏┓┣┓┃┏┓  ┏┳┓┏┓┏┫┏   
   ┗┻┗┛┗┻┗┗┻┗┛┗┗   ┛┗┗┗┛┗┻┛   
   "

function welcome() {
   #local version="$1"
   clear
   show_version=$(gum format -- "- Game version: *"x-x-x"*")
   author=$(gum format -- "- A script by: *thatmfrick*  ")
   info=$(gum join --vertical "$show_version" "$author")
   total=$(gum join --vertical --align="center" "$welcome_logo" "$info")
   gum style --border="rounded" "$total"
}

function show_info() {
   clear
   local category="$1"
   local file="$2"
   list=$(yq ".[] | select(.name == \"$category\") | .remodels[] | select(.name != \"Stock\" and .name != \"Go Back 👈\") | \"🟠 \(.name) 👉 \(.source // \\\"N/A\\\")\"" "$file")

   var1=$(gum style --border="rounded" --align="center" "$avaiable_logo")
   var2=$(gum style --border="rounded" --align="center" "$list")

   gum join --vertical --align="center" "$var1" "$var2"
}
