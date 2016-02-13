import io
import os
import os.path
import proc
import models
import re
import yaml

KEY_PATTERN = re.compile('\W+', re.UNICODE)
VER_PATTERN = re.compile('[^a-z0-9-]+', re.UNICODE)

class Result(object):
  def __init__(self, success, stdout, stderr):
    self.success = success
    self.stdout = stdout
    self.stderr = stderr

class API(object):
  def __init__(self, repopath):
    datapath = os.path.join(repopath, 'data')
    buildpath = os.path.join(repopath, 'build')
    self.__cwdpath = os.path.join(os.path.dirname(__file__), '..', '..')
    self.__projectpath = os.path.join(datapath, 'projects')
    self.__latestbuildpath = os.path.join(buildpath, 'projects')

  def __load_yaml(self, path):
    with open(path, 'r', encoding='utf8') as f:
      return yaml.load(f)

  def __load_project_paths(self, projectfile):
    key, _ = os.path.splitext(os.path.basename(projectfile))
    return models.ProjectPaths(
      config = os.path.join(self.__projectpath, projectfile),
      latex = os.path.join(self.__latestbuildpath, key + '.tex'),
      pdf = os.path.join(self.__latestbuildpath, key + '.pdf'),
      version = os.path.join(self.__latestbuildpath, key + '.version.txt'))

  def __load_project(self, projectfile):
    key, _ = os.path.splitext(os.path.basename(projectfile))
    paths = self.__load_project_paths(projectfile)
    project = self.__load_yaml(paths.config)
    return models.ProjectMeta(key, project, paths)

  def projects(self):
    return [ self.__load_project(x) for x in os.listdir(self.__projectpath) ]

  def clean_key(self, unsafekey):
    return KEY_PATTERN.sub('', unsafekey)

  def clean_version(self, unsafeversion):
    return VER_PATTERN.sub('', unsafeversion)

  def safe_get_meta(self, unsafekey, unsafeversion):
    safekey = self.clean_key(unsafekey)
    safeversion = self.clean_version(unsafeversion)
    path = os.path.join(self.__projectpath, safekey + '.yaml')
    if os.path.isfile(path):
      meta = self.__load_project(path)
      if meta.version == safeversion:
        return meta
    return None

  def build(self, key):
    return proc.Process.run(['./src/compiler/laulik.sh', key])
