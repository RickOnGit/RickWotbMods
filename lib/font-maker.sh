#!/bin/bash

#Variables
wgdata="$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data"
mywotb="$HOME/$(whoami)_wotb_folder"

mkdir -p ../tmp/Fonts
elem=$(ls ../config/font | grep -E 'otf|ttf')

wotbfonts=(
    arialmb.ttf
    IwaGGoPro-Md.otf
    BadiyaLT-Bold.ttf
    NotoSans-Regular.ttf
    BadiyaLT-Regular.ttf
    NotoSans-SemiBold.ttf
    cinecav_x_ui.ttf
    SirichanaLT-Bold.ttf
    cinecav_x_ui_bold.ttf
    SirichanaLT-Regular.ttf
    CoreSans.ttf
    WarHeliosCondC.ttf
    HelveticaNeueWorld-45Lt.ttf
    WarHeliosCondCBold.ttf
    HelveticaNeueWorld-55Roman.ttf
    XinGothic-SC-W6.otf
    HelveticaNeueWorld-75Bold.ttf
    XinGothic-TC-W6.otf
    IwaGGoPro-Bd.otf
)

function copy() {
    echo "Creating Fonts..."
    for i in ${wotbfonts[@]}; do
        cp ../config/font/"$elem" ../tmp/Fonts/
        mv ../tmp/Fonts/"$elem" ../tmp/Fonts/$i
    done
}

function send() {
mkdir -p $mywotb
mv "$wgdata/Fonts" "$mywotb/"
mv ../tmp/Fonts "$wgdata"

echo "Font loaded!"
}

copy
send
