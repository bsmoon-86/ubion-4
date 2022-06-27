a <- c(1,2,3,4,5,6,7,8,9) #백터형 데이터
a
b <- array(1:20, dim=c(4,5))
b
c <- matrix(1:10, nrow=2)
c
## 리스트형태의 데이터 python dict형태의 데이터와 흡사
l <- list(name = "test", age = 20, phone="01012345678")
l
l["name"]

## 데이터프레임 형태의 데이터 만들기
df <- data.frame(name = c("test1", "test2"), 
                 age = c(20, 30),
                 phone = c("01012345678", 
                           "01098765432"))
df

a <- matrix(1:10, nrow=2)
b <- matrix(1:10, nrow=5)
a %*% b

c <- 1:3
d <- 2:4
c %in% d

## 연산자를 생성
"%s%" <- function(x, y){
  return ((x+y)^2)
}
1 %s% 5


## 조건문 if를 사용 가능
a <- 10
if (a > 20){
  print("a는 20보다 크다")
}else{
  print("a는 20보다 작거나 같다. ")
}

## which문 : 조건에 해당하는 값의 위치를 출력
## 위치는 1부터 시작
## 조건문에 해당하는 값이 존재하지 않으면 0 출력
name <- c("test", "test2", "test3")
which(name == "test2")
which(name != "test")
which(name == "test5")


## 반복문 for문 사용이 가능
a <- 1:10
for(i in a){
  if(i < 5){
    next
  }
  print(i)
}

## 함수는 함수명 <- function(매개변수){
##    실행이 되는 코드
## }
func_1 <- function(){
  print("Hello R")
}
func_1()

func_2 <- function(x,y){
  return (x+y)
}
func_2(10, 20)

func_3 <- function(x, y=5){
  return (x - y)
}
func_3(10, 2)
func_3(10)

## 인자의 개수가 가변일시 ...으로 매개변수를 선언
## python에서는 인자의 개수가 가변이라면?
## *매개변수명
func_4<- function(x, ...){
  print(x)
  summary(...)
}

v <- 1:10
v2 <- 1:5
v
func_4("test", v)
func_4("test2", v2)




