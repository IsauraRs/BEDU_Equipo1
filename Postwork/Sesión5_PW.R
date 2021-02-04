#Postwork Sesión 05

# A partir del conjunto de datos de soccer de
# la liga española de las temporadas 2017/2018, 2018/2019 
# y 2019/2020, crea el data frame SmallData, que contenga 
# las columnas date, home.team, home.score, away.team y 
# away.score; esto lo puedes hacer con ayuda de la función 
# select del paquete dplyr. Luego crea un directorio de trabajo 
# y con ayuda de la función write.csv guarde el data frame como 
#un archivo csv con nombre soccer.csv. Puedes colocar como 
#argumento row.names = FALSE en write.csv.

#install.packages("fbRanks")

library(dplyr)
library(fbRanks)

data.1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
data.1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
data.1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

data.1718 <- read.csv(file = data.1718)
data.1819 <- read.csv(file = data.1819)
data.1920 <- read.csv(file = data.1920)

data.List <- list(data.1718, data.1819, data.1920)
data.selectList <- lapply(data.List, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

lapply(data.selectList, str)

data.selectList[[1]] <- mutate(data.selectList[[1]], Date = as.Date(Date, "%d/%m/%y"))
data.selectList[[2]] <- mutate(data.selectList[[2]], Date = as.Date(Date, "%d/%m/%y"))
data.selectList[[3]] <- mutate(data.selectList[[3]], Date = as.Date(Date, "%d/%m/%y"))

lapply(data.selectList, str)

data.finalList <- do.call(rbind, data.selectList)

smallData <- select(data.finalList, date = Date, home.Team = HomeTeam, home.Score = FTHG, away.Team = AwayTeam, away.Score = FTAG)
write.csv(x = smallData, file = "soccer.csv", row.names = FALSE)

#Con la función create.fbRanks.dataframes del paquete fbRanks importa el 
#archivo soccer.csv a R y al mismo tiempo asignarlo a una variable llamada 
#listasoccer. Se creará una lista con los elementos scores y teams que son 
#data frames listos para la función rank.teams. Asigna estos data frames a variables 
#llamadas anotaciones y equipos.
#?create.fbRanks.dataframes

listasoccer <- create.fbRanks.dataframes(scores.file = "soccer.csv")
anotaciones <- listasoccer$scores
equipos <- listasoccer$teams

#Con ayuda de la función unique crea un vector de fechas (fecha) que no 
#se repitan y que correspondan a las fechas en las que se jugaron partidos. 
#Crea una variable llamada n que contenga el número de fechas diferentes. 
#Posteriormente, con la función rank.teams y usando como argumentos los data frames 
#anotaciones y equipos, crea un ranking de equipos usando únicamente datos desde la 
#fecha inicial y hasta la penúltima fecha en la que se jugaron partidos, estas fechas 
#las deberá especificar en max.date y min.date. Guarda los resultados con el nombre ranking.

fecha <- unique(anotaciones$date)
n <- length(fecha)
ranking <- rank.teams(scores = anotaciones, teams = equipos, max.date = fecha[n-1], min.date = fecha[1])

#Finalmente estima las probabilidades de los eventos, el equipo de casa gana, 
#el equipo visitante gana o el resultado es un empate para los partidos que se 
#jugaron en la última fecha del vector de fechas fecha. Esto lo puedes hacer con 
#ayuda de la función predict y usando como argumentos ranking y fecha[n] que deberá 
#especificar en date.

predicciones <- predict(ranking, date = fecha[n])