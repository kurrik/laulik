import argparse
import compiler
from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)
api = None

@app.route('/', methods=['GET', 'POST'])
def root():
  data = {}
  if request.method == 'POST':
    data['msg'] = 'Post'
    data['projects'] = api.projects()
    api.build()
  return render_template('index.html', **data)

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Web frontend')
  parser.add_argument(
      'datapath',
      metavar='PATH',
      type=str,
      help='Path to the data directory')
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
  api = compiler.API(args.datapath, args.rootpath)
  app.run(host='0.0.0.0', debug=args.debug)
