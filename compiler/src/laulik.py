# -*- coding: utf8 -*-

import atexit
import io
import os
import pystache
import re
import sys
import yaml

class Verse(object):
  def __init__(self, is_refrain=False):
    self.is_refrain = is_refrain
    self.lines = []

  def add(self, line):
    self.lines.append(line)

class VerseFactory(object):
  def __init__(self):
    self.verses = []
    self.current = None

  def add(self, line):
    cleaned = line.strip()
    if self.current is None:
      if cleaned == '%REFRAIN':
        self.current = Verse(True)
      self.current = Verse()
    if cleaned == '':
      self.close()
    else:
      self.current.add(cleaned)

  def close(self):
    self.verses.append(self.current)
    self.current = None

class Laul(yaml.YAMLObject):
  yaml_tag = u'!Laul'

  def __init__(
      self,
      title=None,
      composer=None,
      poet=None,
      margin=None,
      index=None,
      misc=None,
      paths=None):
    self.title = title
    self.composer = composer
    self.poet = poet
    self.margin = margin
    self.index = index
    self.misc = misc
    self.paths = paths
    self.verses = None
    self.music = None

  def poet_or_composer(self):
    return self.poet != None or self.composer != None

class Project(yaml.YAMLObject):
  yaml_tag = u'!Project'

  def __init__(self, title, subtitle, parts):
    self.title = title
    self.subtitle = subtitle
    self.parts = parts
    self.content = None

class Config(object):
  def __init__(self, datapath, buildpath):
    self.datapath = datapath
    self.buildpath = buildpath
    self.outputpath = os.path.join(self.buildpath, 'laulik.lytex')
    self.templatespath = os.path.join(self.datapath, 'templates')

    self.stache = pystache.Renderer(
        escape=lambda u: u,
        string_encoding='utf8',
        file_encoding='utf8',
        search_dirs=[self.templatespath],
        file_extension='tex')

class BuildLaulik:
  def __init__(self, projectpath, datapath, buildpath, *args, **kwargs):
    self.projectpath = projectpath
    self.config = Config(datapath, buildpath)

  def __clear_output(self):
    if os.path.isfile(self.config.outputpath):
      os.remove(self.config.texoutputpath)
    print('[laulik] Removed {0}'.format(self.config.outputpath))

  def __output(self, lines, name=''):
    with open(self.config.outputpath, 'a') as f:
      for line in lines:
        f.write(line)
    print('[laulik] Wrote {0} to {1}'.format(name, self.config.outputpath))

  def __output_file(self, path):
    if os.path.isfile(path):
      with open(path, 'r', encoding='utf8') as f:
        self.__output(f, name=path)

  def __load_yaml(self, path):
    with open(path, 'r', encoding='utf8') as f:
      return yaml.load(f)

  def __print(self, output):
    sys.stdout.buffer.write(output)

  def __render(self, path, obj):
    if os.path.isfile(path):
      with open(path, 'r', encoding='utf8') as f:
        template = f.read()
        return self.config.stache.render(template, obj)
    print('[laulik] Warning - {0} is not a file'.format(path))
    return None

  def __parselyrics(self, lyrics):
    factory = VerseFactory()
    for line in lyrics.split('\n'):
      factory.add(line)
    factory.close()
    return factory.verses

  def run(self):
    self.__clear_output()
    #self.__output_file(self.texprefixpath)
    #self.__output_file(self.texsuffixpath)

    rendered = io.StringIO()
    project = self.__load_yaml(self.projectpath)
    for part in project.parts:
      partpath = os.path.join(self.config.datapath, part)
      partdir = os.path.dirname(partpath)
      if not os.path.isfile(partpath):
        print('[laulik] Warning - {0} is not a real file'.format(partpath))
        continue
      _, ext = os.path.splitext(partpath)
      if ext == '.yml':
        print('[laulik] Processing yaml config at {0}'.format(partpath))
        laul = self.__load_yaml(partpath)
        lyricspath = os.path.join(partdir, laul.paths['lyrics'])
        musicpath = os.path.join(partdir, laul.paths['music'])
        laul.verses = self.__parselyrics(self.__render(lyricspath, laul))
        laul.music = self.__render(musicpath, laul)
        rendered.write(self.config.stache.render(laul))
      else:
        print('[laulik] Warning - {0} was not processed'.format(partpath))
    project.content = rendered.getvalue()
    rendered.close()
    self.__output(self.config.stache.render(project))


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
  datapath = os.path.join(os.path.dirname(__file__), 'data')
  projectpath = sys.argv[1]
  buildpath = sys.argv[2]
  inst = BuildLaulik(projectpath, datapath, buildpath)
  inst.run()
