📱 Podsumowanie projektu: Automat stanów przycisku zasilania (LOGO! Soft Comfort)
💡 Główna idea działania

Układ oparty jest na automacie stanów (Moore'a/Mealy'ego), gdzie jeden fizyczny przycisk (I1) steruje dwoma wyjściami (Q1 - ekran, Q2 - telefon). Czas przytrzymania przycisku determinuje akcję (krótkie < 0,5s, średnie 0,5-2s, długie > 2s). Kluczowe jest użycie pamięci M1 (stan telefonu), która pełni rolę nadrzędnego strażnika – blokuje działanie ekranu i menu, gdy telefon jest wyłączony.
⚙️ Zmienne i ich role

    I1 – Przycisk (wejście cyfrowe).

    M1 – Stan telefonu (1=wł, 0=wył). Steruje Q2.

    M2 – Zapamiętany stan ekranu (intencja użytkownika).

    M3 – Stan menu wyłączenia (1=otwarte, 0=zamknięte).

    M4 – Impuls krótkiego kliknięcia (generowany przy puszczeniu < 0,5s).

    M5 – Impuls średniego kliknięcia (generowany przy puszczeniu 0,5-2s).

    M6 – Impuls długiego kliknięcia (generowany po 2s, trwa do puszczenia).

    Q1 – Ekran (wzór: Q1 = M1 AND (M2 OR M3)).

    Q2 – Telefon (wzór: Q2 = M1).

🛠️ Podział na sieci (Step-by-Step)
SIEĆ 1: Pomiar czasu (Timery)

    Bloki: I1, T001 (0,5s), T002 (2s), T003 (Edge Triggered Wiping Relay).

    Logika:

        I1 podłączone bezpośrednio do T001 i T002.

        I1 zanegowane (NOT) podłączone do wejścia wyzwalającego (Trg) bloku T003 (detekcja zbocza opadającego).

        T003 ustawiony na generowanie impulsu 0,1s (Pulse width).

    Dlaczego tak? T001 i T002 mierzą czas naciśnięcia. T003 generuje jednorazowy, krótki impuls w momencie puszczenia przycisku, co jest niezbędne do rozróżnienia krótkiego i średniego kliknięcia.

SIEĆ 2: Rozpoznawanie kliknięć (M4, M5, M6)

    Bloki: T003, T001, T002, NOT, AND, RS.

    Logika:

        M4 (krótkie): T003 AND NOT(T001) -> ustawia M4 (cewka).

        M5 (średnie): T003 AND T001 AND NOT(T002) -> ustawia M5 (cewka).

        M6 (długie): T002 podane na Set (S) przerzutnika RS. NOT(I1) podane na Reset (R). Wyjście RS -> M6.

    Dlaczego tak? Jeśli puścimy przycisk przed 0,5s, T001 jest 0 (stąd negacja). Jeśli między 0,5s a 2s, T001 jest 1, a T002 jest 0 (stąd negacja). M6 ustawia się w momencie przekroczenia 2s (jeszcze przed puszczeniem) i zeruje przy puszczeniu – zapobiega to wielokrotnemu wyzwoleniu.

SIEĆ 3: Sterowanie ekranem (M2)

    Bloki: M4, M1, M3, M2, M6, RS.

    Logika (przerzutnik RS_M2):

        Set: (M4 AND M1 AND NOT(M3)) OR (M6 AND NOT(M1)).

        Reset: M4 AND M1 AND M2.

        Wyjście: RS -> M2 (Wyświetlacz).

    Dlaczego tak? Krótkie kliknięcie (M4) zmienia stan ekranu, ale tylko gdy telefon działa (M1) i menu jest zamknięte (NOT M3). Warunek M6 AND NOT(M1) sprawia, że przy uruchamianiu telefonu z S0 ekran od razu się zapala (zgodnie z tabelą przejść S0->S2).

SIEĆ 4: Sterowanie menu (M3)

    Bloki: M5, M1, M4, M6, M3, RS.

    Logika (przerzutnik RS_M3):

        Set: M5 AND M1.

        Reset: (M4 AND M3) OR M6.

        Wyjście: RS -> M3 (Menu).

    Dlaczego tak? Menu otwiera się tylko średnim kliknięciem (M5) przy włączonym telefonie (M1). Zamyka się krótkim kliknięciem (M4 - anulowanie) lub długim kliknięciem (M6 - wyłączanie telefonu).

SIEĆ 5: Sterowanie telefonem (M1)

    Bloki: M6, M1, RS (priorytet Reset).

    Logika (przerzutnik RS_M1):

        Set: M6 AND NOT(M1).

        Reset: M6 AND M1.

        Wyjście: RS -> M1 (Stan telefonu).

    Dlaczego tak? Telefon włącza się i wyłącza wyłącznie długim kliknięciem (M6). Ustawienie priorytetu Reset zapobiega sytuacji, w której telefon mógłby się nie wyłączyć przy jednoczesnym Set i Reset.

SIEĆ 6: Wyjścia (Q1, Q2)

    Bloki: M1, M2, M3, OR, AND.

    Logika:

        Q2 = M1

        Q1 = M1 AND (M2 OR M3)

    Dlaczego tak? Q2 to bezpośrednie odzwierciedlenie stanu M1. Wzór na Q1 gwarantuje, że ekran nie świeci się przy wyłączonym telefonie (M1). Jednocześnie otwarcie menu (M3) wymusza zapalenie ekranu, nawet jeśli intencja użytkownika (M2) była zgaszona.