"""
Dati enter dupa fiecare solutie afisata.
 
"""

import copy
import sys
import time

# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
    def __init__(self, info, parinte, cost=0, h=0):
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.g = cost  # consider cost=1 pentru o mutare
        self.h = h
        self.f = self.g + self.h

    def obtineDrum(self):
        l = [self]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte)
            nod = nod.parinte
        return l

    def afisDrum(
        self, afisCost=False, afisLung=False
    ):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        for i, nod in enumerate(l):
            print(i + 1, ")\n", str(nod), sep="")
        if afisCost:
            print("Cost: ", self.g)
        if afisCost:
            print("Lungime: ", len(l))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if infoNodNou == nodDrum.info:
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += str(self.info)
        return sir

    # euristica banală: daca nu e stare scop, returnez 1, altfel 0

    def __str__(self):
        sir = ""
        for linie in self.info:
            sir += " ".join([str(elem) for elem in linie]) + "\n"
        sir += "\n"
        return sir


class Graph:  # graful problemei
    def __init__(self, nume_fisier):
        f = open(nume_fisier, "r")
        sirFisier = f.read()
        try:
            listaLinii = sirFisier.strip().split("\n")
            self.start = []
            for linie in listaLinii:
                self.start.append([int(x) for x in linie.strip().split(" ")])
            print(self.start)
            # verificarea corectitudinii starii de start
            self.scopuri = [[[1, 2, 3], [4, 5, 6], [7, 8, 0]]]
            print(self.scopuri)
        except:
            print("Eroare la parsare!")
            sys.exit(0)  # iese din program

    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    # va genera succesorii sub forma de noduri in arborele de parcurgere

    def nuAreSolutii(self, infoNod):
        listaMatrice = sum(infoNod, [])
        nrInversiuni = 0
        for i in range(len(listaMatrice)):
            if listaMatrice[i] != 0:
                for j in range(i + 1, len(listaMatrice)):
                    if listaMatrice[j] != 0:
                        if listaMatrice[i] > listaMatrice[j]:
                            nrInversiuni += 1
        return nrInversiuni % 2 == 1

    def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):
        listaSuccesori = []
        for lGol in range(len(nodCurent.info)):
            try:
                cGol = nodCurent.info[lGol].index(0)
                break
            except:
                pass
        # stanga, dreapta, sus, jos
        directii = [
            [lGol, cGol - 1],
            [lGol, cGol + 1],
            [lGol - 1, cGol],
            [lGol + 1, cGol],
        ]
        for lPlacuta, cPlacuta in directii:
            if 0 <= lPlacuta < 3 and 0 <= cPlacuta < 3:
                copieMatrice = copy.deepcopy(nodCurent.info)
                copieMatrice[lGol][cGol] = copieMatrice[lPlacuta][cPlacuta]
                copieMatrice[lPlacuta][cPlacuta] = 0
                if not nodCurent.contineInDrum(
                    copieMatrice
                ):  # and not self.nuAreSolutii(copieMatrice):
                    costArc = 1
                    listaSuccesori.append(
                        NodParcurgere(
                            copieMatrice,
                            nodCurent,
                            nodCurent.g + costArc,
                            self.calculeaza_h(copieMatrice, tip_euristica),
                        )
                    )

        return listaSuccesori

    # euristica banala
    def calculeaza_h(self, infoNod, tip_euristica="euristica banala"):
        if infoNod in self.scopuri:
            return 0
        if tip_euristica == "euristica banala":
            return 1
        else:
            h = 0
            for lPlacutaC in range(len(infoNod)):
                for cPlacutaC in range(len(infoNod[0])):
                    if infoNod[lPlacutaC][cPlacutaC] != 0:
                        placuta = infoNod[lPlacutaC][cPlacutaC]
                        lPlacutaF = (placuta - 1) // len(infoNod[0])
                        cPlacutaF = (placuta - 1) % len(infoNod[0])
                        h += abs(lPlacutaF - lPlacutaC) + abs(cPlacutaF - cPlacutaC)
            return h

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


def breadth_first(gr, nrSolutiiCautate):

    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start, None)]

    while len(c) > 0:
        # print("Coada actuala: " + str(c))
        # input()
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie:")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
            print("\n----------------\n")
            input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent)
        c.extend(lSuccesori)


def uniform_cost(gr, nrSolutiiCautate=1):

    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start, None, 0, gr.calculeaza_h(gr.start))]

    while len(c) > 0:
        print("Coada actuala: " + str(c))
        input()
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ", end="")
            nodCurent.afisDrum()
            print("\n----------------\n")
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                # ordonez dupa cost(notat cu g aici și în desenele de pe site)
                if c[i].g > s.g:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)


def a_star(gr, nrSolutiiCautate, tip_euristica):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    if gr.nuAreSolutii(gr.start):
        print("Nu are solutii!")
        return
    c = [NodParcurgere(gr.start, None, 0, gr.calculeaza_h(gr.start))]

    while len(c) > 0:

        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
            print(time.time() - t1, "secunde")
            print("\n----------------\n")
            input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica=tip_euristica)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                # diferenta fata de UCS e ca ordonez dupa f
                if c[i].f >= s.f:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)


gr = Graph("input.txt")

# Rezolvat cu breadth first
# print("Solutii obtinute cu breadth first:")
# breadth_first(gr, nrSolutiiCautate=3)

# print("\n\n##################\nSolutii obtinute cu UCS:")
# print("\nObservatie: stivele sunt afisate pe orizontala, cu baza la stanga si varful la dreapta.")
# uniform_cost(gr, nrSolutiiCautate=4)


print("\n\n##################\nSolutii obtinute cu A*:")
t1 = time.time()
a_star(gr, nrSolutiiCautate=3, tip_euristica="euristica nebanala")
