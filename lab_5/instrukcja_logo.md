# Instrukcja budowy w LOGO! Soft Comfort (LAD)

Instrukcja realizuje `plan.md`. Zakładam, że masz już projekt z zrzutów, czyli 6 sieci z `T001`, `T002`, `T003`. Przerabiasz go, a nie budujesz od zera. Nazwy menu mogą się lekko różnić zależnie od wersji programu.

## Oznaczenia

| Zapis | Znaczenie |
|---|---|
| `A` | styk zwierny (normalnie otwarty) |
| `/A` | styk rozwierny (normalnie zamknięty, negacja) |
| `A · B` | styki szeregowo w jednym rzędzie (AND) |
| `A ∥ B` | dwa rzędy połączone równolegle do tego samego wejścia (OR) |
| `→ (X)` | cewka pamięci lub wyjścia |

---

## Krok 0. Przygotowanie

1. Zapisz obecny projekt pod nową nazwą, np. `lab5_v2.lsc`. Stara wersja zostaje jako kopia.
2. Zostaw `I1`, `Q1`, `Q2` i markery `M1–M6`. Dojdą `M7`, `M8`, `M9`.
3. Czasy w timerach wpisuj w formacie sekundowym. Format `00:50s` odpowiada 0,50 s, a `02:00s` odpowiada 2,00 s (sprawdź po wpisaniu w podglądzie).
4. Wszystkie bloki RS mają `Rem=off`. Po restarcie symulacji układ zawsze startuje w S0.

---

## Krok 1. Sieć 1 – timery

Zostają tylko dwa rzędy:

```
I1 ──────────► T001   (TON, 0,50 s)     opis: PRÓG 0,5 s
I1 ──────────► T002   (TON, 2,00 s)     opis: PRÓG 2 s
```

Do zrobienia:

1. Usuń rząd z negowanym `I1` oraz blok `T003` (IMPULS OPADANIA).
2. Przepisz opisy `T001` na "PRÓG 0,5 s" i `T002` na "PRÓG 2 s" (dwuklik na bloku, pole komentarza).
3. Zostaw wspólne rozgałęzienie od `I1`, tak jak na zrzucie.

Kontrola: w symulacji przytrzymaj `I1`. `T001` powinien się włączyć po 0,5 s, a `T002` po 2 s.

---

## Krok 2. Sieć 2 – zdarzenia K, Ś, D

Usuń wszystko, co jest w sieci 2: dwa stare rzędy `M4`, `M5`, blok `SF004` (`M6_RS`) i rząd z cewką `M6`. Zbuduj od nowa trzy rzędy:

```
Rząd 2.1:  M7 · I1/ · M8/                   → (M4)   opis: ZDARZENIE K
Rząd 2.2:  M7 · I1/ · M8 · M9/               → (M5)   opis: ZDARZENIE Ś
Rząd 2.3:  T002 · M9/                        → (M6)   opis: ZDARZENIE D
```

Szczegóły styków (zapis `/` oznacza rozwierny):

| Rząd | Styk 1 | Styk 2 | Styk 3 | Styk 4 | Cewka |
|---|---|---|---|---|---|
| 2.1 | M7 | /I1 | /M8 | – | M4 |
| 2.2 | M7 | /I1 | M8 | /M9 | M5 |
| 2.3 | T002 (wyjście bloku) | /M9 | – | – | M6 |

Wskazówki:

- Styk `T002` wstawiasz jako styk typu "wyjście bloku" i wybierasz `T002`.
- `M4`, `M5`, `M6` są cewkami pamięci (typ M). Nie podłączaj tu bloków RS.

---

## Krok 3. Sieć 3 – ekran (`M2`)

Do zrobienia: cztery rzędy warunków, blok `RS_M2` i rząd wyjściowy.

### 3.1. Rzędy warunków

```
Rząd 3.1 (Set):   M4 · M1 · /M3 · /M2   ─┐
                                           ├──► wejście S bloku RS_M2
Rząd 3.2 (Set):   M6 · /M1              ─┘

Rząd 3.3 (Reset): M4 · M1 · /M3 · M2    ─┐
                                           ├──► wejście R bloku RS_M2
Rząd 3.4 (Reset): M6 · M1               ─┘
```

| Rząd | Styk 1 | Styk 2 | Styk 3 | Styk 4 | Wchodzi na |
|---|---|---|---|---|---|
| 3.1 | M4 | M1 | /M3 | /M2 | S |
| 3.2 | M6 | /M1 | – | – | S |
| 3.3 | M4 | M1 | /M3 | M2 | R |
| 3.4 | M6 | M1 | – | – | R |

### 3.2. Łączenie przewodów (OR na wejściu bloku)

1. Wstaw blok RS (Funkcje specjalne → przerzutnik RS). Nazwij go "RS_M2", `Rem=off`.
2. Końce rzędów 3.1 i 3.2 połącz pionowym przewodem i doprowadź do górnego wejścia `S`.
3. Końce rzędów 3.3 i 3.4 połącz pionowym przewodem i doprowadź do dolnego wejścia `R`.
4. Zbiegające się przewody tworzą OR (węzeł z kropką), tak jak w Twojej sieci 6 przy `M2` i `M3`.

### 3.3. Rząd wyjściowy

```
Rząd 3.5:  RS_M2 (styk: wyjście bloku) ──► (M2)   opis: EKRAN – PAMIĘĆ
```

Kontrola: z niczym jeszcze nie połączonym `M1` ekran nie reaguje. Pełny test dopiero po kroku 7.

---

## Krok 4. Sieć 4 – menu (`M3`)

```
Rząd 4.1 (Set):   M5 · M1                 ──────► wejście S bloku RS_M3

Rząd 4.2 (Reset): M4 · M3                 ─┐
                                            ├──► wejście R bloku RS_M3
Rząd 4.3 (Reset): M6                      ─┘

Rząd 4.4:         RS_M3 (wyjście bloku)   ──► (M3)   opis: MENU
```

| Rząd | Styk 1 | Styk 2 | Wchodzi na |
|---|---|---|---|
| 4.1 | M5 | M1 | S |
| 4.2 | M4 | M3 | R |
| 4.3 | M6 | – | R |

Nowość względem Twojego programu: rząd 4.3 (`M6` w Resecie). Bez niego po wyłączeniu telefonu menu zostaje otwarte.

---

## Krok 5. Sieć 5 – telefon (`M1`)

Bez zmian w strukturze:

```
Rząd 5.1 (Set):   M6 · /M1               ──► wejście S bloku RS_M1
Rząd 5.2 (Reset): M6 · M1                ──► wejście R bloku RS_M1
Rząd 5.3:         RS_M1 (wyjście bloku)  ──► (M1)   opis: STAN TELEFONU
```

Sprawdź tylko, że `M6` wchodzi na pierwsze wejście (`S`) wraz z `/M1`, a `M6 · M1` na drugie (`R`).

---

## Krok 6. Sieć 6 – wyjścia

Bez zmian:

```
Rząd 6.1:  M1                                   ──► (Q2)   opis: STAN TELEFONU
Rząd 6.2:  M1 · ( M2 ∥ M3 )                     ──► (Q1)   opis: WYŚWIETLACZ
```

---

## Krok 7. Sieć 7 – pamięć poprzedniego cyklu (nowa, na końcu)

Dodaj nową sieć na samym dole. Ma być ostatnia.

```
Rząd 7.1:  I1                       ──► (M7)   opis: POPRZEDNI I1
Rząd 7.2:  T001 (wyjście bloku)     ──► (M8)   opis: POPRZEDNI T001
Rząd 7.3:  T002 (wyjście bloku)     ──► (M9)   opis: POPRZEDNI T002
```

Jeśli sieć znajdzie się wyżej niż sieci 2–6, zdarzenia przestaną być jednocyklowe. Sprawdź kolejność przed testami.

---

## Krok 8. Kontrola przed symulacją

Lista kontrolna:

- [ ] `T003`, `SF004` i `M6_RS` są usunięte.
- [ ] Rząd 2.1 ma `/M8` (rozwierny), a nie `M8`.
- [ ] Rząd 2.2 ma `M8` (zwierny) i `/M9` (rozwierny).
- [ ] Rząd 2.3 ma `/M9` (rozwierny).
- [ ] Set i Reset bloku `RS_M2` mają po dwa rzędy połączone w OR.
- [ ] Reset `RS_M3` ma dwa rzędy w OR (`M4·M3` i `M6`).
- [ ] Każdy marker ma dokładnie jedną cewkę: `M2`, `M3`, `M1` z bloków RS, `M4`–`M6` z sieci 2, `M7`–`M9` z sieci 7.
- [ ] Sieć 7 jest ostatnia.

---

## Krok 9. Opcjonalne diody testowe

Zdarzenia trwają jeden cykl, więc nie zobaczysz ich w symulacji. Do debugowania dodaj tymczasowo:

```
Blok RS "DBG_K":  S = M4,  R = I1   → (Q3)
Blok RS "DBG_S":  S = M5,  R = I1   → (Q4)
```

`Q3` zaświeci się po krótkim kliknięciu, a `Q4` po średnim. Zgasną po kolejnym naciśnięciu `I1`. Po testach usuń je, bo zmieniają schemat do dokumentacji.

---

## Krok 10. Testy w symulacji

Uruchom symulację, `I1` jako przycisk (przytrzymanie myszy). Czasy odmierzaj stoperem.

| # | Akcja | Oczekiwany efekt |
|---|---|---|
| 1 | K (0,2 s) w S0 | brak zmian, `Q1=0`, `Q2=0` |
| 2 | Ś (1 s) w S0 | brak zmian |
| 3 | D (3 s) w S0 | po 2 s `Q2=1` i `Q1=1`, bez migotania |
| 4 | K | `Q1=0` |
| 5 | K | `Q1=1` |
| 6 | Ś | menu otwarte (`M3=1`), `Q1=1` |
| 7 | K | menu zamknięte, `Q1=1` |
| 8 | K, potem Ś, potem K | `Q1`: 0 → 1 → 0 |
| 9 | D | `Q2=0`, `Q1=0`, `M3=0` |
| 10 | D, potem Ś, potem D | `Q2=1`, menu otwarte, potem `Q2=0`, `M3=0` |
| 11 | D (telefon jest wyłączony po teście 10) | `Q2=1`, `Q1=1`, menu zamknięte (`M3=0`) |

Pełna lista (18 testów i przypadki brzegowe) jest w `plan.md`, pkt 7.

---

## Diagnostyka

| Objaw | Prawdopodobna przyczyna | Co zrobić |
|---|---|---|
| `Q2` nadal oscyluje podczas trzymania | `M6` trwa więcej niż jeden cykl | Sprawdź `/M9` w rzędzie 2.3 i czy `M9` jest w sieci 7 |
| Krótkie nic nie robi | złe styki w rzędzie 2.1 | `M7` zwierny, `/I1` rozwierny, `/M8` rozwierny |
| Średnie nic nie robi | złe styki w rzędzie 2.2 | `M8` zwierny, `/M9` rozwierny |
| Krótkie zachowuje się jak średnie albo odwrotnie | zła wartość czasu `T001` | Sprawdź 00:50s |
| Anulowanie menu gasi ekran, choć wcześniej był włączony | brak `/M3` w Resecie `M2` (rząd 3.3) | Dodaj `/M3` |
| Po D telefon włącza się z menu otwartym | brak `M6` w Resecie `M3` | Dodaj rząd 4.3 |
| Po D z S0 ekran nie zapala się | brak rzędu 3.2 | Dodaj `M6 · /M1` do Set `RS_M2` |
| Zdarzenia nie działają wcale | sieć 7 nie jest ostatnia albo markery mają podwójne cewki | Przestaw sieć 7 na koniec, usuń duplikaty cewek |
