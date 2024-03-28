#!/bin/bash

sudo apt update
sudo apt install python3.10-venv -y
python3 -m venv venv
source venv/bin/activate
apt install python3-pip -y
pip install Flask

export FILENAME="hello_world.py"

bash -c "cat > $FILENAME" <<EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Hello, World!</title>
        <style>
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                background-color: #f0f0f0; /* Light gray background */
            }
            .content {
                text-align: center;
                color: #333; /* Dark gray text color */
            }
            h1 {
                color: #007bff; /* Blue color for headings */
            }
            p {
                color: #6c757d; /* Gray color for paragraphs */
            }
        </style>
    </head>
    <body>
        <div class="content">
            <h1>Hello, World!</h1>
            <p>We have just configured our Flask application!</p>
        </div>
    </body>
    </html>
    '''
@app.route('/health')
def health_check():
    return 'Healthy!\n', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
EOF

nohup python3 hello_world.py > flask.log 2>&1 &