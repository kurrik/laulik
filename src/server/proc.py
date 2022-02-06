import io
import os
import subprocess

class Result(object):
  def __init__(self, success, stdout, stderr):
    self.success = success
    self.stdout = stdout
    self.stderr = stderr

class Process(object):
  cwdpath = os.path.join(os.path.dirname(__file__), '..', '..')

  @classmethod
  def run(self, cmd):
    proc = subprocess.Popen(
      cmd,
      cwd=Process.cwdpath,
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE,
      universal_newlines=True)
    stdout = io.StringIO()
    stderr = io.StringIO()
    success = True
    outs = ""
    errs = ""
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
