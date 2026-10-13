%-------------Hechos------------

%padres primera generacion
padre(abraham, herbert).
padre(abraham, homero).
padre(clancy, marge).
padre(clancy, patty).
padre(clancy, selma).

%padres segunda generacion
padre(homero, bart).
padre(homero, lisa).
padre(homero, maggie).

%madres primera generacion
madre(mona, herbert).
madre(mona, homero).
madre(jacqueline, marge).
madre(jacqueline, patty).
madre(jacqueline, selma).

%madres segunda generacion
madre(marge, bart).
madre(marge, lisa).
madre(marge, maggie).
madre(selma, ling).

%--------------------------------


%------------Reglas-----------
hermano(Hermanox, Hermanoy) :-
	(   padre(Padre, Hermanox), padre(Padre, Hermanoy), Hermanox \= Hermanoy ) ; %hermano por parte de papa
    (   madre(Madre, Hermanox), madre(Madre, Hermanoy), Hermanox \= Hermanoy ). %hermano por parte de mama

tio(Tio, Yo) :-
    (   padre(Padre, Yo), hermano(Padre, Tio), Tio \= Padre  ); %tio por parte de papa
    (   madre(Madre, Yo), hermano(Madre, Tio), Tio \= Madre  ). %tio por parte de mama

primo(Yo, Primo) :-
    (   padre(Tio, Primo), tio(Tio, Yo)  ); %primo por parte de papa
    (   madre(Tio, Primo), tio(Tio, Yo)  ). %primo por parte de mama

abuelo(Abuelo, Yo) :-
    (   padre(Padre, Yo), (   padre(Abuelo, Padre); madre(Abuelo, Padre)), Abuelo \= Padre); %tio por parte de papa
    (   madre(Madre, Yo), (   madre(Abuelo, Madre); padre(Abuelo, Madre)), Abuelo \= Madre). %tio por parte de mama


%==========================================================
%   MEJORAS CON LISTAS
%==========================================================

%------------Hechos con listas-----------
% Cada familia (apellido) agrupa a sus miembros en una lista
familia(simpson, [abraham, mona, homero, marge, bart, lisa, maggie]).
familia(bouvier, [clancy, jacqueline, patty, selma, ling]).
familia(powell,  [herbert]).

%------------Reglas auxiliares-----------
% progenitor/2: unifica padre y madre en una sola relacion
progenitor(P, H) :- padre(P, H).
progenitor(P, H) :- madre(P, H).

% apellido/2: usa member/2 para buscar a la persona en la lista de su familia
apellido(Persona, Apellido) :-
    familia(Apellido, Miembros),
    member(Persona, Miembros).

%------------Reglas que devuelven listas-----------
% findall/3 junta todas las respuestas y sort/2 elimina duplicados
% (las reglas originales repiten resultados cuando hay hermanos
% por padre y por madre a la vez).
hijos(Persona, Lista) :-
    findall(H, progenitor(Persona, H), L0),
    sort(L0, Lista).

progenitores(Persona, Lista) :-
    findall(P, progenitor(P, Persona), L0),
    sort(L0, Lista).

hermanos(Persona, Lista) :-
    findall(H, hermano(Persona, H), L0),
    sort(L0, Lista).

tios(Persona, Lista) :-
    findall(T, tio(T, Persona), L0),
    sort(L0, Lista).

primos(Persona, Lista) :-
    findall(P, primo(Persona, P), L0),
    sort(L0, Lista).

abuelos(Persona, Lista) :-
    findall(A, abuelo(A, Persona), L0),
    sort(L0, Lista).

%------------Reglas recursivas sobre listas-----------
% descendientes/2: hijos, nietos, bisnietos, ...
descendientes(Persona, Lista) :-
    hijos(Persona, Hijos),
    descendientes_de_todos(Hijos, Nietos),
    append(Hijos, Nietos, L0),
    sort(L0, Lista).

descendientes_de_todos([], []).
descendientes_de_todos([H|T], Lista) :-
    descendientes(H, DH),
    descendientes_de_todos(T, DT),
    append(DH, DT, Lista).

% ancestros/2: padres, abuelos, bisabuelos, ...
ancestros(Persona, Lista) :-
    progenitores(Persona, Padres),
    ancestros_de_todos(Padres, Abuelos),
    append(Padres, Abuelos, L0),
    sort(L0, Lista).

ancestros_de_todos([], []).
ancestros_de_todos([P|T], Lista) :-
    ancestros(P, AP),
    ancestros_de_todos(T, AT),
    append(AP, AT, Lista).

%------------Reglas que consultan listas-----------
% numero_hijos/2: usa length/2
numero_hijos(Persona, N) :-
    hijos(Persona, Lista),
    length(Lista, N).

% mismo_apellido/2: ambos pertenecen a la misma lista de familia
mismo_apellido(P1, P2) :-
    apellido(P1, A),
    apellido(P2, A),
    P1 \= P2.

% son_hermanos/2: verifica pertenencia con member/2
son_hermanos(P1, P2) :-
    hermanos(P1, Lista),
    member(P2, Lista).