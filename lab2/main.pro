﻿% Copyright

implement main
    open core, file, stdio

domains
    genre = развлекательный; научный; бытовой; новостной; спортивный.

class facts - publications
    журнал : (integer Id, string Название, genre Жанр, integer Цена).
    газета : (integer Id, string Название, genre Жанр, integer Цена).
    подписчик : (integer Id, string ФИО, integer Возраст, string Адрес).
    подписан : (integer Id_подписчика, integer Id_подписки).

class predicates
    %Правило "Список подписок для каждого человека"
    читает : (string Имя).
    %Правило "Сколько стоят издания"
    стоимость : (string Название, integer Цена) nondeterm (o,o) (i,i) (i,o).
    %Правило "Издание и кто на него подписан"
    подписчикиИздания : (string Название).
    %Правило "Сбор набора из трёх подписок до 300 рублей"
    собрать : ().
    %Правило "Вывод людей, подписанных на определенный жанр издания"
    жанр : (genre Жанр) determ.
    %Правило "Куда развозят издания?"
    доставка : (string Название).
    издание : (integer Id, string Название, genre Жанр, integer Цена) nondeterm (i,i,o,o) (o,i,o,i) (o,i,o,o) (o,o,i,o) (o,o,o,o) (o,o,o,i) (i,o,o,o).

clauses
    издание(А, Б, В, Г) :-
        журнал(А, Б, В, Г).
    издание(А, Б, В, Г) :-
        газета(А, Б, В, Г).

    %Правило "Список подписок для каждого человека"
    читает(Имя) :-
        подписчик(НомерП, Имя, _, _),
        подписан(НомерП, НомерИ),
        издание(НомерИ, Название, _, _),
        write(Имя, " ", Название),
        nl,
        fail.

    читает(_) :-
        write("Конец списка \n").

    %Правило "Сколько стоят издания"
    стоимость(Название, Цена) :-
        издание(_, Название, _, Цена).

    %Правило "Издание и кто на него подписан"
    подписчикиИздания(Название) :-
        издание(НомерИ, Название, _, _),
        подписчик(НомерП, Имя, _, _),
        подписан(НомерП, НомерИ),
        write(Название, " ", Имя),
        nl,
        fail.

    подписчикиИздания(_) :-
        write("Конец списка\n").

    %Правило "Сбор набора из трёх подписок до 300 рублей"
    собрать() :-
        стоимость(Название1, Цена1),
        стоимость(Название2, Цена2),
        стоимость(Название3, Цена3),
        Название1 <> Название2,
        Название1 <> Название3,
        Название2 <> Название3,
        Цена1 + Цена2 + Цена3 = Сумма,
        Сумма < 300,
        write(Название1, ", ", Название2, ", ", Название3, " - ", Сумма),
        nl,
        fail.

    собрать() :-
        write("Конец списка\n").

    %Правило "Вывод людей, подписанных на определенный жанр издания"
    жанр(Жанр) :-
        издание(Id_издания, _, Жанр, _),
        подписан(Id_подписчика, Id_издания),
        подписчик(Id_подписчика, Имя, _, _),
        write("Жанр: ", Жанр, ", подписан: ", Имя),
        nl,
        fail.

    жанр(новостной) :-
        write("Конец списка\n").

    %Правило "Куда развозят издания?"
    доставка(Название) :-
        издание(Id_издания, Название, _, _),
        подписан(Id_подписчика, Id_издания),
        подписчик(Id_подписчика, _, _, Адрес),
        write(Название, " - ", Адрес),
        nl,
        fail.

    доставка(_) :-
        write("Конец списка\n").

clauses
    run() :-
        consult("C:\\prolog\\lab2\\data.txt", publications),
        fail.

    run() :-
        write("\nЧеловек и его издания: \n"),
        читает("Мишина Анастасия Алексеевна"),
        fail.

    run() :-
        write("\nИздание и кто на него подписан: \n"),
        подписчикиИздания("Сельцовский вестник"),
        fail.

    run() :-
        write("\nЖанр и его подписчики: \n"),
        жанр(новостной),
        fail.

    run() :-
        write("\nНаборы изданий до 300 рублей: \n"),
        собрать(),
        fail.

    run() :-
        write("\nКуда развозят издания: \n"),
        доставка("Брянские новости"),
        fail.

    run().

end implement main

goal
    console::run(main::run).
