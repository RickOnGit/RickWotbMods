#install gum yq, set environment variables
#create structure like my mod and og data

dvpl_converter() {
    cd ~
    git clone https://github.com/Maddoxkkm/dvpl_converter.git
    cd dvpl_converter
    npm install
    sudo npm install -g
    cd ~
}

npm install -g cli-table3
