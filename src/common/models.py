import os
from xml.etree.ElementInclude import include
import yaml


class Content(yaml.YAMLObject):
  yaml_tag = u'!Content'
  yaml_loader = yaml.SafeLoader

  data = None

  def __init__(self, path=None, data=None):
    self.path = path
    self.data = data


class Laul(yaml.YAMLObject):
  yaml_tag = u'!Laul'
  yaml_loader = yaml.SafeLoader

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
    self.image = None

  def poet_or_composer(self):
    return self.poet != None or self.composer != None


class Project(yaml.YAMLObject):
  yaml_tag = u'!Project'
  yaml_loader = yaml.SafeLoader

  def __init__(self, title, subtitle, parts):
    self.title = title
    self.subtitle = subtitle
    self.parts = parts
    self.content = None


class ProjectMeta(object):
  def __init__(
          self,
          key,
          project,
          paths):
    self.key = key
    self.project = project
    self.paths = paths
    self.__version = False

  @property
  def version(self):
    if self.__version is False:
      if os.path.isfile(self.paths.version):
        with open(self.paths.version) as f:
          self.__version = f.read().strip()
      else:
        self.__version = None
    return self.__version


class ProjectPaths(object):
  def __init__(
          self,
          config,
          latex=None,
          pdf=None,
          version=None):
    self.config = config
    self.latex = latex
    self.pdf = pdf
    self.version = version
