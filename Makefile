# Makefile
# Usage:
#   make pdf   -> Generates PDF from index.md
#   make docx  -> Generates DOCX from index.md
#   make all   -> Builds and serves the site locally

HTML_FILE := index.html
MARKDOWN=index.md
PDF_OUTPUT=WilliamFishCV.pdf
DOCX_OUTPUT=WilliamFishCV.docx
PRINT_CSS=media/davewhipp-print.css

all: serve

pdf: build
	cd _site/ && wkhtmltopdf --enable-local-file-access --print-media-type --disable-smart-shrinking \
		--page-size A4 --margin-top 0 --margin-bottom 0 \
		--margin-left 0 --margin-right 0 \
		$(HTML_FILE) $(PDF_OUTPUT)

docx: build
	sed -n '/<article /,/<\/article>/p' _site/$(HTML_FILE) | pandoc \
		--from html \
		--to docx \
		--output $(DOCX_OUTPUT)

serve:
	@echo "Serving Jekyll content..."
	jekyll serve

clean:
	@echo "Removing generated files..."
	rm -f $(PDF_OUTPUT) $(DOCX_OUTPUT)

.SILENT:
build:
	jekyll build

.PHONY: all pdf docx serve clean build
