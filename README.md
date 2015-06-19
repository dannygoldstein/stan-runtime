## STAN Runtime Test: Hierarchical Gaussian Process Fitting and Posterior Realization in 2D

<p align="center">
  <img src="static/space.gif">
</p>

### Problem Setup

1.    Pick 100 inputs (xy points) in the above space from a uniform distribution.
2.    Compute associated responses via: <br><p align="center"><img src="static/z.png"></p>
3.    Pick 20 new inputs from uniform distribution in above space.
4.    Try to infer associated responses by modeling responses as a gaussian process in STAN.
5.    2 hyperparameters: x and y length scales (left floating).

### Four Different Implementations

Model responses as a gaussian process. 

1.    `JOINT`: Standard implementation (STAN manual pp. 129-130. -- (`y ~ multi_normal(mu, Sigma)`). Expected to be slowest. 
2.    `JOINT_CHOLESKY`: Standard implementation with "cholesky speedup." (STAN manual p. 135 -- `y ~ multi_normal_cholesky(mu, cholesky_decompose(Sigma))`). Expected to finish 3rd or 2nd.
3.    `ANALYTIC`: Derive posterior preditive distribution for unknown responses analytically. (STAN manual pp. 136-7 -- `y2 ~ multi_normal(K_transpose_div_Sigma * y1, Omega - K_transpose_div_Sigma * K)`). Expected to finish 2nd or 2rd. 
4.    `ANALYTIC_CHOLESKY`: Derive posterior predictive distribution for unknonwn responses analytically, with "cholesky speedup." (STAN Manual p. 137 -- `y2 ~ multi_normal_cholesky(K_transpose_div_Sigma * y1, cholesky_decompose(Omega - K_transpose_div_Sigma * K))`). Expected to finish 1st.

### Results

