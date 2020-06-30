# GMM (Gaussian Mixture Model)
## Problem Description

|point | $x_1$ | $x_2$ | $x_3$ |
|:---:|:---:|:---:|:---:|:---:|
1 | 0.42 | -0.087 | 0.58
2 | -0.2 | -3.3 | -3.4
3 | 1.3 | -0.32 | 1.7
4 | 0.39| 0.71 | 0.23
5 | -1.6 | -5.3 | -0.15
6 | -0.029 | 0.89 | -4.7
7 | -0.23 | 1.9 | 2.2
8 | 0.27 | -0.3 | -0.87
9 | -1.9 | 0.76 | -2.1
10 | 0.87 | -1.0 | -2.6 

Suppose we know that the ten data points in category $\omega_1$ in the table above come from a three-dimensional Gaussian. Suppose, however, that we do not have access to the $x_3$ components for the even-numbered data points.

1. Write an EM program to estimate the mean and covariance of the distribution. Start your estimate with $\pmb{\mu}^0=0$ and $\pmb{\Sigma}^0 = \bm{I}$, the three-dimensional identity matrix.

2. Compare your final estimation with that for the case when there are no missing data.

## Result
### Q1
$$
\mu = 
\begin{pmatrix}
-0.0709\\
-0.6047\\
0.7721
\end{pmatrix}
,\quad \Sigma=
\begin{pmatrix}
0.9062&	0.5678&	0.8813\\
0.5678&	4.2007&	0.4622\\
0.8813&	0.4622&	1.7827
\end{pmatrix}
$$
### Q2
$$
\mu_e = 
\begin{pmatrix}
-0.0709\\	
-0.6047\\	
-0.9110
\end{pmatrix}
,\quad \Sigma_e=
\begin{pmatrix}
0.9062&	0.5678&	0.3941\\
0.5678&	4.2007&	0.7337\\
0.3941&	0.7337&	4.5419
\end{pmatrix}
$$