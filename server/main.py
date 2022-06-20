## 웹서버 오픈 사용할 라이브러리(flask) import
from flask import Flask, render_template, request, url_for , redirect

# class인 Flask안에 __init__ 함수에는 self를 제외한 매개변수 1개는 존재
app = Flask(__name__)

# localhost:5000/ 에 접속할때 바로 밑에 있는 함수를 실행.
@app.route("/")     
def index():
    return render_template("index.html")      
## localhost:5000/이라는 주소로 서버에 요청을 보내면
## index.html을 렌더링 한다. 

## 회원가입 페이지
@app.route("/signup/")
def signup():
    return render_template("signup.html")
## localhost:5000/signup 이라는 주소로 서버에 요청을 보내면
## signup.html을 렌더링 한다. 

## localhost:5000/signup2로 요청이 들어오는데 요청의 형식이 POST인 경우 (기본은 GET)
@app.route("/signup2/", methods=["GET"])
def signup2():
    ## signup page에서 _id, _pass, _name 받아오는 작업.
    ## post 형식에서는 데이터를 body 라는 곳에 담아서 서버에 요청
    ## get 형식에서는 url에 데이터를 담아서 보낸다. 
    ## 서버와의 요청 방식은 데이터를 딕셔너리 형태로 보내준다. 
    ## GET 형식에서는 request 안에 args 곳에 데이터가 저장
    ## POST 형식에서는 request 안에 form 곳에 데이터가 저장
    _id = request.args["_id"]
    _pass = request.args["_pass"]
    _name = request.args["_name"]
    print(_id, _pass, _name)
    return redirect(url_for('index'))





# ## localhost:5000/second
# @app.route("/second/")
# def second():
#     return "Second Page"
# ## localhost:5000/second 요청이 들어오면 
# ## 'Second Page'라는 문자를 응답



app.run