# Sprawozdanie – klatka schodowa (4 włączniki + PIR)

## Kompilacja

```bash
pdflatex main.tex
pdflatex main.tex        # drugie przejście – spis treści
```

Wymagane pakiety LaTeX:
`babel`, `amsmath`, `amssymb`, `geometry`, `booktabs`,
`graphicx`, `tikz`, `circuitikz`, `hyperref`.

## Narzędzia użyte do rysunków

| Rysunek                  | Narzędzie                              |
|--------------------------|----------------------------------------|
| `figures/logic_gates.tex`| TikZ + biblioteka `circuits.logic.US`  |
| `figures/ladder.tex`     | TikZ (rysowany ręcznie)                |
| `figures/ladder_rotated.tex` | TikZ + `\rotatebox{90}`            |

Alternatywy (jeżeli ktoś woli graficzne edytory):
- **Logisim Evolution** / **Digital** – do schematu bramkowego
  (eksport PDF/PNG i `\includegraphics`).
- **FluidSIM** / **PC|SCHEMATIC** – do schematu drabinkowego.
- **KiCad** – jeżeli miałby to być schemat elektryczny, nie logiczny.

## Uwaga o ,,obrocie o 90°''

Obrót zrealizowano przez `\rotatebox{90}{...}` wokół całego `tikzpicture`.
Jeżeli prowadzący wymaga fizycznego obrotu tylko schematu drabinkowego
(bez legendy), wystarczy wydzielić `figures/ladder.tex` do osobnego
dokumentu `standalone` i wstawić `\includegraphics[angle=90]{ladder.pdf}`.

## Kolejność milestonów

1. **M1** – opis problemu i założeń (`01_problem.tex`)
2. **M2** – model bramkowy (`02_model_bramki.tex`)
3. **M3** – uproszczenie wyrażenia (`03_uproszczenie.tex`)
4. **M4** – tabela prawdy (`04_tabela_prawdy.tex`)
5. **M5** – schemat drabinkowy + wersja obrócona (`05_schemat_drabinkowy.tex`)