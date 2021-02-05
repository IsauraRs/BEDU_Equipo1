#Postwork Sesión 06

#Importe el conjunto de datos match.data.csv a R y realice lo siguiente:
#Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
#Obtén el promedio por mes de la suma de goles.


library(dplyr)
match.data <- read.csv("match.data.csv")

newCol <- match.data %>%
    mutate(date = as.Date(date, "%Y-%m-%d"),
    sumagoles = home.score + away.score) %>%
    mutate(fechas = format(date, "%Y-%m")) %>%
    group_by(fechas) %>% 
    summarise(goles.mean = mean(sumagoles))

sumagoles <- as.data.frame(newCol)
sumagoles <- sumagoles %>% filter(fechas != "2010-08")

#Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
#Grafica la serie de tiempo. 
mes.mean <- ts(sumagoles$goles.mean, start = 1, frequency = 12)
ts.plot(mes.mean)