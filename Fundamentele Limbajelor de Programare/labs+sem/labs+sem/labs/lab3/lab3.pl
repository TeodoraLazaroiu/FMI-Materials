% Crossword puzzle - ex. 1

word(abalone,a,b,a,l,o,n,e).
word(abandon,a,b,a,n,d,o,n).
word(enhance,e,n,h,a,n,c,e).
word(anagram,a,n,a,g,r,a,m).
word(connect,c,o,n,n,e,c,t).
word(elegant,e,l,e,g,a,n,t).

% L
% abandon
% elegant
% enhance

% C
% abalone
% anagram
% connect

crosswd(V1, V2, V3, H1, H2, H3) :- word(V1, _, A, _, B, _, C, _),
				   word(H1, _, A, _, D, _, G, _),
                                   word(V2, _, D, _, E, _, F, _),
                                   word(H2, _, B, _, E, _, H, _),
                                   word(V3, _, G, _, H, _, I, _),
                                   word(H3, _, C, _, F, _, I, _).

% ex. 2 - baza de date

born(jan, date(20,3,1977)).
born(jeroen, date(2,2,1992)).
born(joris, date(17,3,1995)).
born(jelle, date(1,1,2004)).
born(joan, date(24,12,0)).
born(joop, date(30,4,1989)).
born(jannecke, date(17,3,1993)).
born(jaap, date(16,11,1995)).

% gaseste toate persoanele nascute intr-un an Y 
year(Y, P) :- born(P, date(_,_,Y)).

% adevarat daca prima data este inainte de a 2-a, altfel fals
before(date(D1,M1,Y1), date(D2,M2,Y2)) :- (D1<D2, M1=:=M2, Y1=:=Y2); (M1<M2, Y1=:=Y2); Y1<Y2.

% adevarat daca prima persoana este mai in varsta decat a 2-a, altfel fals
older(P1, P2) :- born(P1, D1), born(P2, D2), before(D1, D2).

% ex. 3 - drumuri in labirint

connected(1,2).
connected(3,4).
connected(5,6).
connected(7,8).
connected(9,10).
connected(12,13).
connected(13,14).
connected(15,16).
connected(17,18).
connected(19,20).
connected(4,1).
connected(6,3).
connected(4,7).
connected(6,11).
connected(14,9).
connected(11,15).
connected(16,12).
connected(14,17).
connected(16,19).

/*
connected(1,2).
connected(2,1).
connected(1,3).
connected(3,4).
*/

% verifica daca dintr-un pct. se poate ajunge in alt pct.
path(X, Y) :- connected(X,Y); connected(X, Aux), path(Aux, Y).

path2(X,Y) :- path2(X,Y, []).
path2(X,Y,_) :- connected(X,Y).
path2(X,Y,L) :- connected(X,Z), not(member(Z,L)), path2(Z,Y,[X,Z|L]).

% ex.4 - numere naturale

% intoarce succesorul dat ca prim argument
succesor(L, R) :- append(L, [x], R).

% aduna 2 numere
plus(L1,L2,R) :- append(L1,L2,R).

% inmulteste 2 numere
times([], _, []).
times([x|N1], N2, R) :- times(N1,N2,R2), append(R2,N2,R).

% intoarce al n-lea element din lista
element_at([H|_], 1, H).
element_at([_|L], I, R) :- NewI is I - 1, element_at(L, NewI, R).

animal(alligator). 
animal(tortue) .
animal(caribou).
animal(ours) .
animal(cheval) .
animal(vache) .
animal(lapin) .

% ex.6 - sufix, prefix
mutant(X) :-  animal(Y), animal(Z), Y \== Z,
    			name(Y, Ny), name(Z, Nz),
    			append(Y1, Y2, Ny), Y1 \== [],
    			append(Y2, _, Nz) , Y2 \== [],
    			append(Y1, Nz, LX), name(X, LX).
