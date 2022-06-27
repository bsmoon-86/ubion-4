## 지도 시각화 
install.packages("ggiraphExtra")
library(ggiraphExtra)
library(dplyr)
library(ggplot2)
library(tibble)

## 미국 주 별 강력 범죄율
str(USArrests)
head(USArrests)

# tibble 패키지에 있는 rowsnames_to_column을 이용하여
# 인덱스 값의 컬럼의 이름은 부여
crime <- rownames_to_column(USArrests, var = "state")

## state 컬럼의 값들을 소문자로 변경
crime$state <- tolower(crime$state)

head(crime)

##미국의 지역 정보가 담겨있는 패키지
install.packages("maps")
library(maps)

states_map <- map_data("state")
head(states_map)

ggChoropleth(data = crime,   ##지도에 표현할 데이터
             aes(fill = Murder, ##지도를 채울 데이터의 수치
                 map_id = state),  ##지역의 기준 변수
             map = states_map)   ##지도 데이터

ggChoropleth(data = crime,   ##지도에 표현할 데이터
             aes(fill = Murder, ##지도를 채울 데이터의 수치
                 map_id = state),  ##지역의 기준 변수
             map = states_map,
             interactive = T)   

install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
## 한국의 지도 데이터, 인구 수 데이터
library(kormaps2014)
## korpop1 : 시도별 인구 데이터
## kormap1 : 시도별 지도 데이터

str(korpop1)

korpop1 <- rename(korpop1, 
                  pop = 총인구_명, 
                  name = 행정구역별_읍면동)
View(korpop1)

ggChoropleth(data = korpop1, 
             aes(fill = pop, 
                 map_id = code, 
                 tooltip = name),
             map = kormap1, 
             interactive = T)



