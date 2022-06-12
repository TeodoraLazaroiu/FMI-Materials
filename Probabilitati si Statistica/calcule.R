# multiply 2 random variables

# only for distinct random variables

library("discreteRV")

product.matrix <- t(outer(c(-5,3,5),c(3,4,7),"*"))
probability.matrix <- t(outer(c(0.44,0.52,0.04), c(0.78,0.15,0.07)))
unique.products <- unique(as.vector(product.matrix))
probability.vector <- rep(0, length(unique.products))

for(i in 1:length(probability.vector)){
  
  z <- unique.products[i]
  indices <- which(as.vector(product.matrix) == z)
  probability.vector[i] <- sum(as.vector(probability.matrix)[indices])
  
}

XtimesY <- RV(outcomes = unique.products, probs = probability.vector, fractions = FALSE)

# random variables operations

x <- RV(outcomes = c(1,2,3), probs = c(1/9,1/9,1/9), fractions = TRUE)
y <- RV(outcomes = c(1,2,3), probs = c(1/9,1/9,1/9), fractions = TRUE)

# mean value of a random variable
E(x)

# variance of a random variable
variance <- function(a) E(a^2)-(E(a))^2

# covariance of 2 random variables
covariance <- function(a,b) E(a*b) - E(a)*E(b)

# correlation coefficient of 2 random variables (rho)
correlation <- function(a,b) covariance(a,b) / (sqrt(variance(a)) * sqrt(variance(b)))

# standard deviation of random variables
deviation <- function(x) sqrt(variance(a))
