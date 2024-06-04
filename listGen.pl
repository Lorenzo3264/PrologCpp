:- module(listGen,[readNext/2]).

readWord(InStream,W):-
   get_code(InStream,Char),
   checkCharAndReadRest(Char,Chars,InStream),
   atom_codes(W,Chars).


checkCharAndReadRest(10,[],_) :- !.

checkCharAndReadRest(32,[],_) :- !.

checkCharAndReadRest(-1,[],_) :- !.

checkCharAndReadRest(46,[],_) :- !.

checkCharAndReadRest(end_of_file,[],_):- !.

checkCharAndReadRest(Char,[Char|Chars],InStream):-
   get_code(InStream,NextChar),
   checkCharAndReadRest(NextChar,Chars,InStream).


end_of_phrase('.','').
end_of_phrase(W,W) :- W \== '.'.

reading(Stream,[H|T]):-
	readWord(Stream,Temp),
	end_of_phrase(Temp,Out),
	Out \== '',
	!,H = Temp,
	reading(Stream,T).
	
reading(_,[]) :- !.

readNext(Stream,[]) :- at_end_of_stream(Stream).

readNext(Stream,L) :-
	3 is 2+1,
	\+ at_end_of_stream(Stream),
	reading(Stream,L),
	L \== [],!.
	
readNext(Stream,L) :-
	6 is 3*2,
	\+ at_end_of_stream(Stream),
	readNext(Stream,L),!.
