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
