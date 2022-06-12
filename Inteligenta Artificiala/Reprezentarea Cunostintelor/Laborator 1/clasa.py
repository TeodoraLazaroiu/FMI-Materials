class Elev:
    i = 0
    d = {}
    def __init__(self, nume=None, sanatate=90, inteligenta=20, oboseala=0, buna_dispozitie=100, lista_activitati=[]):
        if nume == None:
            i = i + 1
            nume = f"Necunoscut_{i}"
        else:
            self.nume = nume
        self.sanatate = sanatate
        self.inteligenta = inteligenta
        self.oboseala = oboseala
        self.buna_dispozitie = buna_dispozitie
        self.lista_activitati = lista_activitati

class Activitati:
    def __init__(self, nume, factor_sanatate, factor_inteligenta, factor_oboseala, factor_dispozitie, durata):
        self.nume = nume
        self.factor_sanatate = factor_sanatate
        self.factor_inteligenta = factor_inteligenta
        self.factor_oboseala = factor_oboseala
        self.factor_dispozitie = factor_dispozitie
        self.durata = durata

f = open("activitati.txt", "r")

f.readline()

# citire fisier activitati
activitati = []
for line in f.readlines():
    line = line.split()
    activitate = Activitati(line[0], int(line[1]), int(line[2]), int(line[3]), int(line[4]), int(line[5]))
    Elev.d[line[0]] = activitate
    activitati.append(activitate)

# citire fisier elevi
nrElevi, nrActivitati = [int(x) for x in f.readline().split()]

listaElevi = []
for i in range(nrElevi):
    line = f.readline().split()
    
    # elev = Elev(line[0], int(line[1], int(line[2], int(line[3], int(line[4]))