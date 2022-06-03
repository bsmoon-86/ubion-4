from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/") #web -> address(url), localhost:5000/
def index():
    return "Hello World"

#localhost:5000/second로 접속시 바로 아래 함수가 실행
@app.route("/second")  
def second():
    return "Second page"

@app.route("/img")
def img():
    return render_template("index.html")

#localhost:5000/login 접속(request) -> login.html을 rendering한다. 
@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/login2")
def login2():
    _id = request.args.get("id")
    _pass = request.args.get("pass")
    print(request.form)
    if _id == "test" and _pass == "1234":
        return "로그인 성공"
    else :
        return "로그인 실패"
## id = test, pass = 1234인 경우 로그인 성공 메시지
## 아니면 로그인 실패 메시지
app.run