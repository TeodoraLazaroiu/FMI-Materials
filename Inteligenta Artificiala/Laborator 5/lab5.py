import numpy as np
import matplotlib.pyplot as plt
import random

# regresii liniare

# puncte cu 2 coordonate de la 0 la 10
x_train = np.random.random((1000,2)) * 10
x_test = np.random.random((500,2)) * 10

y_train = 3.5 * x_train [:,0] + 5.7 * x_train[:,1] - 3.2 + np.random.randn(1000) * 0.1
y_test = 3.5 * x_test [:,0] + 5.7 * x_test[:,1] - 3.2 + np.random.randn(500) * 0.1

w1 = np.random.randn()
w2 = np.random.randn()
b = np.random.randn()

for sample, target in zip(x_train, y_train):
    e = (w1 * sample[0] + w2 * sample[1] + b - target ** 2)