import time

import pygame, sys, copy

ADANCIME_MAX=6

def elem_identice(lista):
	if(all(elem ==lista[0] for elem in lista[1:])) :
		return lista[0] if lista[0]!=Joc.GOL else False
	return False

class Joc:
	"""
	Clasa care defineste jocul. Se va schimba de la un joc la altul.
	"""
	NR_COLOANE=3
	JMIN=None
	JMAX=None
	GOL='#'

	@classmethod
	def initializeaza(cls, display, NR_COLOANE=3, dim_celula=100):
		cls.display=display
		cls.dim_celula=dim_celula
		cls.x_img = pygame.image.load('ics.png')
		cls.x_img = pygame.transform.scale(cls.x_img, (dim_celula,dim_celula))
		cls.zero_img = pygame.image.load('zero.png')
		cls.zero_img = pygame.transform.scale(cls.zero_img, (dim_celula,dim_celula))
		cls.celuleGrid=[] #este lista cu patratelele din grid
		for linie in range(NR_COLOANE):
			for coloana in range(NR_COLOANE):
				patr = pygame.Rect(coloana*(dim_celula+1), linie*(dim_celula+1), dim_celula, dim_celula)
				cls.celuleGrid.append(patr)



	def deseneaza_grid(self, marcaj=None, castig=None): # tabla de exemplu este ["#","x","#","0",......]

		for ind in range(len(self.matr)):
			linie=ind//3 # // inseamna div
			coloana=ind%3

			if marcaj==ind:
				#daca am o patratica selectata, o desenez cu rosu
				culoare=(255,0,0)
			else:
				#altfel o desenez cu alb
				culoare=(255,255,255)
            
			pygame.draw.rect(self.__class__.display, culoare, self.__class__.celuleGrid[ind]) #alb = (255,255,255)
			if self.matr[ind]=='x':
				self.__class__.display.blit(self.__class__.x_img,(coloana*(self.__class__.dim_celula+1),linie*(self.__class__.dim_celula+1)))
			elif self.matr[ind]=='0':
				self.__class__.display.blit(self.__class__.zero_img,(coloana*(self.__class__.dim_celula+1),linie*(self.__class__.dim_celula+1)))
		pygame.display.flip() # !!! obligatoriu pentru a actualiza interfata (desenul)
		#pygame.display.update()



	def __init__(self, tabla=None):
		self.matr= tabla or [self.__class__.GOL]*self.__class__.NR_COLOANE**2

	
	@classmethod
	def jucator_opus(cls, jucator):
		return cls.JMAX if jucator==cls.JMIN else cls.JMIN


	def final(self):
		rez= (elem_identice(self.matr[0:3]) 
		or elem_identice(self.matr[3:6]) 
		or elem_identice(self.matr[6:9])
		or elem_identice(self.matr[0:9:3])
		or elem_identice(self.matr[1:9:3])
		or elem_identice(self.matr[2:9:3])
		or elem_identice(self.matr[0:9:4])
		or elem_identice(self.matr[2:8:2]))
		if(rez):
			return rez
            
		elif self.__class__.GOL not in self.matr:
			return 'remiza'
		else:
			return False

	def mutari(self, jucator):#jucator = simbolul jucatorului care muta
		l_mutari=[]
		for i in range(len(self.matr)):
			if self.matr[i]==Joc.GOL:
				copie_matr=copy.deepcopy(self.matr)
				copie_matr[i]=jucator
				l_mutari.append(Joc(copie_matr))
		return l_mutari
	

	#linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie castigatoare
	#practic e o linie fara simboluri ale jucatorului opus
	def linie_deschisa(self,lista, jucator):
		jo=self.jucator_opus(jucator)
		#verific daca pe linia data nu am simbolul jucatorului opus
		if not jo in lista:
				return 1
		return 0
			
	def linii_deschise(self, jucator):
		return (self.linie_deschisa(self.matr[0:3],jucator) 
			+ self.linie_deschisa(self.matr[3:6], jucator) 
			+ self.linie_deschisa(self.matr[6:9], jucator)
			+ self.linie_deschisa(self.matr[0:9:3], jucator)
			+ self.linie_deschisa(self.matr[1:9:3], jucator)
			+ self.linie_deschisa(self.matr[2:9:3], jucator)
			+ self.linie_deschisa(self.matr[0:9:4], jucator) #prima diagonala
			+ self.linie_deschisa(self.matr[2:8:2], jucator)) # a doua diagonala
			
		
	def estimeaza_scor(self, adancime):
		t_final=self.final()
		#if (adancime==0):
		if t_final==self.__class__.JMAX :
			return (99+adancime)
		elif t_final==self.__class__.JMIN:
			return (-99-adancime)
		elif t_final=='remiza':
			return 0
		else:
			return (self.linii_deschise(self.__class__.JMAX)- self.linii_deschise(self.__class__.JMIN))


	def sirAfisare(self):
		sir="  |"
		sir+=" ".join([str(i) for i in range(self.NR_COLOANE)])+"\n"
		sir+="-"*(self.NR_COLOANE+1)*2+"\n"
		for i in range(self.NR_COLOANE): #itereaza prin linii
				sir+= str(i)+" |"+" ".join([str(x) for x in self.matr[self.NR_COLOANE*i : self.NR_COLOANE*(i+1)]])+"\n"
		#[0,1,2,3,4,5,6,7,8]
		return sir

	def __str__(self):
		return self.sirAfisare()

	def __repr__(self):
		return self.sirAfisare()		



class Stare:
	"""
	Clasa folosita de algoritmii minimax si alpha-beta
	Are ca proprietate tabla de joc
	Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
	De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile posibile in urma mutarii unui jucator
	"""
	def __init__(self, tabla_joc, j_curent, adancime, parinte=None, estimare=None):
		self.tabla_joc=tabla_joc
		self.j_curent=j_curent
		
		#adancimea in arborele de stari
		self.adancime=adancime	
		
		#estimarea favorabilitatii starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
		self.estimare=estimare
		
		#lista de mutari posibile din starea curenta
		self.mutari_posibile=[]
		
		#cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
		self.stare_aleasa=None


	def mutari(self):		
		l_mutari=self.tabla_joc.mutari(self.j_curent)
		juc_opus=Joc.jucator_opus(self.j_curent)
		l_stari_mutari=[Stare(mutare, juc_opus, self.adancime-1, parinte=self) for mutare in l_mutari]

		return l_stari_mutari
		
	
	def __str__(self):
		sir= str(self.tabla_joc) + "(Juc curent:"+self.j_curent+")\n"
		return sir
	

			
""" Algoritmul MinMax """

def min_max(stare):
	
	if stare.adancime==0 or stare.tabla_joc.final() :
		stare.estimare=stare.tabla_joc.estimeaza_scor(stare.adancime)
		return stare
		
	#calculez toate mutarile posibile din starea curenta
	stare.mutari_posibile=stare.mutari()

	#aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
	mutariCuEstimare=[min_max(mutare) for mutare in stare.mutari_posibile]
	


	if stare.j_curent==Joc.JMAX :
		#daca jucatorul e JMAX aleg starea-fiica cu estimarea maxima
		stare.stare_aleasa=max(mutariCuEstimare, key=lambda x: x.estimare)
	else:
		#daca jucatorul e JMIN aleg starea-fiica cu estimarea minima
		stare.stare_aleasa=min(mutariCuEstimare, key=lambda x: x.estimare)
	stare.estimare=stare.stare_aleasa.estimare
	return stare
	

def alpha_beta(alpha, beta, stare):
	if stare.adancime==0 or stare.tabla_joc.final() :
		stare.estimare=stare.tabla_joc.estimeaza_scor(stare.adancime)
		return stare
	
	if alpha>beta:
		return stare #este intr-un interval invalid deci nu o mai procesez
	
	stare.mutari_posibile=stare.mutari()
		

	if stare.j_curent==Joc.JMAX :
		estimare_curenta=float('-inf')
		
		for mutare in stare.mutari_posibile:
			#calculeaza estimarea pentru starea noua, realizand subarborele
			stare_noua=alpha_beta(alpha, beta, mutare)
			
			if (estimare_curenta<stare_noua.estimare):
				stare.stare_aleasa=stare_noua
				estimare_curenta=stare_noua.estimare
			if(alpha<stare_noua.estimare):
				alpha=stare_noua.estimare
				if alpha>=beta:
					break

	elif stare.j_curent==Joc.JMIN :
		estimare_curenta=float('inf')
		
		for mutare in stare.mutari_posibile:
			
			stare_noua=alpha_beta(alpha, beta, mutare)
			
			if (estimare_curenta>stare_noua.estimare):
				stare.stare_aleasa=stare_noua
				estimare_curenta=stare_noua.estimare

			if(beta>stare_noua.estimare):
				beta=stare_noua.estimare
				if alpha>=beta:
					break
	stare.estimare=stare.stare_aleasa.estimare

	return stare
	

def afis_daca_final(stare_curenta):
	final=stare_curenta.tabla_joc.final()
	if(final):
		if (final=="remiza"):
			print("Remiza!")
		else:
			print("A castigat "+final)
			tabla_joc.culoare = (0,255,0)
            

		return True
		
	return False
		
	

def main():
	#initializare algoritm
	raspuns_valid=False
	while not raspuns_valid:
		tip_algoritm=input("Algorimul folosit? (raspundeti cu 1 sau 2)\n 1.Minimax\n 2.Alpha-beta\n ")
		if tip_algoritm in ['1','2']:
			raspuns_valid=True
		else:
			print("Nu ati ales o varianta corecta.")
	#initializare jucatori
	raspuns_valid=False
	while not raspuns_valid:
		Joc.JMIN=input("Doriti sa jucati cu x sau cu 0? ").lower()
		if (Joc.JMIN in ['x', '0']):
			raspuns_valid=True
		else:
			print("Raspunsul trebuie sa fie x sau 0.")
	Joc.JMAX= '0' if Joc.JMIN == 'x' else 'x'
	
	
	#initializare tabla
	tabla_curenta=Joc();
	print("Tabla initiala")
	print(str(tabla_curenta))
	
	#creare stare initiala
	stare_curenta=Stare(tabla_curenta,'x',ADANCIME_MAX)
	
	#setari interf grafica
	pygame.init()
	pygame.display.set_caption('x si 0')
	#dimensiunea ferestrei in pixeli
	#dim_celula=..
	ecran=pygame.display.set_mode(size=(302,302))# N *100+ (N-1)*dimensiune_linie_despartitoare (dimensiune_linie_despartitoare=1)
	Joc.initializeaza(ecran)


	de_mutat=False
	tabla_curenta.deseneaza_grid()
	while True :
		
		if (stare_curenta.j_curent==Joc.JMIN):
		#muta jucatorul
			#[MOUSEBUTTONDOWN, MOUSEMOTION,....]
			#l=pygame.event.get()
			for event in pygame.event.get():
				if event.type== pygame.QUIT:
					pygame.quit() #inchide fereastra
					sys.exit()
				elif event.type == pygame.MOUSEBUTTONDOWN: #click
					
					pos = pygame.mouse.get_pos()#coordonatele clickului
					
					for np in range(len(Joc.celuleGrid)):
						
						if Joc.celuleGrid[np].collidepoint(pos):#verifica daca punctul cu coord pos se afla in dreptunghi(celula)
							#linia si coloana celulei pe care am facut click
							linie=np//3 
							coloana=np%3
							###############################
							if stare_curenta.tabla_joc.matr[np] == Joc.JMIN:
								if (de_mutat and linie==de_mutat[0] and coloana==de_mutat[1]):
									#daca am facut click chiar pe patratica selectata, o deselectez
									de_mutat=False
									stare_curenta.tabla_joc.deseneaza_grid()
								else:
									de_mutat=(linie, coloana)
									#desenez gridul cu patratelul marcat
									stare_curenta.tabla_joc.deseneaza_grid(np)
							elif stare_curenta.tabla_joc.matr[np] == Joc.GOL:	
								if de_mutat:
									#### eventuale teste legate de mutarea simbolului
									stare_curenta.tabla_joc.matr[de_mutat[0]*3+de_mutat[1]]=Joc.GOL
									de_mutat=False		
								#plasez simbolul pe "tabla de joc"
								stare_curenta.tabla_joc.matr[linie*3+coloana]=Joc.JMIN
								
								#afisarea starii jocului in urma mutarii utilizatorului
								print("\nTabla dupa mutarea jucatorului")
								print(str(stare_curenta))
								
								stare_curenta.tabla_joc.deseneaza_grid()
								#testez daca jocul a ajuns intr-o stare finala
								#si afisez un mesaj corespunzator in caz ca da
								if (afis_daca_final(stare_curenta)):
									break
									
									
								#S-a realizat o mutare. Schimb jucatorul cu cel opus
								stare_curenta.j_curent=Joc.jucator_opus(stare_curenta.j_curent)
								
		
		#--------------------------------
		else: #jucatorul e JMAX (calculatorul)
			#Mutare calculator
			
			#preiau timpul in milisecunde de dinainte de mutare
			t_inainte=int(round(time.time() * 1000))
			if tip_algoritm=='1':
				stare_actualizata=min_max(stare_curenta)
			else: #tip_algoritm==2
				stare_actualizata=alpha_beta(-500, 500, stare_curenta)
			stare_curenta.tabla_joc=stare_actualizata.stare_aleasa.tabla_joc
			print("Tabla dupa mutarea calculatorului")
			print(str(stare_curenta))
			
			stare_curenta.tabla_joc.deseneaza_grid()
			#preiau timpul in milisecunde de dupa mutare
			t_dupa=int(round(time.time() * 1000))
			print("Calculatorul a \"gandit\" timp de "+str(t_dupa-t_inainte)+" milisecunde.")
			
			if (afis_daca_final(stare_curenta)):
				break
				
			#S-a realizat o mutare. Schimb jucatorul cu cel opus
			stare_curenta.j_curent=Joc.jucator_opus(stare_curenta.j_curent)

			
if __name__ == "__main__" :
	main()
	while True :
		for event in pygame.event.get():
			if event.type== pygame.QUIT:
				pygame.quit()
				sys.exit()