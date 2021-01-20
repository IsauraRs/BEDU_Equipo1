#Postwork sesión 03

#Con el último data frame obtenido en el postwork de la sesión 2, elabora tablas de frecuencias relativas para estimar 
#las siguientes probabilidades:

#Data frame de la sesión 2

data.1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
data.1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
data.1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

data.1718 <- read.csv(file = data.1718)
data.1819 <- read.csv(file = data.1819)
data.1920 <- read.csv(file = data.1920)

data.List <- list(data.1718, data.1819, data.1920)
data.selectList <- lapply(data.List, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

data.selectList[[1]] <- mutate(data.selectList[[1]], Date = as.Date(Date, "%d/%m/%y"))
data.selectList[[2]] <- mutate(data.selectList[[2]], Date = as.Date(Date, "%d/%m/%y"))
data.selectList[[3]] <- mutate(data.selectList[[3]], Date = as.Date(Date, "%d/%m/%y"))

data.finalList <- do.call(rbind, data.selectList)

home <- data.finalList$FTHG
visitor <- data.finalList$FTAG

#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)

(P.home<- (table(home)/dim(data.finalList)[1]))

#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)

(P.visitor <- (table(visitor)/dim(data.finalList)[1]))

#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

(P.conjunta <- (table(home, visitor)/dim(data.finalList)[1]))

P.home <- as.data.frame(P.home)
P.visitor <- as.data.frame(P.visitor)

#Realiza lo siguiente:

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa

home.plot <- ggplot(P.home, aes(x = home, y = Freq)) + geom_bar(stat = "identity") + ggtitle('Goles del equipo de casa')

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.

visitor.plot <- ggplot(P.visitor, aes(x = visitor, y = Freq)) + geom_bar(stat = "identity") + ggtitle('Goles del equipo visitante')

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

library("reshape2")

P.conjunta <- melt(P.conjunta)

P.conjunta %>% ggplot(aes(home, visitor)) + geom_tile(aes(fill = value)) + ggtitle("Probabiliades conjuntas") 
 