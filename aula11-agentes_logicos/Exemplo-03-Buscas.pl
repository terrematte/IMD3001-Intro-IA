% O código a seguir implementa em Swi-Prolog, versão 5.2.7, um algoritmo de
% busca genérico que deve ser parametrizado com o tipo de busca que se deseja
% realizar, conforme as instruções dadas no comentário.
% Disponível em: https://www.ime.usp.br/~slago/IA-Busca.pdf
% /*-----------------------------------------------------------------------------------+
% | Algoritmo de busca gen´erico (selecione uma estratégia) |
% | Para executar, especifique o problema (veja anexo B) e digite: |
% | ?- busca. <enter> |
% +-----------------------------------------------------------------------------------*/
% Selecione a estrategia de busca desejada
% 1 - largura
% 2 - profundidade
% 3 - menor custo
% 4 - melhor estimativa
% 5 - A*
% modificando a linha a seguir
estrategia(5).
busca :- inicial(So), busca([0-0-0-So-[]],[]).
busca([_-G-_-Estado-Caminho|_],_) :-
meta(M), member(Estado,M), !,
reverse(Caminho,Solu¸c~ao),
estrategia(T),
(T=1 -> N = 'busca em largura' ;
T=2 -> N = 'busca em profundidade' ;
T=3 -> N = 'busca pelo menor custo' ;
T=4 -> N = 'busca pela melhor estimativa' ;
T=5 -> N = 'busca A'),
format('~nEstrategia........: ~w', [N]),
format('~nCusto da solucao..: ~w',[G]),
format('~nSequencia de acoes: ~w~n',[Solucao]).
busca([_-G-_-Estado-Caminho|ListaEstados],Expandidos) :-
	sucessores(Estado,Sucessores),
	union([Estado],Expandidos,NovosExpandidos),
	subtract(Sucessores,NovosExpandidos,SucessoresNaoExpandidos),
	estende(G,Estado,Caminho,SucessoresNaoExpandidos,NovosEstados),
	insere(NovosEstados,ListaEstados,NovaListaEstados),
	busca(NovaListaEstados,NovosExpandidos).
	
sucessores(Estado,Sucessores) :-
	findall(X,oper(_,Estado,X,_),Sucessores).

estende(_,_,_,[],[]).

estende(X,E,C,[S|Ss],[F-G-H-S-[A|C]|Ps]) :-
	oper(A,E,S,Y),
	G is X+Y,
	h(S,H),
	estrategia(Tipo),
	(Tipo=1 -> F is 0 ;
	Tipo=2 -> F is 0 ;
	Tipo=3 -> F is G ;
	Tipo=4 -> F is H ;
	Tipo=5 -> F is G+H),
	estende(X,E,C,Ss,Ps).
	
insere(NovosEstados,ListaEstados,NovaListaEstados) :-
	estrategia(Tipo),
	(Tipo=1 -> append(ListaEstados,NovosEstados,NovaListaEstados) ;
	Tipo=2 -> append(NovosEstados,ListaEstados,NovaListaEstados) ;
		append(ListaEstados,NovosEstados,Lista), sort(Lista,NovaListaEstados)).

