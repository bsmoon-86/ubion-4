# ggplot2 패키지를 설치
install.packages("ggplot2")
# ggplt2 패키지를 로드
library(ggplot2)
library(dplyr)

## 산점도 그래프

#배경 레이어만 설정
ggplot(data = mpg, aes(x = displ, y = hwy))

#그래프 레이어 추가 
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()

# 그래프에서 x축의 범위 지정
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + 
  xlim(3,6)

# 그래프에서 y축의 범위 지정
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + 
  xlim(3,6) + ylim(10, 20)


# 막대그래프 
mpg <- ggplot2::mpg
mpg2 <- mpg %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))
mpg2

# geom_col()함수를 이용한 막대 그래프 
# x축과 y축의 데이터가 필요
ggplot(data=mpg2, aes(x = drv, y = mean_hwy)) + 
  geom_col()

# 데이터의 크기에 따라 막대의 순서를 변경

# 오름차순으로 변경
ggplot(data=mpg2, aes(x = reorder(drv, mean_hwy), 
                      y = mean_hwy)) + geom_col()
# 내림차순으로 변경
ggplot(data=mpg2, aes(x = reorder(drv, -mean_hwy), 
                      y = mean_hwy)) + geom_col()


# geom_bar()를 이용하여 막대 그래프 출력
table(mpg$drv)
# 컬럼의 데이터의 개수를 막대의 크기로 표현하여 출력
ggplot(data=mpg, aes(x = drv)) + geom_bar()

View(economics)
# 라인 그래프 
# geom_line()를 사용하여 라인 그래프를 출력
ggplot(data = economics, aes(x = date, y = unemploy)) +
  geom_line()

# 박스 플롯
# geom_boxplot()
ggplot(data=mpg, aes(x = drv, y = hwy)) + geom_boxplot()



