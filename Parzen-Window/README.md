# Function Estimation by Parzen Window method
## Problem Description

Assume:
<img src="http://latex.codecogs.com/gif.latex?p(x)\sim0.2\mathcal{N}(-1,1)+0.8\mathcal{N}(1,1)"/>. 
Draw n samples from <img src="http://latex.codecogs.com/gif.latex?p(x)"/>, for example, <img src="http://latex.codecogs.com/gif.latex?n=5,10,50,100,\cdots,1000,\cdots,10000"/>. Use Parzen-window method to estimate <img src="http://latex.codecogs.com/gif.latex?p_n(x)\approx p(x)"/> (Hint: use randn() function in matlab to draw samples)

(a) Try window-function <img src="http://latex.codecogs.com/gif.latex?P(x)=\left\{\begin{aligned}&\frac{1}{a},-\frac{1}{2}a\leq x\leq \frac{1}{2}a \\&0,otherwise.\end{aligned}\right."/>. Estimate <img src="http://latex.codecogs.com/gif.latex?p(x)"/> with different window width <img src="http://latex.codecogs.com/gif.latex?a"/>. Please draw <img src="http://latex.codecogs.com/gif.latex?p_n(x)"/> under different <img src="http://latex.codecogs.com/gif.latex?n"/> and <img src="http://latex.codecogs.com/gif.latex?a"/> and <img src="http://latex.codecogs.com/gif.latex?p(x)"/> to show the estimation effect.

(b) Derive how to compute <img src="http://latex.codecogs.com/gif.latex?\epsilon(p_n)=\int[p_n(x)-p(x)]^2dx"/> numerically.

(c) Demonstrate the expectation and variance of <img src="http://latex.codecogs.com/gif.latex?\epsilon(p_n)"/> w.r.t different $n$ and $a$ .

(d) With n given, how to choose optimal $a$ from above the empirical experiences?

(e) Substitute <img src="http://latex.codecogs.com/gif.latex?h(x)"/> in (a) with Gaussian window. Repeat (a)-(e).

(g) Try different window functions and parameters as many as you can. Which window function/parameter is the best one? Demonstrate it numerically.