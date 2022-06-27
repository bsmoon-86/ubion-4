## .sav 파일 로드하기 위한 패키지 설치
install.packages("foreign")
install.packages("readxl")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

## 한국복지패널 데이터
raw_welfare <- read.spss(file = "Koweps_hpc10_2015_beta1.sav", 
                         to.data.frame = T)
View(raw_welfare)
dim(raw_welfare)
head(raw_welfare, 1)

## 복사본 생성
welfare <- raw_welfare

welfare <- rename(welfare, 
                  gender = h10_g3, 
                  birth = h10_g4, 
                  marriage = h10_g10, 
                  religion = h10_g11, 
                  income = p1002_8aq1, 
                  code_job = h10_eco9, 
                  code_region = h10_reg7)

## 성별에 따른 월급의 차이가 존재하는지 
## 데이터를 시각화하여 확인

## 성별에 이상치가 존재하는지 확인
## 이상치를 체크할때 사용될 함수? table()
table(welfare$gender)

## gender 컬럼은 1은 남자 2는 여자 9는 무응답
## 이상치 제거 
welfare$gender <- ifelse(welfare$gender == 9, NA, welfare$gender)

## 결측치 확인
table(is.na(welfare$gender))

## gender의 값을 1은 male, 2는 female 변경
welfare$gender <- ifelse(welfare$gender == 1, "male", "female")

table(welfare$gender)

## 성별 데이터를 그래프 출력
qplot(welfare$gender)

## 월급에 대한 통계요약 정보 출력
summary(welfare$income)

## 월급이 0, 9999 데이터를 결측치로 변경

#case1
welfare$income <- ifelse(welfare$income == 0, NA, 
                         ifelse(welfare$income == 9999, NA, welfare$income))
#case2
welfare$income <- ifelse(welfare$income == 0 | welfare$income == 9999, 
                         NA, welfare$income)
#case3
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

#결측치 확인
table(is.na(welfare$income))

## 성별에 따른 월급의 차이가 있는가?
## 결측치는 제외
## 성별로 그룹화
## 월급의 평균
## 시각화

gender_income <- welfare %>% 
  filter(!is.na(income)) %>%             ## 결측치 제외
  group_by(gender) %>%                   ## 성별로 그룹화
  summarise(income_mean = mean(income))  ## 그룹화된 데이터 평균 값 출력

gender_income

ggplot(data=gender_income, aes(x = gender, y = income_mean)) + 
  geom_col()

## 나이에 따른 월급의 차이가 존재하는가?
## 컬럼중에 나이 컬럼이 존재하지 않는다. 
## 파생변수 age 생성.
## welfare 데이터에 새로운 컬럼 age를 생성
## birth컬럼은 출생년도
## 나이는 현재 년도 - 출생 년도
table(welfare$birth)

## 이상치를 제거 (출생년도가 현재년도보다 크면 이상치)
welfare$birth <- ifelse(welfare$birth > 2022, NA, 
                        welfare$birth)
table(is.na(welfare$birth))

## age 파생변수 생성
welfare$age <- 2022 - welfare$birth
summary(welfare$age)
qplot(welfare$age)

## 나이별 월급이 어떤가 확인.
## 월급, 나이의 결측치를 제거
## 나이를 기준으로 그룹화
## 월급의 평균
## 시각화

age_income <- welfare %>% 
  filter(!is.na(income) & !is.na(age)) %>% 
  group_by(age) %>% 
  summarise(income_mean = mean(income))
age_income
# 바 그래프로 표시
ggplot(data = age_income, aes(x = age, y = income_mean)) + 
  geom_col()
# 라인 그래프 표시
ggplot(data = age_income, aes(x = age, y = income_mean)) + 
  geom_line()

## 나이 컬럼을 연령대 파생변수
## 나이가 30세 미만 'young'
## 30세 이상 - 60세 미만 'middle'
## 60세 이상 'old'
## 새로운 컬럼은 ageg 생성
## 연령대별 월급의 평균은 출력, 시각화 (막대 그래프)

welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30, 'young', 
                       ifelse(age < 60, 'middle', 'old')))
table(welfare$ageg)

## 연령대별 평균 월급 출력
## 월급 컬럼의 결측치 제거
## 연령대로 그룹화
## 월급 평균
ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(income_mean = mean(income))
ageg_income

ggplot(data = ageg_income, aes(x = ageg, y = income_mean)) +
  geom_col() + 
  scale_x_discrete(limits = c('young', 'middle', 'old'))

## 연령대 컬럼 존재, 성별 컬럼 존재
## 연령대별 성별 평균 월급 출력

ageg_gender_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, gender) %>% 
  summarise(income_mean = mean(income))
ageg_gender_income

ggplot(data = ageg_gender_income, 
       aes(x= ageg, y= income_mean, fill=gender)) +
  geom_col(position = 'dodge') +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

## 직업별로 평균 월급

table(welfare$code_job)
## welfare 데이터프레임에는 code_job 부분은 존재하지만
## job은 존재하지 않는다. 
## Codebook 파일을 이용하여 job 파생변수를 생성

## readxl 패키지를 이용하여 엑셀 파일을 로드 
## sheet 2번에 직업 이름 존재
## col_names 은 컬럼의 이름이 존재한다. 
list_job <- read_excel("Koweps_Codebook.xlsx", sheet=2,
                       col_names = T)
head(list_job)

## welfare와 list_job 결합. (join을 이용하여)
## job 컬럼을 기준으로 평균 월급 출력
## 상위 10개의 직업의 평균 월급의 값을 출력하고 
## 막대 그래프로 표시 
table(is.na(welfare$code_job))

## left_join()데이터프레임 2개를 결합
welfare <- left_join(welfare, list_job, by="code_job")
## 결합을 확인
welfare %>% filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(5)

## code_job에 NA가 아니면
## 월급도 NA가 아니면 
## job을 기준으로 그룹화
## 평균 월급

job_income <- welfare %>% 
  filter(!is.na(code_job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income))

job_income

## 월급 상위 10개의 직업을 추출하려면
## 평균 월급을 내림차순 정렬
## 상위 10개 출력
top10 <- job_income %>% 
  arrange(desc(income_mean)) %>% 
  head(10)
top10

## reorder 함수를 이용하여 x축 순서 변경
## coord_flip() 옵션을 추가하여 막대 그래프 90도 회전
ggplot(data = top10, aes(x = reorder(job, income_mean), 
                         y=income_mean)) + geom_col() +
                        coord_flip()

