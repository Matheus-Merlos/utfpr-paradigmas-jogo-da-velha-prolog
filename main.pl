% Ponto de entrada

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
    writeln('   ┌───┬───┬───┐'),
    format('L1 │ ~w │ ~w │ ~w │~n', [PosA,PosB,PosC]),
    writeln('   ├───┼───┼───┤'),
    format('L2 │ ~w │ ~w │ ~w │~n', [PosD,PosE,PosF]),
    writeln('   ├───┼───┼───┤'),
    format('L3 │ ~w │ ~w │ ~w │~n', [PosG,PosH,PosI]),
    writeln('   └───┴───┴───┘').