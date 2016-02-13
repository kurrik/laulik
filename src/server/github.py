import os
import os.path

#class Request(object):
#  def __init__(self):

class API(object):
  def __init__(self, repopath):
    datapath = os.path.join(repopath, 'data')
    buildpath = os.path.join(repopath, 'build')
    self.__cwdpath = os.path.join(os.path.dirname(__file__), '..', '..')

  def parse_webhook(self, decoded):
    return decoded
