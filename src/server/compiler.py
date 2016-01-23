import io
import os
import models
import subprocess
import yaml

class Result(object):
  def __init__(self, success, stdout, stderr):
    self.success = success
    self.stdout = stdout
    self.stderr = stderr

class API(object):
  def __init__(self, rootpath):
    self.__rootpath = rootpath
    self.__datapath = os.path.join(rootpath, 'data')
    self.__projectpath = os.path.join(rootpath, 'data', 'projects')
    self.__latestbuildpath = os.path.join(rootpath, 'build', 'projects')

  def __load_yaml(self, path):
    with open(path, 'r', encoding='utf8') as f:
      return yaml.load(f)

  def __load_project(self, projectfile):
    key, _ = os.path.splitext(os.path.basename(projectfile))
    paths = models.ProjectPaths(
        config = os.path.join(self.__projectpath, projectfile),
        latex = os.path.join(self.__latestbuildpath, key + '.tex'),
        pdf = os.path.join(self.__latestbuildpath, key + '.pdf'),
        version = os.path.join(self.__latestbuildpath, key + '.version.txt'))
    project = self.__load_yaml(paths.config)
    return models.ProjectMeta(key, project, paths)

  def projects(self):
    return [ self.__load_project(x) for x in os.listdir(self.__projectpath) ]

  def build(self, key):
    proc = subprocess.Popen(
        [ './compiler/laulik.sh', key ],
        cwd=self.__rootpath,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True)
    stdout = io.StringIO()
    stderr = io.StringIO()
    success = True
    try:
      outs, errs = proc.communicate(timeout=30)
      stdout.write(outs)
      stderr.write(errs)
      success = proc.returncode == 0
    except subprocess.TimeoutExpired:
      stdout.write(outs)
      stderr.write(errs)
      proc.kill()
      outs, errs = proc.communicate(timeout=5)
      stdout.write(outs)
      stderr.write(errs)
      success = False
    result = Result(success, stdout.getvalue(), stderr.getvalue())
    stdout.close()
    stderr.close()
    return result
