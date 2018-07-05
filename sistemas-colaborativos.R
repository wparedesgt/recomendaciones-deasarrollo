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


n_recommended <- 6
ibcf_recc_predicted <- predict(object = ibcf_recc_model, newdata = recc_data_test, n = n_recommended)
ibcf_recc_predicted


ibcf_recc_matrix <- sapply(ibcf_recc_predicted@items, function(x){ colnames(ratings_movies)[x]
})

View(ibcf_recc_matrix[, 1:4])


#basado en los usuarios


ubcf_recc_model <- Recommender(data = recc_data_train, method = "UBCF")
ubcf_model_details <- getModel(ubcf_recc_model)
ubcf_model_details

n_recommended <- 5
ubcf_recc_predicted <- predict(object = ubcf_recc_model, newdata = recc_data_test, n = n_recommended)
ubcf_recc_predicted

ubcf_recc_matrix <- sapply(ubcf_recc_predicted@items, function(x){ colnames(ratings_movies)[x] })
View(ubcf_recc_matrix[, 1:4])


recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
names(recommender_models)
