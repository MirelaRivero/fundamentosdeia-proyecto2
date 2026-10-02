% Hechos: destinos y su ubicación geográfica
% ------------------------------------------
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

% Hechos: atributos y criterios del destino
% formato: destino(pais, costo, clima, resenas)
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

% Hechos: requisitos de entrada (visa)
% formato: requiere_visa(pais, true/false)
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

% Hechos: distancia o tiempo de vuelo desde el origen
% formato: distancia(pais, tiempo_vuelo, distancia_km)
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
