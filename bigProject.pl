:- use_module(prettyPrint).
:- use_module(smallProject).
:- use_module(listGen).
	
writing(InStream,_) :- at_end_of_stream(InStream).

writing(InStream,Stream) :-
	readNext(InStream,List),
	write(Stream,List), nl(Stream), nl(Stream),
	s(T,List,[]) ->
	((pptree(Stream,T), readNext(InStream,['hasparse'])); (write(Stream,'no'),readNext(InStream,['notparse']))),
	nl(Stream), nl(Stream),
	writing(InStream,Stream).
	

test(InputFile,File) :-
	open(InputFile,read,InStream),
	open(File,write,Stream),
	writing(InStream,Stream), !,
	close(InStream),
	close(Stream).
	
main :- test('input.txt','output.txt').