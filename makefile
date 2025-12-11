.PHONY: all A B C D correctif_A correctif_B correctif_C correctif_D clean concatenate concatenate_correctif

include makefile.conf

# Compile all versions (regular and correctif) and concatenate them
all: A B C D correctif_A correctif_B correctif_C correctif_D concatenate concatenate_correctif

# Compile regular versions with separate aux file directories
A B C D: | build build/$@
	@echo "Ensuring build/$@ directory exists..."
	@mkdir -p build/$@
	pdflatex -output-directory=build/$@ "\def\version{$@} \def\release{$(release)} \input{src/main.tex}" && mv -f build/$@/main.pdf build/$(name)_$(release)_$@.pdf

# Compile correctif versions with separate aux file directories under build/corr/
correctif_A correctif_B correctif_C correctif_D: | build build/corr/$(@:correctif_%=%)
	@echo "Ensuring build/corr/$(@:correctif_%=%) directory exists..."
	@mkdir -p build/corr/$(@:correctif_%=%)
	pdflatex -output-directory=build/corr/$(@:correctif_%=%) "\def\version{$(@:correctif_%=%)} \def\release{$(release)} \def\withanswers{1} \input{src/main.tex}" && mv -f build/corr/$(@:correctif_%=%)/main.pdf build/$(name)_$(release)_$(@:correctif_%=%)_correctif.pdf

# Concatenate regular versions
concatenate: | build
	pdfunite $(filter-out build/$(name)_$(release)_ABCD.pdf,$(wildcard build/$(name)_$(release)_A.pdf build/$(name)_$(release)_B.pdf build/$(name)_$(release)_C.pdf build/$(name)_$(release)_D.pdf)) build/$(name)_$(release)_ABCD.pdf
	pdfunite $(filter-out build/$(name)_$(release)_ABC.pdf,$(wildcard build/$(name)_$(release)_A.pdf build/$(name)_$(release)_B.pdf build/$(name)_$(release)_C.pdf)) build/$(name)_$(release)_ABC.pdf

# Concatenate correctif versions
concatenate_correctif: | build
	soffice --headless --convert-to pdf src/corr.docx --outdir build
	pdfunite build/corr.pdf $(filter-out build/$(name)_$(release)_ABCD_correctif.pdf,$(wildcard build/$(name)_$(release)_A_correctif.pdf build/$(name)_$(release)_B_correctif.pdf build/$(name)_$(release)_C_correctif.pdf build/$(name)_$(release)_D_correctif.pdf)) build/$(name)_$(release)_ABCD_correctif.pdf

# Ensure the main build directory exists
build:
	mkdir -p build

# Create individual subdirectories for each version
build/%:
	mkdir -p build/$@

build/corr/%:
	mkdir -p build/corr/$@

# Clean command
clean:
	rm -rf build/*
	rm -f *.aux *.log *.nav *.out *.snm *.toc *.fls *.fdb_latexmk

