% Algoritmo minimax para jogar contra você :)

% PREDICADO DE AVALIAÇÃO
% ================================

% Em um jogo da velha, temos 8 "linhas"
% Você ganha com 3 na vertical, 3 horizontal, e diagonal.
% Diagonal só temos 2, vertical temos 3, horizontal temos 3, o que nos dá 8 num geral.
% Para avaliar um jogo da velha, vamos verificar essas 8 linhas, e aqui é onde definimos elas:
line([0, 1, 2]).
line([3, 4, 5]).
line([6, 7, 8]).

line([0, 3, 6]).
line([1, 4, 7]).
line([2, 5, 8]).

line([0, 4, 8]).
line([2, 4, 6]).

% Predicado que avalia a linha, posição 0 representa a quantidade de "X"
% Posição 1 representa a quantidade de "Y", posição 2 é a quantidade de "Vazio"
% E a última é o numero de pontos
evaluate_line(3, 0, 0, 1000).
evaluate_line(2, 0, 1, 10).
evaluate_line(1, 0, 2, 1).

evaluate_line(0, 3, 0, -1000).
evaluate_line(0, 2, 1, -10).
evaluate_line(0, 1, 2, -1).

evaluate_line(_, _, _, 0). % Qualquer outra combinação é 0

% Predicado que filtra elementos iguais
is_equal(X, Y) :- X = Y.
include_eq(X, Table, FilteredTable) :- include(is_equal(X), Table, FilteredTable).

% Predicado pra realmente trazer o valor da linha
count_line_evaluation(Table, [Index1, Index2, Index3], Score) :-
    nth0(Index1, Table, Value1),
    nth0(Index2, Table, Value2),
    nth0(Index3, Table, Value3),
    include_eq(1, [Value1, Value2, Value3], Xs), length(Xs, QuantityX),
    include_eq(2, [Value1, Value2, Value3], Os), length(Os, QuantityBolinha),
    include_eq(0, [Value1, Value2, Value3], Vs), length(Vs, QuantityVazio),
    evaluate_line(QuantityX, QuantityBolinha, QuantityVazio, Score).

% Predicado final que conta o tabuleiro inteiro
evaluate_table(Table, FinalScore) :-
    findall(Score, (line(L), count_line_evaluation(Table, L, Score)), ScoreList),
    sum_list(ScoreList, FinalScore).


% PREDICADO DE GERAR TODAS JOGADAS POSSÍVEIS DADO UM DETERMINADO TABULEIRO
% ================================

% Predicado auxiliar que troca um elemento de uma lista por outro.
replace(0, Element, [_|Tail], [Element|Tail]).
replace(Index, Element, [Head|Tail], [Head|NewTail]) :- Index > 0, NextIndex is Index - 1, replace(NextIndex, Element, Tail, NewTail).

% Predicado que gera todas as próximas jogadas possíveis dado um determinado tabuleiro
generate_all_possible_moves(Table, Player, PossibleMoves) :-
    findall(NewTable, (
            nth0(Index, Table, 0),
            replace(Index, Player, Table, NewTable)
        ), PossibleMoves).


% PREDICADOS AUXILIARES

% Predicado que avalia toda uma lista de movimentos
evaluate_moves([], _, []).
evaluate_moves([HeadTable|TailTables], Player, [Score-HeadTable|TailScores]) :-
    minimax(HeadTable, Player, _, Score),
    evaluate_moves(TailTables, Player, TailScores).

% Predicado que trás o melhor movimento
choose_best_move(1, ScoresList, BestTable, BestScore) :-
    keysort(ScoresList, SortedList),
    last(SortedList, BestScore-BestTable).
choose_best_move(2, ScoresList, BestTable, BestScore) :-
    keysort(ScoresList, [BestScore-BestTable|_]).


vencedor(Table, Player) :-
    line([I1, I2, I3]),
    nth0(I1, Table, Player),
    nth0(I2, Table, Player),
    nth0(I3, Table, Player),
    Player \= 0,
    !.

% PREDICADO PARA VERIFICAR FIM DE JOGO
% ================================
% O jogo acaba se o tabuleiro não tem mais casas vazias
game_over(Table) :- 
    \+ member(0, Table).

% O jogo acaba se alguém ganhou
game_over(Table) :-
    vencedor(Table, _).


% PREDICADO GERAL (O Minimax em si)
% ================================
next_player(1, 2).
next_player(2, 1).

minimax(Table, _, Table, Score) :- 
    game_over(Table),
    evaluate_table(Table, Score),!.
minimax(Table, Player, BestNextTable, BestScore) :-
    \+ game_over(Table),
    generate_all_possible_moves(Table, Player, PossibleMoves),
    next_player(Player, NextPlayer),
    evaluate_moves(PossibleMoves, NextPlayer, ScoresList),
    choose_best_move(Player, ScoresList, BestNextTable, BestScore).