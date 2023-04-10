## sql 모듈 생성
## 1. Class 생성 Database()
## 2. Class 생성이 될 때 pymysql.connect()함수를 사용해서 DB의 정보를 입력, cursor 생성
## 3. __init__() 함수를 제외하고 함수 3개를 생성
## 4. execute()함수 -> 매개변수 sql, values를 생성. sql문 실행 -> values 값을 같이 넣어서 실행.
## 5. executeAll()함수 -> 매개변수 sql, values를 생성. sql문 실행 
## -> values 값을 같이 넣어서 실행 ->  결과값 받아와서 데이터프레임으로 변경 후 리턴
## 6. commit() 함수 -> DB에 commit 과정
## 7. execute(), executeAll() 함수에서 매개변수 values 기본값을 [] 빈 리스트 형태로 지정

import pymysql
import pandas as pd

class Database():
    def __init__(self):
        self._db = pymysql.connect(
            host = 'localhost', 
            user = 'root',
            password ='1234',   ## 본인 데이터베이스 비밀번호 
            db = 'ubion',
            port = 3306
        )
        self.cursor = self._db.cursor(pymysql.cursors.DictCursor)

    def execute(self, sql, values=[]):
        self.cursor.execute(sql, values)    ## sql구문 실행
    
    def executeAll(self, sql, values=[]):
        self.cursor.execute(sql, values)
        self.result = self.cursor.fetchall()
        return self.result
    
    def commit(self):
        self._db.commit()                   ## DB에 적용
    
    def close(self):
        self._db.close()

## pd.DataFrame()  -> pandas라이브러리 안에 있는 class를 사용 (class는 이름의 첫글자를 대문자로 표시)
## pd.merge()      -> pandas라이브러리 안에 있는 function를 사용
def test(_x, _y):
    result = _x + _y
    return result
