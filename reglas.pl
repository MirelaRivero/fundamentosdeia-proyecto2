%------------- REGLAS -------------

% no_requiere_visa(Destino).
% Verdadero si el pais NO requiere visa (segun el hecho booleano).

no_requiere_visa(Destino) :-
    requiere_visa(Destino, false).
 
%------------------------------------------

% destino_en_continente(Destino, Continente).

destino_en_continente(Destino, Continente) :-
    continente(Destino, Continente).

%------------------------------------------

% destino_economico(Destino, CostoMax).
% Verdadero si el costo del destino es menor o igual a CostoMax.
% (Costo ahora es un numero directo, no una categoria.)
destino_economico(Destino, CostoMax) :-
    destino(Destino, Costo, _, _),
    Costo =< CostoMax.

%------------------------------------------

% distancia_valor(CategoriaDistancia, ValorNumerico).
% Traduce la categoria de distancia a un numero para poder comparar.
distancia_valor(poco, 1).
distancia_valor(cercano, 2).
distancia_valor(lejano, 3).

%------------------------------------------

% bien_evaluado(Destino).
% Verdadero si la reseña promedio es 4.5 o superior.

bien_evaluado(Destino) :-
    destino(Destino, _, _, Reseña),
    Reseña >= 4.5.

%------------------------------------------

% cercano(Destino, KmMax).
% Verdadero si la distancia desde Chile en km es menor o igual a KmMax.

cercano(Destino, KmMax) :-
    distancia(chile, Destino, _, Km),
    Km =< KmMax.

%------------------------------------------

% vuelo_corto(Destino, HorasMax).
% Verdadero si el tiempo de vuelo desde Chile es menor o igual a HorasMax.

vuelo_corto(Destino, HorasMax) :-
    distancia(chile, Destino, Horas, _),
    Horas =< HorasMax.

%------------------------------------------

% recomendar(CostoMax, KmMax, ReseñaMin, Destino).

recomendar(CostoMax, KmMax, ReseñaMin, Destino) :-
    destino(Destino, Costo, _, Reseña),
    Costo =< CostoMax,
    distancia(chile, Destino, _, Km),
    Km =< KmMax,
    Reseña >= ReseñaMin,
    no_requiere_visa(Destino).

%------------------------------------------    
 
% recomendar_por_clima(Clima, Destino).

recomendar_por_clima(Clima, Destino) :-
    destino(Destino, _, Clima, _).