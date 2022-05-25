NAME=master-thesis
LANG_ASPELL=en

IMG_DIR=img
SRC_DIR=src

MISC=Makefile

MAJOR_VERSION=0
MINOR_VERSION=1
VERSION=$(MAJOR_VERSION).$(MINOR_VERSION)

UNAME=$(shell uname)

BIBTEX=bibtex
TEX=xelatex
TEX_FILES=$(wildcard $(SRC_DIR)/*.tex)
TEX_FLAGS=--shell-escape --synctex=1

all: $(NAME)

$(NAME):
	@echo "** Compiling the \"$(NAME)\" file."
	$(TEX) $(TEX_FLAGS) $(NAME)

check: $(addsuffix .spchk,$(basename $(TEX_FILES)))

%.spchk: %.tex
	aspell -x -l $(LANG_ASPELL) -t -c $<

clean:
	@echo "** Removing subsidiary TeX files."
	$(RM) $(NAME).{aux,bbl,blg,lof,log,lom,lot,out,snm,tex.backup,nav,toc}

help:
	@echo "make COMMAND"
	@echo
	@echo "COMMAND:"
	@echo "  all     compile the \"$(NAME)\" file"
	@echo "  check   check spelling of TeX files"
	@echo "  clean   remove subsidiary TeX files"
	@echo "  help    display available commands"
	@echo "  full    compile the \"$(NAME)\" file and the bibliography"
	@echo "  open    open the \"$(NAME)\" fileq"
	@echo "  tar     create a tar archive"

full:
	@echo "** Compiling the \"$(NAME)\" file and the bibliography."
	$(TEX) $(TEX_FLAGS) $(NAME)
	$(BIBTEX) $(NAME)
	$(TEX) $(TEX_FLAGS) $(NAME)
	$(TEX) $(TEX_FLAGS) $(NAME)

open:
ifeq ($(UNAME), Linux)
	@echo "** Opening the \"$(NAME)\" file with evince."
	evince $(NAME).pdf &
endif
ifeq ($(UNAME), Darwin)
	@echo "** Opening the \"$(NAME)\" file with preview."
	open $(NAME).pdf &
endif

tar:
	@echo "** Creating the tar archive."
	@mkdir -p $(NAME)-$(VERSION)
	@cp -r $(SRC_DIR) $(IMG_DIR) $(MISC) $(NAME).tex $(NAME)-$(VERSION)
	tar czvf $(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION)
	$(RM) -r $(NAME)-$(VERSION)

.PHONY: all check clean help full open tar $(NAME)
