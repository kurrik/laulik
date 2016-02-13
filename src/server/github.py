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
    self.__infopath = os.path.join(repopath, 'gitinfo.txt')

  def parse_webhook(self, decoded):
    return Request(
      commit=decoded['head_commit']['id'],
      ref=decoded['ref'],
      pusher_name=decoded['pusher']['name'],
      pusher_email=decoded['pusher']['email'],
      sender_login=decoded['sender']['login'],
    )

  def pull(self):
    return proc.Process.run(['./src/server/git_pull.sh'])

  def info(self):
    if os.path.exists(self.__infopath):
      with open(self.__infopath, 'r', encoding='utf8') as f:
        return f.read()
    return "Could not parse current git version (development mode?)"
