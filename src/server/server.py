from ansi2html import Ansi2HTMLConverter
import argparse
import compiler
from flask import Flask
from flask import Markup
from flask import Response
from flask import make_response
from flask import render_template
from flask import request
from flask import send_file

app = Flask(__name__)
api = None
conv = Ansi2HTMLConverter(markup_lines=True)

@app.route('/', methods=['GET', 'POST'])
def root():
  data = {}
  if request.method == 'POST':
    key = request.form['key']
    result = api.build(key)
    data['msg'] = Markup('Built project <strong>{0}</strong>'.format(key))
    data['output'] = Markup(conv.convert(result.stdout, full=False))
  data['projects'] = api.projects()
  return render_template('index.html', **data)

@app.route('/build/<key>/<version>.pdf')
def pdf(key, version):
  meta = api.safe_get_meta(key, version)
  if meta is None:
    return 'Not found!', 404
  return send_file(
      meta.paths.pdf,
      mimetype='application/pdf',
      as_attachment=True,
      attachment_filename='{0}-{1}.pdf'.format(meta.key, meta.version))

@app.route('/build/<key>/<version>.tex')
def tex(key, version):
  meta = api.safe_get_meta(key, version)
  if meta is None:
    return 'Not found!', 404
  return send_file(
      meta.paths.latex,
      mimetype='text/plain',
      as_attachment=True,
      attachment_filename='{0}-{1}.tex'.format(meta.key, meta.version))

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
  api = compiler.API(repopath=args.repopath)
  app.run(host='0.0.0.0', debug=args.debug)
