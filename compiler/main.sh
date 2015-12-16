#!/usr/bin/env bash

# cd /tmp

jobname=`uuidgen`

# cat /opt/laulik/songs/*.tex > /tmp/$jobname.latex
# pdflatex --interaction=nonstopmode /tmp/$jobname.latex
# cat /tmp/$jobname.pdf

set -e

cd /opt/laulik
python laulik.py
cd build
echo "[main] Running lilypond-book"
/opt/lilypond/bin/lilypond-book -V laulik.lytex
echo "[main] First latex pass"
latex -interaction=nonstopmode laulik.tex
echo "[main] Running xindy to generate index"
xindy -M numeric-sort -M latex-loc-fmts -I latex -L estonian -t ex1.xlg -M ../laulik.xdy laulik.idx
echo "[main] Second latex pass"
latex -interaction=nonstopmode laulik.tex
echo "[main] Running dvips"
dvips laulik.dvi
echo "[main] Running ps2pdf"
ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true -dPDFSETTINGS=/printer laulik.ps
echo "[main] Press enter"
read
