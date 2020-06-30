import struct
import numpy as np


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