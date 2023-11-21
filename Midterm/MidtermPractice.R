c(TRUE, FALSE) | c(FALSE, FALSE)

f2 = function(x){
  #x
  45
}

f2( x=stop("Let's pass an error.") )


mat <- matrix(sample(1:100, 24), ncol = 6)
apply(mat, c(1, 2), max) # row and column

data(mtcars)

li <- list(5, letters[1:4], head(mtcars))
length(li)

lapply(li, length)

#1
a <- 1:100 %% 2
b <- c(1, 2)
q <- sum(a * b)
q

#2
mean_x <- function(x) {
  if(is.vector(x) == F){
    stop(print("Error! not a vector"))
  }
  else(is.vector(x) == T)
 mean_x = sum(x)/length(x)
 mean_x2 = sum(x^2)/length(x)
    output <- cbind(mean_x, mean_x2) 
    return(output)


}

#4 

string_vector <- c("cat", "a73", "?=+", "abcd")
grep("^...$", string_vector)
grep("^(.){3}$", string_vector)
grep("^[^.]{3}$", string_vector)
grep("^[^l][^l][^l]$", string_vector)




