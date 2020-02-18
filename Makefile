# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
LANG            = en
SPHINXOPTS      =
SPHINXINTLOPTS  = $(SPHINXOPTS) -D language=$(LANG)
SPHINXBUILD     ?= sphinx-build
SPHINXINTL      ?= sphinx-intl
SOURCEDIR       = source
RESOURCEDIR     = static
BUILDDIR        = build
SITEDIR         = /var/www/html/qgisdocs

# Internal variables.
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(SPHINXOPTS) $(SOURCEDIR)

# Put it first so that "make" without argument is like "make help".
help:
	@echo "  "
	@echo "Please use \`make <target> LANG=xx' where xx=language code and <target> is one of:"
	@echo "  updatestatic  to update the static content (images) into the source directory"
	@echo "  html         to build the documentation as html for english only"
	@echo "  gettext     to Extract translatable messages into pot files"
	@echo "  springclean  to also remove build output besides normal clean"
	@echo "  doctest     to run all doctests embedded in the documentation (if enabled)"
	@echo "  "
	@echo "OPTION: use LANG=xx to do it only for one language, eg: make html LANG=de"
	@echo "  "

	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile doctest html fasthtml springclean gettext

springclean:
	rm -r $(BUILDDIR)
	# all .mo files
	find $(SOURCEDIR)/locale/*/LC_MESSAGES/ -type f -name '*.mo' -delete

gettext:
	@$(SPHINXBUILD) -M gettext "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

updatestatic:
	@echo
	@echo "Updating static content into $(SOURCEDIR)/static."
	rsync -uthvr --delete $(RESOURCEDIR)/ $(SOURCEDIR)/static

html: updatestatic
	# ONLY in the english version run in nit-picky mode, so source errors/warnings will fail in Travis
	#  -n   Run in nit-picky mode. Currently, this generates warnings for all missing references.
	#  -W   Turn warnings into errors. This means that the build stops at the first warning and sphinx-build exits with exit status 1.
	if [ $(LANG) != "en" ]; then \
		$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html/$(LANG); \
	else \
		$(SPHINXBUILD) -n -W -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html/$(LANG); \
	fi

site: html
	rsync -az $(BUILDDIR)/html/ $(SITEDIR)/$(LANG)/

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest

fasthtml: updatestatic
	$(SPHINXBUILD) -n -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html/$(LANG)

pdf: updatestatic
	$(SPHINXBUILD) -M latexpdf "$(SOURCEDIR)" "$(BUILDDIR)/pdf/$(LANG)"
	@echo "Running LaTeX files through pdflatex..."
	make -C $(BUILDDIR)/pdf/$(LANG) all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/pdf/$(LANG)."
