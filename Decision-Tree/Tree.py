import math


class Tree(object):
	def __init__(self, data, datalabel, depth):
		self.leftchild = None
		self.rightchild = None
		self.label = 0			#判断这一类属于什么文档类型
		self.keynumber = -1		#作为该节点继续向下分的关键词编号，叶子结点为-1
		self.delta_entropy = 0.0
		self.entropy = 0.0		#该节点的熵
		self.data = data
		self.datalabel = datalabel
		self.count = dict()
		self.depth = depth
		self.error_num = 0

	def Impurity(self):
		#计算本节点的不纯度
		num = len(self.datalabel)
		for i in range(num):
			ind = self.datalabel[i][0]
			if ind not in self.count:
				self.count[ind] = 1
			else:
				self.count[ind] += 1

		maxv = 0
		self.entropy = 0.0
		for i in self.count:
			p = self.count[i]/num
			self.entropy -= p*math.log2(p)
			if self.count[i] > maxv:
				maxv = self.count[i]
				self.label = i

	def SelectFeature(self):
		#选择熵减小最大的二分支特征并进行预分支
		keyamount = len(self.data[0])
		docamount = len(self.data)
		for k in range(keyamount):
			leftdata = []
			leftdatalabel = []
			rightdata = []
			rightdatalabel = []
			for i in range(docamount):
				if self.data[i][k]:
					leftdata.append(self.data[i])
					leftdatalabel.append(self.datalabel[i])
				else:
					rightdata.append(self.data[i])
					rightdatalabel.append(self.datalabel[i])

			templeftchild = Tree(leftdata, leftdatalabel, self.depth + 1)
			temprightchild = Tree(rightdata, rightdatalabel, self.depth + 1)
			templeftchild.Impurity()
			temprightchild.Impurity()
			tempde = self.entropy - (len(leftdata)*templeftchild.entropy/docamount +
									 len(rightdata)*temprightchild.entropy/docamount)
			if tempde > self.delta_entropy:
				self.delta_entropy = tempde
				self.leftchild = templeftchild
				self.rightchild = temprightchild
				self.keynumber = k

	def SplitNode(self, de_threshold, depth_threshold):
		if self.delta_entropy > de_threshold and self.depth < depth_threshold:
			self.data = None
			self.datalabel = None
			self.count = dict()
			self.delta_entropy = 0.0
			self.entropy = 0.0
			return True
		else:
			self.leftchild = None
			self.rightchild = None
			self.keynumber = -1
			self.data = None
			self.datalabel = None
			self.count = dict()
			self.delta_entropy = 0.0
			self.entropy = 0.0
			return False

	def GenerateTree(self, de_threshold, depth_threshold):
		self.SelectFeature()
		if self.SplitNode(de_threshold, depth_threshold):
			self.leftchild.GenerateTree(de_threshold, depth_threshold)
			self.rightchild.GenerateTree(de_threshold, depth_threshold)

	def Refresh(self, data, datalabel):
		# 计算每个节点的错误个数
		self.error_num = 0
		leftdata = []
		leftdatalabel = []
		rightdata = []
		rightdatalabel = []
		for i in range(len(data)):
			if datalabel[i][0] != self.label:
				self.error_num += 1

			if self.keynumber >= 0:
				if data[i][self.keynumber]:
					leftdata.append(data[i])
					leftdatalabel.append(datalabel[i])
				else:
					rightdata.append(data[i])
					rightdatalabel.append(datalabel[i])
		data = None
		datalabel = None
		if self.keynumber >= 0:
			self.leftchild.Refresh(leftdata, leftdatalabel)
			self.rightchild.Refresh(rightdata, rightdatalabel)

	def Prune_inner(self):
		if self.keynumber >= 0:
			self.leftchild.Prune_inner()
			self.rightchild.Prune_inner()
			if self.leftchild.keynumber < 0 and self.rightchild.keynumber < 0:
				# 保证孩子节点是叶子结点
				if self.leftchild.error_num + self.rightchild.error_num > self.error_num:
					self.leftchild = None
					self.rightchild = None
					self.keynumber = -1
		else:
			return

	def Prune(self, crossdata, crosslabel):
		self.Refresh(crossdata, crosslabel)

		self.Prune_inner()

	def sum_error_num(self):
		if self.keynumber < 0:
			return self.error_num

		return self.leftchild.sum_error_num()+self.rightchild.sum_error_num()

	def Decision(self, testdata, testlabel):
		amount = len(testlabel)
		self.Refresh(testdata, testlabel)
		error = self.sum_error_num()
		accuracy = (amount - error)/amount
		return accuracy