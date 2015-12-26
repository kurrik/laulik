#!/usr/bin/env bash

source ./common/common.sh

jobname=ver-`date +"%Y%m%d-%H%M%S"`-`uuidgen`
scriptpath=/opt/laulik/compiler
projectname=voluja
datapath=/opt/laulik/data
projectpath=$datapath/projects/${projectname}.yaml
buildpath=/opt/laulik/build/$jobname

mkdir -p $buildpath
cd $buildpath

python3 $scriptpath/laulik.py $projectpath $datapath $buildpath

output "[laulik] Running lilypond-book"
/opt/lilypond/bin/lilypond-book -V laulik.lytex
output "[laulik] First latex pass"
latex -interaction=nonstopmode laulik.tex
output "[laulik] Running xindy to generate index"
xindy -M numeric-sort -M latex-loc-fmts -I latex -L estonian -t ex1.xlg -M $scriptpath/laulik.xdy laulik.idx
output "[laulik] Second latex pass"
latex -interaction=nonstopmode laulik.tex
output "[laulik] Running dvips"
dvips laulik.dvi
output "[laulik] Running ps2pdf"
ps2pdf \
  -dMaxSubsetPct=100 \
  -dCompatibilityLevel=1.2 \
  -dSubsetFonts=true \
  -dEmbedAllFonts=true \
  -dPDFSETTINGS=/prepress \
  laulik.ps
output "[laulik] Copying to latest directory"
cd ..
rsync --archive --inplace --delete $jobname/* latest
echo $jobname > latest/VERSION.txt
output "[laulik] Copying to project output"
mkdir -p projects
cp $jobname/laulik.pdf projects/${projectname}.pdf
cp $jobname/laulik.tex projects/${projectname}.tex
echo $jobname > projects/${projectname}.version.txt
output "[laulik] Done"
