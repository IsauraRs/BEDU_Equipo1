LigaEspanola.1raDiv.2017.2018 <- read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
LigaEspanola.1raDiv.2018.2019 <- read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
LigaEspanola.1raDiv.2019.2020 <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
library(dplyr)
Lista.LigaEspanola.1raDiv.2017.2020 <- list(LigaEspanola.1raDiv.2017.2018,LigaEspanola.1raDiv.2018.2019,LigaEspanola.1raDiv.2019.2020)
Lista.LigaEspanola.1raDiv.2017.2020 <- lapply(Lista.LigaEspanola.1raDiv.2017.2020, select,Date,HomeTeam:FTR)
Lista.LigaEspanola.1raDiv.2017.2020[1] <- lapply(Lista.LigaEspanola.1raDiv.2017.2020[1], mutate,Date=as.Date(Date,"%d/%m/%y"))
Lista.LigaEspanola.1raDiv.2017.2020[2:3] <- lapply(Lista.LigaEspanola.1raDiv.2017.2020[2:3], mutate,Date=as.Date(Date,"%d/%m/%Y"))
LigaEspanola.1raDiv.2017.2020 <- do.call(rbind,Lista.LigaEspanola.1raDiv.2017.2020)
Goles.LigaEspanola.1raDiv.2017.2020 <- data.frame(Casa=LigaEspanola.1raDiv.2017.2020$FTHG,Visitante=LigaEspanola.1raDiv.2017.2020$FTAG)
Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020 <- table(Goles.Casa=Goles.LigaEspanola.1raDiv.2017.2020$Casa,Goles.Visitante=Goles.LigaEspanola.1raDiv.2017.2020$Visitante)
Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020 <- addmargins(Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020)
Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020 <- Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020/dim(Goles.LigaEspanola.1raDiv.2017.2020)[1]
Frecuencia.Goles.Casa.LigaEspanola.1raDiv.2017.2020 <- filter(select(filter(as.data.frame(Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020),Goles.Visitante=="Sum"),-Goles.Visitante),Goles.Casa!="Sum")
Frecuencia.Goles.Visitante.LigaEspanola.1raDiv.2017.2020 <- filter(select(filter(as.data.frame(Tabla.Frecuencia.Goles.LigaEspanola.1raDiv.2017.2020),Goles.Casa=="Sum"),-Goles.Casa),Goles.Visitante!="Sum")


#Ya hemos estimado las probabilidades conjuntas de que el equipo de casa anote X=x goles (x=0,1,... ,8), y el equipo visitante anote Y=y goles (y=0,1,... ,6), en un partido. Obtén una tabla de cocientes al dividir estas probabilidades conjuntas por el producto de las probabilidades marginales correspondientes.
Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020 <- table(Goles.Casa=Goles.LigaEspanola.1raDiv.2017.2020$Casa,Goles.Visitante=Goles.LigaEspanola.1raDiv.2017.2020$Visitante)
Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020 <- Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020/dim(Goles.LigaEspanola.1raDiv.2017.2020)[1]
for (i in 1:which.max(Frecuencia.Goles.Casa.LigaEspanola.1raDiv.2017.2020$Goles.Casa)) {
  for(j in 1:which.max(Frecuencia.Goles.Visitante.LigaEspanola.1raDiv.2017.2020$Goles.Visitante)){
    Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020[i,j]=Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020[i,j]/(Frecuencia.Goles.Casa.LigaEspanola.1raDiv.2017.2020[i,2]*Frecuencia.Goles.Visitante.LigaEspanola.1raDiv.2017.2020[j,2])
  }
}
Cocientes.Goles.LigaEspanola.1raDiv.2017.2020 <- as.data.frame(Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020)[3]
Tabla.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020

#Mediante un procedimiento de boostrap, obtén más cocientes similares a los obtenidos en la tabla del punto anterior. Esto para tener una idea de las distribuciones de la cual vienen los cocientes en la tabla anterior. Menciona en cuáles casos le parece razonable suponer que los cocientes de la tabla en el punto 1, son iguales a 1 (en tal caso tendríamos independencia de las variables aleatorias X y Y).
library(rsample)
Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020 <- bootstraps(Cocientes.Goles.LigaEspanola.1raDiv.2017.2020,100000)
Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020 <- list()
for (i in 1:100000) {
  Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020[[i]] <- as.data.frame(Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020$splits[[i]])
  Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020[[i]] <- mean(Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020[[i]][,1])
}
Medias.Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020 <- unlist(Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020)
t.test(Medias.Lista.Bootstrap.Cocientes.Goles.LigaEspanola.1raDiv.2017.2020, alternative = "two.sided", mu = 1)