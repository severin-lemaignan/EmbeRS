OUTPUT ?= docx
TARGET=project.md
BIBS=biblio.bib my-publications.bib

SVG=$(wildcard figs/*.svg)

%.png: %.svg
	inkscape -d 200 --export-png $(@) $(<)


all: $(SVG:.svg=.png) 
	pandoc $(TARGET) -McodeBlockCaptions=true -MfigureTitle=Figure -MtableTitle=Table -MlistingTitle=Listing -F pandoc-crossref -F pandoc-citeproc -o $(TARGET:.md=.$(OUTPUT))  $(foreach b,$(BIBS),--bibliography=$(b)) --reference-doc=eu-template-reference.docx
