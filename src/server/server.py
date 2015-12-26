from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def root():
  data = {}
  if request.method == 'POST':
    data['msg'] = 'Post'
  return render_template('index.html', **data)

if __name__ == '__main__':
  app.run(host='0.0.0.0')
