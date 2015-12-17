#!/usr/bin/env bash

function output {
  echo -e "\033[1;95m$1\033[0m	$2"
}

set -e

jobname=`uuidgen`
scriptpath=/opt/laulik
projectpath=$scriptpath/data/projects/voluja.yaml
buildpath=$scriptpath/build/$jobname

mkdir -p $buildpath
cd $buildpath

python $scriptpath/laulik.py $projectpath $buildpath
output "[main] Running lilypond-book"
/opt/lilypond/bin/lilypond-book -V laulik.lytex
output "[main] First latex pass"
latex -interaction=nonstopmode laulik.tex
output "[main] Running xindy to generate index"
xindy -M numeric-sort -M latex-loc-fmts -I latex -L estonian -t ex1.xlg -M $scriptpath/laulik.xdy laulik.idx
output "[main] Second latex pass"
latex -interaction=nonstopmode laulik.tex
output "[main] Running dvips"
dvips laulik.dvi
output "[main] Running ps2pdf"
ps2pdf \
  -dMaxSubsetPct=100 \
  -dCompatibilityLevel=1.2 \
  -dSubsetFonts=true \
  -dEmbedAllFonts=true \
  -dPDFSETTINGS=/prepress \
  laulik.ps
output "[main] Done"
