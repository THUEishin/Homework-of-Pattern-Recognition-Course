import os
import numpy as np
import struct
import datetime
from multiprocessing import Process, Manager, Lock


# define a function to read images
def read_image(filename):
	file = open(filename, "rb").read()
	'''according to the website http://yann.lecun.com/exdb/mnist/, the image file is constructed in MSB as: 
		magic number, image amount, image row size, image col size and image data
	'''
	magic_number, image_amount, row_size, col_size = struct.unpack_from('>IIII', file, 0)
	offset = struct.calcsize('>IIII')
	image_size = row_size*col_size
	image_format = '>'+str(image_size)+'B'
	images = np.empty((image_amount, image_size))
	for i in range(image_amount):
		images[i] = np.array(struct.unpack_from(image_format, file, offset))
		offset = offset + struct.calcsize(image_format)

	return images


# define a function to read labels
def read_label(filename):
	file = open(filename, "rb").read()
	'''according to the website http://yann.lecun.com/exdb/mnist/, the label file is constructed in MSB as: 
			magic number, label amount and label data
	'''
	magic_number, label_amount = struct.unpack_from('>II', file, 0)
	offset = struct.calcsize('>II')
	label_format = '>'+str(label_amount)+'B'
	labels = np.array(struct.unpack_from(label_format, file, offset))
	return labels


# define a function of KNN algorithm
def KNN(train_image, train_label, train_number, test_image, test_label, metric,
		k, process_amount, process_index, error_lock, error_list):
	test_amount = test_image.shape[0]
	for i in range(process_index, test_amount, process_amount):
		distance_kmin = np.array([[0, 1.0e6] for _ in range(k)])
		temp_image = test_image[i]
		temp_distance = 0.0
		for j in range(train_number):
			if metric == 1:
				# L1-norm
				diff_image = temp_image - train_image[j]
				temp_distance = np.sum(np.abs(diff_image))
			elif metric == 2:
				# L2-norm
				diff_image = temp_image - train_image[j]
				temp_distance = np.sqrt(np.dot(diff_image, diff_image))
			elif metric == 3:
				# Linfty-norm
				diff_image = temp_image - train_image[j]
				temp_distance = np.max(np.abs(diff_image))
			else:
				print('These distance metric has not been implemented!')
				os._exit(1)

			if temp_distance < distance_kmin[k-1][1]:
				distance_kmin[k-1][1] = temp_distance
				distance_kmin[k-1][0] = j
				distance_kmin = distance_kmin[np.lexsort(distance_kmin.T)]

		vote_class = np.array([0 for _ in range(10)])
		for j in range(k):
			vote_class[train_label[int(distance_kmin[j][0])]] += 1

		max_index = np.argmax(vote_class)
		if max_index != test_label[i]:
			with error_lock:
				error_list.append(i)
			print("第"+str(i)+"张测试图片预测错误，预测值"+str(max_index)+"，真实值"+str(test_label[i]))


# define main function
def main():
	k = int(input('选取最邻近的K个值，K='))
	train_amount = int(input('输入用于训练的样本数(1-60000):'))
	process_amount = int(input('输入计算进程数（最好与CPU核心数相同）:'))
	metric = int(input('输入距离公式选取（1-L1, 2-L2, 3-Linfty）:'))
	train_image = read_image('train-images.idx3-ubyte')
	train_label = read_label('train-labels.idx1-ubyte')
	test_image = read_image('t10k-images.idx3-ubyte')
	test_label = read_label('t10k-labels.idx1-ubyte')

	# Parallelization
	errors = Manager()
	error_lock = Lock()
	error_list = errors.list([])
	process_list = []
	t1 = datetime.datetime.now()
	for i in range(process_amount):
		p=Process(target=KNN, args=(train_image, train_label, train_amount, test_image, test_label,
									metric, k, process_amount, i, error_lock, error_list))
		p.start()
		process_list.append(p)
	for p in process_list:
		p.join()
	t2 = datetime.datetime.now()
	print("\n错误率为={:.2f}%".format(len(error_list)/float(len(test_label))*100))
	print('耗 时 = ', t2 - t1)


if __name__ == "__main__":
	main()
