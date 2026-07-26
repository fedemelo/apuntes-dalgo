---
name: section-review
description: Reviews the intellectual content (correctness and pedagogy) of a section of the algorithms/graphs LaTeX notes, given a directory containing that section's files. Use when asked to review, check, or audit a section's content, accuracy, or pedagogy — not for LaTeX/formatting/typesetting review.
---

# Algorithms notes content review

You are reviewing a section of these algorithms/graphs notes, written in LaTeX. The document
already compiles successfully. Do not review LaTeX syntax, formatting, typography, style files,
or compilation issues — treat the document as final from a technical typesetting perspective.
Your task is only to review the intellectual content.

## Input: a directory, not a file

A "section" is normally not a single file. It is split across several `.tex` files in one
directory, e.g. `algoritmos/diseno/decremento_conquista/`:

- One file named after the directory (e.g. `decremento_conquista.tex`) holds the section's
  prose and an `\inputlist{...}` line that pulls in the rest, in reading order.
- Several files hold subsections/algorithms (e.g. `insertion_sort.tex`, `busqueda_binaria.tex`).
- A `notes.tex` file, if present, holds the author's own rationale, citations, and design
  decisions (via `\textcite{...}`) for the section — this is background context explaining
  *why* something was written a certain way, not itself content to grade for pedagogy. Read it
  before reviewing the rest so you understand intentional choices (e.g. "I omit X because Y") and
  don't flag them as omissions.

When given a directory: read every `.tex` file in it, follow the `\inputlist`/`\input` order in
the section-name file to reconstruct the section as the reader will actually encounter it, and
review the section as a whole rather than file-by-file. Note which file a passage is quoted from
when you flag it.

## Primary objective (highest priority): correctness

Flag anything that is:

- Factually incorrect.
- Mathematically incorrect.
- Algorithmically incorrect.
- Logically inconsistent.
- Inconsistent with established computer science terminology.
- Potentially misleading to a student, even if technically defensible.
- Missing an important assumption that makes a statement false.
- Overgeneralized or stated with excessive certainty.

For each issue found:

1. Quote the relevant passage (and name the file it's in).
2. Explain precisely why it is problematic.
3. State how serious the issue is.

Do NOT rewrite the text — report only, per the instructions above.

## Secondary objective: pedagogical quality

After correctness, evaluate pedagogy. Examples:

- Explanations that may be difficult for students to follow.
- Missing motivation.
- Abrupt logical jumps.
- Examples that fail to illustrate the intended concept.
- Ambiguous wording.
- Definitions introduced before necessary context.
- Concepts introduced in a confusing order.
- Places where an additional example would substantially improve understanding.
- Claims that would benefit from justification.

These are subjective observations. Clearly distinguish them from the factual/correctness
findings above — don't let them blur together in the same list.

## Out of scope

Ignore: wording preferences, tone, LaTeX code, formatting, typesetting, citation style, and
missing references (unless a missing reference affects correctness).

## Stance

Be skeptical. It is much better to report a possible issue than to overlook an actual mistake.
Always clearly distinguish objective errors (primary objective) from subjective suggestions
(secondary objective) — never present one as the other.

## Output

Report directly as text in two clearly labeled groups, in this order:

1. **Correctness issues** (primary) — each with the quoted passage + file, the explanation, and
   a severity (e.g. minor/moderate/serious).
2. **Pedagogical observations** (secondary) — each with the quoted passage + file and the
   observation, clearly marked as subjective.

If a group has no findings, say so explicitly rather than omitting it. Do not edit any files as
part of this review.
