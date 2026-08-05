---
name: tree-diagrams
description: Draws tree diagrams (execution trees, recursion trees, decision trees, etc.) in this LaTeX repo using the `forest` package, matching the house style set by `algoritmos/fundamentos/recursion/ejecucion.tex`. Covers highlighting/boxing a subtree, sizing wide trees to the page, and how to compile+verify the result. Use whenever asked to draw, add, or fix a tree figure (árbol de ejecución/recursión/decisión) in a `.tex` file.
---

# Tree diagrams with `forest`

This repo already has `tikz`, `forest`, and the TikZ `fit` library loaded globally (via
`packages/fmb-code-annotations.sty` and `packages/fmbmath.sty`, `\RequirePackage`'d from
`fmbnotes.cls`). **Don't add `\usepackage{tikz}`/`\usepackage{forest}`/`\usetikzlibrary{fit}`
to a chapter file** — they're already available everywhere; adding them again is redundant
and, if you ever guess wrong on where to put them, can break compilation order. If a tree
needs a TikZ library not already loaded, check `packages/*.sty` and `packages/fmbnotes.cls`
first before assuming you need to add a `\usepackage`.

## Base template

Match the style already established in
`algoritmos/fundamentos/recursion/ejecucion.tex` (the canonical example):

```latex
\begin{center}
\begin{forest}
  for tree={
    draw, rounded corners,
    font=\ttfamily\small,
    inner sep=4pt,
    l sep=1.5em,
    s sep=1.2em,
    edge={-latex},
  }
  [{root label}
    [{child label}
      [{grandchild label}]
    ]
    [{other child label}]
  ]
\end{forest}
\end{center}
```

- `l sep` controls vertical spacing between levels, `s sep` horizontal spacing between
  siblings. Shrink `s sep` (down to `0.4em`–`0.6em`) for trees with many leaves — see
  "Wide trees" below before reaching for that, though.
- Node labels go in `{...}`, monospace by default via `font=\ttfamily\small` — matches how
  pseudocode identifiers read elsewhere in the book.

## Wide trees (page overflow)

A tree's width grows with its leaf count, not its depth. A naive-recursion execution tree
already overflows the 1in-margin textwidth (~16.5cm) at n=6 (13 leaves). Don't fight this by
shrinking font/sep indefinitely — wrap the whole `forest` in `\resizebox`, which `graphicx`
(loaded via `packages/fmbmath.sty`) already provides:

```latex
\begin{center}
\resizebox{\textwidth}{!}{%
\begin{forest}
  ...
\end{forest}%
}
\end{center}
```

The trailing `%` after `\end{forest}` and inside the closing `}` matters — without it you get
stray horizontal space. Only reach for `resizebox` when the tree is actually wide; small trees
(like the trimmed/memoized ones) look better at native size and shouldn't be force-scaled.

## Highlighting/boxing a subtree

To draw a dashed box around an entire subtree (e.g. to call out a duplicated computation),
**don't** try to box just the root node — `draw, dashed, red` as a forest node style only
boxes that one node. Instead:

1. Name three nodes with forest's `name=` option (comma-separated after the label, before any
   children brackets): the subtree's **root**, its **leftmost-descendant leaf**, and its
   **rightmost-descendant leaf**. These three points define the subtree's bounding box.
   ```latex
   [{F(3)}, name=f3-root
     [{F(2)}
       [{F(1)}, name=f3-left]
       [{F(0)}]
     ]
     [{F(1)}, name=f3-right]
   ]
   ```
2. After the tree's closing `]` but still inside `\begin{forest}...\end{forest}`, add a
   `\node[fit=...]` using those three names (the `fit` library computes the convex bounding
   box, so three well-chosen anchor points are enough — no need to enumerate every node):
   ```latex
   \node[fit=(f3-root)(f3-left)(f3-right), draw, dashed, red, rounded corners, inner sep=4pt] {};
   ```
   Extra plain TikZ commands like this after the tree spec are valid inside a `forest`
   environment — it's built on `tikzpicture` under the hood.
3. Repeat with a fresh set of names for each additional subtree to box. Keep names
   descriptive and scoped to the figure (e.g. `f4a-*`/`f4b-*` for two different `F(4)`
   subtrees in the same tree) to avoid clashes if the file has multiple `forest` figures.

If asked to highlight "the subtree that computes X", identify which node is duplicated by
walking the recursion by hand first (see the worked example in `fibonacci.tex`'s overlapping-
subproblems figure) — don't guess which value repeats without tracing the actual calls.

## Compiling and verifying

Don't invoke `pdflatex`/`latexmk` directly on a chapter file — `fmbnotes.cls` lives in
`packages/`, which is only on `TEXINPUTS` when built through the Makefile. From the repo root:

```
make algoritmos   # or: make grafos
```

To visually confirm the figure (font sizing, box placement, page overflow) rather than just
trusting a clean compile log:

```
pdftotext -layout algoritmos/algoritmos.pdf - | grep -n "<unique string near your figure>"
# or, page-by-page:
python3 -c "
import subprocess
pages = subprocess.run(['pdftotext','-layout','algoritmos/algoritmos.pdf','-'],
                        capture_output=True, text=True).stdout.split('\x0c')
for i,p in enumerate(pages,1):
    if '<unique string>' in p: print(i)
"
pdftoppm -png -r 150 -f <page> -l <page> algoritmos/algoritmos.pdf /tmp/treepage
```

Then read the resulting PNG directly with the Read tool. Check specifically for: labels
readable at the rendered size, boxes tightly hugging the intended subtree (not clipping a
node or including a sibling), and no horizontal overflow past the page margin.

## Workflow

1. Work out the tree's actual shape by hand (which calls happen, in what order, which repeat)
   — don't eyeball it from the pseudocode alone, trace it.
2. Write the `forest` tree using the base template, matching label style (e.g. `F(n)` vs
   `fibonacci(n)`) to what the surrounding prose already uses.
3. Add `resizebox` only if the tree is wide enough to need it.
4. Add subtree boxes only if asked to highlight something, using the root+leftmost+rightmost
   naming technique above.
5. Compile with `make algoritmos`/`make grafos` and visually verify via `pdftoppm` before
   calling the work done — a clean compile does not guarantee correct box placement or
   layout that fits the page.
