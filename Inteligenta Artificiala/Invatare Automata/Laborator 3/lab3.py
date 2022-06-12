import numpy as np
import matplotlib.pyplot as plt

# 1. numarul de vecini
# 2. normalizare
# 3. distanta

# L1 = diferentele adunate
# L2 = diferentele la patrat adunate

# KNN Classifier

def classify(test_image):
    # calculam distantele de la imaginea de test
    # la toate imaginile de training

    diferente = np.zeros( [len(train_images), len(train_images[0])] )

    for i in range(len(train_images)):
        for j in range(len(train_images[0])):
            diferente[i][j] = abs(train_images[i][j] - test_image[j])


    # calculul diferentei cu numpy:
    # np.sum(np.abs(train_images - test_image), axis = sum)

    sume = []

    for dif in diferente:
        sume.append(sum(dif))

    # pastrez cei mai apropiati K vecini

    # indicii elementelor sortate dupa suma
    sume = np.argsort(sume)
    k = 10

    # returnez labelul cel mai frecvent printre vecini
    labels = []
    for i in range(k):
        labels.append(train_labels[sume[i]])

    # np.bincount =  vector de frecvente
    # np.argmax(np.bincount(labels)) = labelul care apare de cele mai multe ori
    label = max(labels, key = labels.count)
    
    return label

train_images = np.loadtxt("train_images.txt")
train_labels = np.loadtxt("train_labels.txt")
test_images = np.loadtxt("test_images.txt")
test_labels = np.loadtxt("test_labels.txt")

label = classify(test_images[0])
print(label)