---
name: code-annotations
description: Adds braces/box annotations (the green side-notes with arrows/braces) to pseudocode listings in this LaTeX repo, using the fmb-code-annotations package. Use whenever the user asks to annotate, explain inline, or add a note/brace/box to a \begin{pseudocode} block, or asks to adjust the position/width of an existing annotation.
---

# Code annotations for pseudocode listings

This repo has a custom TikZ-based annotation system (`packages/fmb-code-annotations.sty`) for
`\begin{pseudocode}...\end{pseudocode}` listings: green braces or boxes that point at a span of
code with an explanatory note. This file is the spec — if the package's actual behavior is ever
changed on purpose, update this file to match as part of that change.

## How it works

1. Inside the `pseudocode` listing, mark the code span(s) you want to annotate using
   `\br{id}` (a single point, for a brace) or `\bxl{id}` ... `\bxr{id}` (a start/end pair
   around a token, for a box). These rely on `escapeinside={|}{|}` from `listings`, so marks
   must be wrapped in `|...|` inline in the code, e.g.:
   ```
   |\br{memoi}|if optimal_revs[n] >= 0:
       return optimal_revs[n]|\br{memof}|
   ```
   for a brace spanning those two lines, or
   ```
   |\bxl{ir}|r = 0|\bxr{ir}|
   ```
   for a box around a single token.
2. Immediately after `\end{pseudocode}`, open `\begin{annotations}...\end{annotations}`
   (this environment just wraps a `tikzpicture` in overlay mode) and call `\codebrace` or
   `\codebox` once per annotation, referencing the ids from step 1.
3. Wrap the whole `pseudocode` + `annotations` pair in `\begin{codeblock}...\end{codeblock}`:
   ```latex
   \begin{codeblock}
   \begin{pseudocode}
   ...
   \end{pseudocode}
   \begin{annotations}
   ...
   \end{annotations}
   \end{codeblock}
   ```
   This is required whenever a `pseudocode` block has an `annotations` block after it (skip it
   for a bare `pseudocode` block with no annotations). Without it, a listing that happens to
   land exactly at the bottom of a page can get separated from its annotations by a page break
   — the `annotations` tikzpicture is `overlay`, so it has zero size as far as TeX's page
   builder is concerned, and `\nopagebreak` doesn't help (the builder can already have
   committed to breaking right after the listing before the penalty is seen). `codeblock`
   captures both inside one `\vbox`, making them a single atomic item in the vertical list so
   they're always kept on the same page — which matters because the `remember picture`
   coordinates the annotations draw from are only valid on the page the marks landed on.

### `\codebrace[<options>]{<top-id>}{<bottom-id>}{<text>}`

A curly brace spanning from the `\br{<top-id>}` mark down to the `\br{<bottom-id>}` mark,
with `<text>` set beside it. Use it for anything that spans multiple lines or a whole block.

Options (all optional, pgfkeys):
- `xshift` (default `15pt`) — horizontal offset of the brace, anchored to the **bottom mark's
  own column** (not the top mark, not the span as a whole — see `\coordinate (brace@x) at
  ([xshift=\codebracexshift] #3)` in the package, where `#3` is the bottom id). This matters:
  if the bottom line is long (e.g. a `return foo(a, b, c)` call), the anchor is already far
  right, and a large `xshift` on top of that can push the brace off the page margin even
  though the top line is short. Size `xshift` relative to *where the bottom mark actually
  sits*, not the longest line in the span — check that line's length specifically.
- `width` (default `3cm`) — text width of the note. Needs to be wide enough that the
  explanation doesn't look cramped, but narrow enough that `xshift + width` doesn't run
  the note off the page (page margins are 1in on all sides, see `packages/fmbnotes.cls`).
- `noteshift` (default `0pt`) — gap between the brace tip and the note text.
- `yshift` (default `0pt`) — vertical offset of the note relative to the brace midpoint.
- `amplitude` (default `3pt`) — how "deep"/curved the brace is.

### `\codebox[<options>]{<id>}{<text>}`

A rounded box around the single token bracketed by `\bxl{<id>}`/`\bxr{<id>}`, plus a floating
note with a dotted arrow to it. Use it for annotating one specific token/expression rather
than a whole block.

Options:
- `xshift` (default `1.5cm`) — how far right of the box the note starts (controls arrow
  length). Ignored if `notepos` is given.
- `notepos=<calc expr>` — explicit position for the note, written as a TikZ `calc` expression
  *without* the surrounding `$ $`, e.g. `notepos={(cbox@id.east)+(2cm,1cm)}`. Use this instead
  of `xshift` when the token is mid-line (not near the right edge) so the note doesn't have
  to travel in a straight horizontal line, or when several boxes are close together and
  their notes would otherwise collide.
- `curve=<to-path options>` — shape of the connecting arrow, e.g. `bend left=25`,
  `bend right=5`. Common when `notepos` places the note somewhere the straight arrow would
  cross the code.
- `noteanchor` (default `west`), `from` (default `east`), `to` (default `west`) — anchors for
  note/arrow endpoints.
- `arrstyle` (default `dotted`) — draw style of the arrow.
- `width` (default `3cm`) — text width of the note.

## Sizing heuristic (do this without compiling)

The listing uses `\footnotesize\ttfamily` monospace text (see `packages/fmbdalgo.sty`), so
character width is fairly predictable. To size an annotation:

1. Find the longest line within the marked span (for a brace) or the line containing the
   marked token (for a box), measured in characters *from the mark's column to the end of
   that line's meaningful content*.
2. `xshift` needs to clear that length. As a rough rule of thumb drawn from existing
   annotations in this repo: short remainders (under ~20 chars) only need the default/no
   `xshift`; medium remainders (~20–40 chars) need `xshift` around `2.5cm`–`4.5cm`; long or
   full-width lines need `5cm`–`8cm`. When in doubt, look at an existing annotation on a
   similarly-long line (see examples below) and match its `xshift`.
3. `width` should fit the note's text without excessive wrapping, but `xshift + width` should
   stay within reach of the 1in right margin — err on the side of narrower notes (`4cm`–`7cm`
   is typical) rather than assuming lots of margin to spare.
4. If you can compile (see "Compiling to check your work" below), do a final pass to catch
   collisions the heuristic misses — it's an estimate, not a guarantee. If you can't compile,
   trust the heuristic and move on.

## Avoiding vertical collisions between annotations

When several annotations sit close together (marks within ~3 code lines of each other),
their note text — which wraps to multiple lines — is usually taller than the vertical gap
between the marks. Left alone, notes will overlap or run into each other, even though each
one's `xshift`/`width` is individually fine.

Fix it in this order:
1. **Widen the note first (`width`).** A wider box wraps to fewer lines, so it needs less
   vertical room. This is the cheapest fix and doesn't touch positioning at all.
2. **Shorten the text second.** If widening still doesn't leave enough clearance, or would
   run past the page margin, tighten the prose — cut it to the essential point. Don't
   preserve every clause of a draft comment if it's fighting for vertical space; a terser
   note that fits is better than a verbose one that collides.
3. **Only then reach for `yshift`.** Nudging notes up/down off their natural midpoint
   (positive `yshift` on one, negative on the other) works, but it's a last resort: it
   detaches the note from the visual center of what it's pointing at, and stacking several
   staggered offsets gets fragile as annotations are added or edited later. If you find
   yourself needing more than a small nudge (~0.3–0.5cm) on more than two annotations in the
   same block, that's a sign the block has too many separate annotations for its size —
   consider merging adjacent points into one combined note instead.

## Compiling to check your work

### Fast path: preview a single block

`scripts/preview-annotations.sh <file.tex> [block-index]` compiles just one
`\begin{pseudocode}...\end{annotations}` block in isolation (a standalone `article` doc that
only loads `fmbdalgo`), crops it tightly with `pdfcrop`, and prints the path to a PNG. Takes
under 2 seconds, versus compiling the whole book. Run it with no index first to list the
blocks in a file with their line ranges:
```
scripts/preview-annotations.sh algoritmos/diseno/decremento_conquista/busqueda_binaria.tex
scripts/preview-annotations.sh algoritmos/diseno/decremento_conquista/busqueda_binaria.tex 1
```
Then read the printed PNG path directly — no manual crop-region guessing needed. Use this
after every edit to an annotation while iterating; it's cheap enough to call repeatedly.

### Full check: compile the whole book

Before considering the work done, also do one full-book compile with `make algoritmos` or
`make grafos` (from the repo root) — the standalone preview can't catch things like a page
break landing inside a listing. Don't invoke `pdflatex`/`latexmk` directly — the Makefile sets
`TEXINPUTS` so the custom `packages/` directory is found, and `latexmk` reruns automatically
until stable (typically 3–4 passes), which is required: annotations use TikZ's `remember
picture, overlay`, so node positions from one compile are only available on the *next* one. A
single raw `pdflatex` run renders every annotation collapsed at the origin — that's not a
layout bug, just a missing pass, and `make algoritmos`/`make grafos` already handles it.

To inspect the result without opening the full PDF:
```
pdftotext -f <p> -l <p> algoritmos/algoritmos.pdf -   # grep across pages for a unique string
                                                        # in the listing to find its page number
pdftoppm -png -r 300 -f <page> -l <page> algoritmos/algoritmos.pdf out
```
then read `out-<page>.png` directly (crop with `convert`/`magick` first if you only need one
region — full pages render fine too, just larger).

## Real examples to imitate

Files with existing annotations, in increasing sophistication:
- `algoritmos/diseno/pre/insertion_sort.tex` — one brace, two boxes, simple.
- `algoritmos/diseno/decremento_conquista/busqueda_binaria.tex` — several braces/boxes
  staggered with `yshift` to avoid collisions, one using the shared `\annMitadSinOverflow`.
- `algoritmos/diseno/programacion_dinamica/fibonacci.tex` — several braces/boxes together,
  no notepos overrides needed.
- `algoritmos/diseno/dividir_conquistar/merge_sort.tex` — mixes braces and boxes, one with
  `notepos` + `curve=bend left=25` for a mid-line token, one using `\annMitadSinOverflow`.
- `algoritmos/diseno/programacion_dinamica/corte_de_vara.tex` — most sophisticated: uses
  `notepos={(cbox@id.east)+(...)}` with `curve=bend right=5` to route a note around other
  content.
- `algoritmos/shared_annotations.tex` — the shared reusable-annotation-text library itself.

## Reusable annotation text

Some explanations recur across listings — e.g. the overflow-safe midpoint pattern
(`izq + (der - izq) // 2`, `i + (j - i) // 2`, ...) shows up in binary search, merge sort, and
the max-subarray divide-and-conquer solution. These live in `algoritmos/shared_annotations.tex`
(scoped to the `algoritmos` book — not `packages/`, which is shared infra for both books and
has no business holding algorithm-specific prose), `\input` from `algoritmos/algoritmos.tex`'s
preamble so every chapter can use them. Each is a `\newcommand{\ann<Concepto>}[N]{...}`,
parametrized by the variable names used in that listing, e.g.:
```latex
\codebox[...]{over}{\annMitadSinOverflow{izq}{der}}   % busqueda_binaria.tex
\codebox[...]{mid}{\annMitadSinOverflow{i}{j}}          % merge_sort.tex
```
one canonical phrasing, correct variable names per call site. Before writing new annotation
prose, check `shared_annotations.tex` for something close. **Promote text into it on the
second occurrence** (or clear anticipated reuse) — don't pre-abstract on the first write. When
editing an existing shared macro, re-preview every call site (`preview-annotations.sh`), not
just the one you were working on — the point of centralizing is that wording changes ripple
everywhere, including collisions/width you didn't touch directly.

## Workflow

The user will always tell you *what* to annotate and roughly *what it should say* — a draft,
a comment, or a description of the point to make. Your job is:

1. Check `algoritmos/shared_annotations.tex` for an existing reusable macro covering this
   point before writing fresh prose.
2. Place `\br`/`\bxl`/`\bxr` marks at the right spot(s) in the pseudocode.
3. Write (or lightly copyedit) the note text into proper prose for the `<text>` argument —
   tighten wording, fix grammar, but don't invent content the user didn't ask for.
4. Choose `\codebrace` vs `\codebox` (span vs single token) and pick reasonable option values
   using the heuristic above.
5. Never fabricate the *content* of an annotation — if the user hasn't indicated what a note
   should say, ask, don't guess.

Note text and surrounding prose in this repo is written in Spanish (see existing examples);
match that unless told otherwise.
