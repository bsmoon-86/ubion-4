#install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", 
#                   "bit", "rex", "lazyeval", "htmlwidgets", "crosstalk", 
#                   "promises", "later", "sessioninfo", "xopen", "bit64", 
#                   "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", "rversions"), type = "binary")
#install.packages("multilinguer")
library(multilinguer)
multilinguer::install_jdk()
#install.packages("remotes")
#remotes::install_github('haven-jeon/KoNLP', upgrade = "never",
                        INSTALL_opts=c("--no-multiarch"))

library(KoNLP)
#install.packages("dplyr")
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
#install.packages("stringr")
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
typeof(df_word$word)
## word 컬럼의 값이 숫자형에서 문자형 변경
df_word$word <- as.character(df_word$word)
## nchar()글자의 수를 출력
## 글자의 수가 2개 이상인 경우만 보여주겠다
df_word <- filter(df_word, nchar(word) >= 2)

## 워드클라우드 설치
#install.packages("wordcloud")

## 워드클라우드 로드
library(RColorBrewer)
library(wordcloud)

## Dark2 색상목록 이중에서 8개를 출력
pal <- brewer.pal(8, "Dark2")
pal

# 난수를 랜덤하게 생성. 시드를 지정하면 랜덤이 고정
set.seed(1234)
wordcloud(words = df_word$word, 
          freq = df_word$freq, 
          min.freq = 2, 
          random.order = F, 
          max.words = 200, 
          rot.per = .1, 
          scale = c(4, 0.5), 
          color = pal)

