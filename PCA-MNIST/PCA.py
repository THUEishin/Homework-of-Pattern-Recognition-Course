import os
import numpy as np
import struct
import matplotlib.pyplot as plt


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


def draw_picture(pic_data):
	img = pic_data.reshape(28, 28)
	plt.imshow(img)
	plt.show()


def main():
	train_image = read_image('train-images.idx3-ubyte')
	train_label = read_label('train-labels.idx1-ubyte')

	# 每一个类选取1000张图片
	count = [0]*10
	train_amount = train_image.shape[0]
	mean = np.zeros((28*28,))
	data = np.empty((10000, 28*28))
	for i in range(train_amount):
		label = train_label[i]
		temp = sum(count)
		if temp == 10000:
			break

		if count[label] < 1000:
			data[temp] = np.array(train_image[i])
			mean += np.array(train_image[i])
			count[label] += 1

	# 零均值化
	mean /= 10000
	for i in range(10000):
		data[i] -= mean

	Sigma = np.matmul(data.T, data)/10000
	U, S, V = np.linalg.svd(Sigma)
	for i in range(10):
		draw_picture(V[i])


if __name__ == "__main__":
	main()