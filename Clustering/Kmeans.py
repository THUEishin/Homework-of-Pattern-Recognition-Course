from read import *
from NMI import *
import matplotlib.pyplot as plt


def initialize(data, class_num=10):
	"""
		Decide initial class
		Calculate the mean and Je
	"""
	feature_amount = data.shape[1]
	data_amount = data.shape[0]
	means = np.zeros((class_num, feature_amount), dtype=np.float)
	J = np.zeros(class_num, dtype=np.float)
	number = np.zeros(class_num, dtype=np.int)
	labels = np.zeros(data_amount, dtype=np.int)
	# even distribution
	slice_num = data_amount // class_num
	index = []
	for i in range(class_num):
		index.append(i*slice_num)
	index.append(data_amount)

	for i in range(class_num):
		start_index = index[i]
		end_index = index[i+1]
		means[i] = data[start_index:end_index].sum(axis=0)/(end_index-start_index)
		number[i] += end_index-start_index
		for j in range(start_index, end_index):
			labels[j] = i
			J[i] += np.dot(data[j] - means[i], data[j] - means[i])

	return J, means, labels, number


if __name__ == "__main__":
	# 聚类问题，不需要测试集数据
	train_image = read_image('train-images.idx3-ubyte')
	train_label = read_label('train-labels.idx1-ubyte')

	mini_size = 2000
	train_image = train_image[:mini_size]
	train_label = train_label[:mini_size]
	final_nmi = []
	for class_num in range(5, 21):
		J, means, labels, number = initialize(train_image, class_num)
		Je = []
		nmi = []
		Je.append(J.sum())
		print("\n\tClass Number: ", class_num)
		nmi.append(NMI(train_label, labels))
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
				y = train_image[i]
				dJk = np.dot(temp_mk - y, temp_mk - y)*Nk/(Nk-1)
				dJj = 1.0e10
				index_j = -1
				for j in range(class_num):
					if not j == k:
						Nj = number[j]
						temp_mj = means[j]
						temp_dJj = np.dot(temp_mj - y, temp_mj - y)*Nj/(Nj+1)
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
					means[index_j] = temp_mj + (y-temp_mj)/(Nj + 1)
					number[k] -= 1
					number[index_j] += 1
					count = 0
				else:
					count += 1
				if count == 1000:
					Je.append(J.sum())
					nmi.append(NMI(train_label, labels))
					if nmi[-1] <= nmi[-2]:
						flag = True
						break

			Je.append(J.sum())
			nmi.append(NMI(train_label, labels))
			print((Je[-1], nmi[-1]))
			if count == mini_size or flag:
				break

		# plt.plot(Je, nmi)
		# plt.xlabel("Je")
		# plt.ylabel("NMI")
		# plt.show()
		print(iter_count)
		final_nmi.append([nmi[-2]])

	plt.plot(range(5, 21), final_nmi)
	plt.xlabel("k")
	plt.ylabel("NMI")
	plt.show()