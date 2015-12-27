import os
import subprocess

class API(object):
  def __init__(self, rootpath):
    self.__rootpath = rootpath
    self.__datapath = os.path.join(rootpath, 'data')

  def projects(self):
    projectpath = os.path.join(self.__datapath, 'projects')
    return [ os.path.join(projectpath, x) for x in os.listdir(projectpath) ]

  def build(self):
    proc = subprocess.Popen(
        [ './compiler/laulik.sh' ],
        cwd=self.__rootpath,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True)
    outs = ''
    errs = ''
    try:
      outs, errs = proc.communicate(timeout=30)
    except subprocess.TimeoutExpired:
      print('[compiler] Error: {0} {1}'.format(outs, errs))
      proc.kill()
      outs, errs = proc.communicate(timeout=5)
    print('[compiler] Done: {0} {1}'.format(outs, errs))
