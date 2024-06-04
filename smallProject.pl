:- module(smallProject,[s/3]).

lex(the,det,_).
lex(a,det,singular).

lex(woman,noun,singular).
lex(man,noun,singular).
lex(women,noun,plural).
lex(men,noun,plural).
lex(shower,noun,singular).
lex(cow,noun,singular).
lex(table,noun,singular).

lex(shoots,verb,singular).
lex(likes,verb,singular).
lex(like,verb,plural).
lex(shoot,verb,plural).

lex(he,pron,singular,subject).
lex(him,pron,singular,object).
lex(her,pron,singular,object).
lex(she,pron,singular,subject).

lex(big,adj).
lex(fat,adj).
lex(small,adj).
lex(frightened,adj).
lex(dead,adj).

lex(under,prep).
lex(on,prep).

main(Tree, List) :- s(Tree, List, []).

s(s(NP,VP)) --> np(NP,Num,subject),vp(VP,Num),!.

np(np(DET,N),Num,_) --> det(DET,Num),n(N,Num).
np(np(DET,N,NP),Num,_) --> det(DET,Num),n(N,Num), np2(NP).
np(np(DET,ADJBLOCK,N),Num,_) --> det(DET,Num), adjBlock(ADJBLOCK),n(N,Num).
np(np(DET,ADJBLOCK,N,NP),Num,_) --> det(DET,Num), adjBlock(ADJBLOCK),n(N,Num), np2(NP).
np(np(PRON),Num,X) --> pron(PRON,Num,X).

np2(_) --> [].
np2(prepW(PREP,NP)) --> prep(PREP), np(NP,_,_).

adjBlock(_) --> [].
adjBlock(adj(ADJ)) --> adj(ADJ).
adjBlock(adj(ADJ,ADJBLOCK)) --> adj(ADJ), adjBlock(ADJBLOCK).

vp(vp(V,NP),Num) --> v(V,Num), np(NP,_,object).
vp(vp(V),Num) --> v(V,Num).

n(n(W),Num) --> [W], {lex(W,noun,Num)}.
pron(pron(W),Num,X) --> [W], {lex(W,pron,Num,X)}.
det(det(W),Num) --> [W], {lex(W,det,Num)}.
v(v(W),Num) --> [W], {lex(W,verb,Num)}.
prep(prep(W)) --> [W], {lex(W,prep)}.
adj(W) --> [W], {lex(W,adj)}.