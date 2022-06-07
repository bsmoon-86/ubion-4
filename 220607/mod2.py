def func_1(_x, _y): ## _x부터 _y까지의 합을 구하는 함수 생성
    sum = 0
    for i in range(min(_x, _y), max(_x, _y)+1, 1):
        sum += i
    return sum

class ModClass():
    def __init__(self, _a, _b):
        self.a = _a
        self.b = _b
    def func_2(self):
        return self.a ** self.b