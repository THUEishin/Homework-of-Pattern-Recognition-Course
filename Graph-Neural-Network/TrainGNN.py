import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import torch
from torch import nn


class GNN(nn.Module):
	def __init__(self, D_in, H, D_out, A):
		super(GNN, self).__init__()
		self.A_hat = nn.Parameter(A)
		for p in self.parameters():
			p.requires_grad = False

		self.W1 = nn.Parameter(torch.randn(D_in, H, dtype=torch.double))
		self.W2 = nn.Parameter(torch.randn(H, D_out, dtype=torch.double))

	def forward(self, x):
		h1 = torch.mm(self.A_hat, x)
		h1 = torch.mm(h1, self.W1).clamp(min=0)
		h2 = torch.mm(self.A_hat, h1)
		y_pred = torch.mm(h2, self.W2).clamp(min=0)
		return y_pred


def test():
	zkc = nx.karate_club_graph()
	colors = []
	Dim_input = zkc.number_of_nodes()
	Dim_hidden = 10  # defined by me
	Dim_output = 2
	X = np.identity(Dim_input)
	A = np.identity(Dim_input)
	D = np.zeros([Dim_input, Dim_input])

	for i in zkc.nodes:
		for j in zkc[i]:
			A[i][j] = 1

	Temp = np.sum(A, axis=1)
	for i in range(Dim_input):
		D[i][i] = Temp[i]

	A = np.linalg.inv(D).dot(A)
	x = torch.from_numpy(X)
	y = torch.zeros([Dim_input, Dim_output], dtype=torch.double)
	for index in zkc.nodes:
		if zkc._node[index]['club'] == 'Mr. Hi':
			y[index][0] = 1
		else:
			y[index][1] = 1

	model = GNN(Dim_input, Dim_hidden, Dim_output, torch.from_numpy(A))
	criterion = torch.nn.MSELoss(reduction='sum')
	optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, model.parameters()), lr=0.0001, betas=(0.9, 0.999),
						   eps=1e-6, weight_decay=1e-5)

	loss = 1.0
	t = 0
	while loss > 1e-5:
		t += 1
		y_pred = model(x)
		loss = criterion(y_pred, y)
		if t % 100 == 99:
			print(t, loss.item())

		optimizer.zero_grad()
		loss.backward()
		optimizer.step()

	for index in zkc.nodes:
		if y_pred[index][0] > y_pred[index][1]:
			colors.append('blue')
		else:
			colors.append('red')

	nx.draw(zkc, node_color=colors, with_labels=True)
	plt.show()

if __name__ == "__main__":
	test()