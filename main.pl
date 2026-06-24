% main.pl - Ponto de entrada e game loop
% Implementado por: David e Carlos
% Para executar: swipl main.pl

:- ensure_loaded(minimax).
:- ensure_loaded(regras).


simbolo(0, ' ').
simbolo(1, 'X').
simbolo(2, 'O').

exibir_tabuleiro([A,B,C,D,E,F,G,H,I]) :-
    simbolo(A, PosA),
    simbolo(B, PosB),
    simbolo(C, PosC),
    simbolo(D, PosD),
    simbolo(E, PosE),
    simbolo(F, PosF),
    simbolo(G, PosG),
    simbolo(H, PosH),
    simbolo(I, PosI),
    writeln('     1   2   3'),
    writeln('   +-----------+'),
    format('L1 | ~w | ~w | ~w |~n', [PosA,PosB,PosC]),
    writeln('   |---|---|---|'),
    format('L2 | ~w | ~w | ~w |~n', [PosD,PosE,PosF]),
    writeln('   |---|---|---|'),
    format('L3 | ~w | ~w | ~w |~n', [PosG,PosH,PosI]),
    writeln('   +-----------+').

proximo_jogador(1, 2).
proximo_jogador(2, 1).


iniciar :-
    tabuleiro(Tab),
    nl,
    writeln('=== JOGO DA VELHA ==='),
    writeln('1 - Jogador x Computador'),
    writeln('2 - Jogador x Jogador'),
    read(Modo),
    (Modo = 1 ; Modo = 2),
    nl,
    rodar(Tab, 1, Modo, _).

% rodar(Tab, Jogador, Modo, NovoTab) -> Controla o fluxo principal do jogo.

% Caso 1: ha vencedor - exibe tabuleiro final e anuncia o resultado.
rodar(Tab, _, _, Tab) :-
    vencedor(Tab, Vencedor), !,
    exibir_tabuleiro(Tab),
    format('Jogador ~w venceu!~n', [Vencedor]).

% Caso 2: empate - exibe tabuleiro final e anuncia o empate.
rodar(Tab, _, _, Tab) :-
    empate(Tab), !,
    exibir_tabuleiro(Tab),
    writeln('Empate!').

% Caso 3: turno do jogador, exibe tabuleiro, le e processa a jogada.
rodar(Tab, Jogador, Modo, NovoTab) :-
    (Jogador =:= 1;(Jogador =:= 2, Modo =:= 2)),
    nl,
    exibir_tabuleiro(Tab),
    format('Vez do jogador ~w. Digite Linha, Coluna.~n', [Jogador]),
    read(Entrada),
    processar_entrada(Entrada, Tab, Jogador, Modo, NovoTab).

% Caso 4: turno do computador, calcula a melhor jogada via minimax e continua.
rodar(Tab, 2, 1, NovoTab) :-
    writeln('O computador esta calculando a melhor jogada...'),
    minimax(Tab, 2, TabPC, _),
    proximo_jogador(2, Proximo),
    rodar(TabPC, Proximo, 1, NovoTab).

% processar_entrada(Entrada, Tab, NovoTab) -> Processa o termo lido do teclado.

% Saida solicitada pelo jogador: encerra o jogo imediatamente.
processar_entrada((-1, -1), Tab, _, _, Tab) :- !,
    writeln('Jogo encerrado pelo jogador!').

% Jogada informada: Se invalida, solicita nova jogada sem trocar o turno.
processar_entrada((Linha, Coluna), Tab, Jogador, Modo, NovoTab) :-
    (jogar(Linha, Coluna, Tab, Jogador, TabAtualizado)
        -> proximo_jogador(Jogador, Proximo),
        rodar(TabAtualizado, Proximo, Modo, NovoTab)
        ;  writeln('Jogada invalida! Posicao ocupada ou fora do tabuleiro. Tente novamente.'),
           rodar(Tab, Jogador, Modo, NovoTab)
    ).

:- initialization(iniciar, main).
