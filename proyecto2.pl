
% PROYECTO N2 - Chatbot de Turismo (Fundamentos de IA)
% Archivo unico: hechos + reglas + chatbot interactivo

% ------------------------------------------------------------
% HECHOS
% ------------------------------------------------------------

% origen(Pais).
origen(chile).

% continente(Pais, Continente).
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

% destino(Pais, CostoUSD, Clima, Resena).
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

% requiere_visa(Pais, true/false).
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

% distancia(Pais, TiempoVueloHoras, DistanciaKm).
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

% peso(Criterio, Valor).
peso(resena, 20).
peso(costo, 0.005).
peso(distancia, 0.001).

% dias_minimos(Pais, Dias).
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

% ------------------------------------------------------------
% REGLAS
% ------------------------------------------------------------

no_requiere_visa(Destino) :-
    requiere_visa(Destino, false).

destino_en_continente(Destino, Continente) :-
    continente(Destino, Continente).

destino_economico(Destino, CostoMax) :-
    destino(Destino, Costo, _, _),
    Costo =< CostoMax.

bien_evaluado(Destino) :-
    destino(Destino, _, _, Resena),
    Resena >= 4.5.

cercano(Destino, KmMax) :-
    distancia(Destino, _, Km),
    Km =< KmMax.

vuelo_corto(Destino, HorasMax) :-
    distancia(Destino, Horas, _),
    Horas =< HorasMax.

recomendar(CostoMax, KmMax, ResenaMin, Destino) :-
    destino(Destino, Costo, _, Resena),
    Costo =< CostoMax,
    distancia(Destino, _, Km),
    Km =< KmMax,
    Resena >= ResenaMin,
    no_requiere_visa(Destino).

recomendar_por_clima(Clima, Destino) :-
    destino(Destino, _, Clima, _).

puntaje(Pais, PuntajeFinal) :-
    destino(Pais, Costo, _, Resena),
    distancia(Pais, _, Km),
    peso(resena, PR),
    peso(costo, PC),
    peso(distancia, PK),
    PuntajeFinal is (PR * Resena) - (PC * Costo) - (PK * Km).

recomendaciones(ClimaPref, ContinentePref, DiasPref, PresupuestoMax, VisaStr, ListaOrdenada) :-
    (VisaStr == si -> ReqVisa = true ; ReqVisa = false),
    findall(Puntaje-Pais,
        (
            destino(Pais, Costo, ClimaPais, _),
            continente(Pais, ContinentePais),
            requiere_visa(Pais, ReqVisa),
            dias_minimos(Pais, MinDias),
            ClimaPais == ClimaPref,
            ContinentePais == ContinentePref,
            Costo =< PresupuestoMax,
            MinDias =< DiasPref,
            puntaje(Pais, Puntaje)
        ),
        ListaDesordenada),
    sort(0, @>=, ListaDesordenada, ListaOrdenada).

% ------------------------------------------------------------
% ENTRADA DE USUARIO
% ------------------------------------------------------------

sinonimo('cálido', calido).
sinonimo('sí', si).
sinonimo('américa', america).
sinonimo('áfrica', africa).
sinonimo('oceanía', oceania).
sinonimo('japón', japon).
sinonimo('méxico', mexico).
sinonimo('españa', espana).

limpiar(Texto, Limpio) :-
    (   sinonimo(Texto, Normalizado)
    ->  Limpio = Normalizado
    ;   Limpio = Texto
    ).

leer_linea(Texto) :-
    write('> '), flush_output,
    read_line_to_string(user_input, Linea),
    (   Linea == end_of_file
    ->  nl, halt
    ;   normalize_space(string(S0), Linea),
        string_lower(S0, S),
        atom_string(Texto, S)
    ).

preguntar_opcion(Pregunta, Validas, Respuesta) :-
    writeln(Pregunta),
    leer_linea(T0),
    limpiar(T0, T),
    (   memberchk(T, Validas)
    ->  Respuesta = T
    ;   format('Opción inválida. Opciones válidas: ~w~n', [Validas]),
        preguntar_opcion(Pregunta, Validas, Respuesta)
    ).

preguntar_numero(Pregunta, Minimo, Numero) :-
    writeln(Pregunta),
    leer_linea(T),
    (   atom_number(T, N),
        N >= Minimo
    ->  Numero = N
    ;   format('Por favor ingresa un número mayor o igual a ~w.~n', [Minimo]),
        preguntar_numero(Pregunta, Minimo, Numero)
    ).

% ------------------------------------------------------------
% SALIDA
% ------------------------------------------------------------

mostrar_destino(Posicion, Pais, Puntaje) :-
    destino(Pais, Costo, Clima, Resena),
    distancia(Pais, Horas, Km),
    continente(Pais, Continente),
    (   requiere_visa(Pais, true)
    ->  Visa = 'Requiere visa'
    ;   Visa = 'No requiere visa'
    ),
    format('~d. ~w (~w)~n', [Posicion, Pais, Continente]),
    format(' Costo: USD ~w | Clima: ~w | Reseña: ~w~n', [Costo, Clima, Resena]),
    format(' Vuelo: ~w h (~w km) | ~w | Puntaje: ~1f~n', [Horas, Km, Visa, Puntaje]).

primeros(N, Lista, Top) :-
    length(Lista, L),
    (   L >= N
    ->  length(Top, N),
        append(Top, _, Lista)
    ;   Top = Lista
    ).

mostrar_resultados([]) :-
    writeln('No se encontraron destinos que cumplan con tus preferencias.'),
    writeln('Intenta cambiar tus criterios de búsqueda.').
mostrar_resultados(Lista) :-
    Lista \== [],
    writeln('Destinos recomendados:'),
    primeros(3, Lista, Top),
    length(Lista, Total),
    format('Se encontraron ~d destinos que cumplen con tus preferencias.~n', [Total]),
    forall(nth1(I, Top, Puntaje-Pais),
        mostrar_destino(I, Pais, Puntaje)).

% ------------------------------------------------------------
% FLUJOS DE CONVERSACION
% ------------------------------------------------------------

flujo_recomendacion :-
    nl,
    preguntar_opcion('¿Qué tipo de clima prefieres? (calido/templado)', [calido, templado], Clima),
    preguntar_opcion('¿En qué continente te gustaría viajar? (america/europa/asia/africa/oceania)', [america, europa, asia, africa, oceania], Continente),
    preguntar_numero('¿Cuántos días planeas viajar?', 1, Dias),
    preguntar_numero('¿Cuál es tu presupuesto aproximado en dólares?', 100, Presupuesto),
    preguntar_opcion('¿Buscas un destino que requiera visa? (si/no)', [si, no], Visa),
    nl,
    writeln('Buscando destinos turísticos que cumplan con tus preferencias...'),
    recomendaciones(Clima, Continente, Dias, Presupuesto, Visa, Lista),
    mostrar_resultados(Lista).

flujo_consulta :-
    nl,
    findall(P, destino(P, _, _, _), Paises),
    format('Destinos disponibles: ~w~n', [Paises]),
    writeln('¿Sobre qué destino te gustaría obtener información?'),
    leer_linea(T0),
    limpiar(T0, Pais),
    (   destino(Pais, _, _, _)
    ->  puntaje(Pais, Puntaje),
        dias_minimos(Pais, MinDias),
        mostrar_destino(1, Pais, Puntaje),
        format('Este destino requiere un mínimo de ~d días para disfrutarlo plenamente.~n', [MinDias])
    ;   writeln('Lo siento, no tengo información sobre ese destino.')
    ).

chat :-
    writeln('Chatbot Asistente de Viajes'),
    writeln('---------------------------------'),
    writeln('¡Hola! Soy tu asistente de viajes.'),
    writeln('Puedo ayudarte a encontrar destinos de viaje según clima, continente, días, presupuesto y requisitos de visa.'),
    menu.

menu :-
    nl,
    writeln('Por favor, selecciona una opción:'),
    writeln('1. Obtener recomendaciones de destinos'),
    writeln('2. Consultar información sobre un destino específico'),
    writeln('3. Salir'),
    preguntar_opcion('Ingresa el número de la opción deseada:', ['1', '2', '3'], Opcion),
    ejecutar(Opcion).

ejecutar('1') :- flujo_recomendacion, menu.
ejecutar('2') :- flujo_consulta, menu.
ejecutar('3') :- writeln('¡Gracias por usar el Chatbot Asistente de Viajes! ¡Hasta luego!').