import atexit
import io
import os
from models import Laul, Project, Content
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
  def __init__(self, projectpath, datapath, buildpath, project):
    self.projectpath = projectpath
    templatesdir = project.templatesdir if project.templatesdir else 'templates'
    outputfile = project.outputfile if project.outputfile else 'laulik.lytex'

    self.datapath = datapath
    self.buildpath = buildpath
    self.outputpath = os.path.join(self.buildpath, outputfile)
    self.templatespath = os.path.join(self.datapath, templatesdir)

    self.stache = pystache.Renderer(
        escape=lambda u: u,
        string_encoding='utf8',
        file_encoding='utf8',
        search_dirs=[self.templatespath],
        file_extension='tex')


class BuildLaulik:
  def __init__(self, projectpath, datapath, buildpath, *args, **kwargs):
    project = self.__load_yaml(projectpath)
    self.config = Config(projectpath, datapath, buildpath, project)

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
      return yaml.safe_load(f)

  def __print(self, output):
    sys.stdout.buffer.write(output)

  def __render(self, path, obj, **kwargs):
    if os.path.isfile(path):
      with open(path, 'r', encoding='utf8') as f:
        template = f.read()
        return self.config.stache.render(template, obj, **kwargs)
    print('[laulik] Warning - {0} is not a file'.format(path))
    return None

  def __parselyrics(self, lyrics):
    factory = VerseFactory()
    for line in lyrics.split('\n'):
      factory.add(line)
    factory.close()
    return factory.verses

  def __process_laul(self, laul, project, partdir, output):
    lyricspath = os.path.join(partdir, laul.paths['lyrics'])
    if 'image' in laul.paths:
      src = os.path.join(partdir, laul.paths['image'])
      _, ext = os.path.splitext(src)
      (_, dst) = tempfile.mkstemp(suffix=ext, dir=self.config.buildpath)
      shutil.copyfile(src, dst)
      laul.image = dst
      print('[laulik] Copied image {0} to {1}'.format(src, dst))
    laul.verses = self.__parselyrics(self.__render(lyricspath, laul))
    if 'music' in laul.paths:
      musicpath = os.path.join(partdir, laul.paths['music'])
      laul.music = self.__render(musicpath, laul)
    output.write(self.config.stache.render(laul, project=project))

  def __process_content(self, content, project, partdir, output):
    contentpath = os.path.join(partdir, content.path)
    output.write(self.__render(contentpath, content.data, project=project))

  def run(self):
    self.__clear_output()

    rendered = io.StringIO()
    project = self.__load_yaml(self.config.projectpath)
    for part in project.parts:
      partpath = os.path.join(self.config.datapath, part)
      partdir = os.path.dirname(partpath)
      if not os.path.isfile(partpath):
        print('[laulik] Warning - {0} is not a real file'.format(partpath))
        continue
      _, ext = os.path.splitext(partpath)
      if ext == '.yml':
        print('[laulik] Processing yaml config at {0}'.format(partpath))
        object = self.__load_yaml(partpath)
        if isinstance(object, Laul):
          self.__process_laul(object, project, partdir, rendered)
        elif isinstance(object, Content):
          self.__process_content(object, project, partdir, rendered)
        else:
          print('[laulik] Warning - {0} had an unhandled yaml tag {1}'.format(
              partpath, object.yaml_tag))
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
