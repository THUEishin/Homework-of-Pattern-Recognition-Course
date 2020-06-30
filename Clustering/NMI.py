import numpy as np
from collections import defaultdict


def NMI(exact_label, cluster_label):
	count_exact = defaultdict(int)
	count_cluster = defaultdict(int)
	for i in exact_label:
		count_exact[i] += 1
	for i in cluster_label:
		count_cluster[i] += 1

	n = len(exact_label)
	count_exact_cluster = defaultdict(lambda:defaultdict(int))
	for index in range(n):
		count_exact_cluster[exact_label[index]][cluster_label[index]] += 1

	H_exact = 0.0
	H_cluster = 0.0
	for index in count_exact:
		value = count_exact[index]
		H_exact += (value*np.log(value/n))
	for index in count_cluster:
		value = count_cluster[index]
		H_cluster += (value*np.log(value/n))
	H_exact_cluster = 0.0
	for index1 in count_exact:
		value1 = count_exact[index1]
		for index2 in count_cluster:
			value2 = count_cluster[index2]
			if count_exact_cluster[index1][index2] == 0:
				continue
			H_exact_cluster += (count_exact_cluster[index1][index2]*
								np.log(n*count_exact_cluster[index1][index2]/value1/value2))

	return H_exact_cluster/np.sqrt(H_exact*H_cluster)