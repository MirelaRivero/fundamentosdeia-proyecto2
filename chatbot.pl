% Chatbot de Turismo
%-----------------------------------------------

:- ['base_conocimiento.pl', 'reglas.pl'].

% Entrada de usuario
%-----------------------------------------------

% sinonimo(Escrito, Normalizado): acepta las tildes y variantes de escritura y normaliza a una forma estándar
sinonimo('cálido', 'calido').
sinonimo('sí', 'si').
sinonimo('américa', 'america').
sinonimo('áfrica', 'africa').
sinonimo('oceanía', 'oceania').
sinonimo('japón', 'japon').
sinonimo('méxico', 'mexico').
sinonimo('españa', 'espana').

limpiar(Texto, Limpio) :-
    (   sinonimo(Texto, Normalizado)
    ->  Limpio = Normalizado
    ;   Limpio = Texto
    ).

% leer_linea(Texto): lee una línea de entrada del usuario y la pasa a minuscula
% y sin dejar espacios sobrantes
leer_linea(Texto) :-
    write('> '), flush_output,
    read_line_to_string(user_input, Linea),
    (   Linea == end_of_file
    ->  nl, halt
    ;   normalize_space(string(S0), Linea),
        string_lower(S0, S),
        atom_string(Texto, S)
    ).

% preguntar_opcion(Pregunta, Validas, Respuesta): repite la pregunta hasta recibir
% una respuesta valida
preguntar_opcion(Pregunta, Validas, Respuesta) :-
    writeln(Pregunta),
    leer_linea(T0),
    limpiar(T0, T),
    (   memberchk(Respuesta, Validas)
    ->  Respuesta = T
    ;   format('Opción inválida. Opciones válidas: ~w~n', [Validas]),
        preguntar_opcion(Pregunta, Validas, Respuesta)
    ).

% preguntar_numero(Pregunta, Minimo, Numero).
preguntar_numero(Pregunta, Minimo, Numero) :-
    writeln(Pregunta),
    leer_linea(T),
    (   atom_number(T, N),
        N >= Minimo
    ->  Numero = N
    ;   format('Por favor ingresa un número mayor o igual a ~w.~n', [Minimo]),
        preguntar_numero(Pregunta, Minimo, Numero)
    ).

%-----------------------------------------------
% Salida
%-----------------------------------------------

mostrar_destino(Posicion, Pais, Puntaje) :-
    destino(Pais, Costo, Clima, Resena),
    distancia(Pais, Horas, Km),
    continente(Pais, Continente),
    (   requiere_visa(Pais, true)
    ->  Visa = 'Requiere visa'
    ;   Visa = 'No requiere visa'
    ).
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

%-----------------------------------------------
% Flujos de conversacion
%-----------------------------------------------

flujo_recomendacion :-
    nl,
    preguntar_opcion('¿Qué tipo de clima prefieres? (calido/templado)', ['calido', 'templado'], Clima),
    preguntar_opcion('¿En qué continente te gustaría viajar? (america/europa/asia/africa/oceania)', ['america', 'europa', 'asia', 'africa', 'oceania'], Continente),
    preguntar_numero('¿Cuántos días planeas viajar?', 1, Dias),
    preguntar_numero('¿Cuál es tu presupuesto aproximado en dólares?', 100, Presupuesto),
    preguntar_opcion('¿Buscas un destino que requiera visa? (si/no)', ['si', 'no'], Visa),
    (   Visa == 'si' -> RequiereVisa = true ; RequiereVisa = false ),
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
        mostrar_informacion(1, Pais, Puntaje),
        format('Este destino requiere un mínimo de ~d días para disfrutarlo plenamente.~n', [MinDias])
        ;   writeln('Lo siento, no tengo información sobre ese destino.')
    ).
    
% Programa principal del chatbot

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
