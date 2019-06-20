OUTPUT ?= pdf
TARGET=project.tex
BIBS=biblio.bib my-publications.bib

SVG=$(wildcard figs/*.svg)

all: latex

%.png: %.svg
	inkscape -d 200 --export-png $(@) $(<)


latex: $(SVG:.svg=.pdf)
	lualatex $(TARGET)


pandoc: $(SVG:.svg=.png) gantt.pdf
	pandoc $(TARGET) -McodeBlockCaptions=true -MfigureTitle=Figure -MtableTitle=Table -MlistingTitle=Listing -F pandoc-crossref -F pandoc-citeproc -o $(TARGET:.md=.$(OUTPUT))  $(foreach b,$(BIBS),--bibliography=$(b)) --reference-doc=eu-template-reference.docx --pdf-engine=lualatex --dpi=300 --standalone 
