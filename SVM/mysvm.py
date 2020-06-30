from svmutil import *
import numpy as np
import cmath
import matplotlib.pyplot as plt

y1 = [1 for _ in range(10)]
x1 = [[-3.0, -2.9, 9.0, 8.7, 8.41],
      [0.5, 8.7, 0.25, 4.35, 75.69],
      [2.9, 2.1, 8.41, 6.09, 4.41],
      [-0.1, 5.2, 0.01, -0.52, 27.04],
      [-4.0, 2.2, 16.0, -8.8, 4.84],
      [-1.3, 3.7, 1.69, -4.81, 13.69],
      [-3.4, 6.2, 11.56, -21.08, 38.44],
      [-4.1, 3.4, 16.81, -13.94, 11.56],
      [-5.1, 1.6, 26.01, -8.16, 2.56],
      [1.9, 5.1, 3.61, 9.69, 26.01]]
y2 = [-1 for _ in range(10)]
x2 = [[-2.0, -8.4, 4.0, 16.8, 70.56],
      [-8.9, 0.2, 79.21, -1.78, 0.04],
      [-4.2, -7.7, 17.64, 32.34, 59.29],
      [-8.5, -3.2, 72.25, 27.2, 10.24],
      [-6.7, -4.0, 44.89, 26.8, 16.0],
      [-0.5, -9.2, 0.25, 4.6, 84.64],
      [-5.3, -6.7, 28.09, 35.51, 44.89],
      [-8.7, -6.4, 75.69, 55.68, 40.96],
      [-7.1, -9.7, 50.41, 68.87, 94.09],
      [-8.0, -6.3, 64.0, 50.4, 39.69]]
Num = 10
model = svm_train(y1[:Num]+y2[:Num], x1[:Num]+x2[:Num], '-s 0 -c 10000 -t 0')

number = int(model.nSV[0] + model.nSV[1])
SVs = [[0 for _ in range(5)] for _ in range(number)]
coe = [0 for _ in range(number)]
for i in range(number):
    for j in range(5):
        SVs[i][j] = model.SV[i][j].value

    coe[i] = model.sv_coef[0][i]

w = np.dot(coe, SVs)

margin = np.dot(w, w)
margin = 1/(margin**0.5)
f = open("result"+str(Num)+".txt", "w")
f.write("w=\n")
for i in range(5):
    f.write("%0.7f\n" % w[i])

b = -model.rho[0]
f.write("b=%0.7f\n" % b)
f.write("margin=%0.7f" % margin)

theta = [i/100.0 for i in range(315)]
rho = [0 for _ in range(315)]
zeros = []
for i in range(315):
    c = cmath.cos(theta[i])
    s = cmath.sin(theta[i])
    cc = b
    bb = w[0]*c + w[1]*s
    aa = w[2]*c*c + w[3]*c*s + w[4]*s*s
    dd = bb*bb - 4*aa*cc
    if dd < 0:
        rho[i] = -1
        zeros.append(i)
    else:
        rho[i] = (cmath.sqrt(dd)-bb)/2/aa

zeros.reverse()
for i in range(len(zeros)):
    theta.pop(zeros[i])
    rho.pop(zeros[i])

xx = []
yy = []
for i in range(len(theta)):
    xx.append(rho[i]*cmath.cos(theta[i]))
    yy.append(rho[i]*cmath.sin(theta[i]))

plt.plot(xx, yy, c='g', lw='2')

theta = [3.15+i/100.0 for i in range(314)]
rho = [0 for _ in range(314)]
zeros = []
for i in range(314):
    c = cmath.cos(theta[i])
    s = cmath.sin(theta[i])
    cc = b
    bb = w[0]*c + w[1]*s
    aa = w[2]*c*c + w[3]*c*s + w[4]*s*s
    dd = bb*bb - 4*aa*cc
    if dd < 0:
        rho[i] = -1
        zeros.append(i)
    else:
        rho[i] = (cmath.sqrt(dd)-bb)/2/aa

zeros.reverse()
for i in range(len(zeros)):
    theta.pop(zeros[i])
    rho.pop(zeros[i])

xx = []
yy = []
for i in range(len(theta)):
    xx.append(rho[i]*cmath.cos(theta[i]))
    yy.append(rho[i]*cmath.sin(theta[i]))

plt.plot(xx, yy, c='g', lw='2')
plt.scatter(np.array(x1)[:Num, 0], np.array(x1)[:Num, 1], c='r', marker='o')
plt.scatter(np.array(x2)[:Num, 0], np.array(x2)[:Num, 1], c='b', marker='s')
plt.xlim(-20, 20)
plt.ylim(-20, 20)
plt.xlabel("X_1")
plt.ylabel("X_2")
plt.savefig("./discriment"+str(Num)+".png", dpi=300)

for i in range(Num):
    flag = np.dot(w, x1[i]) + b
    if flag < 0:
        print("Wrong in w1 class"+str(i))

    flag = np.dot(w, x2[i]) + b
    if flag > 0:
        print("Wrong in w2 class"+str(i))
