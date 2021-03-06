## 백터형의 데이터를 데이터프레임으로 만드려면 
## 백터의 길이가 같아야 한다. 

##data.frame()함수를 이용한 데이터프레임 생성
name <- c("A", "B", "C", "D", "E")
grade <- c(1, 3, 2, 1, 2)
student <- data.frame(name, grade)
student

##cbind() 함수를 이용한 데이터프레임 생성
midturm <- c(70, 80, 60, 70, 90)
final <- c(80, 80, 70, 60, 60)
scores <- cbind(midturm, final)
scores

gender <- c("M", "F", "F", "F", "M")

## student -> dataframe
## scores -> dataframe
## gender -> vector

## 데이터프레임을 만드는 경우 
## dataframe과 vector의 형태를 같이 사용이 가능
## 대신 dataframe의 행의 개수와 
## vector의 데이터의 길이가 같아야 한다. 
students <- data.frame(student, gender, scores)
students

## cbind() 함수는 컬럼을 추가하는 함수.
## total_score는 백터 2개의 합. 컬럼x
total_score <- midturm + final
total_score
cbind(students, total_score)
students

## rbind() 함수. 행을 추가하는 함수.
new_student <- data.frame(name = "F", grade = 2, 
                          gender = "M", 
                          midturm = 90, final=80)
new_student
## students에 new_student을 결합(행 추가)
rbind(students, new_student)

## 컬럼의 기준으로 출력 방법
students$name    ## $컬럼명
students[["grade"]]    ## [[컬럼명]]
students[[4]]         ##[[컬럼의 위치]]
students[,"gender"]   ##[행의 수, 열의 컬럼명/위치]

## 인덱스를 기준으로 출력 방법
students[1,]
students[2:5,]
## 인덱스 번호가 음수가 되면 그 번호를 제외한 인덱스가 출력
student[-2,]

## 데이터 프레임 필터링
## []의 인덱스 부분에 조건식을 넣어주게 되면 참이 되는 
## 인덱스를 출력한다. 
students$midturm >= 80
students[students$midturm >= 80, ]

## 오름차순, 내림차순 정렬 방법 order() 함수를 사용
## 오름차순 정렬
order(students$grade) ##인덱스의 값 출력.  백터형
students[order(students$grade),]

## 내림차순 정렬
order(students$midturm, decreasing = TRUE)
order(-students$midturm)
students[order(students$midturm, decreasing = TRUE), ]

## 결측치인 NA 연산 관련
x <- c(7, 9, NA, 5, 2)
x[x>6]
x[x<6]
x[x==7]
subset(x, x>6)
subset(x, x<6)

exam <- read.csv("csv_exam.csv")
## 데이터프레임의 내장함수들 사용
## head()는 데이터프레임에 상단에 6개를 출력
## head(데이터프레임명, 출력될 행의 개수)
head(exam)
head(exam, 3)

##tail()은 데이터프레임에서 하단에 6개를 출력
## head()함수와 사용 방법이 같습니다. 
tail(exam)
tail(exam, 2)

## 데이터프레임을 엑셀의 시트와 같이 보여주는 함수 
## View() : 앞 글자 V는 대문자
View(exam)

## 데이터프레임의 사이즈를 출력 하는 함수 dim()
## 출력 값의 앞의 숫자는 행의 개수 뒤의 숫자는 열의 개수
dim(exam)

## 데이터프레임의 속성 값 확인하는 함수 str()
str(exam)

## table()은 컬럼의 데이터들의 개수를 출력
table(exam$class)

## 통계 요약 정보를 출력하는 함수 summary()
## 데이터프레임을 선택하면 컬럼별로 통계요약 정보가 출력
## 컬럼을 지정하면 해당 컬럼의 통계 요약정보를 출력
summary(exam)
summary(exam$math)

## 패키지 설치 dplyr 
install.packages("dplyr")
## 패키지는 로드(python에서의 import와 같은 기능)
library(dplyr)

df_raw <- data.frame(var1 = c(1,2,1), 
                     var2 = c(2,3,5))
df_raw

#rename() 함수를 이용하여 컬럼의 이름을 변경
rename(df_raw, v2 = var2)

#파생변수를 생성. 
df_raw$sum <- df_raw$var1 + df_raw$var2
df_raw

# 조건문을 이용해서 파생변수 생성
# ifelse(조건식, 참인경우 부여가 될 값, 거짓인경우 부여될 값)
df_raw$total <- ifelse(df_raw$sum > 5, "pass", "fail")
df_raw
# 조건식이 다중인 경우
df_raw$total <- ifelse(df_raw$sum > 5, "pass", 
                       ifelse(df_raw$sum == 5, 
                              "hold", "fail"))
df_raw


exam

# 파이프 연산자 단축키는 Shift + Ctrl + M
# filter() 함수는 필터링 기능을 가진 함수
exam %>% filter(class == 1)

# arrange()함수는 특정 컬럼의 값을 기준으로 정렬하는 함수
exam %>% arrange(math)
# 내림차순 정렬을 하려면 desc()함수를 사용
exam %>% arrange(desc(english))
# 정렬의 기준을 다중으로 사용하려면 ,를 사용하여
# 기준 값을 늘려준다. 
exam %>% arrange(math, english)
exam %>% arrange(desc(class), math)
exam %>% arrange(-class, math)

# 특정 컬럼을 출력을 하는 함수 select()
exam %>% select(class)
exam %>% select(class, math)
# 특정 컬럼만 제거
exam %>% select(-class)

#컬럼의 범위 지정
exam %>% select(math:science)

# 새로운 컬럼을 추가하는 함수 mutate()
exam %>% mutate(total = math + english + science, 
                mean = (math + english + science)/3)

# group_by() summarise() 동시 사용
exam %>% group_by(class) %>% 
  summarise(math_mean = mean(math), 
            english_mean = mean(english))

# join() 함수를 사용
data.frame(id = 1:5, score = c(60,70,80,90,95)) -> df_1
df_2 <- data.frame(id = 1:5, weight=c(80,70,75,65,60))
df_3 <- data.frame(id = 1:3, class = c(1,1,2))

#inner_join
inner_join(df_1, df_2, by="id")
inner_join(df_1, df_3, by="id")
#left_join
left_join(df_1, df_2, by="id")
left_join(df_1, df_3, by="id")
#right_join
right_join(df_1, df_2, by="id")
right_join(df_1, df_3, by="id")
#full_join
full_join(df_1, df_3, by="id")
full_join(df_1, df_2, by="id")

#bind_rows() 데이터의 행을 추가하는 함수 
#데이터프레임 단순 결합

a <- df_1
b <- df_2
bind_rows(a, b)
c <- data.frame(id= c(7,8,10), score=c(100, 80, 50))
bind_rows(a, c)

c1 <- c(1,2,NA,NA,5)
c2 <- c(1,2,3,4,5)
c3 <- c(NA,2,3,4,5)
df <- data.frame(c1, c2, c3)
df
#is.na()는 결측치는 True 결측치가 아니면 False를 출력
is.na(df)
#is.na()와 table()를 같이 사용하면 결측치의 개수를 확인
table(is.na(df))
table(df$c1)
#is.na() 앞에 부정의 표시 `!`를 사용하면 True는 False로
# False는 True로 변환
!is.na(df)
table(is.na(df$c1))
table(is.na(df$c2))
table(is.na(df$c3))

#결측치를 제거하는 방법 1
#필터링을 이용한 결측치 제거
df %>% filter(is.na(c1))
df %>% filter(!is.na(c1))
#na.omit() 행에 결측치가 하나라도 존재하면 그 행을 삭제
na.omit(df)

# 결측치가 존재하면 연산이 되질 않는다. 
# na.rm = T를 이용하여 결측치를 제외하고 연산을 한다. 
mean(df$c1)
sum(df$c1)
mean(df$c1, na.rm = T)
sum(df$c1, na.rm = T)

#exam 데이터프레임에 결측치 추가
exam[c(5,7), 3] = NA
exam

#결측치에 특정 한 값을 대체
table(is.na(exam$math))
# mean(exam$math) NA를 포함하고 있기 때문에 연산이 X
# NA값이 들어가게 됩니다. 
# 결측치의 대체가 안되는 코드
exam$math <- ifelse(is.na(exam$math), 
                    mean(exam$math), exam$math)
table(is.na(exam$math))
# 결측치가 존재하는 컬럼에서 연산을 하려면 
# na.rm = T 를 이용하여 연산 코드를 실행.
exam$math <- ifelse(is.na(exam$math), 
                    mean(exam$math, na.rm = T), exam$math)
table(is.na(exam$math))
exam

#이상치 데이터프레임 만들기 
outlier <- data.frame(gender = c(1,2,1,3,2,1),
                      score = c(60,70,30,40,80,90))
# 이상치를 체크
table(outlier$gender)

# 이상치를 제거 ifelse를 이용하여 이상치를 NA 변환
outlier$gender <- ifelse(outlier$gender == 3, NA, 
                         outlier$gender)
# 이상치의 값이 NA 변환 됬는지 확인
table(is.na(outlier$gender))

# 이상치를 제외한 성별 점수 평균 구하기
outlier %>% filter(!is.na(gender)) %>% 
  group_by(gender) %>% 
  summarise(score_mean = mean(score))

library(ggplot2)
mpg
View(mpg)

mpg <- ggplot2::mpg
#극단치 확인 박스 플롯 그래프
boxplot(mpg$hwy)
# 박스 플롯 그래프의 수치를 출력(극단치의 경계를 체크)
boxplot(mpg$hwy)$stats
table(is.na(mpg$hwy))

# 극단치를 ifelse를 이용하여 제거.
mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy >37, 
                  NA, mpg$hwy)
table(is.na(mpg$hwy))

# mpg 데이터에서 hwy기준으로 결측치가 아닌 값을 필터링
# manufacturer를 기준으로 그룹화
# hwy의 평균 값을 출력 
# (dplyr 패키지를 사용해서 한줄로 처리)
mpg %>% filter(!is.na(hwy)) %>% 
  group_by(manufacturer) %>% 
  summarise(hwy_mean = mean(hwy))

mpg %>% group_by(manufacturer) %>% 
  summarise(hwy_mean = mean(hwy, na.rm=T))









