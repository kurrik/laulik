import atexit
import os
import re
import sys
import yaml

class BuildLaulik:
  def __init__(self, projectpath, buildpath, *args, **kwargs):
    self.basepath = os.path.dirname(__file__)
    self.buildpath = buildpath
    self.songspath = os.path.join(self.basepath, 'data', 'songs')
    self.notespath = os.path.join(self.basepath, 'data', 'notes')
    self.projectpath = projectpath
    self.texprefixpath = os.path.join(self.basepath, 'data', 'prefix.tex')
    self.texsuffixpath = os.path.join(self.basepath, 'data', 'suffix.tex')
    self.texoutputpath = os.path.join(self.buildpath, 'laulik.lytex')

  def __clear_output(self):
    if os.path.isfile(self.texoutputpath):
      os.remove(self.texoutputpath)
    print('[laulik] Removed {0}'.format(self.texoutputpath))

  def __output(self, lines, name=''):
    with open(self.texoutputpath, 'a') as f:
      for line in lines:
        f.write(line)
    print('[laulik] Wrote {0} to {1}'.format(name, self.texoutputpath))

  def __output_file(self, path):
    if os.path.isfile(path):
      with open(path, 'r') as f:
        self.__output(f, name=path)

  def __load_yaml(self, path):
    with open(path, 'r') as f:
      return yaml.load(f)

  def run(self):
    self.__clear_output()
    self.__output_file(self.texprefixpath)
    self.__output_file(self.texsuffixpath)

    print(self.__load_yaml(self.projectpath))
"""
    dirlisting = os.listdir(songspath)
    dirlisting.sort()
    for filename in dirlisting:
      lyricsfile=os.path.join(lyricspath, filename)
      if os.path.isdir(lyricsfile):
        # it's a directory
        pass
      else:
        if (filename[-4:] == '.tex'):
            notesfile=os.path.join(notespath, filename[:-4]+".ly")
            notesstr = ""
            if os.path.isfile(notesfile):
                #print "Notes:  ", notesfile
                #tempstr = "\lilypondfile[quote,noindent]{" + notesfile + "}"
                infilehandle = open( notesfile, 'r' )
                filecontents = infilehandle.read()
                extrajunk = filecontents.find("\header")
                notesstr = "\\begin[noindent,line-width=3\\in, staffsize=9, fontload]{lilypond}\n"+filecontents[extrajunk:]+"\n\\end{lilypond}"
                print("Wrote contents of " + notesfile + " to MasterLaulik.lytex")
            #print "Lyrics: ", lyricsfile
            infilehandle = open(lyricsfile, 'r')
            loopgoing = True
            var_songtitle = ""
            var_composer = ""
            var_poet = ""
            var_miscdata = ""
            var_lastline = ""
            var_addlindex = ""
            var_lmargin = ""
            var_rmargin = ""
            var_reflmargin = ""
            var_refrmargin = ""
            while(loopgoing):
                parsedline = infilehandle.readline()
                if (parsedline[:7] == "%TITLE="):
                    var_songtitle = parsedline[7:].strip()
                    print("Parsed title: '"+var_songtitle+"'")
                elif (parsedline[:10] == "%COMPOSER="):
                    var_composer = parsedline[10:].strip()
                    print("Parsed composer: "+"'"+var_composer+"'")
                elif (parsedline[:6] == "%POET="):
                    var_poet = parsedline[6:].strip()
                    print("Parsed poet: "+"'"+var_poet+"'")
                elif (parsedline[:6] == "%MISC="):
                    var_miscdata = parsedline[6:].strip()
                    print("Parsed misc data: "+"'"+var_miscdata+"'")
                elif (parsedline[:11] == "%ADDLINDEX="):
                    var_addlindex += "\\index{" + parsedline[11:].strip() + "}\n"
                    print("Parsed additional index: "+"'"+var_addlindex+"'")
                elif (parsedline[:9] == "%LMARGIN="):
                    var_lmargin = parsedline[9:].strip()
                    print("Parsed left margin: "+"'"+var_lmargin+"'")
                elif (parsedline[:9] == "%RMARGIN="):
                    var_rmargin = parsedline[9:].strip()
                    print("Parsed right margin: "+"'"+var_rmargin+"'")
                elif (parsedline[:12] == "%REFLMARGIN="):
                    var_reflmargin = parsedline[12:].strip()
                    print("Parsed left refrain margin: "+"'"+var_reflmargin+"'")
                elif (parsedline[:12] == "%REFRMARGIN="):
                    var_refrmargin = parsedline[12:].strip()
                    print("Parsed right refrain margin: "+"'"+var_refrmargin+"'")
                else:
                    loopgoing = False
                    lastline = parsedline.strip()

            if (var_lmargin == ""):
                var_lmargin = "0.5in"
            if (var_rmargin == ""):
                var_rmargin = "0.1in"
            if (var_reflmargin == ""):
                var_reflmargin = "0.8in"
            if (var_refrmargin == ""):
                var_refrmargin = "0.2in"

            outfilehandle.write("\n")
            if (notesstr != ""):
                outfilehandle.write("\\clearpage\n")
            outfilehandle.write("{\\samepage\\raggedbottom\n\\raggedright\n\\sloppy\n")
            if (var_addlindex != ""):
                outfilehandle.write(var_addlindex)
            if (var_songtitle != ""):
                outfilehandle.write("\\index{")
                outfilehandle.write(var_songtitle)
                outfilehandle.write("}\n")
                outfilehandle.write("\\vspace{0.2in}\n\\centerline{ {\\bf {\\large ")
                outfilehandle.write(var_songtitle)
                outfilehandle.write("}}}\n\\nopagebreak[4]\n\\vspace{0.1in}\n\\nopagebreak[4]\n\\hrule height 0.05ex\n\\nopagebreak[4]\n\\vspace{-0.05in}\n")

            if ((var_poet != "") or (var_composer != "")): 
                outfilehandle.write("{\\footnotesize " + var_poet + "\\hfill " + var_composer + "}\\\\\\vspace{0.01in}\n")

            if (var_miscdata != ""):
                outfilehandle.write("{\\em {\\footnotesize "+var_miscdata+"}}\\vspace{0.01in}\n")
            if (notesstr != ""):
                outfilehandle.write("\\vspace{0.01in}\\nopagebreak[4]\n")
                outfilehandle.write(notesstr + "\n\n")
            outfilehandle.write("\\begin{changemargin}{"+var_lmargin+"}{"+var_rmargin+"}\n")
            outfilehandle.write("{\\small \n")
            print("Getting the rest of the file\n")
            if (lastline != ""):
                outfilehandle.write("\\nopagebreak[4]\\noindent " + lastline.strip()+"\\\\\n")

            var_isnewverse = False
            for nextline in infilehandle.read().strip().split('\n'):
                if (var_isnewverse):
                    if (nextline[:8] == "%REFRAIN"):
                        outfilehandle.write("\\pagebreak[1]\n\\begin{changemargin}{"+var_reflmargin+"}{"+var_refrmargin+"}\n{\\small \n\\noindent ")
                    else:
                        outfilehandle.write("\\pagebreak[1]\n\\begin{changemargin}{"+var_lmargin+"}{"+var_rmargin+"}\n{\\small \\noindent ")
                    var_isnewverse = False
                if (nextline):
                    if (nextline.strip() == ""):
                        outfilehandle.write("}\n\\end{changemargin}\n")
                        var_isnewverse = True
                    else:
                        outfilehandle.write("\\nopagebreak[4]"+nextline.strip()+"\\\\\n")
            outfilehandle.write("}\n\\end{changemargin}\n}\n\\vskip 0in plus 1in minus 0in\n\\pagebreak[3]\n")
            print("Wrote contents of " + lyricsfile + " to MasterLaulik.lytex")
            infilehandle.close()

    if os.path.isfile(latexposttemplate):
      infilehandle = open(latexposttemplate, 'r')
      outfilehandle.write(infilehandle.read())
      print("Wrote post.tex to MasterLaulik.lytex")
      infilehandle.close()
"""

if __name__ == '__main__':
  inst = BuildLaulik(sys.argv[1], sys.argv[2])
  inst.run()
