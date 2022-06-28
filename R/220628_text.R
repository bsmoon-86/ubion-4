install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", 
                   "bit", "rex", "lazyeval", "htmlwidgets", "crosstalk", 
                   "promises", "later", "sessioninfo", "xopen", "bit64", 
                   "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", "rversions"), type = "binary")
install.packages("multilinguer")
library(multilinguer)
multilinguer::install_jdk()
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never",
                        INSTALL_opts=c("--no-multiarch"))

library(KoNLP)
install.packages("dplyr")
library(dplyr)


## 사전 정보 가져오기 단어 추출하기전 설치를 해야되는 부분
useNIADic()

## 사전 정보 test
extractNoun("조회날짜, 항목코드, 측정소코드, 시간구분을 기준으로 중금속 성분 측정 결과를 2시간 평균, 24시간 평균 측정 수치 자료로 제공하는 서비스")

twitter <- read.csv("twitter.csv", header=T, 
                    fileEncoding = "UTF-8")
twitter <- rename(twitter, 
                  no = 번호, 
                  id = 계정이름, 
                  date = 작성일, 
                  tw = 내용)
head(twitter)

## 특수문자 제거
install.packages("stringr")
library(stringr)

#twitter <- str_replace_all(twitter, "[[:punct:]]", " ")
twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
View(twitter)
nouns <- extractNoun(twitter$tw)

nouns

typeof(nouns)

## table()함수에서 list의 값들의 빈도수 체크가 불가능하여
## unlist() 함수를 이용하여 list 형태는 vactor의 형태로 변경
wordcount <- table(unlist(nouns))
wordcount

## 빈도수 데이터를 데이터프레임의 형태로 변경
df_word <- as.data.frame(wordcount)
View(df_word)

df_word <- rename(df_word, 
                  word = Var1, 
                  freq = Freq)



