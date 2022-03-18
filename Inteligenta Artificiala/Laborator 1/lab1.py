import numpy as np
import glob
import cv2
import matplotlib.pyplot as plt


#x=np.array([[1,2,3],[2,3,7]])
#y=np.array([[4,5,6],[2,5,7]])
#print(x@y)

#laboratoare : fmi-unibuc-ia.github.io/ia
# x*y -> element cu element
# x@y -> inmultire de matrici de la mate

X=np.random.randint(0,10, size=(10,10))
#print(X)
#print(X[2:5,3:6]) # printeaza liniile 2 3 4 si col 3 4 5
a=X[2:5,3:6]
a[0,0]=1000
#print(X) # se schimba x daca modifici in a ai grija
#pt a nu se intampla foloseste
b=np.copy(X[2:5,3:6])


filenames= glob.glob('./images/*')
# ca sa iei toate folderele din images si toate imaginile din folderele din images
#filenamesall= glob.glob('./images/**/*')
# ./ floder curent ../ folder precedent

im=np.load(filenames[0])
#print(im.shape)
#plt.imshow(im,cmap='gray')
#plt.show()

filenames2= glob.glob('./imagini/*') #pt imagini nu npy
im2= cv2.imread(filenames2[0])
#print(im2.shape)
im2=im2[:,:,::-1]
#plt.imshow(im2)
#plt.show()
imag=[]
imag2=[]
for fn in filenames:
    img=np.load(fn)
    imag.append(img)

for fn in filenames2:
    img=cv2.imread(fn)
    imag2.append(img)

imag=np.array(imag)
imag2=np.array(imag2)

val=np.mean(imag, axis=0)
print(val.shape)
#nu plotezi asa val normal imparti la 255 ca pc asteapta intre 0 si 1
plt.imshow(val/255,cmap='gray')
#plt.show()

#print(np.mean(imag2)) #sum(suma) mean(medie) std(diferenta standard)

#BROADCASTING
# daca am img 1000,3 media 3 std 3 , numpy stie sa calculeze singur (images-mean)/std pt fiecare imagine

#vector cu suma pixelilor pt fiecare imag
suma=np.sum(imag, axis=(1,2))
suma2=np.sum(imag, axis=(1,2,3))
print(suma)


