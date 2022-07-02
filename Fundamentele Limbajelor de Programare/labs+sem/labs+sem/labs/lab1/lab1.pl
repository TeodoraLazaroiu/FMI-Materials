female(mary).
female(sandra).
female(juliet).
female(lisa).
male(peter).
male(paul).
male(dony).
male(bob).
male(harry).
parent(bob, lisa).
parent(bob, paul).
parent(bob, mary).
parent(juliet, lisa).
parent(juliet, paul).
parent(juliet, mary).
parent(peter, harry).
parent(lisa, harry).
parent(mary, dony).
parent(mary, sandra).

father_of(Father, Child) :- male(Father), parent(Father, Child).
mother_of(Mother, Child) :- female(Mother), parent(Mother, Child).
grandfather_of(Grandfather, Child) :- father_of(Grandfather, Father), parent(Father, Child).
grandmother_of(Grandmother, Child) :- mother_of(Grandmother, Mother), parent(Mother, Child).
sister_of(Sister,Person) :- female(Sister), parent(Father, Sister), parent(Father, Person), Sister\=Person.
brother_of(Brother,Person) :- male(Brother), parent(Father, Brother), parent(Father, Person), Brother\=Person.
aunt_of(Aunt,Person) :- sister_of(Aunt, Parent), parent(Parent, Person).
uncle_of(Uncle,Person) :- brother_of(Uncle, Parent), parent(Parent, Person).

%not_parent(Parent, Child) :- not(parent(Parent, Child)).

%negarea lui parent
not_parent(Parent, Child) :- (female(Parent); male(Parent)), (female(Child); male(Child)) , not(parent(Parent, Child)), Parent\=Child.

%distanta intre 2 puncte
distance((X1, Y1), (X2, Y2), D) :- D is sqrt((X2-X1)^2 + (Y2-Y1)^2).