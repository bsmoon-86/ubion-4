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



