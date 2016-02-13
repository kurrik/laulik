import os
import os.path
import proc

class Request(object):
  def __init__(self, commit, ref, pusher_name, pusher_email, sender_login):
    self.commit = commit
    self.ref = ref
    self.user_name = pusher_name
    self.user_email = pusher_email
    self.user_login = sender_login

class API(object):
  def __init__(self, repopath):
    datapath = os.path.join(repopath, 'data')
    buildpath = os.path.join(repopath, 'build')
    self.__cwdpath = os.path.join(os.path.dirname(__file__), '..', '..')

  def parse_webhook(self, decoded):
    return Request(
      commit=decoded['head_commit']['id'],
      ref=decoded['ref'],
      pusher_name=decoded['pusher']['name'],
      pusher_email=decoded['pusher']['email'],
      sender_login=decoded['sender']['login'],
    )

  def pull(self):
    return proc.Process.run(['./src/server/pull.sh'])
