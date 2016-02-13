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

app = Flask(__name__)
laulik_api = None
github_api = None
conv = Ansi2HTMLConverter(markup_lines=True)

@app.route('/', methods=['GET', 'POST'])
def root():
  data = {}
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
  print(github_api.parse_webhook(request.get_json(force=True)))
  return make_response('Done!', 200)

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Web frontend')
  parser.add_argument(
      'repopath',
      metavar='REPO_PATH',
      type=str,
      help='Path to the repository containing data and build dirs')
  parser.add_argument(
      '--debug',
      action='store_true',
      help='Launch in debug mode with hot reload')
  args = parser.parse_args()
  laulik_api = laulik.API(repopath=args.repopath)
  github_api = github.API(repopath=args.repopath)
  app.run(host='0.0.0.0', debug=args.debug)
