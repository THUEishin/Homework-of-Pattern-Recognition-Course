# K-means, hierarchical clustering and spectral clustering
## Problem Description
Test the clustering algorithms $\mathbf{K-means}$, $\mathbf{hierarchical\ clustering}$ and $\mathbf{spectral\ clustering}$ with different parameters on [MNIST dataset](http://yann.lecun.com/exdb/mnist/) or subsets of it when the scale is too large for the algorithm involved.

To compare the effectiveness of different clustering methods, **Normalized mutual information**(NMI) are widely used as a measurement. NMI is defined as following:
$$
NMI = \frac{\sum_{s=1}^{K}\sum_{t=1}^{K}n_{s,t}log(\frac{nn_{s,t}}{n_{s}n_{t}})}{\sqrt{(\sum_{s}n_{s}log\frac{n_{s}}{n})(\sum_{t}n_{t}log\frac{n_{t}}{n})}}
$$
Where $n$ is the number of data points, $n_{s}$ and $n_{t}$ denote the numbers of the data in class $s$ and class $t$, $n_{s,t}$ denotes the number of data points in both class $s$ and class $t$. For more details and other measurements, google "evaluation of clustering".

1. Give a brief analysis of time complexity of each algorithm mentioned above (of standard implementation). Estimate how many samples each algorithm can manage with a reasonable time cost.
(Optional) Can you verify your estimations with experiments? Can you speed it up further?

2. Consider each data set, and use the true number of classes as the number of clusters.

(1) With K-means, will the initial partition affect the clustering results? How can you solve this problem? And do $J_{e}$ and NMI match? Show your experiment results.

(2) When hierarchical clustering is adopted, the choice of linkage method depends on the problem. Give an analysis of linkage method's effects with experiments, and which is better in the sense of NMI?
As introduced in the class, some of the most common metrics of distance between two clusters $\{x_{1}, ..., x_{m}\}$ and $\{y_{1}, ..., y_{p}\}$ are:
- **Single linkage:** Distance between clusters is the **minimum** distance between any pair of points from the two clusters, i.e.:
    $$
    min_{i, j}||x_{i}-y_{j}||
    $$
- **Complete linkage:** Distance between clusters is the **maximum** distance between any pair of points from two clusters, i.e.:
    $$
    max_{i, j}||x_{i}-y_{j}||
    $$
- **Average linkage:** Distance between clusters is the **average** distance between all pairs of points from two clusters, i.e.:
    $$
    \frac{1}{mp}\sum_{i=1}^{m}\sum_{j=1}^{p}||x_{i}-y_{j}||
    $$

(3) As for spectral clustering, give an experimental analysis of the choice of similarity graph and corresponding parameters. Which one is better?

3. In practice, we may not know the true number of clusters much. Can you give a strategy to identify the cluster number automatically for each algorithm? Show your results.

4. According to the above analysis, which method do you prefer? Why?