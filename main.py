import os 
from flask import Flask

app = Flask(__name__)

@app.route('/')
def filters():
     return "<center>Hello World! Jebać Disa syna orka kurwe zwisa skurwysyna"


if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0')