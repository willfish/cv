# Makefile
# Usage:
#   make pdf   -> Generates PDF from index.md
#   make docx  -> Generates DOCX from index.md
#   make all   -> Generates both PDF and DOCX

MARKDOWN=index.md
PDF_OUTPUT=WilliamFishCV.pdf
DOCX_OUTPUT=WilliamFishCV.docx
PRINT_CSS=media/davewhipp-print.css

all: pdf docx

pdf: $(MARKDOWN)
	@echo "Generating PDF..."
	pandoc $(MARKDOWN) \
		--from markdown \
		--to pdf \
		--pdf-engine=xelatex \
		--output $(PDF_OUTPUT) \
		--css=$(PRINT_CSS) \
		--metadata pagetitle="William Fish CV"

docx: $(MARKDOWN)
	@echo "Generating DOCX..."
	pandoc $(MARKDOWN) \
		--from markdown \
		--to docx \
		--output $(DOCX_OUTPUT)

serve:
	@echo "Serving Jekyll content..."
	jekyll serve

clean:
	@echo "Removing generated files..."
	rm -f $(PDF_OUTPUT) $(DOCX_OUTPUT)

.PHONY: all pdf docx serve clean
