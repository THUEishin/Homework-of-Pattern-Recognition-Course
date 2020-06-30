from read import *
from NMI import *
from scipy import sparse
import scipy.sparse.linalg
import Kmeans
import matplotlib.pyplot as plt


def spectrum(k_neighbor, class_num, mini_size, flag2=True):
	train_image = read_image('train-images.idx3-ubyte')
	train_label = read_label('train-labels.idx1-ubyte')

	train_image = train_image[:mini_size]
	train_label = train_label[:mini_size]
	gamma = -1/train_image.shape[1]

	# 构建距离矩阵
	Dist = np.zeros((mini_size, mini_size))
	# 欧式距离
	for i in range(mini_size):
		for j in range(mini_size):
			diff = train_image[i] - train_image[j]
			Dist[i][j] = np.sqrt(np.dot(diff, diff))

	# 构建相似度图
	W = np.zeros((mini_size, mini_size))
	for i in range(mini_size):
		c = dict()
		for j in range(mini_size):
			c[Dist[i][j]] = j
		v = sorted(c.keys())
		index = [c[v[j]] for j in range(1, k_neighbor+1)]
		for k in range(k_neighbor):
			W[i][index[k]] = np.exp(v[k+1]*gamma)
	# 对称k近邻
	if(flag2):
		for i in range(mini_size):
			for j in range(mini_size):
				if W[i][j] == 0:
					W[j][i] = 0

	del Dist
	# 计算度矩阵
	D = W.sum(axis=1)
	D = np.diag(D)
	# 计算L矩阵
	L = D - W
	del D
	del W
	# 求解特征值和特征向量
	values, vectors = sparse.linalg.eigs(L, k=class_num, tol=1.0e-3, which="SM")
	return values, vectors, train_label


if __name__ == "__main__":
	mini_size = 2000
	class_num = 20
	val, vec, exact_label = spectrum(40, class_num, mini_size, True)
	data = np.array(vec)
	J, means, labels, number = Kmeans.initialize(data, class_num)

	Je = []
	nmi = []
	Je.append(J.sum())
	nmi.append(NMI(exact_label, labels))
	print((Je[-1], nmi[-1]))
	iter_count = 0
	flag = False

	while True:
		count = 0
		for i in range(mini_size):
			iter_count += 1
			if count == mini_size:
				break
			k = labels[i]
			Nk = number[k]
			if Nk == 1:
				continue
			temp_mk = means[k]
			y = data[i]
			dJk = np.dot(temp_mk - y, temp_mk - y) * Nk / (Nk - 1)
			dJj = 1.0e10
			index_j = -1
			for j in range(class_num):
				if not j == k:
					Nj = number[j]
					temp_mj = means[j]
					temp_dJj = np.dot(temp_mj - y, temp_mj - y) * Nj / (Nj + 1)
					if temp_dJj < dJj:
						dJj = temp_dJj
						index_j = j

			if dJj < dJk:
				J[k] -= dJk
				J[index_j] += dJj
				labels[i] = index_j
				means[k] = temp_mk + (temp_mk - y) / (Nk - 1)
				temp_mj = means[index_j]
				Nj = number[index_j]
				means[index_j] = temp_mj + (y - temp_mj) / (Nj + 1)
				number[k] -= 1
				number[index_j] += 1
				count = 0
			else:
				count += 1
			if count == 1000:
				Je.append(J.sum())
				nmi.append(NMI(exact_label, labels))
				if nmi[-1] <= nmi[-2]:
					flag = True
					break

		Je.append(J.sum())
		nmi.append(NMI(exact_label, labels))
		print((Je[-1], nmi[-1]))
		if count == mini_size or flag:
			break

	plt.plot(Je, nmi)
	plt.xlabel("Je")
	plt.ylabel("NMI")
	plt.show()
	print(iter_count)