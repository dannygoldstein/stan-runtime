## STAN Runtime Test: Hierarchical Gaussian Process Hyperparameter
   Fitting and Posterior Realization in 2D

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

1.    `JOINT`: Standard implementation (STAN manual pp. 129-130. -- (`y ~ multi_normal(mu, Sigma)`). Expected to be slowest. 
2.    `JOINT_CHOLESKY`: Standard implementation with "cholesky speedup." (STAN manual p. 135 -- `y ~ multi_normal_cholesky(mu, cholesky_decompose(Sigma))`). Expected to finish 3rd.
3.    `ANALYTIC`: Derive posterior preditive distribution for unknown responses analytically. (STAN manual pp. 136-7 -- `y2 ~ multi_normal(K_transpose_div_Sigma * y1, Omega - K_transpose_div_Sigma * K)`). Expected to finish 2nd.
4.    `ANALYTIC_CHOLESKY`: Derive posterior predictive distribution for unknonwn responses analytically, with "cholesky speedup." (STAN Manual p. 137 -- `y2 ~ multi_normal_cholesky(K_transpose_div_Sigma * y1, cholesky_decompose(Omega - K_transpose_div_Sigma * K))`). Expected to finish 1st.

### This Repository

Models live in folders named by implmementation type. Python wrappers used to produce each result are provided in each folder, along with STAN logs.

### Results

All results computed using `pystan` on edison at NERSC. Each
implementation was run with 4 chains and 2000 iterations per chain
(1000 warmup, 1000 sampling). Each implementation was alloted 30
minutes of wall clock time; only the `JOINT` implementation terminated
during that period.

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="left" />

<col  class="left" />

<col  class="left" />

<col  class="right" />

<col  class="left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="left">IMPLEMENTATION</th>
<th scope="col" class="left">EXPECTATION</th>
<th scope="col" class="left">RESULT</th>
<th scope="col" class="right">ITER REACHED (CHAIN-MEAN)</th>
<th scope="col" class="left">TERMINATED?</th>
</tr>
</thead>
<tbody>
<tr>
<td class="left">JOINT</td>
<td class="left">FINISH 4TH</td>
<td class="left">FINISHED 1ST</td>
<td class="right">2000</td>
<td class="left">Y (27 min)</td>
</tr>

<tr>
<td class="left">JOINT CHOLESKY</td>
<td class="left">FINISH 3RD</td>
<td class="left">FINISHED 2ND</td>
<td class="right">550</td>
<td class="left">N</td>
</tr>

<tr>
<td class="left">ANALYTIC</td>
<td class="left">FINISH 2ND</td>
<td class="left">FINISHED 3RD</td>
<td class="right">150</td>
<td class="left">N</td>
</tr>

<tr>
<td class="left">ANALYTIC CHOLESKY</td>
<td class="left">FINISH 1ST</td>
<td class="left">FINISHED 4TH</td>
<td class="right">38</td>
<td class="left">N</td>
</tr>
</tbody>
</table>

#### JOINT Results

Only the `JOINT` implementation terminated during its 30-minute run. Convergence was nearly perfect. 

    Out[5]:
    Inference for Stan model: gp_fitpredict_joint_b1ff1ee8e5bf5fbc2283b2f59df94c40.
    4 chains, each with iter=2000; warmup=1000; thin=1;
    post-warmup draws per chain=1000, total post-warmup draws=4000.

             mean se_mean     sd   2.5%    25%    50%    75%  97.5%  n_eff   Rhat
    l[0]      3.5  3.7e-3   0.11   3.27   3.43    3.5   3.57   3.69  820.0    1.0
    l[1]     3.26  3.4e-3    0.1   3.06   3.19   3.26   3.33   3.44  847.0    1.0
    y2[0]   -0.56  3.3e-5 1.2e-3  -0.56  -0.56  -0.56  -0.56  -0.56 1334.0    1.0
    y2[1]   -0.92  4.7e-5 1.7e-3  -0.93  -0.92  -0.92  -0.92  -0.92 1334.0    1.0
    y2[2]    0.02  5.8e-5 2.1e-3   0.01   0.02   0.02   0.02   0.02 1271.0    1.0
    y2[3]    -1.0  8.2e-5 2.7e-3  -1.01   -1.0   -1.0   -1.0   -1.0 1134.0    1.0
    y2[4]   -0.65  4.3e-5 1.6e-3  -0.65  -0.65  -0.65  -0.65  -0.64 1334.0    1.0
    y2[5]   -0.15  4.7e-5 1.7e-3  -0.15  -0.15  -0.15  -0.15  -0.15 1334.0    1.0
    y2[6]   -0.34  5.2e-4   0.02  -0.37  -0.35  -0.34  -0.33  -0.31  856.0    1.0
    y2[7]    0.98  7.0e-5 2.4e-3   0.98   0.98   0.98   0.98   0.98 1176.0    1.0
    y2[8]    0.28  3.4e-5 1.2e-3   0.28   0.28   0.28   0.28   0.28 1334.0    1.0
    y2[9]   -0.93  3.5e-5 1.3e-3  -0.94  -0.94  -0.93  -0.93  -0.93 1334.0    1.0
    y2[10]  -0.99  4.0e-4   0.01  -1.02   -1.0  -0.99  -0.99  -0.97  904.0   1.01
    y2[11]   0.71  6.7e-5 2.3e-3   0.71   0.71   0.71   0.72   0.72 1189.0    1.0
    y2[12]   0.88  1.8e-4 4.7e-3   0.87   0.88   0.88   0.89   0.89  694.0    1.0
    y2[13]  -0.95  3.4e-5 1.2e-3  -0.95  -0.95  -0.95  -0.94  -0.94 1334.0    1.0
    y2[14]   0.89  9.9e-5 3.2e-3   0.89   0.89   0.89    0.9    0.9 1069.0    1.0
    y2[15]  -0.84  9.5e-4   0.03   -0.9  -0.86  -0.84  -0.82  -0.79  865.0    1.0
    y2[16]   0.98  7.7e-5 2.6e-3   0.97   0.98   0.98   0.98   0.98 1140.0    1.0
    y2[17]   -1.0  4.3e-5 1.6e-3   -1.0   -1.0   -1.0   -1.0   -1.0 1334.0    1.0
    y2[18]  -0.22  4.0e-5 1.5e-3  -0.22  -0.22  -0.22  -0.22  -0.22 1334.0    1.0
    y2[19]   0.93  2.5e-4 6.6e-3   0.92   0.93   0.93   0.94   0.94  691.0    1.0
    lp__   455.75    0.12   3.58 447.57 453.61 456.22 458.31 461.43  822.0    1.0

    Samples were drawn using NUTS(diag_e) at Fri Jun 19 11:12:02 2015.
    For each parameter, n_eff is a crude measure of effective sample size,
    and Rhat is the potential scale reduction factor on split chains (at
    convergence, Rhat=1).