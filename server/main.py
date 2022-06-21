## 웹서버 오픈 사용할 라이브러리(flask) import
import mod_sql
import random
from io import BytesIO
import pandas as pd
import matplotlib.pyplot as plt
from flask import Flask, render_template, request, send_file, url_for , redirect

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
    sql = """
        INSERT INTO user VALUES (%s, %s, %s)
    """
    values = [_id, _pass, _name]
    _db = mod_sql.Database()    ## mod_sql에 있는 클래스 선언
    _db.execute(sql, values)
    _db.commit()
    _db.close()
    # print(_id, _pass, _name)
    return redirect(url_for('index'))

@app.route("/signin", methods=["POST"])
def signin():
    _id = request.form["_id"]
    _pass = request.form["_pass"]
    print(_id, _pass)
    sql = """
        SELECT * FROM user WHERE id = %s AND pass = %s
    """
    values = [_id, _pass]
    _db = mod_sql.Database()
    result = _db.executeAll(sql, values)
    ## sql문 실행시 조건식이 거짓이라면 결과의 길이가 0
    ## 조건이 참이면 결과는 1개. -> id값이 primary key

    if result:
        return render_template("main.html")
    else:
        return redirect(url_for('index'))
    # return redirect(url_for('index'))

@app.route("/game", methods=["POST"])
def game():
    ## 리스트의 있는 값들 중에 랜덤하게 하나를 출력을 하는 라이브러리
    ## random 라이브러리 
    ## 상단에 random 라이브러리 import
    _use = request.form["_use"]
    list_ = ["가위", "바위", "보"]
    choicelist = random.choice(list_)
    if _use == choicelist:
        return "무승부"
    if _use == "가위":
        if choicelist == "바위":
            return "패배"
        else:
            return "승리"
    elif _use == "바위":
        if choicelist == "보":
            return "패배"
        else:
            return "승리"
    else:
        if choicelist == "가위":
            return "패배"
        else:
            return "승리"

@app.route("/corona")
def corona():
    df = pd.read_csv('./csv/corona.csv')
    df.columns = ["인덱스", "등록일시", "사망자", 
                "확진자", "게시글번호", "기준일", 
                "기준시간", "수정일시", "누적의심자", 
                "누적확진률"]
    df.sort_values("등록일시", inplace=True)
    df["일일사망자"] = df["사망자"].diff().fillna(0)
    decide_data = df["일일사망자"].tolist()
    plt.plot(decide_data)
    img = BytesIO()
    plt.savefig(img, format="png", dpi=200)
    img.seek(0)

    return send_file(img, mimetype='image/png')

@app.route("/graph")
def graph():
    df = pd.read_csv('./csv/corona.csv')
    df.columns = ["인덱스", "등록일시", "사망자", 
                "확진자", "게시글번호", "기준일", 
                "기준시간", "수정일시", "누적의심자", 
                "누적확진률"]
    df.sort_values("등록일시", inplace=True)
    df["일일사망자"] = df["사망자"].diff().fillna(0)
    decide_data = df["일일사망자"].head(10).tolist()
    date_list = df["등록일시"].head(10).tolist()
    cnt = len(date_list)
    print(cnt)
    # return render_template("graph.html")
    return render_template("dashboard.html", decide = decide_data, 
    date_list = date_list, cnt=cnt)

# ## localhost:5000/second
# @app.route("/second/")
# def second():
#     return "Second Page"
# ## localhost:5000/second 요청이 들어오면 
# ## 'Second Page'라는 문자를 응답



app.run