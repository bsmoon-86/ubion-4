## 웹서버 오픈 사용할 라이브러리(flask) import
from flask import Flask, render_template

# class인 Flask안에 __init__ 함수에는 self를 제외한 매개변수 1개는 존재
app = Flask(__name__)

# localhost:5000/ 에 접속할때 바로 밑에 있는 함수를 실행.
@app.route("/")     
def index():
    return "Hello, World"       
## localhost:5000/이라는 주소로 서버에 요청을 보내면
## "Hello, World"라는 문자를 응답 해준다.

## localhost:5000/second
@app.route("/second/")
def second():
    return "Second Page"
## localhost:5000/second 요청이 들어오면 
## 'Second Page'라는 문자를 응답


# 지금 하는 작업들은 요청이 오면 문자열을 리턴.
# 문자열이 아니라 html 파일을 응답.
# flask 라이브러리 안에 있는 render_template 함수를 불러와야된다.
# render_template은 어디서 불러와야되는것인가?
# flask에서 불러와야됩니다. from flask import Flask, render_template

## localhost:5000/html 요청이 들어올때
@app.route("/html")
def html():
    return render_template("index.html")

app.run