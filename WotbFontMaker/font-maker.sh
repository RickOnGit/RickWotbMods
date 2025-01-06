#!/bin/bash

#Variables
wgdata="$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data"

mkdir -p Fonts
elem=$(ls ./font | grep -E 'otf|ttf')

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
    echo "coping..."
    for i in ${wotbfonts[@]}; do
        cp font/"$elem" Fonts/
        mv Fonts/"$elem" Fonts/$i
    done
}

function compress() {
    echo "compressing..."
    cd Fonts
    dvpl compress &>/dev/null
    cd ..
}

function send() {

rsync -a Fonts "$wgdata"
echo "Font loaded!"
}

copy
compress
send
