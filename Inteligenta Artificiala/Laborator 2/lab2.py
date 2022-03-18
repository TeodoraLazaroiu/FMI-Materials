import numpy as np
import matplotlib.pyplot as plt
from sklearn.naive_bayes import MultinomialNB

train_images = np.loadtxt("train_images.txt")
train_labels = np.loadtxt("train_labels.txt")
test_images = np.loadtxt("test_images.txt")
test_labels = np.loadtxt("test_labels.txt")

im = train_images[0]
im = np.reshape(im, (28, 28))

plt.imshow(im, cmap = 'gray')
# plt.show()

# print(train_labels[0])

model = MultinomialNB()
model.fit(train_images, train_labels)
test_predictions = model.predict(test_images)

train_images = np.digitize(train_images, np.linspace(0, 255, 25))

test_images = np.digitize(test_images, np.linspace(0, 255, 25))

model = MultinomialNB()
model.fit(train_images, train_labels)
test_predictions = model.predict(train_images)
# print(model.score(train_images, train_labels))

model = MultinomialNB()
model.fit(test_images, test_labels)
test_predictions = model.predict(test_images)
# print(model.score(test_images, test_labels))

print(np.mean(test_predictions == test_labels))

test_predictions = model.predict(train_images)
print(np.mean(test_predictions == train_labels))
