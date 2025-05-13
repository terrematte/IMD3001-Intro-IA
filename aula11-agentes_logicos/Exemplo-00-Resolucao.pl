%-----------------------------------------------------------------------------------------
% Exemplo de Consultas em Prolog
%-----------------------------------------------------------------------------------------
% Baseado em https://book.simply-logical.space/src/text/1_part_i/3.1.html
% Para Executar utilize: https://wasm.swi-prolog.org/wasm/tinker 
%-----------------------------------------------------------------------------------------

% Base de Dados:
student_of(X,T):-follows(X,C),teaches(T,C).
follows(paul,computer_science).
follows(paul,expert_systems).
follows(maria,ai_techniques).
teaches(adrian,expert_systems).
teaches(peter,ai_techniques).
teaches(peter,computer_science).


% Verifique: 
?- student_of(S,peter).

% Experimente: 
?- teaches(peter,expert_systems).

% Experimente: 
findall(X, teaches(X,expert_systems), Z).


