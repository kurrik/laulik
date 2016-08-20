import atexit
import io
import os
from models import Laul, Project
import pystache
import re
import sys
import yaml
import shutil
import tempfile

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
      else:
        self.current = Verse()
    if cleaned == '':
      self.close()
    else:
      self.current.add(cleaned)

  def close(self):
    self.verses.append(self.current)
    self.current = None

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
        if 'image' in laul.paths:
          src = os.path.join(partdir, laul.paths['image'])
          _, ext = os.path.splitext(src)
          (_, dst) = tempfile.mkstemp(suffix=ext, dir=self.config.buildpath)
          shutil.copyfile(src, dst)
          laul.image = dst
          print('[laulik] Copied image {0} to {1}'.format(src, dst))
        laul.verses = self.__parselyrics(self.__render(lyricspath, laul))
        laul.music = self.__render(musicpath, laul)
        rendered.write(self.config.stache.render(laul))
      else:
        print('[laulik] Warning - {0} was not processed'.format(partpath))
    project.content = rendered.getvalue()
    rendered.close()
    self.__output(self.config.stache.render(project))

if __name__ == '__main__':
  projectpath = sys.argv[1]
  datapath = sys.argv[2]
  buildpath = sys.argv[3]
  inst = BuildLaulik(projectpath, datapath, buildpath)
  inst.run()
