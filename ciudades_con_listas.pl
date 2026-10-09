%-----------Hechos--------------

%conexiones directas
conexion(vancouver,edmonton,16).
conexion(vancouver,calgary,13).
conexion(edmonton,saskatoon,12).
conexion(calgary,regina, 14).
conexion(calgary,edmonton, 4).
conexion(saskatoon,calgary, 9).
conexion(saskatoon,winnipeg, 20).
conexion(regina,saskatoon, 7).
conexion(regina,winnipeg, 4).


%------------Reglas-------------

% Camino es la lista de ciudades recorridas, de Origen a Destino.
viajar(Origen, Destino, Costo, Camino) :-
    viajar_aux(Origen, Destino, [Origen], Costo, CaminoInverso),
    reverse(CaminoInverso, Camino).

viajar(Origen, Destino, Costo) :-
    viajar(Origen, Destino, Costo, _).

viajar_aux(Actual, Destino, Visitadas, Costo, [Destino|Visitadas]) :-   % Caso base
    conexion(Actual, Destino, Costo),
    \+ member(Destino, Visitadas).

viajar_aux(Actual, Destino, Visitadas, Costo, Camino) :-                % Caso recursivo
    conexion(Actual, Intermediario, Costo1),
    \+ member(Intermediario, Visitadas),                                 % no repetir ciudades
    viajar_aux(Intermediario, Destino, [Intermediario|Visitadas], Costo2, Camino),
    Costo is Costo1 + Costo2.

