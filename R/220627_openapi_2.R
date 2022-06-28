## XML 데이터를 수정을 하기 위한 패키지
install.packages("XML")
library(XML)

# 접속 주소 변수
# 환경부 국립환경과학원 미세먼지 데이터 
# 필수 항목은 서비스 키
url <- "http://apis.data.go.kr/1480523/MetalMeasuringResultService/MetalService"

#서비스키
servicekey <- "dtbWOdJ%2FCz5HE0DGLU%2BCRPe7pOW0NIQBUcGEqsHZaTRiYCI%2F5%2BzugwzQjcvuId7NPdg6rUiW%2Bft3fm7yqyD4pw%3D%3D"



service_url <- paste0(url,
                      "?serviceKey=", servicekey)
service_url

xmlDocument <- xmlTreeParse(service_url, 
                            useInternalNodes = TRUE, 
                            encoding = "UTF-8")
xmlDocument

## xml root node 확인
rootnode <- xmlRoot(xmlDocument)
rootnode

## 페이지당 데이터의 개수를 출력
rows <-xpathSApply(rootnode, '//numOfRows', xmlValue)

## 전체 데이터의 개수
total_rows <- xpathSApply(rootnode, '//totalCount', xmlValue)
total_rows

# 페이지당 데이터의 개수 전체데이터의 개수 나누면 
# 몇번 불러와야 전체 데이터를 가지고 올수 있는지 확인 가능
# rows, total_rows 데이터가 문자형태
typeof(total_rows)
# 숫자의 형태로 변경하고 연산.
rows <- as.numeric(rows)
total_rows <- as.numeric(total_rows)

loopcount <- ceiling(total_rows/rows)
loopcount
# 결과 값들은 결합할 비어있는 데이터프레임 생성
Total_data <- data.frame()

for (i in 1:2){
  service_url <- paste0(url,
                        "?serviceKey=", servicekey,
                        "&pageNo=", i)
  ## xml 형태의 데이터를 10번 반복해서 받는다.
  document <- xmlTreeParse(service_url, 
                           useInternalNodes = TRUE, 
                           encoding= "UTF-8")
  #  rootnode 확인
  rootnode <- xmlRoot(document)
  
  # item 태그안에 있는 값들을 호출
  node <- getNodeSet(rootnode, '//item')
  
  # xml데이터를 데이터프레임을 변경
  df_node <- xmlToDataFrame(node)
  
  #Total_data라는 데이터프레임에 df_node데이터프레임을 결합
  Total_data <- rbind(Total_data, df_node)
}
dim(Total_data)
View(Total_data)
write.csv(Total_data, "미세먼지.csv", row.names = F)











