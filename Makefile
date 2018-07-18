OUTPUT ?= pdf
TARGET=project.md
BIBS=biblio.bib my-publications.bib

SVG=$(wildcard figs/*.svg)

all: project

%.png: %.svg
	inkscape -d 200 --export-png $(@) $(<)

gantt.pdf: gantt.tex
	pdflatex $(<)
	mv $(@) h-$(@)
	pdftk h-$(@) cat 1-endeast output $(@)

project: $(SVG:.svg=.png) gantt.pdf
	pandoc $(TARGET) -McodeBlockCaptions=true -MfigureTitle=Figure -MtableTitle=Table -MlistingTitle=Listing -F pandoc-crossref -F pandoc-citeproc -o $(TARGET:.md=.$(OUTPUT))  $(foreach b,$(BIBS),--bibliography=$(b)) --reference-doc=eu-template-reference.docx --pdf-engine=lualatex --dpi=300 
