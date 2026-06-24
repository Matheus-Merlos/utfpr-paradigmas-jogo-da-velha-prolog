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
    writeln('Voce joga com "X". O computador joga com "O".'),
    writeln('Para sair, digite: -1, -1.'),
    nl,
    rodar(Tab, 1, _).

% rodar(Tab, Jogador, NovoTab) -> Controla o fluxo principal do jogo.

% Caso 1: ha vencedor - exibe tabuleiro final e anuncia o resultado.
rodar(Tab, _, Tab) :-
    vencedor(Tab, Vencedor), !,
    exibir_tabuleiro(Tab),
    (Vencedor =:= 1
        -> writeln('Parabens! Voce venceu!')
        ;  writeln('O computador venceu! Mais sorte da proxima vez.')
    ).

% Caso 2: empate - exibe tabuleiro final e anuncia o empate.
rodar(Tab, _, Tab) :-
    empate(Tab), !,
    exibir_tabuleiro(Tab),
    writeln('Empate!').

% Caso 3: turno do jogador, exibe tabuleiro, le e processa a jogada.
rodar(Tab, 1, NovoTab) :-
    nl,
    exibir_tabuleiro(Tab),
    writeln('Sua vez (X). Digite Linha, Coluna.'),
    read(Entrada),
    processar_entrada(Entrada, Tab, NovoTab).

% Caso 4: turno do computador, calcula a melhor jogada via minimax e continua.
rodar(Tab, 2, NovoTab) :-
    writeln('O computador esta calculando a melhor jogada...'),
    minimax(Tab, 2, TabPC, _),
    proximo_jogador(2, Proximo),
    rodar(TabPC, Proximo, NovoTab).

% processar_entrada(Entrada, Tab, NovoTab) -> Processa o termo lido do teclado.

% Saida solicitada pelo jogador: encerra o jogo imediatamente.
processar_entrada((-1, -1), Tab, Tab) :- !,
    writeln('Jogo encerrado pelo jogador!').

% Jogada informada: Se invalida, solicita nova jogada sem trocar o turno.
processar_entrada((Linha, Coluna), Tab, NovoTab) :-
    (jogar(Linha, Coluna, Tab, 1, TabAtualizado)
        -> rodar(TabAtualizado, 2, NovoTab)
        ;  writeln('Jogada invalida! Posicao ocupada ou fora do tabuleiro. Tente novamente.'),
           rodar(Tab, 1, NovoTab)
    ).

:- initialization(iniciar, main).
