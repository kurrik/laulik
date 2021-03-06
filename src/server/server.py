from ansi2html import Ansi2HTMLConverter
import argparse
from flask import Flask
from flask import Markup
from flask import Response
from flask import make_response
from flask import render_template
from flask import request
from flask import send_file
import github
import laulik
import os

app = Flask(__name__)
repopath = os.environ.get('REPOPATH')
app.logger.info("Repo path: ", repopath)
laulik_api = laulik.API(repopath=repopath)
github_api = github.API(repopath=repopath)
conv = Ansi2HTMLConverter(markup_lines=True)

@app.route('/', methods=['GET', 'POST'])
def root():
  data = {}
  data['git_info'] = github_api.info()
  data['server_version'] = laulik_api.server_version()
  if request.method == 'POST':
    key = request.form['key']
    result = laulik_api.build(key)
    data['msg'] = Markup('Built project <strong>{0}</strong>'.format(key))
    data['output'] = Markup(conv.convert(result.stdout, full=False))
  data['projects'] = laulik_api.projects()
  return render_template('index.html', **data)

@app.route('/build/<key>/<version>.pdf')
def pdf(key, version):
  meta = laulik_api.safe_get_meta(key, version)
  if meta is None:
    return 'Not found!', 404
  return send_file(
      meta.paths.pdf,
      mimetype='application/pdf',
      as_attachment=True,
      attachment_filename='{0}-{1}.pdf'.format(meta.key, meta.version))

@app.route('/build/<key>/<version>.tex')
def tex(key, version):
  meta = laulik_api.safe_get_meta(key, version)
  if meta is None:
    return 'Not found!', 404
  return send_file(
      meta.paths.latex,
      mimetype='text/plain',
      as_attachment=True,
      attachment_filename='{0}-{1}.tex'.format(meta.key, meta.version))

@app.route('/webhook', methods=['POST'])
def webhook():
  data = {}
  if request.headers.get('X-GitHub-Event') == 'push':
    data['req'] = github_api.parse_webhook(request.get_json(force=True))
    result = github_api.pull()
    data['stdout'] = result.stdout
    data['stderr'] = result.stderr
    data['action'] = 'Pulled git repo'
  resp = make_response(render_template('webhook.txt', **data), 200)
  resp.headers['Content-Type'] = 'text/plain'
  return resp

if __name__ == '__main__':
  app.run(host='0.0.0.0', debug=True, port=int(os.environ.get('PORT', 8080)))
