// Predict from Gaussian Process
// Model posterior predictive distribution for 
// unknown y (y2) jointly with known y (y1), using the "cholesky speedup"
// let length scale hyperparmeters float

data {
  real nug;
  int<lower=1> D;     
  int<lower=1> N1;
  int<lower=1> N2;
  vector[D] x1[N1]; 
  vector[D] x2[N2];  
  vector[N1] y1;
}

transformed data{
  int N;      
  vector[N1+N2] mu;
  vector[D] x[N1+N2];
  
  N <- N1 + N2;
  for (i in 1:N)
    mu[i] <- 0;
  for (i in 1:N1)
    x[i] <- x1[i];
  for (i in 1:N2)
    x[N1 + i] <- x2[i];
}

parameters {
  vector<lower=0>[D] l; // length scale hyperparameters
  vector[N2] y2;        // unknown y
}

model {
  vector[N] y;
  matrix[N, N] Sigma;
  matrix[N, N] L;
  
  for (i in 1:N1)
    y[i] <- y1[i];
  for (i in 1:N2)
    y[N1 + i] <- y2[i];

  for (i in 1:N-1){
    for (j in i+1:N){
      vector[D] exp_vec;
      exp_vec <- (x[i] - x[j]) ./ l;
      Sigma[i, j] <- exp(-dot_self(exp_vec));
      Sigma[j, i] <- Sigma[i, j];
    }
  }   
  for (i in 1:N)
    Sigma[i, i] <- 1 + nug;
    
  L <- cholesky_decompose(Sigma);

  l ~ cauchy(0, 5);
  y ~ multi_normal_cholesky(mu, L);
}