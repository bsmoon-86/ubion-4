install.packages("remotes")
install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", 
                   "bit", "rex", "lazyeval", "htmlwidgets", "crosstalk", 
                   "promises", "later", "sessioninfo", "xopen", "bit64", 
                   "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", "rversions"), type = "binary")
install.packages("multilinguer")
library(multilinguer)
multilinguer::install_jdk()

remotes::install_github('haven-jeon/KoNLP', upgrade = "never",
                        INSTALL_opts=c("--no-multiarch"))
library(KoNLP)
install.packages("dplyr")
library(dplyr)

useNIADic()

##테스트
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다.")


install.packages("stringr")
library(stringr)

txt <- readLines("hiphop.txt")
head(txt)

# 특수문자 제거
txt <- str_replace_all(txt, "[[:punct:]]", " ")

# 가사에서 명사를 추출
nouns <- extractNoun(txt)

# 추출한 리스트를 문자열 백터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터의 형태는 데이터프레임으로 변경
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 컬럼의 이름을 변경
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 글자 수를 2개 이상인것만 출력
df_word <- filter(df_word, nchar(word) >= 2)

top_20 <- df_word %>%
  arrange(desc(freq)) %>%
  head(20)

top_20

# 워드클라우드 설치
install.packages("wordcloud")

# 패키지 로드
library(RColorBrewer)
library(wordcloud)

# Dark2 색상 목록에서 8개를 추출
pal <- brewer.pal(8,"Dark2")  
pal
# 난수는 랜덤하게 제작되는데 그것을 고정하는데 사용
set.seed(1234)

wordcloud(words = df_word$word,  # 단어
          freq = df_word$freq,   # 빈도
          min.freq = 2,          # 최소 단어 빈도
          max.words = 200,       # 표현 단어의 수
          random.order = F,      # 고빈도 단어의 중앙 배치
          rot.per = .1,          # 회전 단어의 비율
          scale = c(4, 0.3),     # 단어 크기의 범위
          colors = pal)          # 색상 목록

pal <- brewer.pal(9,"Blues")[5:9]  # blue 색상 목록에서 9개를 추출하여 5번째 에서 9번째까지 추출
pal
set.seed(1234)                     # 난수 고정

wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 2,            # 최소 단어 빈도
          max.words = 200,         # 표현 단어의 수
          random.order = F,        # 고빈도 단어의 중앙 배치
          rot.per = .1,            # 회전 단어의 비율
          scale = c(4, 0.3),       # 단어 크기의 범위
          colors = pal)            # 색상 목록

