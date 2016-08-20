#!/usr/bin/env bash

source ./src/common/common.sh

jobname=ver-`date +"%Y%m%d-%H%M%S"`-`uuidgen`
projectname=$1
projectpath=$DATAPATH/projects/${projectname}.yaml
jobbuildpath=$BUILDPATH/$jobname

output "[laulik] Starting"

if [ ! -e "$projectpath" ]; then
  output "[laulik] No project file found at $projectpath!"
  exit 1
fi

mkdir -p $jobbuildpath
cd $jobbuildpath

python3 $COMPILERPATH/laulik.py $projectpath $DATAPATH $jobbuildpath 2>&1

output "[laulik] Running lilypond-book"
/opt/lilypond/bin/lilypond-book \
  -V \
  laulik.lytex

output "[laulik] First latex pass"
pdflatex \
  -interaction=nonstopmode \
  laulik.tex

output "[laulik] Running xindy to generate index"
xindy \
  -M numeric-sort \
  -M latex-loc-fmts \
  -I latex \
  -L estonian \
  -t ex1.xlg \
  -M $COMPILERPATH/laulik.xdy \
  laulik.idx

output "[laulik] Second latex pass"
pdflatex \
  -interaction=nonstopmode \
  laulik.tex

output "[laulik] Copying to latest directory"
cd $BUILDPATH
rsync \
  --archive \
  --inplace \
  --delete $jobname/* \
  latest
echo $jobname > latest/VERSION.txt

output "[laulik] Copying to project output"
mkdir -p projects
cp $jobname/laulik.pdf projects/${projectname}.pdf
cp $jobname/laulik.tex projects/${projectname}.tex
echo $jobname > projects/${projectname}.version.txt
output "[laulik] Done"
