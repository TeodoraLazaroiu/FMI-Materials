parent(a, b).
parent(a, c).
parent(b, d).
parent(b, e).
parent(d, f).
parent(d, g).

%X stramos al lui Y
ancestor_of(X, Y) :- parent(X, Y).
ancestor_of(X, Y) :- parent(X, Z), ancestor_of(Z, Y).

%al n-lea nr. fibonacci
fib(0, 1).
fib(1, 1).
fib(N, R) :- A is N-1, B is N-2, fib(A, R1), fib(B, R2), R is R1 + R2.

%var. mai eficienta
fibo(0,1).
fibo(1,1).
fibo(N, R) :- fibo(1, 1, 1, N, R).
fibo(_, F, N, N, F).
fibo(F0, F1, I, N, R) :- F2 is F0 + F1, J is I+1, fibo(F1, F2, J, N, R).

%afisare un patrat de caractere
squareAux(N,N,N,C) :- write(C).
squareAux(I,N,N,C) :- write(C), nl, Aux is I+1, squareAux(Aux,1,N,C).
squareAux(I,J,N,C) :- write(C), Aux is J+1, squareAux(I,Aux,N,C).
 
square(N,C) :- squareAux(1,1,N,C).

%verifica daca o lista contine un element X
element_of(X, [X|_]).
element_of(X, [_|Tail]) :- element_of(X,Tail).

%concatenarea a 2 liste 
concat_lists([], List, List).
concat_lists([Elem | List1], List2, [Elem | List3]) :- concat_lists(List1, List2, List3).

%verifica daca o lista contine doar a-uri
all_a([]).
all_a([a|T]) :- all_a(T).

%transforma o lista de a-uri in lista de b-uri
trans_a_b([], []).
trans_a_b([a|T1], [b|T2]) :- trans_a_b(T1, T2).

%inmultire cu scalari
scalarMult(_, [], []).
scalarMult(I, [H1|T1], [H2|T2]) :- H2 is I*H1, scalarMult(I, T1, T2).

%produs scalar
dot([], [], 0).
dot([H1|T1], [H2|T2], Result) :- dot(T1, T2, Rest), Result is H1*H2+Rest.

%elementul maxim din lista
max([M], M).
max([H|T], M) :- max(T, TM), (H > TM -> M = H; M = TM).

%verifica daca lista e palindrom
palindrome(L) :- palindrome(L, L, []).
palindrome([], L, L).
palindrome([H|Y], X, Z) :- palindrome(Y, X, [H|Z]).

%sterge toate duplicatele din lista
remove_duplicates([], []).
remove_duplicates([H|T], R) :- member(H,T), remove_duplicates(T, R).
remove_duplicates([H|T], [H|R]) :- not(member(H,T)), remove_duplicates(T, R).

%inlocuieste aparitiile unui element cu alt element
replace([], _, _, []).
replace([H|T], El1, El2, [H1|T1]) :- replace(T, El1, El2, T1), (H = El1 -> H1 = El2; H1 = H).
