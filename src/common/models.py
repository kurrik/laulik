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
          layout=None,
          index=None,
          misc=None,
          paths=None):
    self.title = title
    self.composer = composer
    self.poet = poet
    self.margin = margin
    self.layout = layout
    self.index = index
    self.misc = misc
    self.paths = paths
    self.verses = None
    self.music = None
    self.image = None
    self.default_verse_l_margin = '0.1in'
    self.default_verse_r_margin = '0.1in'
    self.default_refrain_l_margin = '0.4in'
    self.default_refrain_r_margin = '0.1in'
    self.default_layout_verse_width = '18em'
    self.default_layout_refrain_width = '15em'

  @classmethod
  def from_yaml(cls, loader, node):
    fields = loader.construct_mapping(node)
    return Laul(**fields)

  def title_for_index(self):
    return re.sub('([^"])!', '\\1"!', self.title)

  def poet_or_composer(self):
    return self.poet != None or self.composer != None

  def margin_verse_l(self):
    return glom(self, 'margin.verse.l', default=self.default_verse_l_margin)

  def margin_verse_r(self):
    return glom(self, 'margin.verse.r', default=self.default_verse_r_margin)

  def margin_refrain_l(self):
    return glom(self, 'margin.refrain.l', default=self.default_refrain_l_margin)

  def margin_refrain_r(self):
    return glom(self, 'margin.refrain.r', default=self.default_refrain_r_margin)

  def layout_verse_width(self):
    return glom(self, 'layout.verse.width', default=self.default_layout_verse_width)

  def layout_refrain_width(self):
    return glom(self, 'layout.refrain.width', default=self.default_layout_refrain_width)


class Project(yaml.YAMLObject):
  yaml_tag = u'!Project'
  yaml_loader = yaml.SafeLoader

  def __init__(
          self,
          title,
          subtitle,
          parts,
          debug=False,
          layoutmode='margin',
          page=None,
          music=None,
          templatesdir=None,
          outputfile=None):
    self.title = title
    self.subtitle = subtitle
    self.parts = parts
    self.debug = debug
    self.layoutmode = layoutmode
    self.page = page
    self.music = music
    self.templatesdir = templatesdir
    self.outputfile = outputfile
    self.content = None
    self.default_page_width = '4.00in'
    self.default_page_height = '6.00in'
    self.default_music_linewidth = '3.2\in'
    self.default_music_staffsize = 9

  def page_width(self):
    return glom(self, 'page.width', default=self.default_page_width)

  def page_height(self):
    return glom(self, 'page.height', default=self.default_page_height)

  def music_linewidth(self):
    return glom(self, 'music.linewidth', default=self.default_music_linewidth)

  def music_staffsize(self):
    return glom(self, 'music.staffsize', default=self.default_music_staffsize)

  def layout_mode(self):
    return glom(self, 'layoutmode', default='margin')

  def use_margin_layout(self):
    return self.layoutmode == 'margin'

  def use_width_layout(self):
    return self.layoutmode == 'width'

  @classmethod
  def from_yaml(cls, loader, node):
    fields = loader.construct_mapping(node)
    return Project(**fields)


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
