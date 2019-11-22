OUTPUT ?= pdf
TARGET=project.tex
BIBS=biblio.bib my-publications.bib mutual-modelling.bib

SVG=$(wildcard figs/*.svg)

all: latex

%.png: %.svg
	inkscape -d 200 --export-png $(@) $(<)

%.pdf: %.svg
	inkscape --export-pdf $(@) $(<)

bib: $(TARGET:.tex=.aux)

	biber $(TARGET:.tex=)

latex: $(SVG:.svg=.pdf)
	lualatex $(TARGET)


pandoc: $(SVG:.svg=.png) gantt.pdf
	pandoc $(TARGET) -McodeBlockCaptions=true -MfigureTitle=Figure -MtableTitle=Table -MlistingTitle=Listing -F pandoc-crossref -F pandoc-citeproc -o $(TARGET:.md=.$(OUTPUT))  $(foreach b,$(BIBS),--bibliography=$(b)) --reference-doc=eu-template-reference.docx --pdf-engine=lualatex --dpi=300 --standalone 

touch:
	touch $(TARGET)

force: touch latex

clean:
	rm -f *.spl *.bcf *.idx *.aux *.log *.snm *.out *.toc *.nav *intermediate *~ *.glo *.ist *.bbl *.blg $(SVG:.svg=.pdf) $(DOT:.dot=.svg) $(DOT:.dot=.pdf)

distclean: clean
	rm -f $(TARGET:.tex=.pdf) $(TARGET:.tex=.docx)
