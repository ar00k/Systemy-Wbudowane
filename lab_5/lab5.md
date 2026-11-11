Projekt układu sekwencyjnego obsługi przycisku zasilania telefonu
1. Cel projektu

Celem projektu jest zaprojektowanie układu sekwencyjnego obsługującego przycisk zasilania telefonu za pomocą diagramu drabinkowego LAD w programie LOGO! Soft Comfort.

Układ ma rozpoznawać długość naciśnięcia jednego przycisku i odpowiednio sterować stanem telefonu, ekranu oraz menu wyłączenia.

2. Założenia funkcjonalne

Układ posiada:

Jedno wejście cyfrowe – przycisk zasilania.
Dwa wyjścia cyfrowe – stan ekranu i stan telefonu.
Pamięć wewnętrzną do przechowywania aktualnych stanów.
Timery do pomiaru czasu przytrzymania przycisku.
2.1. Rodzaje kliknięć

Przyjęte czasy działania:

Rodzaj kliknięcia	Czas przytrzymania	Funkcja
Krótkie	poniżej 0,5 s	Włączenie/wyłączenie ekranu
Średnie	od 0,5 s do poniżej 2 s	Otwarcie menu wyłączenia
Długie	2 s lub więcej	Wyłączenie lub uruchomienie telefonu
2.2. Działanie przycisku
Krótkie kliknięcie zmienia stan ekranu.
Średnie kliknięcie otwiera menu wyłączenia.
Krótkie kliknięcie podczas otwartego menu anuluje operację i przywraca poprzedni stan ekranu.
Długie kliknięcie wyłącza telefon.
Gdy telefon jest wyłączony, krótkie i średnie kliknięcie nie powodują żadnej reakcji.
Uruchomienie wyłączonego telefonu jest możliwe wyłącznie przez długie kliknięcie.
Wyłączony telefon nie może mieć włączonego ekranu.
3. Oznaczenia wejść i wyjść
Symbol	Rodzaj	Opis
I1	Wejście	Przycisk zasilania
Q1	Wyjście	Stan ekranu (1 – włączony, 0 – wyłączony)
Q2	Wyjście	Stan telefonu (1 – działa, 0 – wyłączony)
4. Zmienne pamięci wewnętrznej
Symbol	Opis
M1	Stan telefonu
M2	Zapamiętany stan ekranu
M3	Informacja o otwartym menu wyłączenia
M4	Impuls krótkiego kliknięcia
M5	Impuls średniego kliknięcia
M6	Impuls długiego kliknięcia
5. Tabela przejść automatu stanów

Przyjęto następujące stany automatu:

Stan	Nazwa	Telefon Q2	Ekran Q1	Menu
S0	Telefon wyłączony	0	0	Nie
S1	Praca normalna, ekran zgaszony	1	0	Nie
S2	Praca normalna, ekran włączony	1	1	Nie
S3	Menu wyłączenia	1	1	Tak
5.1. Tabela przejść
Stan obecny	Zdarzenie	Stan następny	Działanie
S0	Krótkie kliknięcie	S0	Brak reakcji
S0	Średnie kliknięcie	S0	Brak reakcji
S0	Długie kliknięcie	S2	Uruchomienie telefonu
S1	Krótkie kliknięcie	S2	Włączenie ekranu
S1	Średnie kliknięcie	S3	Otwarcie menu
S1	Długie kliknięcie	S0	Wyłączenie telefonu
S2	Krótkie kliknięcie	S1	Wyłączenie ekranu
S2	Średnie kliknięcie	S3	Otwarcie menu
S2	Długie kliknięcie	S0	Wyłączenie telefonu
S3	Krótkie kliknięcie	S1 lub S2	Anulowanie menu i powrót do poprzedniego stanu ekranu
S3	Średnie kliknięcie	S3	Menu pozostaje otwarte
S3	Długie kliknięcie	S0	Wyłączenie telefonu

Uwaga: podczas otwierania menu należy zapamiętać wcześniejszy stan ekranu. Po anulowaniu menu ekran powinien wrócić do tego stanu.

5.2. Warunki niedozwolone
Stan telefonu wyłączonego i ekranu włączonego jest niedozwolony.
Nie można otworzyć menu, gdy telefon jest wyłączony.
Nie można zmienić stanu ekranu, gdy telefon jest wyłączony.
Krótkie i średnie kliknięcie nie mogą uruchomić telefonu.
6. Logika sterowania wyjściami

Wyjście Q2 odpowiada za stan telefonu:

Q2 = M1

Wyjście Q1 odpowiada za stan ekranu:

Q1 = M1 AND (M2 OR M3)

Gdzie:

M1 – telefon jest włączony.
M2 – ekran jest zapamiętany jako włączony.
M3 – menu wyłączenia jest otwarte.

Dzięki zastosowaniu warunku M1 wyjście Q1 nie może przyjąć wartości 1, gdy telefon jest wyłączony.

7. Wykorzystane elementy LOGO! Soft Comfort
Element	Zastosowanie
Wejście cyfrowe I1	Odczyt przycisku
Timer TON T1	Pomiar czasu 0,5 s
Timer TON T2	Pomiar czasu 2 s
Detekcja zbocza opadającego	Rozpoznawanie krótkiego i średniego kliknięcia
Detekcja zbocza narastającego	Rozpoznawanie długiego kliknięcia
Przerzutnik RS	Zapamiętywanie stanu telefonu i menu
Bramki AND	Łączenie warunków logicznych
Bramki NOT	Negacja stanów
Pamięci M	Przechowywanie stanów automatu
8. Zasada rozpoznawania kliknięć

Pomiar czasu rozpoczyna się w momencie naciśnięcia przycisku I1.

Jeśli przycisk zostanie zwolniony przed upływem 0,5 s, generowany jest impuls krótkiego kliknięcia.
Jeśli przycisk zostanie zwolniony po upływie 0,5 s, ale przed upływem 2 s, generowany jest impuls średniego kliknięcia.
Jeśli przycisk pozostaje wciśnięty przez co najmniej 2 s, generowany jest impuls długiego kliknięcia.

Po zakończeniu pomiaru timery są resetowane, a układ oczekuje na kolejne naciśnięcie.

Impulsy zdarzeń powinny być generowane tylko raz na jedno naciśnięcie przycisku.

9. Podział programu na sieci LAD

Program należy podzielić na następujące sieci:

Odczyt stanu przycisku i pomiar czasu jego przytrzymania.
Rozpoznawanie rodzaju kliknięcia.
Sterowanie stanem ekranu.
Otwieranie i anulowanie menu wyłączenia.
Sterowanie włączaniem i wyłączaniem telefonu.
Sterowanie wyjściami Q1 i Q2.
10. Warunki testowania układu
Nr	Stan początkowy	Czynność	Oczekiwany rezultat
1	S2	Krótkie kliknięcie	Przejście do S1
2	S1	Krótkie kliknięcie	Przejście do S2
3	S1	Średnie kliknięcie	Przejście do S3
4	S2	Średnie kliknięcie	Przejście do S3
5	S3	Krótkie kliknięcie	Anulowanie menu
6	S3	Długie kliknięcie	Przejście do S0
7	S1	Długie kliknięcie	Przejście do S0
8	S2	Długie kliknięcie	Przejście do S0
9	S0	Krótkie kliknięcie	Brak reakcji
10	S0	Średnie kliknięcie	Brak reakcji
11	S0	Długie kliknięcie	Przejście do S2
11. Wnioski

Projekt przedstawia układ sekwencyjny wykorzystujący jeden przycisk do sterowania dwoma wyjściami. Dzięki zastosowaniu timerów możliwe jest rozpoznawanie czasu przytrzymania przycisku, natomiast pamięci wewnętrzne i przerzutniki RS pozwalają na zapamiętywanie stanów automatu.

Zastosowana logika zapewnia, że:

ekran może świecić tylko wtedy, gdy telefon jest włączony,
menu wyłączenia można otworzyć tylko podczas pracy telefonu,
wyłączony telefon można uruchomić wyłącznie długim kliknięciem.