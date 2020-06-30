import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

zkc = nx.karate_club_graph()
colors_exact = []
colors = []

for index in zkc.nodes:
	if zkc._node[index]['club'] == 'Mr. Hi':
		colors_exact.append('blue')
	else:
		colors_exact.append('red')

nx.draw(zkc, node_color=colors_exact, with_labels=True)
plt.show()

# GCN
Dim_input = zkc.number_of_nodes()
Dim_hidden = 10		# defined by me
Dim_output = 2
W1 = np.random.randn(Dim_input, Dim_hidden)
W2 = np.random.randn(Dim_hidden, Dim_output)
X = np.identity(Dim_input)
A = np.identity(Dim_input)
D = np.zeros([Dim_input, Dim_input])

for i in zkc.nodes:
	for j in zkc[i]:
		A[i][j] = 1

Temp = np.sum(A, axis=1)
for i in range(Dim_input):
	D[i][i] = Temp[i]

h1 = np.linalg.inv(D).dot(A).dot(X).dot(W1)
h1[h1 < 0] = 0.0
h2 = np.linalg.inv(D).dot(A).dot(h1).dot(W2)
h2[h2 < 0] = 0.0

for index in zkc.nodes:
	if h2[index][0] > h2[index][1]:
		colors.append('blue')
	else:
		colors.append('red')

nx.draw(zkc, node_color=colors, with_labels=True)
plt.show()