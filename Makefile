# Add `packages` directory to `TEXINPUTS` env var so pdftex can find custom packages
# Absolute path so it resolves correctly regardless of which subdirectory is compiled.
TEXINPUTS := $(CURDIR)/packages/:$(TEXINPUTS)
export TEXINPUTS

TEX=pdflatex -shell-escape
LATEXMK=latexmk -pdf -pdflatex="pdflatex -shell-escape %O %S"
ALGORITMOS_DIR=algoritmos
GRAPHS_DIR=graphs

.PHONY: clean clean-all sml-algoritmos algoritmos sml-grafos grafos

sml-algoritmos:
	cd $(ALGORITMOS_DIR) && $(TEX) algoritmos.tex

algoritmos:
	cd $(ALGORITMOS_DIR) && $(LATEXMK) algoritmos.tex

sml-grafos:
	cd $(GRAPHS_DIR) && $(TEX) grafos.tex

grafos:
	cd $(GRAPHS_DIR) && $(LATEXMK) grafos.tex

clean:  # Remove all temporary files
	find . \
	\( \
		-name "*.aux" -o \
		-name "*.log" -o \
		-name "*.out" -o \
		-name "*.toc" -o \
		-name "*.pyg" -o \
		-name "*.bak0" -o \
		-name "*.bbl" -o \
		-name "*.blg" -o \
		-name "*.glg" -o \
		-name "*.glo" -o \
		-name "*.gls" -o \
		-name "*.ist" -o \
		-name "*.fdb_latexmk" -o \
		-name "*.fls" -o \
		-name "*.gz" -o \
		-name "*.lof" -o \
		-name "*.lot" -o \
		-name "*.run.xml" -o \
		-name "*.listing" \
	\) \
	-exec rm {} +

clean-all: clean  # Remove all temporary files and the generated pdf
	find . -name "*.pdf" -exec rm {} +