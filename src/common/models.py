import os
from xml.etree.ElementInclude import include
import yaml
from glom import glom
import re


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
    self.default_margin = '0.1in'

  @classmethod
  def from_yaml(cls, loader, node):
    fields = loader.construct_mapping(node)
    return Laul(**fields)

  def title_for_index(self):
    return re.sub('([^"])!', '\\1"!', self.title)

  def poet_or_composer(self):
    return self.poet != None or self.composer != None

  def margin_verse_l(self):
    return glom(self, 'margin.verse.l', default=self.default_margin)

  def margin_verse_r(self):
    return glom(self, 'margin.verse.r', default=self.default_margin)

  def margin_refrain_l(self):
    return glom(self, 'margin.refrain.l', default=self.default_margin)

  def margin_refrain_r(self):
    return glom(self, 'margin.refrain.r', default=self.default_margin)


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

  @ property
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
