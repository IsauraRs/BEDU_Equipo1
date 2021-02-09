# Analisis de enfermedad coronaria

## Introducción

La Organización Mundial de la Salud ha estimado que ocurren 12 millones de muertes en todo el mundo, cada año debido a enfermedades cardíacas. La mitad de las muertes en los Estados Unidos y otros países desarrollados se deben a enfermedades cardiovasculares. El pronóstico temprano de las enfermedades cardiovasculares puede ayudar a tomar decisiones sobre cambios en el estilo de vida en pacientes de alto riesgo y, a su vez, reducir las complicaciones. Este analisis tiene la intención de identificar los factores de riesgo / más relevantes de una enfermedad cardíaca.



## Fuente

El conjunto de datos está disponible públicamente en el sitio web Kaggle, y proviene de un estudio cardiovascular en curso en residentes de la ciudad de Framingham, Massachusetts. El objetivo de la clasificación es predecir si el paciente tiene un riesgo de enfermedad coronaria (CHD) dentro de 10 años. El conjunto de datos proporciona la información de los pacientes. Incluye más de 4000 registros y 15 atributos.

https://www.kaggle.com/amanajmera1/framingham-heart-study-dataset/data

https://www.kaggle.com/dileep070/heart-disease-prediction-using-logistic-regression



## Hipótesis

Después de analizar los datos mediante gráficas, nos dimos cuenta de que puede existir una relación entre 5 factores: el nivel de glucosa, la presión arterial, edad, hipertensión y si el paciente ha tenido un derrame, y la posibilidad de presentar una enfermedad coronaria en los próximos 10 años.



## Preguntas clave

¿Existe una relación entre los pacientes que han tenido un derrame y presentan hipertensión?

¿Existe una relación entre los pacientes que han tenido un derrame y sus niveles de glucosa?

¿Existe una relación entre la edad de los pacientes y la presión sistólica?



## Hallazgos relevantes

Además de encontrar que parte de nuestra hipótesis es cierta, encontramos que otros atributos como el nivel de colesterol, presión arterial diabólica y el sexo como factores que influyen en la posibilidad de presentar una enfermedad coronaria.

La educacion y si el paciente es actualmente un fumador, no parecen tener alguna influencia en la posibilidad de presentar una enfermedad coronaria.

De acuerdo con el RFE (recursive feature elimination, eliminación de características recursivas) de la librería caret,  solo 7 (edad, los dos tipos de presiones arteriales, hipertensión, nivel de glucosa, el sexo y el nivel de colesterol) características son de mayor influencia para presentar una enfermedad coronaria.

Existe  una pequeña relación entre ser mujer y presentar una enfermedad coronaria, pero esto probablemente se deba a que el dataset no se encuentra balanceado entre hombres  y mujeres.