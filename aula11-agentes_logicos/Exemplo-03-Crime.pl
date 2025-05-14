%--------------------------------------------------------------------
% Exemplo disponível em: https://slideplayer.com.br/slide/335769/
% https://wasm.swi-prolog.org/wasm/tinker
%--------------------------------------------------------------------

possivel_suspeito(fred).
possivel_suspeito(mary).
possivel_suspeito(jane).
possivel_suspeito(george).

crime(roubo, john, terca, parque).
crime(roubo, robin, quinta, bar).
crime(roubo, jim, quarta, bar).

estava(fred, terca, parque).

inveja(fred, john).

tem_motivo_contra(Pessoa, Vitima) :-
			inveja(Pessoa, Vitima).

principal_suspeito(Pessoa, Crime) :- 
			crime(Crime, Vitima, Dia, Lugar),
			possivel_suspeito(Pessoa),
			estava(Pessoa, Dia, Lugar),
			tem_motivo_contra(Pessoa, Vitima).

%Questões: 
% ?- principal_suspeito(Desconhecido, Crime).

% ?- principal_suspeito(Quem, roubo).

% ?- crime(Crime, Vitima, Dia, bar).
