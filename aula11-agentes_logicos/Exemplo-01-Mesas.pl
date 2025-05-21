% Para comemorar o aniversário de Cíntia, ela e mais quatro amigas 
% - Alice, Bia, Dirce e Eunice - foram almoçar juntas no RU. 
% As mesas são redondas e acomodam exatamente 5 pessoas. 
% Cíntia e Dirce sentam-se uma ao lado da outra. 
% Alice e Bia não sentam-se uma ao lado da outra. 
% As duas amigas sentadas ao lado de Eunice são?


% Considere as funções de Listas:
% permutation(?Xs, ?Ys) 
% - https://www.swi-prolog.org/pldoc/man?predicate=permutation/2
% nextto(X,Y,L) 
% - https://www.swi-prolog.org/pldoc/doc_for?object=nextto/3
% last(L,Y) - 
% - https://www.swi-prolog.org/pldoc/doc_for?object=last/2

:- use_module(library(lists)).

solucao(X,Y) :-
    A = [alice,bia,cintia,dirce,eunice],
    permutation(A,L), % 
    aolado(cintia,dirce,L),
    not(aolado(alice,bia,L)),
    aolado(X,eunice,L),
    aolado(Y,eunice,L),
    not(X=Y),!.

aolado(X,Y,L) :- nextto(X,Y,L); 
    			 nextto(Y,X,L). 

aolado(X,Y,L) :- naspontas(X,Y,L).

naspontas(X,Y,L) :- L = [X|_], last(L,Y).
naspontas(X,Y,L) :- L = [Y|_], last(L,X).
