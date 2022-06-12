import time
import copy

ADANCIME_MAX = 6


def elem_identice(lista):
    if len(set(lista)) == 1:
        return lista[0] if lista[0] != Joc.GOL else False
    return False


class Joc:
    """
    Clasa care defineste jocul. Se va schimba de la un joc la altul.
    """

    NR_COLOANE = 3
    JMIN = None
    JMAX = None
    GOL = "#"

    def __init__(self, tabla=None):  # Joc()
        self.matr = tabla or [Joc.GOL] * self.NR_COLOANE**2

    @classmethod
    def jucator_opus(cls, jucator):
        # val_true if conditie else val_false
        return cls.JMAX if jucator == cls.JMIN else cls.JMIN

    # TO DO 5
    def final(self):  # [0,1,2,3,4,5,6,7,8]
        """
        012
        345
        678
        """
        rez = (
            elem_identice(self.matr[0:3])
            or elem_identice(self.matr[3:6])
            or elem_identice(self.matr[6:9])
            or elem_identice(self.matr[0:9:3])
            or elem_identice(self.matr[1:9:3])
            or elem_identice(self.matr[2:9:3])
            or elem_identice(self.matr[0:9:4])
            or elem_identice(self.matr[2:8:2])
        )
        # exercitiul 32
        if rez:
            if rez=="x":
                return "0"
            return "x"
            # return rez
        elif Joc.GOL not in self.matr:
            return "remiza"
        else:
            return False

    # TO DO 3,6
    def mutari(self, jucator):  # jucator = simbolul jucatorului care muta
        l_mutari = []
        for i in range(len(self.matr)):
            if self.matr[i] == Joc.GOL:
                copie_matr = copy.deepcopy(self.matr)
                copie_matr[i] = jucator
                l_mutari.append(Joc(copie_matr))
        return l_mutari

    # linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie castigatoare
    # practic e o linie fara simboluri ale jucatorului opus
    def linie_deschisa(self, lista, jucator):
        jo = self.jucator_opus(jucator)
        # verific daca pe linia data nu am simbolul jucatorului opus
        if not jo in lista:
            return 1
        return 0

    def linii_deschise(self, jucator):
        return (
            self.linie_deschisa(self.matr[0:3], jucator)
            + self.linie_deschisa(self.matr[3:6], jucator)
            + self.linie_deschisa(self.matr[6:9], jucator)
            + self.linie_deschisa(self.matr[0:9:3], jucator)
            + self.linie_deschisa(self.matr[1:9:3], jucator)
            + self.linie_deschisa(self.matr[2:9:3], jucator)
            + self.linie_deschisa(self.matr[0:9:4], jucator)
            + self.linie_deschisa(self.matr[2:7:2], jucator)
        )

    # exercitiul 32
    def estimeaza_scor(self, adancime, j_curent):
        t_final = self.final()
        # if (adancime==0):
        if (t_final == self.__class__.JMAX):  # self.__class__ referinta catre clasa instantei
            return -(99 + adancime)
            # return 99 + adancime
        elif t_final == self.__class__.JMIN:
            return -(-99 - adancime)
            # return -99 - adancime
        elif t_final == "remiza":
            return 0
        # exercitiul 33
        else:
            stari_viitoare = self.mutari(j_curent)
            for joc in stari_viitoare:
                jmin = joc.__class__.JMIN
                jmax = joc.__class__.JMAX
                final = joc.final()
                if (final == jmin == j_curent):
                    return 99
                elif final == jmax == j_curent:
                    return -99
            return 0

            return -(self.linii_deschise(self.__class__.JMAX) - self.linii_deschise(
                self.__class__.JMIN
            ))

    def sirAfisare(self):
        sir = "  |"
        sir += " ".join([str(i) for i in range(self.NR_COLOANE)]) + "\n"
        sir += "-" * (self.NR_COLOANE + 1) * 2 + "\n"
        for i in range(self.NR_COLOANE):  # itereaza prin linii
            sir += (
                str(i)
                + " |"
                + " ".join(
                    [
                        str(x)
                        for x in self.matr[
                            self.NR_COLOANE * i : self.NR_COLOANE * (i + 1)
                        ]
                    ]
                )
                + "\n"
            )
        # [0,1,2,3,4,5,6,7,8]
        return sir

    def __str__(self):
        return self.sirAfisare()

    def __repr__(self):
        return self.sirAfisare()


class Stare:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    O instanta din clasa stare este un nod din arborele minimax
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile posibile in urma mutarii unui jucator
    """

    # TO DO 2
    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, estimare=None):
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

        # adancimea in arborele de stari
        self.adancime = adancime

        # estimarea favorabilitatii starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.estimare = estimare

        # lista de mutari posibile (tot de tip Stare) din starea curenta
        self.mutari_posibile = []

        # cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        # e de tip Stare (cel mai bun succesor)
        self.stare_aleasa = None

    def mutari(self):
        l_mutari = self.tabla_joc.mutari(
            self.j_curent
        )  # lista de informatii din nodurile succesoare
        juc_opus = Joc.jucator_opus(self.j_curent)

        # mai jos calculam lista de noduri-fii (succesori)
        l_stari_mutari = [
            Stare(mutare, juc_opus, self.adancime - 1, parinte=self)
            for mutare in l_mutari
        ]

        return l_stari_mutari

    def __str__(self):
        sir = str(self.tabla_joc) + "(Joc curent:" + self.j_curent + ")\n"
        return sir


# ALGORITM MIN-MAX


def min_max(stare):

    # daca sunt la o frunza in arborele minimax sau la o stare finala
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime, stare.j_curent)
        return stare

    # calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()

    # aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutariCuEstimare = [min_max(x) for x in stare.mutari_posibile]
    # expandez(constr subarb) fiecare nod x din mutari posibile

    if stare.j_curent == Joc.JMAX:
        # daca jucatorul e JMAX aleg starea-fiica cu estimarea maxima
        stare.stare_aleasa = max(
            mutariCuEstimare, key=lambda x: x.estimare
        )  # def f(x): return x.estimare -----> key=f
    else:
        # daca jucatorul e JMIN aleg starea-fiica cu estimarea minima
        stare.stare_aleasa = min(mutariCuEstimare, key=lambda x: x.estimare)

    stare.estimare = stare.stare_aleasa.estimare
    return stare

# ALGORITM ALPHA-BETA

def alpha_beta(alpha, beta, stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime, stare.j_curent)
        return stare

    if alpha > beta:
        return stare  # este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX:
        estimare_curenta = float("-inf")  # in aceasta variabila calculam maximul

        for mutare in stare.mutari_posibile:
            # calculeaza estimarea pentru starea noua, realizand subarborele
            stare_noua = alpha_beta(
                alpha, beta, mutare
            )  # aici construim subarborele pentru stare_noua

            if estimare_curenta < stare_noua.estimare:
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare
            if alpha < stare_noua.estimare:
                alpha = stare_noua.estimare
                if alpha >= beta:  # interval invalid
                    break

    elif stare.j_curent == Joc.JMIN:
        estimare_curenta = float("inf")
        # completati cu rationament similar pe cazul stare.j_curent==Joc.JMAX
        for mutare in stare.mutari_posibile:
            # calculeaza estimarea
            stare_noua = alpha_beta(alpha, beta, mutare) 
            # aici construim subarborele pentru stare_noua

            if estimare_curenta > stare_noua.estimare:
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare
            if beta > stare_noua.estimare:
                beta = stare_noua.estimare
                if alpha >= beta:
                    break

    stare.estimare = stare.stare_aleasa.estimare

    return stare


def afis_daca_final(stare_curenta):
    final = (stare_curenta.tabla_joc.final()) 
    # metoda final() returneaza "remiza" sau castigatorul ("x" sau "0") sau False daca nu e stare finala
    if final:
        if final == "remiza":
            print("Remiza!")
        else:
            print("A castigat " + final)

        return True

    return False


def main():
    # initializare algoritm
    raspuns_valid = False

    # TO DO 1
    while not raspuns_valid:
        tip_algoritm = input(
            "Algoritmul folosit? (raspundeti cu 1 sau 2)\n 1.Minimax\n 2.Alpha-beta\n "
        )
        if tip_algoritm in ["1", "2"]:
            raspuns_valid = True
        else:
            print("Nu ati ales o varianta corecta.")
    # initializare jucatori
    raspuns_valid = False
    while not raspuns_valid:
        Joc.JMIN = input("Doriti sa jucati cu x sau cu 0? ").lower()
        if Joc.JMIN in ["x", "0"]:
            raspuns_valid = True
        else:
            print("Raspunsul trebuie sa fie x sau 0.")
    Joc.JMAX = "0" if Joc.JMIN == "x" else "x"
    # expresie= val_true if conditie else val_false  (conditie? val_true: val_false)

    # initializare tabla
    tabla_curenta = Joc()
    # apelam constructorul
    print("Tabla initiala")
    print(str(tabla_curenta))

    # creare stare initiala
    stare_curenta = Stare(tabla_curenta, "x", ADANCIME_MAX)

    while True:
        if stare_curenta.j_curent == Joc.JMIN:
            # muta jucatorul utilizator

            # TO DO 4
            print("Acum muta utilizatorul cu simbolul", stare_curenta.j_curent)
            raspuns_valid = False
            while not raspuns_valid:
                try:
                    linie = int(input("linie="))
                    coloana = int(input("coloana="))

                    if linie in range(Joc.NR_COLOANE) and coloana in range(
                        Joc.NR_COLOANE
                    ):
                        if (
                            stare_curenta.tabla_joc.matr[
                                linie * Joc.NR_COLOANE + coloana
                            ]
                            == Joc.GOL
                        ):
                            raspuns_valid = True
                        else:
                            print("Exista deja un simbol in pozitia ceruta.")
                    else:
                        print(
                            "Linie sau coloana invalida (trebuie sa fie unul dintre numerele 0,1,2)."
                        )

                except ValueError:
                    print("Linia si coloana trebuie sa fie numere intregi")

            # dupa iesirea din while sigur am valide atat linia cat si coloana
            # deci pot plasa simbolul pe "tabla de joc"
            stare_curenta.tabla_joc.matr[linie * Joc.NR_COLOANE + coloana] = Joc.JMIN

            # afisarea starii jocului in urma mutarii utilizatorului
            print("\nTabla dupa mutarea jucatorului")
            print(str(stare_curenta))
            # TO DO 8a
            # testez daca jocul a ajuns intr-o stare finala
            # si afisez un mesaj corespunzator in caz ca da
            if afis_daca_final(stare_curenta):
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)

        # --------------------------------
        else:  # jucatorul e JMAX (calculatorul)
            # Mutare calculator

            print("Acum muta calculatorul cu simbolul", stare_curenta.j_curent)
            # preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))

            # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
            if tip_algoritm == "1":
                stare_actualizata = min_max(stare_curenta)
            else:  # tip_algoritm==2
                stare_actualizata = alpha_beta(-500, 500, stare_curenta)
            stare_curenta.tabla_joc = (
                stare_actualizata.stare_aleasa.tabla_joc
            )  # aici se face de fapt mutarea !!!
            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))

            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print(
                'Calculatorul a "gandit" timp de '
                + str(t_dupa - t_inainte)
                + " milisecunde."
            )
            # TO DO 8b
            if afis_daca_final(stare_curenta):
                break

            # S-a realizat o mutare.  jucatorul cu cel opus
            stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)


if __name__ == "__main__":
    main()
    # TO DO 9
