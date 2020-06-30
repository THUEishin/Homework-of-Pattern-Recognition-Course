# Feature selection with L1-norm regularization
## Problem Description
This programming task seems to be heavy, but don't be afraid. This is actually an easy work as long as you follow the steps and hints provided. In this problem, let's consider a regularized approach to feature selection in a simple regression context. Unlike fisher criterion, we are not going to reduce dimensions, but just select features from the existed ones. Suppose we have training inputs $X=(\bold{x}_{1},...,\bold{x}_{n})^{T}$ and corresponding outputs $\bold{y}=(y_{1},...,y_{2})^{T}$, where $\bold{x}_{i}\in \mathcal{R}^{D}$ and $y_{i}\in \mathcal{R}$. We want to train a linear predictor $\hat{y}(\bold{x};\bold{w})=\bold{w}^{T}\phi(\bold{x})$ with $\phi(\bold{x})$ indicating the $M$ features $\phi(\bold{x})=(\phi_{1}(\bold{x}),...,\phi_{M}(\bold{x}))^{T}$. The objective is regularized least-squares as following:
$$
J(\bold{w};\lambda)=\frac{1}{n}\sum_{i=1}^{n}\frac{1}{2}(y_{i}-\bold{w}^{T}\phi(\bold{x}_{i}))^{2}+\lambda||\bold{w}||_{1}
$$
Where $||\bold{w}||_{1}$ is the L1-norm:
$$
||\bold{w}||_{1}=\sum_{k=1}^{M}|w_{k}|
$$
Thus, our task is to minimize the regularized objective in order to seek for the optimal parameters $\hat{\bold{w}}=\hat{\bold{w}}(\lambda)$:
$$
\hat{\bold{w}}=arg min_{\bold{w}\in\mathcal{R}^{M}}J(\bold{w};\lambda)
$$
Implementation of the L1-norm will lead to a sparse $\bold{w}$. What's more, with $\lambda$ increasing, more elements of weight vector $\bold{w}$ are forced to zero, which means the corresponding features are ignored in the predictor.

**Coordinate descent** will be used to solve this L1-regularized least-squares problem. In this approach, we adjust one parameter at a time so as to minimize the objective while keeping the remaining parameters fixed:
$$
\hat{w}_{k}=argmin_{w_{k}}J(\bold{w};\lambda)
$$
With $k$ iterating over all indices \{1,...,M\}, and repeating the process for many times, parameter $\bold{w}$ asymptotically converges to the global minimum of the convex objective (Not familiar with definition of convex? wiki or google).

Since the L1 regularization is not smooth, we can't take derivatives as the differentiable functions to minimize the objective. Instead, we make use of the **subdifferential of a convex function**, which is defined as:
$$
\partial f(w)=\{s|f(w+\Delta)\geq f(w)+s\Delta, \forall \Delta\in\mathcal{R}\}
$$
This is a set-valued generalization of the normal derivative and reduces to the normal derivative $\partial f(w)=\{\frac{\partial f(w)}{\partial w}\}$ whenever $f$ is differentiable. Taking the absolute value function $f(w)=|w|$ as an example:
$$
\partial f(w)= \left\{ \begin{array}{ll}
\{-1\}, & \textrm{w<0} \\
[-1, +1], & \textrm{w=0} \\
\{+1\}, & \textrm{w>0}
\end{array} \right.
$$
We will use the following result from non-smooth analysis:

$\bold{Optimality}$ $\bold{Condition}$: $\hat{w}$ is a global minimizer of a convex function $f(w)$ if and only if $0\in \partial f(\hat{w})$.

For example, the optimality condition $0 \in \partial f(w)$ for the absolute value function $f(w)=|w|$ holds if and only if $w=0$. Hence, $w=0$ is the unique global minimizer of $|w|$.

Below, we will guide you through the analysis to solve the L1-norm regularized least-squares problem.

1. Show that the sub-differential of $J(\bold{w};\lambda)$ with respect to parameter $w_{k}$ is:
$$
\partial_{w_{k}}J(\bold{w};\lambda)=(a_{k}w_{k}-c_{k})+\lambda\partial_{w_{k}}|w_{k}| =\left\{ \begin{array}{ll}
\{a_{k}w_{k}-(c_{k}+\lambda)\}, & w_{k}<0 \\
[-c_{k}-\lambda, -c_{k}+\lambda], & w_{k}=0 \\
\{a_{k}w_{k}-(c_{k}-\lambda)\}, & w_{k}>0
\end{array} \right.
$$
With:
$$
a_{k}=\frac{1}{n}\sum_{i=1}^{n}\phi_{k}^{2}(\bold{x}_{i})
$$
$$
c_{k}=\frac{1}{n}\sum_{i=1}^{n}\phi_{k}(\bold{x}_{i})(y_{i}-\bold{w}_{-k}^{T}\phi_{-k}(\bold{x}_{i}))
$$
Where $\bold{w}_{-k}$(respectively $\phi_{-k}$) denote the vector of all parameters (features) except for parameter $w_{k}$ (feature $\phi_{k}$). Observe equations (15) and (16), you can find that $a_{k}$'s are non-negative and constant parameters while each $c_{k}$ depends on all parameters except for the parameter $w_{k}$ that we are to update. Try to interpret the coefficient $c_{k}$.

2. Solve the non-smooth optimality condition for $\hat{w}_{k}$ s.t. $0 \in \partial_{w_{k}}J(\hat{w_{k}})$. It's helpful to consider each of the following cases separately: 
&emsp;&emsp; (a) $c_{k}<-\lambda$
&emsp;&emsp; (b) $c_{k}\in [-\lambda, +\lambda]$
&emsp;&emsp; (c) $c_{k}>+\lambda$
In each case, provide a plot $\partial_{w_{k}}J(w_{k})$ versus $w_{k}$ and label the zero-crossing $\hat{w_{k}}$. Then, with the help of those plots, you can express $\hat{w_{k}}$ as a function of $a_{k}$, $c_{k}$ and $\lambda$. Finally, provide a plot of $\hat{w_{k}}$ versus $c_{k}$. What role does the regularization parameter $\lambda$ play in this context relative to the coefficient $c_{k}$ ?
**Hint: There is no need for you to spend too much time generating those plots required above. Since those plots are just small tools helping you understand the final equations. You can just provide me with your hand-drawn plots, either inserted in your report, or included in the codes' folder.**

3. We have provided you with training and testing data in the file $\bold{least\_sq.mat}$. Load this file into MATLAB workspace and you will find 4 structures $\bold{test}$, $\bold{train\_large}$, $\bold{train\_mid}$, $\bold{train\_small}$ each containing an $n\times M$ matrix $X$ and a $n\times 1$ vector $\bold{y}$.
For simplicity, we only consider the linear regression, say $\phi(\bold{x})=\bold{x}$. Write a MATLAB subroutine based on the skeleton $\bold{least\_sq\_L1.m}$ to solve for the optimal parameter $\hat{\bold{w}}$ given the training data $(X, \bold{y})$.
**Hint: The skeleton code is just a suggestion, you are not strictly required to follow it as long as you can realize the algorithm.**
**What's more, before writing the code, review the equations derived in 3.2, you may find that the expression for $\hat{w}_{k}$ considered under different cases can be included into just one simple equation, which can accelerate your code by eliminating "if-else" snippets.**

4. Complete the skeleton $\bold{mainFunc.m}$ to run your algorithm for a sequence of $\lambda$ values [0.01: 0.01: 2.0]. And we use $\bold{w}_{0}=(X^{T}X)^{-1}X^{T}\bold{y}$, the usual least-squares parameter estimation as the initial state for $\bold{w}$. Also, a function $\bold{least\_sq\_multi.m}$ is provided, you should read the code carefully.
Plot each of the following versus $\lambda$:
&emsp;(a) the training error $J(\hat{\bold{w}}(\lambda);0)$
&emsp;(b) the regularization penalty $||\hat{\bold{w}}(\lambda)||_{1}$
&emsp;(c) the minimized objective $J(\hat{\bold{w}}(\lambda);\lambda)$
&emsp;(d) the number of non-zero parameters $||\hat{\bold{w}}(\lambda)||_{0}$(the L0-norm)
&emsp;(e) the test error
Run this experiment for each of the three training set $\bold{train\_large}$, $\bold{train\_mid}$ and $\bold{train\_small}$, then test on set $\bold{test}$. Comment on the behavior of each of these quantities as a function of $\lambda$. For each training set, what value of $\lambda$ minimizes the test error? How does this vary with the size of the training set? How could we estimate from the training data the appropriate value of $\lambda$ to use so as to approximately minimize the test error?
**Hint: Above all, we've guided you through the basic idea of optimizing the L1-norm problem. L1-regularization is greatly related to the field of compress sensing or sparse representation which was a hot topic for a few years, to learn more, wiki or google.**