#Construyendo sistemas colaborativos
library(tidyverse)
library(recommenderlab)

data("MovieLense")

#usuarios que le han dado algun rating a las pelilculas

ratings_movies <- MovieLense[rowCounts(MovieLense) > 50,
                             colCounts(MovieLense) > 100]


#usando la informacion y testeandola usando un rango 80/20

which_train <- sample(x = c(TRUE, FALSE), size = nrow(ratings_movies),
                      replace = TRUE, prob = c(0.8, 0.2))
recc_data_train <- ratings_movies[which_train, ]
recc_data_test <- ratings_movies[!which_train, ]

#construyendo el modelo IBCF

ibcf_recc_model <- Recommender(data = recc_data_train, method = "IBCF", parameter = list(k = 30))

ibcf_model_details <- getModel(ibcf_recc_model)

ibcf_model_details


#el top de las peliculas recomendadas

