# 141, Lăzăroiu Teodora-Bianca

# a) [1p] Scrieți o funcție modifica_litera cu 4 parametri p, x, y și prop (în această ordine), unde p este un număr natural, x și y sunt două șiruri diferite de caractere formate dintr-o singură literă, iar prop este o propoziție în care cuvintele sunt separate prin câte un spațiu. Funcția returnează două valori:
# - propoziția obținută modificând propoziția prop astfel: în fiecare cuvânt care conține pe poziția p litera x (literele dintr-un cuvânt sunt numerotate începând de la 1) aceasta  va fi înlocuită cu litera y (dacă poziția p există în cuvântul respectiv)
# - numărul de cuvinte din propoziție care nu au fost modificate
# b) [1p] Scrieți o funcție poz_x cu 2 parametri, respectiv o listă de numere naturale și un număr natural x, și returnează o listă cu pozițiile pe care apare numărul x în listă (numerotate de la 1)
# c) [1p] Se dă fișierul "propozitii.in" cu următoarea structură: pe linia k a fișierului se află o propoziție cu cuvintele separate prin câte un spațiu; spunem că propoziția de pe linia k are indicele k (cu numerotarea începând de la 1).
# Se citesc de la tastatură 3 valori: p (număr natural), x și y (două șiruri diferite formate fiecare din exact o literă), toate date pe o singură linie și separate între ele prin câte un spațiu. Folosind apeluri utile ale funcțiilor de la a) și b) să se creeze un nou fișier text "propozitii_modificate.out" modificând fiecare propoziție din fișierul text "propozitii.in" astfel: în fiecare cuvânt dintr-o propoziție care conține pe poziția p litera x (literele dintr-un cuvânt sunt numerotate începând de la 1) aceasta  va fi înlocuită cu litera y (dacă poziția p există în cuvântul respectiv). În plus, să se afișeze pe ecran indicii k ai propozițiilor în care nu a fost modificat niciun cuvânt (cu numerotarea începând de la 1).
# Pentru punctul c) se acorda 0,75p dacă este rezolvat corect, dar fără a folosi funcțiile de la a) și b).


# punctul a
def modifica_litera (p,x,y,prop):
    nr = 0
    s = ""
    for cuv in prop.split():
        if p <= len(cuv) and cuv[p-1] == x:
            cuv = cuv[:p-1] + y + cuv[p:]
        else:
            nr = nr + 1 # contorizam cuv nemodificate
        s = s + cuv + " "
    prop = s
    return prop,nr
# punctul b
def poz_x(lista,x):
    ls = []
    for i in range(len(lista)):
        if lista[i] == x:
            ls.append(i+1)
    return(ls)
f = open("propozitii.in")
g = open("propozitii_modificate.out", "w")
p,x,y = input().split()
p = int(p)
ls = []
linie = f.readline()
while linie != "":
    prop,nr = modifica_litera(p,x,y,linie)
    if nr == len(linie.split()):
        ls.append(0) # inseamna ca nu s-a modificat nimic in linie
    else:
        ls.append(1) # s-a modificat cel putin un cuvant
    g.write(prop)
    g.write("\n")
    linie = f.readline()
lista = poz_x(ls,0) # indicii liniilor nemodificate
for x in lista:
    print(x,end=" ")