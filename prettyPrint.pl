:- module(prettyPrint,[pptree/2]).
		
pptreeTab(Stream,A,Tab) :-
	(nonvar(A), functor(A,_,X), X>1) ->
		(A =.. [H|T], NTab is Tab+3,
		write(Stream,H),write(Stream,'('),nl(Stream),tab(Stream,NTab),
		pptreeList(Stream,T,NTab),
		write(Stream,')'), nl(Stream), tab(Stream,Tab));
		write(Stream,A),nl(Stream),tab(Stream,Tab).

pptreeList(_,[],_).
pptreeList(Stream,[H|T],Tab):-
	pptreeTab(Stream,H,Tab), pptreeList(Stream,T,Tab).

pptree(Stream,A) :- pptreeTab(Stream,A,0).