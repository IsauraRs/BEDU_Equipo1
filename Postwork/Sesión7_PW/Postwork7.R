#Importamos las librerias
library(RMongo)
library(mongolite)
library(dplyr)

#Establecemos el Directorio de Trabajo
setwd("C:\\Users\\kevin\\Desktop\\Sesion-07\\Postwork")
dir()

#Leemos el dataset SP1 (Primera Division Espanola 2015/2016)
datas1 <- data.frame(read.csv("SP1.csv"))
View(datas1)

#Leemos el dataset match.data.csv del postwork
datas2 <- data.frame(read.csv("match.data.csv"))
View(datas2)

#Modificamos datas1 para que sea parecido a datas2
#creamos un vector con el nombre de las columnas que se conservaran
columnNames <- c("Date", "HomeTeam","AwayTeam","FTHG","FTAG")
#Eliminamos las columas que no esten en columnNames
datas1 <- datas1[, (names(datas1) %in% columnNames)]
#Cambiamos los nombres de las columnas
names(datas1) <- c("date","home.team","away.team","home.score","away.score")
#Cambiamos las columnas de lugar
datas1 <- datas1[, c(1,2,4,3,5)]

#Unimos ambos dataframes
footballDataset <- rbind(datas1,datas2)
View(footballDataset)

#Creamos el csv (Opcional)
write.csv(footballDataset, file = "football.match.csv")

#Creamos una conexion a la bd
connection <- mongo(collection="match", db="match_games")
#Insertamos los datos
connection$insert(footballDataset)
#Count
connection$count()#4180 registros

#Al hacer la consulta en MongoDb obtenemos que
#el Real Madrid gano 10-2 contra el Vallecano

