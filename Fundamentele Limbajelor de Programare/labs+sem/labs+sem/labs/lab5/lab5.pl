%ex. lab 5

% determina nr de aparitii ale unui element intr-o lista

num_aparitii([], _, 0).
num_aparitii([H|T], El, R) :- num_aparitii(T, El, Rest), ((H == El) ->  R is Rest+1; R is Rest).

% determina lista de cifre pentru un numar dat

lista_cifre_aux(0, []).
lista_cifre_aux(N, [C|R]) :- Aux is N//10, C is N mod 10, lista_cifre_aux(Aux, R).

lista_cifre(N, L) :- reverse(L, L1), lista_cifre_aux(N, L1).

% determina lista de permutari circulare pentru o lista

listpermcirc(L, R) :- append(H, [F|T], L), append([F|T], H, R).

%ex.4

% sterge toate aparitiile unui element dintr-o lista
elimina([], _, []).
elimina([H|L], N, R) :- elimina(L, N, Rest), ( (H \= N) -> append([H], Rest, R); R = Rest ).

% transforma o lista in multime, eliminand duplicatele
multime([], []).
multime([H|T], [H|T1]) :- elimina(T, H, R), multime(R, T1).

% verifica daca o lista este multime(nu are duplicate)
emult(L) :- multime(L, R), R == L.

%ex.5

% intersectia a 2 multimi
inters(L1, L2, R) :- multime(L1, M1), multime(L2, M2), intersection(M1, M2, R).

% diferenta a 2 multimi
diff(L1, L2, R) :- multime(L1, M1), multime(L2, M2), subtract(M1, M2, R).

% produsul cartezian a 2 multimi
prod_cartezian(M,N,R):- findall([X,Y],(member(X,M),member(Y,N)),R).
