#!/bin/sh
#Script to convert the images in SVG into either PNG or PDF

source config.sh


if [ ! -e $INKSCAPE ]; then
    echo "\$INKSCAPE do not point to the inkscape executable.\nPlease update 'config.sh accordingly"
    exit 1
fi
echo "Inkscape path from 'config.sh':\n\t$INKSCAPE"

if [ $# -ne 2 ]; then
    echo "Usage: $0 [pdf|png] output"
    echo "Convert the images into the PDF or the PNG format. Files are stored into 'output'"
    exit 1
fi

fmt=$1
out=$2

if [ ! -d $out ]; then
    mkdir -p $out > /dev/null
fi

case $fmt in
pdf|PDF)
	flag="-A"
	;;
png|PNG)
	flag="-e"
	;;
*)
	echo "Unknown output '$fmt'"
	exit 1
esac
#List every svg files
for i in `ls svg/*.svg`; do
    name=`basename $i .svg`
    output=$out/$name.$fmt
    if [ ! -e $output ]; then
	echo "$name: added"
	$INKSCAPE -f $i $flag $output
    elif [ $i -nt $output ]; then
	echo "$name: updated"
	$INKSCAPE -f $i $flag $output
    else
	echo "$name: ignored"
    fi
done


