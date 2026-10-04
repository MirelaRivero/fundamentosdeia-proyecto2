% Base de conocimiento para el chatbot de turismo
% Dominio: el mundo (destinos turísticos vistos desde Chile)
% ------------------------------------------

%------------------------------------------
% origen(Pais).
% Pais desde el cual se miden distancia y tiempo de vuelo.
%------------------------------------------
origen(chile).

%------------------------------------------
% continente(Pais, Continente).
%------------------------------------------
continente(japon, asia).
continente(china, asia).
continente(egipto, africa).
continente(argentina, america).
continente(brasil, america).
continente(mexico, america).
continente(australia, oceania).
continente(francia, europa).
continente(italia, europa).
continente(espana, europa).

% ------------------------------------------
% destino(Pais, CostoUSD, Clima, Resena).
% costoUSD: costo estimado del viaje (numero).
% clima: calido | templado.
% resena: promedio de 1.0 a 5.0.
% ------------------------------------------
destino(japon, 3000, templado, 4.5).
destino(china, 2500, templado, 4.2).
destino(egipto, 2000, calido, 4.0).
destino(argentina, 1500, templado, 4.3).
destino(brasil, 1800, calido, 4.1).
destino(mexico, 2200, calido, 4.4).
destino(australia, 3500, templado, 4.6).
destino(francia, 4000, templado, 4.7).
destino(italia, 3800, templado, 4.8).
destino(espana, 3600, templado, 4.5).

% ------------------------------------------
% requiere_visa(Pais, Booleano).
% true = los chilenos necesitan visa, false = no la necesitan.
% ------------------------------------------
requiere_visa(japon, false).
requiere_visa(china, false).
requiere_visa(egipto, false).
requiere_visa(argentina, false).
requiere_visa(brasil, false).
requiere_visa(mexico, false).
requiere_visa(australia, true).
requiere_visa(francia, false).
requiere_visa(italia, false).
requiere_visa(espana, false).

% ------------------------------------------
% distancia(pais, tiempo_vuelo, distancia_km)
% Medida desde el pais de origen.
% ------------------------------------------
distancia(japon, 26, 17000).
distancia(china, 27, 19000).
distancia(egipto, 21, 12500).
distancia(argentina, 2, 1100).
distancia(brasil, 4, 3000).
distancia(mexico, 9, 6600).
distancia(australia, 13.5, 11200).
distancia(francia, 14, 11600).
distancia(italia, 15, 11900).
distancia(espana, 12, 10700).

%------------------------------------------
% peso(Criterio, Valor).
% Ponderaciones usadas para las recomendaciones, se pueden ajustar sin tocar las reglas
% puntaje = 20*resena - 0.005*costo - 0.001*km
%------------------------------------------
peso(resena, 20).
peso(costo, 0.005).
peso(distancia, 0.001).

%------------------------------------------
% Días mínimos requeridos por destino 
%------------------------------------------
dias_minimos(japon, 10).
dias_minimos(china, 12).
dias_minimos(egipto, 8).
dias_minimos(argentina, 5).
dias_minimos(brasil, 7).
dias_minimos(mexico, 6).
dias_minimos(australia, 14).
dias_minimos(francia, 8).
dias_minimos(italia, 10).
dias_minimos(espana, 10).
