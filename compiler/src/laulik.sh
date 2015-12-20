#!/usr/bin/env bash

function output {
  echo -e "\033[1;95m$1\033[0m	$2"
}

set -e

jobname=ver-`date +"%Y%m%d-%H%M%S"`-`uuidgen`
scriptpath=/opt/laulik
projectname=voluja
projectpath=$scriptpath/data/projects/${projectname}.yaml
buildpath=$scriptpath/build/$jobname

# UTF-8 paths / env everywhere
export PYTHONIOENCODING=utf_8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

mkdir -p $buildpath
cd $buildpath

python3 $scriptpath/laulik.py $projectpath $buildpath

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
output "[main] Copying to latest directory"
cd ..
rsync --archive --inplace --delete $jobname/* latest
echo $jobname > latest/VERSION.txt
output "[main] Copying to project output"
mkdir -p projects
cp $jobname/laulik.pdf projects/${projectname}.pdf
cp $jobname/laulik.tex projects/${projectname}.tex
echo $jobname > projects/${projectname}.version.txt
output "[main] Done"
