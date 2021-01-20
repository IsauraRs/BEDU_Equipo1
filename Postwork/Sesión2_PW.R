#Postwork sesión 02

#Importa los datos de soccer de las temporadas 2017/2018, 
#2018/2019 y 2019/2020 de la primera división de la liga española 
#a R, los datos los puedes encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php

data.1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
data.1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
data.1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

data.1718 <- read.csv(file = data.1718)
data.1819 <- read.csv(file = data.1819)
data.1920 <- read.csv(file = data.1920)

#Obtén una mejor idea de las características de los data 
#frames al usar las funciones: str, head, View y summary

#17-18
str(data.1718)
head(data.1718)
View(data.1718)
summary(data.1718)

#18-19
str(data.1819)
head(data.1819)
View(data.1819)
summary(data.1819)

#19-20
str(data.1920)
head(data.1920)
View(data.1920)
summary(data.1920)

#Con la función select del paquete dplyr selecciona únicamente 
#las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR; esto para cada uno de los data frames. (Hint: también puedes usar lapply).

library("dplyr")

data.List <- list(data.1718, data.1819, data.1920)
data.selectList <- lapply(data.List, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Asegúrate de que los elementos de las columnas correspondientes de los nuevos data frames sean 
#del mismo tipo (Hint 1: usa as.Date y mutate para arreglar las fechas). Con ayuda de la función rbind 
#forma un único data frame que contenga las seis columnas mencionadas en el punto 3 (Hint 2: la función do.call podría ser utilizada).

data.selectList[[1]] <- mutate(data.selectList[[1]], Date = as.Date(Date, "%d/%m/%y"))
data.selectList[[2]] <- mutate(data.selectList[[2]], Date = as.Date(Date, "%d/%m/%y"))
data.selectList[[3]] <- mutate(data.selectList[[3]], Date = as.Date(Date, "%d/%m/%y"))

data.finalList <- do.call(rbind, data.selectList)
