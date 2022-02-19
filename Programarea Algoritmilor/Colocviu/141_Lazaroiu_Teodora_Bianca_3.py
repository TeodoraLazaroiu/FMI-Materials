# 141, Lăzăroiu Teodora-Bianca

# Se dă fișierul “autori.in” cu următoarea structură:
# Pe prima linie sunt două numere naturale m și n separate printr-un spațiu.
# Pe următoarele m linii sunt câte 3 valori separate prin spațiu reprezentând informații despre un autor: codul (număr natural), numele și prenumele unui autor.
# Pe următoarele n linii sunt valori separate prin spațiu reprezentând 5 informații despre cărți scrise de autorii dați anterior (o carte are un unic autor): codul unui autor (număr natural, dintre codurile date pe liniile 2, …, m+1), codul cărții (număr natural), an apariție, număr de pagini, numele cărții (șir ce poate conține spații).
# a)      [1,25p] Să se memoreze datele din fișier într-o singură structură astfel încât să se răspundă cât mai eficient la cerințele b) (ștergerea unei cărți având dat codul cărții și aflarea numelui unicului său autor) și c) (accesarea numelui unui autor și a informațiilor despre toate cărțile sale, având dat codul autorului).
# b)     [0,75p] Să se scrie o funcție sterge_carte cu 2 parametri: în primul parametru se transmite structura în care s-au memorat datele la cerința a), iar al doilea este codul unei cărți, care șterge din structura de date primită toate informațiile legate de cartea cu codul dat ca parametru. Funcția returnează numele unicului autor al cărții cu codul dat, sau None dacă acea carte nu s-a găsit.
# Să se apeleze funcția pentru un cod de carte citit de la tastatură și să se afișeze pe ecran mesajul “Cartea a fost scrisa de … .”, sau mesajul “Cartea nu exista.”. Apoi să se afișeze pe ecran toată structura rămasă după ștergere, într-o formă convenabilă.
# c)      [1p] Să se scrie o funcție carti_autor cu 2 parametri: în primul parametru se transmite structura în care s-au memorat datele la cerința a), iar al doilea este codul unui autor. Funcția returnează numele autorului și o listă cu informații despre cărțile sale (un element al listei fiind un tuplu ce conține: numele cărții, anul apariției, numărul de pagini), lista fiind sortată crescător după anul apariției, în caz de egalitate descrescător după numărul de pagini, iar în caz de egalitate crescător după numele cărții. Funcția va returna o listă vidă dacă nu există un autor cu codul primit ca parametru.
# Să se apeleze funcția pentru un cod de autor citit de la tastatură și să se afișeze rezultatul returnat ca în exemplul de mai jos.

# punctul a
f = open("autori.in")
d = {}
m, n =  f.readline().split()
for i in range (int(m)):
    linie = f.readline().split(maxsplit=1)
    d[linie[0]] = [linie[1].rstrip("\n")]
for i in range (int(n)):
    linie = f.readline().split(maxsplit=4)
    carte = [linie[2],linie[3],linie[4].rstrip("\n")]
    dict = {linie[1]:carte}
    if linie[0] in d:
        d[linie[0]].append(dict)
print(d)

# punctul b
def sterge_carte(d,cod):
    for x in d:
        if cod in d[x][1]:
            del cod