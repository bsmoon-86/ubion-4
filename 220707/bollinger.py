## 볼린저 밴드 생성
def bollinger(data, n):
    df = data.loc[:, ["Close"]].copy()
    df["center"] = df["Close"].rolling(n).mean()
    df["ub"] = df["center"] + 2 * df["Close"].rolling(n).std()
    df["lb"] = df["center"] - 2 * df["Close"].rolling(n).std()
    return df

## 거래 내역 데이터프레임 생성
def create_trade_book(data):
    book = data[["Close"]].copy()
    book["trade"] = ""
    return book

## 거래 내역 데이터 삽입
def trade(data, book):          ## data에는 상단, 하단 밴드 수치가 있는 데이터프레임 삽입
                                ## book에는 거래 내역 데이터프레임 삽입
    for i in data.index:
        if data.loc[i, "Close"] > data.loc[i, "ub"]:    ## 종가가 상단 밴드보다 높은 경우
            book.loc[i, "trade"] = ""
        elif data.loc[i, "lb"] > data.loc[i, "Close"]:    ## 종가가 하단 밴드보다 작은 경우
            book.loc[i, "trade"] = "buy"
        elif data.loc[i, "ub"] >= data.loc[i, "Close"] and data.loc[i, "Close"] >= data.loc[i, "lb"]:  
            ## 상단 밴드와 하단 밴드 사이에 종가가 존재하는 경우
            if book.shift(1).loc[i, "trade"] == "buy":    ## 구매 상태인 경우
                book.loc[i, "trade"] = "buy"
            else:
                book.loc[i, "trade"] = ""

    return book

## 손익 계산
def returns(book):
    rtn = 1.0
    book["return"] = 1
    buy = 0.0
    sell = 0.0
    for i in book.index:
        if book.loc[i, "trade"] == "buy" and book.shift(1).loc[i, "trade"] == "":   ## 구매한 시기
            buy = book.loc[i, "Close"]
            print("진입일 : ", i , "진입 가격 : ", buy)
        elif book.loc[i, "trade"] == "" and book.shift(1).loc[i, "trade"] == "buy": ## 매도한 시기
            sell = book.loc[i, "Close"]
            rtn = (sell - buy) / buy + 1 # 손익 계산
            book.loc[i, "return"] = rtn
            print("청산일 : ", i, "진입 가격 : ", buy, "청산 가격 : ", sell, " | return : ", round(rtn, 4))
        if book.loc[i, "trade"] == "":      ## buy, sell 초기화
            buy = 0.0
            sell = 0.0
    acc_rtn = 1.0
    for i in book.index:
        rtn = book.loc[i, "return"]
        acc_rtn = acc_rtn * rtn  ## 누적 수익률 계산
        book.loc[i, "acc_rtn"] = acc_rtn    ##누적 수익률 컬럼 생성
    print("누적 수익률 : ", round(acc_rtn, 4))
    return (round(acc_rtn, 4)) 