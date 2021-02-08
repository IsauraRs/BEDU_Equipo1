library(rpart)
library(e1071) 
library(caret)
#install.packages("caTools")
library(caTools)

#Se carga el Dataset
dataset <- read.csv("dataset.csv", header = TRUE)
head(dataset)

#Se revisa si hay datos faltantes
is.na(dataset)

#Se coloca un 0 en donde hace falta datos
dataset[is.na(dataset)] <- 0

#Se usa attach para poder trabajar con le nombre de las columnas con mas 
#facilidad

#male: Sexo (1 para hombre, 0 para mujer)
#age: edad
#eduacacion: no se da informacion del mismo
#currentSmoker: 1 si el paciente es fumador actual, 0 si no
#cigsPerDay: Cant. de cigarros que el paciente consume al dia
#BPMeds: 1 si el paciente consume medicamento para la precion
#prevalentStroke: 1 si al paciente a tenido un derrame cerebral, 0 si no
#prevalentHyp: 1 si el paciente tiene hipertension, 0 si no
#diabetes: 1 si el paciente tiene diabetes, 0 si no
#totChol: nivel total de colesterol
#sysBP: presión arterial sistólica
#diaBP: presión arterial diastólica
#BMI: valor de IMC
#heartRate: ritmo cardiaco
#glucose: nivel de glucosa en la sangre
#TenYearCHD: 1 si el paciente tiene riesgo de tener una enfermedad coronaria, 0 si no (variable a predecir)
attach(dataset)

#-----------------------------------------------------------------------------
#la variable a predecir se pasa a tipo factor para poder trabajar de forma correcta con ella
dataset$TenYearCHD = factor(dataset$TenYearCHD, levels = c(0, 1))


#con la libreria caTools, se divide el dataset en un set de entrenamiento y otro de prueba
set.seed(123)

#se divide el data set en 75 para entrenamiento y 25 para test
sample = sample.split(dataset,SplitRatio = 0.75)
train  = subset(dataset,sample ==TRUE)
test   = subset(dataset, sample==FALSE)

#hacemos feature scaling, para normalizar los valores
train[-16] = scale(train[-16])
test[-16] = scale(test[-16])


#con tune se obtiene el mejor modelo para la svm
#(NO CORRER AL MENOS QUE TENGAS MUCHO TIEMPO DISPONIBLE, abajo esta el modelo listo)
tune.out <- tune(svm, TenYearCHD~., data = train, kernel = "radial", 
                 ranges = list(cost = c(0.001, 0.01, 0.1, 1, 2, 5, 10),
                               gamma = c(0.5, 1, 2, 3, 4)))

#vemos que el mejor modelo es con un cost de 0.001 y gamma de 0.5
summary(tune.out)

#aca ponemos el modelo con la mejor configuracion para no tener que volver a 
#correr lo de arriba
bestmod <- svm(TenYearCHD~., data = train, kernel = "radial", 
               cost = 2, gamma= 0.5)

summary(bestmod)

#hacemos predicciones con el set de entrenamiento y con el de entrenamiento
test_pred <- predict(bestmod, test[-16])
train_pred <- predict(bestmod, train[-16])


#mostramos las matrices de confusion
(cm = table(test[, 16], test_pred))
(cm2 = table(train[, 16], train_pred ))

#la matriz de confusion de la libreria caret, nos dice que el modelo tiene un 84% de precision
confusionMatrix(test_pred, test$TenYearCHD
                , dnn = c("Prediccion", "Referencia"))

#calculamos los pesos de la svm
w <- t(bestmod$coefs) %*% bestmod$SV                 
w <- apply(w, 2, function(v){sqrt(sum(v^2))}) 
#los ordenamos de mayor a menor
w <- sort(w, decreasing = T)
# de acuerdo a la svm, las variables mas importantes (su peso es considerablemnte
# mayor a losa demas) son el nivel de glucosa, la presión arterial sistólica (sysBP), 
# la edad, si el paciente tiene diabetes y si el paciente tiene hipertension (prevalentHyp)
print(w)


# para coroborar esto, con la libreria Caret se puede usar el RFE o eliminacion
# recursiva de caracterisitas

# se define el control utilizando una funcion de bosque aleatorio (random forest 
#selection)
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# se corre el RFE (TARDA DEMASIADO)
results <- rfe(dataset[,1:15], dataset[,16], sizes=c(1:15), rfeControl=control)
# muestra los resultados
print(results)
# la lista de los resultados
predictors(results)
# grafica de los resultados
plot(results, type=c("g", "o"))

#Como podemos ver el RFE nos dice que en efecto, el nivel de glucosa, 
#la presión arterial sistólica (sysBP), la edad, si el paciente tiene hipertension (prevalentHyp)
# son atributos importantes para tener una enfermedad coronario en los proximos años

#Nota: no encontro la diabetes como factor y tambien encontro que la presión arterial diastólica (diaBP),
# el sexo (si se es hombre) y el nivel de colesterol (totChol), como atributos importantes



