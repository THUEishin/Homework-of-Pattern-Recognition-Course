# $k$-NN Classifier on MNIST
## Problem Description
Manually implement $k$-NN classifier and run on MNIST.
Please follow the official train/test split of MNIST[^1]
[^1]:http://yann.lecun.com/exdb/mnist/

1. Use 100, 300, 1000, 3000, 10000, 30000, 60000 training samples and compare the performance.
2. Use different values of $k$ and compare the performance.
3. Use at least three different distance metrics and compare the performance.

In this assignment, you are **NOT** allowed to use any existing libraries or code snippets that provides $k$-NN algorithm.

## Result
### $k=1$, L2-norm
N|100|300|1000|3000|10000|30000|60000
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
Error rate| 32.06%|20.77%|13.10%|8.09%|5.37%|3.82%|3.09%|
Runtime|9s|17s|49s|2min18s|7min38s|22min24s|44min19s