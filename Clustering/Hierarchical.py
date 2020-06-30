from read import *
from NMI import *
import datetime
import matplotlib.pyplot as plt


def HCluster(linkage):
	t1 = datetime.datetime.now()
	train_image = read_image('train-images.idx3-ubyte')
	train_label = read_label('train-labels.idx1-ubyte')

	mini_size = 500
	class_num = 10
	train_image = train_image[:mini_size]
	train_label = train_label[:mini_size]

	# 构建距离矩阵
	D = np.zeros((mini_size, mini_size))
	for i in range(mini_size):
		for j in range(mini_size):
			diff = train_image[i] - train_image[j]
			D[i][j] = np.sqrt(np.dot(diff, diff))

	labels = list(range(0, mini_size))
	cluster = dict()
	nmi = []
	count = 0
	plot_count = []
	link_h = []
	# 每一个点为一类
	for i in range(mini_size):
		cluster[i] = [i]

	while len(cluster) > class_num:
		count += 1
		index1 = -1
		index2 = -1
		dist = 1.0e10
		length = len(cluster)
		keys = list(cluster.keys())
		if linkage == 1:
			for i in range(length):
				for j in range(i+1, length):
					temp_dist = D[cluster[keys[i]]][:, cluster[keys[j]]].min()
					if temp_dist < dist:
						dist = temp_dist
						index1 = keys[i]
						index2 = keys[j]
		elif linkage == 2:
			for i in range(length):
				for j in range(i+1, length):
					temp_dist = D[cluster[keys[i]]][:, cluster[keys[j]]].max()
					if temp_dist < dist:
						dist = temp_dist
						index1 = keys[i]
						index2 = keys[j]
		else:
			for i in range(length):
				for j in range(i + 1, length):
					temp_dist = D[cluster[keys[i]]][:, cluster[keys[j]]].sum()/len(cluster[keys[i]])/len(cluster[keys[j]])
					if temp_dist < dist:
						dist = temp_dist
						index1 = keys[i]
						index2 = keys[j]

		for index in cluster[index2]:
			labels[index] = index1
		cluster[index1].extend(cluster[index2])
		del cluster[index2]
		if len(cluster) < 100:
			nmi.append(NMI(train_label, labels))
			plot_count.append(count)
			print((count, nmi[-1]))
			link_h.append(dist)
		t2 = datetime.datetime.now()
		print(t2 - t1)

	return plot_count, nmi, link_h


if __name__ == "__main__":
	#count, nmi1, _ = HCluster(1)
	count, nmi2, link_h = HCluster(2)
	#_, nmi3, _ = HCluster(3)
	#print((nmi1[-1], nmi2[-1], nmi3[-1]))
	#plt.plot(count, nmi1, label="linkage 1")
	plt.plot(count, nmi2, label="linkage 2")
	#plt.plot(count, nmi3, label="linkage 3")
	plt.legend()
	plt.xlabel("Step")
	plt.ylabel("NMI")
	plt.show()