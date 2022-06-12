"""
Dati enter dupa fiecare solutie afisata.

Presupunem ca avem costul de plimbare a unui canibal =2 si a unui misionar =1. Astfel A* are trebui sa prefere drumurile in care se muta mai rar canibalii
"""

import math

# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
    gr = None  # trebuie setat sa contina instanta problemei

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
        for nod in l:
            if nod.parinte is not None:
                if nod.parinte.info[2] == 1:
                    mbarca1 = self.__class__.gr.malInitial
                    mbarca2 = self.__class__.gr.malFinal
                else:
                    mbarca1 = self.__class__.gr.malFinal
                    mbarca2 = self.__class__.gr.malInitial
                print(
                    ">>> Barca s-a deplasat de la malul {} la malul {} cu {} canibali si {} misionari.".format(
                        mbarca1,
                        mbarca2,
                        abs(nod.info[0] - nod.parinte.info[0]),
                        abs(nod.info[1] - nod.parinte.info[1]),
                    )
                )
            print(str(nod))
        if afisCost:
            print("Cost: ", self.g)
        if afisCost:
            print("Nr noduri: ", len(l))
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
        if self.info[2] == 1:
            barcaMalInitial = "<barca>"
            barcaMalFinal = "       "
        else:
            barcaMalInitial = "       "
            barcaMalFinal = "<barca>"
        return (
            "Mal: "
            + self.gr.malInitial
            + " Canibali: {} Misionari: {} {}  |||  Mal:"
            + self.gr.malFinal
            + " Canibali: {} Misionari: {} {}"
        ).format(
            self.info[0],
            self.info[1],
            barcaMalInitial,
            self.__class__.gr.N - self.info[0],
            self.__class__.gr.N - self.info[1],
            barcaMalFinal,
        )

    """
	def __str__(self):
		return str(self.info)+"\n"

	"""


class Graph:  # graful problemei
    def __init__(self, nume_fisier):

        f = open(nume_fisier, "r")
        textFisier = (
            f.read()
        )  # citeste tot fisierul si returneaza un string cu continutul lui
        listaInfoFisier = textFisier.split()  # ["3", "2", "stang", "drept"]
        # self.__class__ inseamna clasa curenta
        self.__class__.N = int(listaInfoFisier[0])
        self.__class__.M = int(listaInfoFisier[1])
        self.__class__.malInitial = listaInfoFisier[2]
        self.__class__.malFinal = listaInfoFisier[3]
        # memoram in stare doar canibalii si misionarii de pe malul stang; pe ceilalti ii deducem
        # (nrCanibaliMalInitial, numarMisionariMalInitial, locatieBarca)
        # locatieBarca= 1 daca e pe malul initial si 0 daca e pe malul final
        self.start = (
            self.__class__.N,
            self.__class__.N,
            1,
        )  # informatia nodului de start
        # self.scopuri=[(0,0,0)]

    def testeaza_scop(self, nodCurent):
        return nodCurent.info[0] == nodCurent.info[1] == nodCurent.info[2] == 0

    # functia de generare a succesorilor, facuta la laborator
    def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):
        # mal curent = mal cu barca; mal opus=mal fara barca
        def test_conditie(mis, can):
            return mis == 0 or mis >= can

        listaSuccesori = []
        # nodCurent.info va contine un triplet (c_i, m_i, mal_barca)
        barca = nodCurent.info[2]
        if barca == 1:  # malul barcii este cel initial malul curent e cel cu barca
            canMalCurent = nodCurent.info[0]
            misMalCurent = nodCurent.info[1]
            canMalOpus = Graph.N - canMalCurent
            misMalOpus = Graph.N - misMalCurent
        else:  # barca==0 adica malul final
            canMalOpus = nodCurent.info[0]  # malul opus (barcii) este cel initial
            misMalOpus = nodCurent.info[1]
            canMalCurent = Graph.N - canMalOpus
            misMalCurent = Graph.N - misMalOpus
        maxMisionariBarca = min(Graph.M, misMalCurent)
        for misBarca in range(maxMisionariBarca + 1):
            if misBarca == 0:
                maxCanibaliBarca = min(Graph.M, canMalCurent)
                minCanibaliBarca = 1
            else:
                maxCanibaliBarca = min(Graph.M - misBarca, canMalCurent, misBarca)
                minCanibaliBarca = 0
            for canBarca in range(minCanibaliBarca, maxCanibaliBarca + 1):
                # consideram mal curent nou ca fiind acelasi mal de pe care a plecat barca
                canMalCurentNou = canMalCurent - canBarca
                misMalCurentNou = misMalCurent - misBarca
                canMalOpusNou = canMalOpus + canBarca
                misMalOpusNou = misMalOpus + misBarca
                if not test_conditie(misMalCurentNou, canMalCurentNou):
                    continue
                if not test_conditie(misMalOpusNou, canMalOpusNou):
                    continue
                if (
                    barca == 1
                ):  # testul este pentru barca nodului curent (parinte) deci inainte de mutare
                    infoNodNou = (canMalCurentNou, misMalCurentNou, 0)
                else:
                    infoNodNou = (canMalOpusNou, misMalOpusNou, 1)
                if not nodCurent.contineInDrum(infoNodNou):
                    costSuccesor = 1
                    # costSuccesor=canBarca*2+misBarca
                    listaSuccesori.append(
                        NodParcurgere(
                            infoNodNou,
                            nodCurent,
                            cost=nodCurent.g + costSuccesor,
                            h=NodParcurgere.gr.calculeaza_h(infoNodNou, tip_euristica),
                        )
                    )

        return listaSuccesori

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    # aceasta este o functie mai eficienta de generare a succesorilor, care genereaza direct perechiile valide de numere de canibali si misionari care trec raul (respectand conditia problemei atat pe maluri cat si in barca; deci nu se mai genereaza acele perechi pe care le eliminam apoi pentru ca nu indeplineau conditia)
    """
	def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):

		#functie ajutatoare pentru a nu duplica codul
		def adaugaUnSuccesor(graf,nodCurent,listaSuccesori,canBarca,misBarca,bOpus, tip_euristica):
			infoNodNou=(nodCurent.info[0]+operatie*canBarca, nodCurent.info[1]+operatie*misBarca,bOpus)					
			if not nodCurent.contineInDrum(infoNodNou):						
				costSuccesor=canBarca*2+misBarca # presupunem ca mutarea unui canibal costa de 2 ori mai mult
				listaSuccesori.append(NodParcurgere( infoNodNou , parinte=nodCurent, cost=nodCurent.g+costSuccesor, h=graf.calculeaza_h(infoNodNou, tip_euristica)))

		listaSuccesori=[]
		if nodCurent.info[2]==1:
			canMalCurent=nodCurent.info[0]
			misMalCurent=nodCurent.info[1]
			operatie=-1
		else:
			operatie=1
			canMalCurent=self.N-nodCurent.info[0]
			misMalCurent=self.N-nodCurent.info[1]

		bOpus=1-nodCurent.info[2]

	
		#Voi incerca sa generez numerele de misionari si canibali care pleaca cu barca, cat mai eficient, astfel incat sa nu generez perechi care nu ar verifica conditia din enunt.

		#Observatie: daca am si misionari si canibali  pe un mal, atunci, pe acel mal:
		#- ori sunt toti misionarii si canibali pot fi oricati
		#- ori numarul de misionari e egal cu numarul de canibali

		#daca am avea si misionari si canibali (deci numarul lor diferit de 0) pe ambele maluri si nu ar fi in numar egal, presupunem ca M1 si C1 sunt pe malul 1 
		conditia cere M1>=C1 si cum am zis ca testam ce se intampla cand nu sunt in numar egal, presupunem M1>C1 (strict)
		atunci avem pe celalalt mal N-M1 si N-C1 dar pentru care e adevarat ca N-M1<N-C1 deci nu indeplineste conditia
	

		#generez intai toti succesorii pentru canibali cand numarul de misionari este 0
	
		#canibalii pot pleca singuri doar daca toti misionarii sunt pe un singur mal, altfel daca avem M1 misionari pe primul mal, respectiv M2 misionari pe al doilea mal, ca sa avem echilibru, obligatoriu avem tot M1 si M2 canibali, iar la mutarea unui grup de canibali pe un mal nu se va mai indeplini conditia
		if misMalCurent==0:
			#pleaca 0 misionari si oricati canibali
			for can in range(1, min(self.M, canMalCurent)+1):
					adaugaUnSuccesor(self,nodCurent,listaSuccesori,can,0,bOpus, tip_euristica)


		
		else:
			#singurul caz in care pot pleca doar canibali daca exista si misionari pe malul curent este cand toti misionarii sunt pe malul curent
			if misMalCurent==self.N:				
				for can in range(1, min(self.M, canMalCurent)+1):
					adaugaUnSuccesor(self,nodCurent,listaSuccesori,can,0,bOpus,tip_euristica)

			#pot pleca toti misionarii gramada + canibali cat mai incap in barca
			if misMalCurent<=self.M:
				for can in range(0, self.M-misMalCurent+1):
					adaugaUnSuccesor(self,nodCurent,listaSuccesori,can,misMalCurent,bOpus,tip_euristica)

			#daca nu pleaca toti misionarii, sunt restrictionati de cati canibali sunt pe malul curent si opus
			# de exemplu, pe malul curent : can:C1 mis:N   opus: can:N-C1 mis:0 atunci pot pleca doar de la N-C1 misionari incolo. Daca pleaca N-C1+K misionari, trebuie sa trimit obligatoriu si K canibali.
			#daca misionarii sunt in numar nenul, mai mic decat N pe malul curent, malurile sigur arata asa: can:X mis:X can:N-X mis: N-X si atunci pleaca in numar egal; N-C1 de mai sus ar fi X-X= 0 in cazul asta, 
			minimMisionari=min(misMalCurent-canMalCurent,misMalCurent)#nu pot pleca mai multi misionari decat am pe malul curent, dar nici mai multi decat diferenta dintre numarul de misionari si canibali pe malul curent (care reprezinta surplusul de canibali de pe malul opus). De exemplu 3m 1c | 0m 2c din stanga nu pot pleca mai putin de  2 misionari fiindca malul din dreapta nu ar mai respecta conditia
			minK=1 if minimMisionari==0 else 0#trebuie sa plece macar un misionar ca sa nu pic pe cazul de mai sus cand pleaca doar canibali
			for k in range(minK, min(canMalCurent, (self.M-minimMisionari)//2, misMalCurent-minimMisionari-1)+1):		
				#print("minK", minK, "minimMisionari", minimMisionari, "can ", k, "mis ",minimMisionari+k) #pentru debug
				adaugaUnSuccesor(self,nodCurent,listaSuccesori,k,minimMisionari+k,bOpus, tip_euristica)

			
			
		return listaSuccesori
	"""

    # euristica banala
    def calculeaza_h(self, infoNod, tip_euristica="euristica banala"):
        if tip_euristica == "euristica banala":
            if not infoNod[0] == infoNod[1] == infoNod[2] == 0:
                return 1
            return 0
        elif tip_euristica == "euristica neadmisibila":
            return 100000
        else:
            # calculez cati oameni mai am de mutat si impart la nr de locuri in barca
            # totalOameniDeMutat=infoNod[0]+infoNod[1]
            return (
                2 * math.ceil((infoNod[0] + infoNod[1]) / (self.M - 1))
                + (1 - infoNod[2])
                - 1
            )  # (1-infoNod[2]) vine de la faptul ca daca barca e pe malul final trebuie sa mai faca o trecere spre malul initial ca sa ii ia pe oameni, pe cand daca e deja pe malul initial, nu se mai aduna acel 1

        """
		5c 5m  barca:3locuri


		----->b:3
		<---- b:1

		 2  --->b:3
		"""

        """
		21+21=42  3   42/3=14 drumuri dus, dar si intors
		<--- 14
		"""

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
        # print(nodCurent.info, lSuccesori)
        c.extend(lSuccesori)


def a_star(gr, nrSolutiiCautate, tip_euristica):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start, None, 0, gr.calculeaza_h(gr.start))]

    while len(c) > 0:
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
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
NodParcurgere.gr = gr
# Rezolvat cu breadth first
# print("Solutii obtinute cu breadth first:")
# breadth_first(gr, nrSolutiiCautate=3)

print("\n\n##################\nSolutii obtinute cu A*:")
nrSolutiiCautate = 3
a_star(gr, nrSolutiiCautate=3, tip_euristica="euristica neadmisibila")
