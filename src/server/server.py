from ansi2html import Ansi2HTMLConverter
import argparse
import compiler
from flask import Flask
from flask import Markup
from flask import render_template
from flask import request

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

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Web frontend')
  parser.add_argument(
      'rootpath',
      metavar='PATH',
      type=str,
      help='Path to the root directory')
  parser.add_argument(
      '--debug',
      action='store_true',
      help='Launch in debug mode with hot reload')
  args = parser.parse_args()
  api = compiler.API(args.rootpath)
  app.run(host='0.0.0.0', debug=args.debug)
