import yaml

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
