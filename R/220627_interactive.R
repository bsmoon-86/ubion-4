## 인터렉티브 그래프 
## plotly, dygraghs 패키지가 존재

# plotly 패키지
install.packages("plotly")
library(plotly)
library(ggplot2)
##ggpplotly() 함수 ggplot에서 작업한 그래프를 그대로 대입

a <- ggplot(data = mpg, aes(x = displ, y = hwy, col=drv)) +
  geom_point()

ggplotly(a)

b <- ggplot(data = diamonds, aes(x = cut, fill=clarity))+
  geom_bar(position='dodge')
ggplotly(b)

## dygraghs -> 시계열데이터 그래프 최적화
install.packages("dygraphs")
library(dygraphs)

economics <- ggplot2::economics

## xts 데이터 타입 변경(시계열 데이터)
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)

dygraph(eco) %>% dyRangeSelector()

eco_a <- xts(economics$psavert, order.by = economics$date)
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)
eco_2 <- cbind(eco_a, eco_b)
head(eco_2)

dygraph(eco_2)
