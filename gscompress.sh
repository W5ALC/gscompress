#!/bin/bash -e
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program uses ghostscript to compress multiple .PDF files in the 
#current directory. Compressed .PDF files have same name as original
#file and saved to the "compressed" directory. Original .PDF files 
#are not modified or deleted.

#requirements: ghostscript

mkdir compressed -p
option=-1, dpi=-1

echo "Compression Options:
'1' - (prepress) Highest quality output (300 dpi) and larger file size
'2' - (optimal) High quality output (200 dpi) and moderate file size
'3' - (ebook) Medium quality output (150 dpi) and smaller file size
'4' - (screen) Lower quality output (72 dpi) and smallest possible size
'5' - (custom) User specified variable quality (1-300)
'6' - Exit/Quit"
echo " "

while [[ "$option" != @(1|2|3|4|5|6) ]]
do
    read -p "Enter a valid compression option: " option
done

if [[ "$option" == "1" ]]
    then
    dpi=300
elif [[ "$option" == "2" ]]
    then
    dpi=200
elif [[ "$option" == "3" ]]
    then
    dpi=150
elif [[ "$option" == "4" ]]
    then
    dpi=72
elif [[ "$option" == "5" ]]
    then
    while [[ "$dpi" -lt 0 ]] || [[ "$dpi" -gt 300 ]]
    do
        read -p "Enter dpi (0-300): " dpi
    done
else
    echo "Terminating program..."
    exit
fi

read -p "Continue compressing .PDF files using $dpi dpi? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

for i in ./*.pdf
do
    file=$i
    filename=${file%.pdf}
	pdffile="$filename.pdf"
	
	echo $pdffile
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dDownsampleColorImages=true -dColorImageResolution=$dpi -dNOPAUSE -dBATCH -sOutputFile=compressed/"$pdffile" "$pdffile"
done