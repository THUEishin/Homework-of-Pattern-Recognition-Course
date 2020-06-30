import scipy.io as scio
from Tree import Tree
import time

def main():
	# Read data and split into train, cross-test and test as 3:1:1
	datafile = "./Sogou_data/Sogou_webpage.mat"
	data = scio.loadmat(datafile)
	doclabel = data['doclabel']
	wordMat = data['wordMat']
	doc_number = wordMat.shape[0]
	key_number = wordMat.shape[1]
	traindata = [wordMat[i] for i in range(doc_number) if i % 5 == 0 or i % 5 == 1 or i % 5 == 2]
	trainlabel = [doclabel[i] for i in range(doc_number) if i % 5 == 0 or i % 5 == 1 or i % 5 == 2]
	crossdata = [wordMat[i] for i in range(doc_number) if i % 5 == 3]
	crosslabel = [doclabel[i] for i in range(doc_number) if i % 5 == 3]
	testdata = [wordMat[i] for i in range(doc_number) if i % 5 == 4]
	testlabel = [doclabel[i] for i in range(doc_number) if i % 5 == 4]

	time_start = time.time()
	T = Tree(traindata, trainlabel, 0)
	de_threshold = 0.001
	depth_threshold = 100
	T.Impurity()
	T.GenerateTree(de_threshold, depth_threshold)
	T.Prune(crossdata, crosslabel)
	accuracy = T.Decision(testdata, testlabel)
	accuracy_train = T.Decision(traindata, trainlabel)
	time_end = time.time()
	print("超参数(de_threshold={0}, depth_threshold={1})下的训练集正确率为{2}，测试集正确率为{3}，耗时{4}s".format(de_threshold,
																			  depth_threshold, accuracy_train, accuracy,
																			  time_end - time_start))

if __name__ == "__main__":
	main()
