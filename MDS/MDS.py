import numpy as np
import matplotlib.pyplot as plt
import math
plt.rcParams['font.sans-serif']=['SimHei']
plt.rcParams['axes.unicode_minus']=False

def calculate_b_matrix(D):
	dimension = D.shape[0]
	A = np.empty((dimension, dimension))
	for i in range(dimension):
		for j in range(dimension):
			A[i][j] = -D[i][j]*D[i][j]/2.0

	l = np.ones((dimension, 1))
	H = np.identity(dimension) - np.matmul(l, l.T)/dimension
	B = np.matmul(np.matmul(H, A), H)
	return B


def MDS(B, dimension):
	U, S, V = np.linalg.svd(B)
	V = V[:dimension]
	S = np.diag(np.sqrt(S[:dimension]))
	X = np.matmul(V.T, S).T
	return X


def main():
	# Traffic
	D = np.array([[0. , 18. , 10. , 7. , 10. , 13.5, 44. , 2. ],
				  [18. , 0. , 19. , 18. , 27. , 17.5, 31.5, 31.],
				  [10. , 19. , 0. , 11.5, 18.5, 11. , 45.5, 39.],
				  [7. , 18. , 11.5, 0. , 25.5, 33.5, 26. , 9. ],
				  [10. , 27. , 18.5, 25.5, 0. , 22.5, 52.5, 38. ],
				  [13.5, 17.5, 11. , 33.5, 22.5, 0. , 43.5, 50. ],
				  [44. , 31.5, 45.5, 26. , 52.5, 43.5, 0. , 43.],
				  [12. , 31. , 39. , 9. , 38. , 50. , 43. , 0. ]])
	# Geometry
	D2 = np.array([[0.0, 3.0, 1.0, 3.0, 3.0, 2.3, 5.0, 5.0],
				   [3.0, 0.0, 2.0, 2.2, 6.0, 1.0, 2.0, 3.6],
				   [1.0, 2.0, 0.0, 2.4, 4.0, 1.3, 4.0, 4.5],
				   [3.0, 2.2, 2.4, 0.0, 5.5, 3.0, 3.0, 2.0],
				   [3.0, 6.0, 4.0, 5.5, 0.0, 5.0, 8.0, 8.0],
				   [2.3, 1.0, 1.3, 3.0, 5.0, 0.0, 3.0, 5.0],
				   [5.0, 2.0, 4.0, 3.0, 8.0, 3.0, 0.0, 3.0],
				   [5.0, 3.6, 4.5, 2.0, 8.0, 5.0, 3.0, 0.0]])

	D = (D + D.T)/2.0
	# D = D2
	B = calculate_b_matrix(D)
	X = MDS(B, 2)
	label = ("北京市", "甘肃省天水市", "山西省五台县", "湖北省武汉市",
			 "黑龙江省哈尔滨市", "宁夏自治区永宁县", "四川省九龙县", "广州省广州市")

	# 旋转矩阵，角度需要自己调整
	theta = 60*math.pi/180.0
	cost = math.cos(theta)
	sint = math.sin(theta)

	for i in range(8):
		x = X[0][i]*cost-X[1][i]*sint
		y = X[0][i]*sint+X[1][i]*cost
		plt.scatter(x, y, marker='o')
		plt.annotate(label[i], (x, y))
	plt.show()


if __name__ == "__main__":
	main()