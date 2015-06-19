// Predict from Gaussian Process
// Model posterior predictive distribution for 
// unknown y (y2) analytically
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

parameters {
  vector<lower=0>[D] l; // length scale hyperparameters
  vector[N2] y2;        // unknown y
}

model {
  vector[N2] mu;  
  matrix[N1, N1] Sigma;
  matrix[N2, N2] Omega;
  matrix[N1, N2] K;
  matrix[N2, N1] K_transpose_div_Sigma;
  matrix[N2, N2] Tau;

  for (i in 1:N1-1){
    for (j in i+1:N1){
      vector[D] exp_vec;
      exp_vec <- (x1[i] - x1[j]) ./ l;
      Sigma[i, j] <- exp(-dot_self(exp_vec));
      Sigma[j, i] <- Sigma[i, j];
    }
  } 
  for (i in 1:N1)
    Sigma[i, i] <- 1 + nug;

  for (i in 1:N2-1){
    for (j in i+1:N2){
      vector[D] exp_vec;
      exp_vec <- (x2[i] - x2[j]) ./ l;
      Omega[i, j] <- exp(-dot_self(exp_vec));
      Omega[j, i] <- Omega[i, j];
    }
  }
  
  for (i in 1:N2)
    Omega[i, i] <- 1 + nug;
    
  for (i in 1:N1){
    for (j in 1:N2){    
      vector[D] exp_vec;
      exp_vec <- (x1[i] - x2[j]) ./ l;
      K[i, j] <- exp(-dot_self(exp_vec));
    }
  }
  
  K_transpose_div_Sigma <- K' / Sigma;
  mu <- K_transpose_div_Sigma * y1;
  Tau <- Omega - K_transpose_div_Sigma * K;
  for (i in 1:(N2-1))
    for (j in (i+1):N2)
      Tau[i, j] <- Tau[j, i];

  l ~ cauchy(0, 5);
  y2 ~ multi_normal(mu, Tau); 
}