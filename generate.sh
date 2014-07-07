#!/bin/sh
# Script to generate the catalog.


function generatePDF {
#Index style
IST=btrpcc.ist

#Images in PDF format
mkdir -p latex/img
./make_images.sh pdf latex/img

#Generate the PDF
cd latex
pdflatex main
# go for the bibliography
bibtex main

# go for the index
makeindex -s $IST -o main.ind main.idx

#go for the latex again
pdflatex main
pdflatex main

cd -
mv latex/main.pdf $1    

#Clean useless files
rm -rf latex/*.log latex/*.aux latex/*.blg latex/*.ind latex/*.idx\
latex/*.toc latex/*.ilg latex/*.bbl latex/*.ind latex/*.out > /dev/null 
}

function generateHTML {
OUT=$1

mkdir -p $OUT

#Images
mkdir -p $OUT/img
./make_images.sh png $OUT/img

mkdir tmp
#tralics
cd latex
tralics -confdir ../tralics main.tex -output_dir ../tmp
cd -

#Copy the resources
cp tralics/style.css $OUT/
cp atom.xml $OUT/
cd $OUT
xsltproc --novalid ../tralics/html.xsl ../tmp/main.xml
cd -
#rm -rf tmp
}

if [ $# -eq 0 ]; then
    echo "Usage: $0 [--only-pdf | --only-html] output"
    echo "Generate the PDF and the HTML version of the catalog into the 'output' directory"
    echo "--only-pdf: to only generate the PDF version"
    echo "--only-html: to only generate the HTML version"
    exit 1
fi

#set -x
onlyPDF=0
onlyHTML=0
output=$1
if [ $1 = "--only-pdf" ]; then
    onlyPDF=1
    output=$2
elif [ $1 = "--only-html" ]; then
    onlyHTML=1
    output=$2
fi

cd latex
../makeInheritances.pl constraints/*.tex
cd -
if [ $onlyPDF -eq 1 ]; then
    generatePDF $output
elif [ $onlyHTML -eq 1 ]; then
    generateHTML $output
else
    generateHTML $output
    mkdir -p $output/pdf
    generatePDF $output/pdf/catalog-last.pdf
fi

