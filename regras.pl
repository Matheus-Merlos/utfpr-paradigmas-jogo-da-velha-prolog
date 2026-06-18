% Fatos e predicados que ditam a regra do jogo

% Representação do tabuleiro:
%   - Lista de 9 elementos (índices 0 a 8, linha por linha).
%   - 0 = casa vazia.
%   - 1 = jogador 'X' (humano).
%   - 2 = jogador 'O' (computador / IA).

% Mapeamento de posições (Linha x Coluna -> Índice na lista):
%   (1,1)=0  (1,2)=1  (1,3)=2
%   (2,1)=3  (2,2)=4  (2,3)=5
%   (3,1)=6  (3,2)=7  (3,3)=8


% posicao(Linha, Coluna, Pos) -> Exigido pelo enunciado e utilizado em jogar(Linha, Coluna, Tab, Jogador, NovoTab).
% Descreve cada posição do tabuleiro usando coordenadas (Linha, Coluna) mapeadas para o índice linear Pos na lista do tabuleiro.
posicao(1, 1, 0).
posicao(1, 2, 1).
posicao(1, 3, 2).
posicao(2, 1, 3).
posicao(2, 2, 4).
posicao(2, 3, 5).
posicao(3, 1, 6).
posicao(3, 2, 7).
posicao(3, 3, 8).


% tabuleiro(Tab) -> Estado inicial do tabuleiro, conforme exigido pelo enunciado.
% Todos os 9 elementos são 0 (casas vazias).
tabuleiro([0, 0, 0, 0, 0, 0, 0, 0, 0]).


% substituir(Indice, Elemento, ListaOriginal, ListaNova) -> Predicado auxiliar.
% Substitui o elemento no índice 'Indice' da 'ListaOriginal' por 'Elemento', produzindo 'ListaNova'.
% Utilizado internamente por jogar(Linha, Coluna, Tab, Jogador, NovoTab).

% Caso base: substitui a cabeça da lista.
substituir(0, Elemento, [_|Resto], [Elemento|Resto]).

% Caso recursivo: percorre recursivamente a lista até encontrar o índice desejado.
substituir(Indice, Elemento, [Cabeca|Resto], [Cabeca|RestoNovo]) :- Indice > 0, ProxIndice is Indice - 1, substituir(ProxIndice, Elemento, Resto, RestoNovo).


% empate(Tab) -> Verifica se o jogo terminou em empate no tabuleiro Tab. (vencedor já está em minimax)
% O empate ocorre quando:
%   1. Não há mais casas vazias no tabuleiro (nenhum 0 na lista); E
%   2. Nenhum dos dois jogadores venceu.
% Tab: lista representando o tabuleiro atual.
empate(Tab) :- \+ member(0, Tab), \+ vencedor(Tab, _).
% Não existe nenhuma casa vazia e nenhum jogador venceu.


% casa_vazia(Pos, Tab) -> Auxiliar que verifica se a posição Pos do tabuleiro está livre (valor 0).
% Utilizado por jogar(Linha, Coluna, Tab, Jogador, NovoTab) para validar se a posição está disponível.
% Pos: posição linear na lista (0 a 8).
% Tab: lista representando o tabuleiro atual.
casa_vazia(Pos, Tab) :- nth0(Pos, Tab, 0).
% O valor na posição deve ser 0 (vazia).


% jogar(Linha, Coluna, Tab, Jogador, NovoTab) -> Realiza uma jogada válida e retorna o novo estado do tabuleiro.
% Uma jogada é válida quando:
%   1. Existe uma posição correspondente para as coordenadas informadas através de posicao/3;
%   2. A casa correspondente no tabuleiro está vazia (valor 0).
%   3. O jogador informado é válido (1 ou 2).
% Se todas as condições forem satisfeitas, o tabuleiro é atualizado com a peça do Jogador na posição indicada.
% Linha: linha do tabuleiro (1 a 3).
% Coluna: coluna do tabuleiro (1 a 3).
% Tab: lista representando o tabuleiro atual.
% Jogador: 1 (X) ou 2 (O).
% NovoTab: lista com o tabuleiro atualizado após a jogada.
jogar(Linha, Coluna, Tab, Jogador, NovoTab) :- (Jogador = 1 ; Jogador = 2), posicao(Linha, Coluna, Pos), casa_vazia(Pos, Tab), substituir(Pos, Jogador, Tab, NovoTab).
% Verifica se o jogador é válido, converte as coordenadas (Linha, Coluna) para a posição correspondente no tabuleiro, verifica se a casa está vazia e, se tudo estiver correto, atualiza o tabuleiro com a jogada do jogador.