echo -e Starting Build
date
echo ===============================================================
echo -n "Changing directory to "
cd /home/laulik
pwd
echo
echo Clearing the contents of the output dir...
echo ===============================================================
rm /home/laulik/out/*
echo Done 

echo
echo Building .lytex
echo ===============================================================
python /home/laulik/BuildLaulik.py
echo "Done"

echo
echo Building .tx
echo ===============================================================
lilypond-book -V --output=out --psfonts MasterLaulik.lytex
echo "Done"

echo
echo Building .dvi
echo ===============================================================
echo -n "Changing directory to: "
cd out
pwd
echo ---------------------------------------------------------------
latex -interaction=nonstopmode MasterLaulik.tex
echo "Done"

echo
echo Building index
echo ===============================================================
#makeindex -l -s ../LaulikIndexStyle.ist MasterLaulik.idx
#mendex -l -s ../LaulikIndexStyle.ist -p 10002 MasterLaulik.idx
export PATH=$PATH:/opt/xindy-2.2/bin/
#makeindex4 -l -s ../LaulikIndexStyle.ist MasterLaulik.idx
#texindy --language estonian -l MasterLaulik.idx
#xindy --language estonian -I latex MasterLaulik.idx
xindy -M numeric-sort -M latex-loc-fmts -I latex -L estonian -t ex1.xlg -M ../MasterLaulik.xdy MasterLaulik.idx
latex -interaction=nonstopmode MasterLaulik.tex
echo "Done"

echo
echo Building .ps
echo ===============================================================
#Convert to DVI
dvips -h MasterLaulik.psfonts MasterLaulik.dvi
echo "Done"

echo 
echo Copying .ps file to current directory
echo ===============================================================
cd ..
echo -e "Changing directory to: "
pwd
echo ---------------------------------------------------------------
cp ./out/MasterLaulik.ps .
echo Done

echo 
echo Converting .ps to .pdf
echo ===============================================================
ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true -dPDFSETTINGS=/printer MasterLaulik.ps
echo Done

echo
echo Copying to WWW directory
echo ===============================================================
filebuildtime=`date +"%Y-%m-%d-%H-%M"`
mostrecentmd5=`md5sum /var/www/laulik/files/MostRecent.lytex | cut -d " "  -f1`
currentmd5=`md5sum MasterLaulik.lytex | cut -d " "  -f1`

if [ $? ] ; then
	if [ "$currentmd5" = "$mostrecentmd5" ] ; then
		echo MostRecent md5 matches the current build: Not updating
		copyfiles=0
	else
		echo MostRecent md5 does not match: Copying...
		copyfiles=1
	fi
else
	echo No MostRecent file, copy away
	copyfiles=1
fi

if [ $copyfiles -eq 1 ] ; then
	echo Copying Files To Web Directory...
	cp MasterLaulik.ps /var/www/laulik/files/in/Laulik-$filebuildtime.ps
	cp MasterLaulik.ps /var/www/laulik/files/in/MostRecent.ps
	#cp MasterLaulik.pdf /var/www/laulik/files/Laulik-$filebuildtime.pdf
	#cp MasterLaulik.pdf /var/www/laulik/files/MostRecent.pdf
	cp MasterLaulik.lytex /var/www/laulik/files/MostRecent.lytex

	#chmod 666 /var/www/laulik/files/Laulik-$filebuildtime.pdf
	chmod 666 /var/www/laulik/files/in/Laulik-$filebuildtime.ps
	chmod 666 /var/www/laulik/files/in/MostRecent.ps
	chmod 666 /var/www/laulik/files/MostRecent.lytex
else 
	echo No Need To Copy Files: Found MD5 collision
fi
echo Done

/home/laulik/MakeIndex.sh

echo
echo Built OK
echo 
