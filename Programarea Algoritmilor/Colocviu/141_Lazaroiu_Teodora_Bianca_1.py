# 141, Lăzăroiu Teodora-Bianca

# a) [0,5p] Scrieți o funcție citire_patrat cu un parametru reprezentând numele unui fișier care conține elementele unei matrice pătratice de numere naturale cu următoarea structură: pe linia i a fișierului sunt elementele de pe linia i a matricei separate printr-un spațiu (vezi exemplul de fișier de intrare la punctul c)). Funcția citește elementele matricei din fișierul cu numele dat ca parametru și returnează matricea cu aceste elemente. Dacă matricea nu este pătratică atunci funcția va returna None.
# b) [1,25p] Scrieți o funcție cifre care primește ca parametri (în această ordine): o matrice, un număr natural pozitiv x și un număr variabil de numere naturale reprezentând indici ai liniilor din matrice (indicele primei linii din matrice este 0; indicii dați sunt mai mici decât numărul de linii ale matricei). Asociem fiecărei linii din matrice două mulțimi: mulțimea elementelor care au suma cifrelor mai mică strict decât x și mulțimea elementelor care au suma cifrelor mai mare sau egală ca x de pe acea linie.
# Funcția returnează următoarele două mulțimi:
# - intersecția mulțimilor elementelor care au suma cifrelor mai mică strict decât x asociate liniilor corespunzătoare indicilor dați
# - reuniunea mulțimilor elementelor care au suma cifrelor mai mare sau egală ca x asociate liniilor corespunzătoare indicilor dați
#  (elementele din reuniune sunt distincte două câte două, la fel și cele din intersecție).
# Se acordă jumătate din punctaj dacă în loc de o funcție cu număr variabil de parametri se va scrie o funcție cifre care primește 3 parametri (în această ordine): o matrice, un număr natural pozitiv x și o listă de numere naturale reprezentând indici ai liniilor din matrice și returnează informațiile cerute la punctul b).
# c) [1,25p] Se dă fișierul "patrat.in" cu structura descrisă la punctul a).  Folosind apeluri utile ale funcțiilor de la a) și b) să se citească matricea din fișierul “matrice.in” și să se afișeze pe ecran numerele comune de pe liniile din mijlocul matricei (când matricea are un număr impar de linii considerăm doar linia din mijloc) care au suma cifrelor mai mică decât 9 (pe aceeași linie, separate prin spațiu, ordonate crescător), precum și numărul total de numere care au suma mai mare sau egală ca 9 (distincte) de pe primele 3 linii din matrice.
# Pentru punctul c) se acordă 1p dacă este rezolvat corect dar fără a folosi funcția de la b).
# Explicații: numerele comune celor două linii din mijloc care au suma cifrelor mai mică strict decât 9 sunt 7 și 10 (în ordine crescătoare). Numerele care au suma cifrelor mai mare sau egală ca 9 sunt: 67, 54, 67 – deci în total sunt 2 numere distincte pe primele 3 linii din matrice.

# punctul a
def citire_patrat (fisier):
    a = []
    n = 0
    linie = f.readline()
    while linie != "":
        linie = linie.split()
        m = len(linie)
        a.append(linie)
        linie = f.readline()
        n = n + 1
    if m == n:
        return a

# punctul b
def sum_cifre(x): # returneaza suma cifrelor lui x
    s = 0
    while x != 0:
        s = s + x%10
        x = x//10
    return s

def cifre(matrice,x,numere):
    m1 = set() # intersecția mulțimilor elementelor care au suma cifrelor mai mică strict decât x
    m2 = set() #  reuniunea mulțimilor elementelor care au suma cifrelor mai mare sau egală ca x
    for nr in numere:
        for i in range(len(matrice[nr])):
            if sum_cifre(int(matrice[nr][i])) < int(x):
                m1.add(matrice[nr][i])
            else:
                m2.add(matrice[nr][i])
    return m1,m2

# punctul c
f = open("patrat.in")
a = citire_patrat("patrat.in")
numere = []
for i in range (1,len(a)-1):
    numere.append(i)
m1, m2 = cifre(a,9,numere)
for x in m1:
    print(x,end=" ")
print()
numere = [0,1,2]
m1, m2 = cifre(a,9,numere)
print (len(m2))