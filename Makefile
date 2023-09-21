TARGETS=project.tex # wizus-ethics.tex
BIBS=biblio.bib my-publications.bib mutual-modelling.bib

SVG=$(wildcard figs/*.svg)

all: latex

$(SVG:.svg=.png): %.png: %.svg
	inkscape -d 200 --export-png $(@) $(<)

$(SVG:.svg=.pdf): %.pdf: %.svg
	inkscape --export-pdf $(@) $(<)

%.pdf: %.tex
	lualatex $(<)

%.docx: %.tex
	pandoc $(<) -McodeBlockCaptions=true -MfigureTitle=Figure -MtableTitle=Table -MlistingTitle=Listing -F pandoc-crossref -F pandoc-citeproc -o $(@)  $(foreach b,$(BIBS),--bibliography=$(b)) --reference-doc=eu-template-reference.docx --pdf-engine=lualatex --dpi=300 --standalone 

%.blg: %.aux
	biber $(<:.aux=)
	touch $(<:.aux=.tex)

bib: $(TARGETS:.tex=.blg)


latex: $(SVG:.svg=.pdf) $(TARGETS:.tex=.pdf)

docx: $(SVG:.svg=.png) $(TARGETS:.tex=.docx)

touch:
	touch $(TARGETS)

force: touch latex

clean:
	rm -f *.spl *.bcf *.idx *.aux *.log *.snm *.out *.toc *.nav *intermediate *~ *.glo *.ist *.bbl *.blg $(SVG:.svg=.pdf) $(DOT:.dot=.svg) $(DOT:.dot=.pdf)

distclean: clean
	rm -f $(TARGETS:.tex=.pdf) $(TARGETS:.tex=.docx)
