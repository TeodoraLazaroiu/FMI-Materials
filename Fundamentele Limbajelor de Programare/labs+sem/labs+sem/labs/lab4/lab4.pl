%ex. 1

la_dreapta(X,Y) :- X is Y + 1.	%1

la_stanga(X,Y) :- la_dreapta(Y,X).	%2

langa(X,Y) :- la_dreapta(X,Y) ; la_stanga(X,Y).	%3

solutie(Strada,PosesorZebra) :- 
  Strada = [
      casa(1,_,_,_,_,_), %sunt 5 case
      casa(2,_,_,_,_,_),
      casa(3,_,_,_,_,_),
      casa(4,_,_,_,_,_),
      casa(5,_,_,_,_,_)],
    member(casa(_,englez,rosie,_,_,_), Strada), %Englezul locuieste in casa rosie.
    member(casa(_,spaniol,_,caine,_,_), Strada), %Spaniolul are un caine.
    member(casa(_,_,verde,_,cafea,_), Strada),  %In casa verde se bea cafea.
    member(casa(_,ucrainean,_,_,ceai,_), Strada),  %Ucraineanul bea ceai.
    member(casa(A,_,verde,_,_,_), Strada), %Casa verde este imediat in dreapta casei bej.
    member(casa(B,_,bej,_,_,_), Strada),
    la_dreapta(B,A),
    member(casa(_,_,_,melci,_,'Old_Gold'), Strada), %Fumatorul de "Old Gold" are melci.
    member(casa(_,_,galben,_,_,'Kools'), Strada), %In casa galbena se fumeaza "Kools"      
    member(casa(3,_,_,_,lapte,_), Strada), %In casa din mjloc se bea lapte.
    member(casa(1,norvegian,_,_,_,_), Strada), %Norvegianul locuieste in prima casa.
    member(casa(C,_,_,_,_,'Chesterfields'), Strada), 
    member(casa(D,_,_,vulpe,_,_), Strada), %Fumatorul de "Chesterelds" locuieste langa cel care are o vulpe.
    langa(C,D),
    member(casa(E,_,_,_,_,'Kools'), Strada), %"Kools" sunt fumate in casa de langa cea in care se tine calul.
    member(casa(F,_,_,cal,_,_), Strada),
    langa(E,F),
    member(casa(_,_,_,_,portocale,'Lucky Strike'),Strada), %Fumatorul de "Lucky Strike" bea suc de portocale.
    member(casa(_,japonez,_,_,_,'Parliaments'), Strada), %Japonezul fumeaza "Parliaments"
    member(casa(G,norvegian,_,_,_,_), Strada), %Norvegianul locuieste langa casa albastra.
    member(casa(H,_,albastra,_,_,_), Strada),
    langa(G,H),
    member(casa(_,PosesorZebra,_,zebra,_,_), Strada).

/*
	?- solutie(Strada, P).
*/

%ex. 2

:- ['words.pl'].

word_letters(Word,Letters) :- atom_chars(Word,Letters).

cover([],_).
cover([Head|Tail], List2) :- 
            select(Head,List2,Result), 
            cover(Tail,Result).

solution(ListLetters, Word, Score) :- 
    word(Word),
    word_letters(Word,Letters),
    length(Letters, Score),
    cover(Letters,ListLetters).

search_solution(_,'no solution',0).
search_solution(ListLetters,Word,X) :- solution(ListLetters,Word,X).
search_solution(ListLetters,Word,X) :- Y is X-1, search_solution(ListLetters,Word,Y).

topsolution(ListLetters,Word) :- length(ListLetters, Score),
    search_solution(ListLetters,Word,Score).

/*
	topsolution([y,c,a,l,b,e,o,s,x], Word).
*/
