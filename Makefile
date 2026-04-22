# Makefile for building the mus-colab book
# Builds LaTeX document and places all output in bin/

# Absolute repo root so lilypond-book → lilypond -I survives any cwd (e.g. CI Docker).
BOOK_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# Same image as CI (.github/workflows/main.yml).
DOCKER_LILYPOND_IMAGE ?= kyledickersoncomposer/docker-lilypond:latest

MAIN = main
OUTPUT_DIR = bin
LILYPOND_BOOK = lilypond-book

# LaTeX compiler
LATEX = pdflatex
BIBTEX = biber
MAKEGLOSSARIES = makeglossaries
LATEX_FLAGS = -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode

.PHONY: check-ly clean docx docker-pull lily open pdf require-pandoc

# Pull the toolchain image once into Docker Desktop (same platform as make pdf).
docker-pull:
	docker pull --platform linux/amd64 $(DOCKER_LILYPOND_IMAGE)

pdf:
	docker run --rm --platform linux/amd64 --pull missing \
		-v "$(BOOK_ROOT):/workdir" -w /workdir \
		$(DOCKER_LILYPOND_IMAGE) \
		sh -lc '\
			set -eu; \
			LOG_DIR="$(OUTPUT_DIR)/build-logs"; \
			cleanup() { \
				find . -maxdepth 1 -name "tmp*" -type f -delete 2>/dev/null; \
				find . -maxdepth 1 -name "*.tmp" -type f -delete 2>/dev/null; \
			}; \
			summarize_failure() { \
				echo ""; \
				echo "================ FATAL SUMMARY ================"; \
				found=0; \
				for file in "$$LOG_DIR/lilypond-book.log" "$$LOG_DIR/pdflatex-pass1.log" "$$LOG_DIR/biber.log" "$$LOG_DIR/makeglossaries.log" "$$LOG_DIR/pdflatex-pass2.log" "$$LOG_DIR/pdflatex-pass3.log" "$(OUTPUT_DIR)/$(MAIN).log" "$(OUTPUT_DIR)/$(MAIN).blg"; do \
					[ -f "$$file" ] || continue; \
					matches="$$(awk "BEGIN{IGNORECASE=1; ctx=0} /warning:|^! |fatal error|error:|undefined control sequence|emergency stop|ERROR -|unrecognized option|non-zero exit status/ {print NR \":\" \$$0; ctx=2; next} ctx>0 {print NR \":\" \$$0; ctx--;}" "$$file")"; \
					[ -n "$$matches" ] || continue; \
					found=1; \
					echo "-- $$file --"; \
					printf "%s\n" "$$matches"; \
					if [ "$$file" = "$$LOG_DIR/lilypond-book.log" ]; then \
						failing_ref="$$(awk "match(\$$0, /[[:alnum:]_\/.-]*lily-[0-9a-f]+\\.ly:[0-9]+:[0-9]+:/) {print substr(\$$0, RSTART, RLENGTH); exit}" "$$file")"; \
						if [ -n "$$failing_ref" ]; then \
							fr="$$failing_ref"; \
							fr="$${fr%:}"; \
							tmp1="$${fr%:*}"; \
							gen_line="$${tmp1##*:}"; \
							gen_ly="$${tmp1%:*}"; \
							ly_base="$$(basename "$$gen_ly" .ly)"; \
							owner_tex="$$(grep -R -l -F "$${ly_base}-systems.tex" "$(OUTPUT_DIR)" 2>/dev/null | head -n 1)"; \
							if [ -z "$$owner_tex" ]; then \
								owner_tex="$$(grep -R -l -F "$$gen_ly" "$(OUTPUT_DIR)" 2>/dev/null | head -n 1)"; \
							fi; \
							echo "Likely generated snippet: $(OUTPUT_DIR)/$$gen_ly:$$gen_line"; \
							if [ -n "$$owner_tex" ]; then \
								ot="$$owner_tex"; \
								case "$$ot" in "$(OUTPUT_DIR)"/*) sg="$${ot#$(OUTPUT_DIR)/}";; *) sg="$$ot";; esac; \
								case "$$sg" in *.tex) source_guess="$${sg%.tex}.lytex";; *) source_guess="$$sg";; esac; \
								echo "Likely source file: $$source_guess"; \
							else \
								echo "Likely source file: (no $$ly_base-systems.tex in $(OUTPUT_DIR); see .lytex lines below)"; \
								echo "Recent .lytex paths in lilypond-book.log:"; \
								grep -E -o '[A-Za-z0-9_./-]+\.lytex' "$$file" 2>/dev/null | tail -n 12 | while read -r p; do echo "  $$p"; done || true; \
								note_line="$$(awk "hit && !seen {sub(/^[[:space:]]+/, \"\"); sub(/[[:space:]]+$$/, \"\"); print; exit} /fatal error: barcheck failed/ {hit=1}" "$$file")"; \
								if [ -n "$$note_line" ]; then \
									source_hits="$$(grep -R -n -F "$$note_line" chapters frontmatter source main.lytex preface.lytex 2>/dev/null | head -n 5)"; \
									if [ -n "$$source_hits" ]; then \
										echo "Source text matches:"; \
										printf "%s\n" "$$source_hits"; \
									fi; \
								fi; \
							fi; \
							echo ""; echo "--- lilypond-book.log (last 40 lines) ---"; tail -n 40 "$$file" 2>/dev/null || true; \
							if printf "%s\n" "$$matches" | grep -qi "syntax error"; then \
								echo ""; echo "Hint: LilyPond header values must be quoted strings, e.g. title = \"Scale Etude\", composer = \"You\"."; \
							fi; \
						fi; \
					fi; \
				done; \
				if [ "$$found" -eq 0 ]; then \
					echo "No fatal diagnostics were extracted from known logs."; \
					echo "Check $(OUTPUT_DIR)/build-logs/ and $(OUTPUT_DIR)/$(MAIN).log for full output."; \
				fi; \
				echo "==============================================="; \
			}; \
			on_exit() { \
				status=$$?; \
				if [ "$$status" -ne 0 ]; then \
					summarize_failure; \
				fi; \
				cleanup; \
				exit "$$status"; \
			}; \
			trap on_exit EXIT; \
			mkdir -p $(OUTPUT_DIR); \
			mkdir -p "$$LOG_DIR"; \
			echo ""; echo "================ check-ly (excerpt/inline .ly) ================"; \
			mkdir -p $(OUTPUT_DIR)/lycheck; \
			find chapters -type f \( -path "*/excerpt/*.ly" -o -path "*/inline/*.ly" \) | sort | while IFS= read -r f; do \
				echo ""; echo "==== lilypond $$f ===="; \
				b="$$(basename "$$f" .ly)"; \
				lilypond -dwarning-as-error -I /workdir -I /workdir/source -I /workdir/source/lilyjazz-styles -o "/workdir/$(OUTPUT_DIR)/lycheck/$$b" "/workdir/$$f"; \
			done; \
			echo ""; echo "================ lilypond-book (snippets) ================"; \
			$(LILYPOND_BOOK) --pdf --process="lilypond -dwarning-as-error" --output=$(OUTPUT_DIR) -I /workdir -I /workdir/source -I /workdir/source/lilyjazz-styles $(MAIN).lytex >"$$LOG_DIR/lilypond-book.log" 2>&1; \
			echo "================ LaTeX / BibTeX / glossaries ================="; \
			cp references.bib $(OUTPUT_DIR)/references.bib; \
			echo "Building $(MAIN).pdf (pdflatex pass 1)..."; \
			$(LATEX) $(LATEX_FLAGS) $(OUTPUT_DIR)/$(MAIN).tex >"$$LOG_DIR/pdflatex-pass1.log" 2>&1; \
			( cd $(OUTPUT_DIR) && $(BIBTEX) $(MAIN) ) >"/workdir/$$LOG_DIR/biber.log" 2>&1; \
			( cd $(OUTPUT_DIR) && $(MAKEGLOSSARIES) $(MAIN) ) >"/workdir/$$LOG_DIR/makeglossaries.log" 2>&1; \
			cd /workdir; \
			$(LATEX) $(LATEX_FLAGS) $(OUTPUT_DIR)/$(MAIN).tex >"$$LOG_DIR/pdflatex-pass2.log" 2>&1; \
			$(LATEX) $(LATEX_FLAGS) $(OUTPUT_DIR)/$(MAIN).tex >"$$LOG_DIR/pdflatex-pass3.log" 2>&1; \
			echo "Build complete! Output: $(OUTPUT_DIR)/$(MAIN).pdf"'

# Snippets only: same lilypond-book step as pdf, with DEBUG log (maps snippets to .lytex better).
# Does not run pdflatex.
lily:
	docker run --rm --platform linux/amd64 --pull missing \
		-v "$(BOOK_ROOT):/workdir" -w /workdir \
		$(DOCKER_LILYPOND_IMAGE) \
		sh -lc '\
			set -eu; \
			LOG_DIR="$(OUTPUT_DIR)/build-logs"; \
			cleanup() { \
				find . -maxdepth 1 -name "tmp*" -type f -delete 2>/dev/null; \
				find . -maxdepth 1 -name "*.tmp" -type f -delete 2>/dev/null; \
			}; \
			summarize_failure() { \
				echo ""; \
				echo "================ FATAL SUMMARY ================"; \
				found=0; \
				for file in "$$LOG_DIR/lilypond-book.log" "$$LOG_DIR/pdflatex-pass1.log" "$$LOG_DIR/biber.log" "$$LOG_DIR/makeglossaries.log" "$$LOG_DIR/pdflatex-pass2.log" "$$LOG_DIR/pdflatex-pass3.log" "$(OUTPUT_DIR)/$(MAIN).log" "$(OUTPUT_DIR)/$(MAIN).blg"; do \
					[ -f "$$file" ] || continue; \
					matches="$$(awk "BEGIN{IGNORECASE=1; ctx=0} /warning:|^! |fatal error|error:|undefined control sequence|emergency stop|ERROR -|unrecognized option|non-zero exit status/ {print NR \":\" \$$0; ctx=2; next} ctx>0 {print NR \":\" \$$0; ctx--;}" "$$file")"; \
					[ -n "$$matches" ] || continue; \
					found=1; \
					echo "-- $$file --"; \
					printf "%s\n" "$$matches"; \
					if [ "$$file" = "$$LOG_DIR/lilypond-book.log" ]; then \
						failing_ref="$$(awk "match(\$$0, /[[:alnum:]_\/.-]*lily-[0-9a-f]+\\.ly:[0-9]+:[0-9]+:/) {print substr(\$$0, RSTART, RLENGTH); exit}" "$$file")"; \
						if [ -n "$$failing_ref" ]; then \
							fr="$$failing_ref"; \
							fr="$${fr%:}"; \
							tmp1="$${fr%:*}"; \
							gen_line="$${tmp1##*:}"; \
							gen_ly="$${tmp1%:*}"; \
							ly_base="$$(basename "$$gen_ly" .ly)"; \
							owner_tex="$$(grep -R -l -F "$${ly_base}-systems.tex" "$(OUTPUT_DIR)" 2>/dev/null | head -n 1)"; \
							if [ -z "$$owner_tex" ]; then \
								owner_tex="$$(grep -R -l -F "$$gen_ly" "$(OUTPUT_DIR)" 2>/dev/null | head -n 1)"; \
							fi; \
							echo "Likely generated snippet: $(OUTPUT_DIR)/$$gen_ly:$$gen_line"; \
							if [ -n "$$owner_tex" ]; then \
								ot="$$owner_tex"; \
								case "$$ot" in "$(OUTPUT_DIR)"/*) sg="$${ot#$(OUTPUT_DIR)/}";; *) sg="$$ot";; esac; \
								case "$$sg" in *.tex) source_guess="$${sg%.tex}.lytex";; *) source_guess="$$sg";; esac; \
								echo "Likely source file: $$source_guess"; \
							else \
								echo "Likely source file: (no $$ly_base-systems.tex in $(OUTPUT_DIR); see .lytex lines below)"; \
								echo "Recent .lytex paths in lilypond-book.log:"; \
								grep -E -o '[A-Za-z0-9_./-]+\.lytex' "$$file" 2>/dev/null | tail -n 12 | while read -r p; do echo "  $$p"; done || true; \
								note_line="$$(awk "hit && !seen {sub(/^[[:space:]]+/, \"\"); sub(/[[:space:]]+$$/, \"\"); print; exit} /fatal error: barcheck failed/ {hit=1}" "$$file")"; \
								if [ -n "$$note_line" ]; then \
									source_hits="$$(grep -R -n -F "$$note_line" chapters frontmatter source main.lytex preface.lytex 2>/dev/null | head -n 5)"; \
									if [ -n "$$source_hits" ]; then \
										echo "Source text matches:"; \
										printf "%s\n" "$$source_hits"; \
									fi; \
								fi; \
							fi; \
							echo ""; echo "--- lilypond-book.log (last 40 lines) ---"; tail -n 40 "$$file" 2>/dev/null || true; \
							if printf "%s\n" "$$matches" | grep -qi "syntax error"; then \
								echo ""; echo "Hint: LilyPond header values must be quoted strings, e.g. title = \"Scale Etude\", composer = \"You\"."; \
							fi; \
						fi; \
					fi; \
				done; \
				if [ "$$found" -eq 0 ]; then \
					echo "No fatal diagnostics were extracted from known logs."; \
					echo "Check $(OUTPUT_DIR)/build-logs/ and $(OUTPUT_DIR)/$(MAIN).log for full output."; \
				fi; \
				echo "==============================================="; \
			}; \
			on_exit() { \
				status=$$?; \
				if [ "$$status" -ne 0 ]; then \
					summarize_failure; \
				fi; \
				cleanup; \
				exit "$$status"; \
			}; \
			trap on_exit EXIT; \
			mkdir -p $(OUTPUT_DIR); \
			mkdir -p "$$LOG_DIR"; \
			echo ""; echo "================ make lily: lilypond-book (DEBUG log) ================="; \
			$(LILYPOND_BOOK) --pdf --loglevel=DEBUG --process="lilypond -dwarning-as-error" --output=$(OUTPUT_DIR) -I /workdir -I /workdir/source -I /workdir/source/lilyjazz-styles $(MAIN).lytex >"$$LOG_DIR/lilypond-book.log" 2>&1; \
			echo ""; echo "lilypond-book: snippets OK."; \
			'

# Same excerpt/inline pass as the start of `make pdf` (native lilypond, real .ly paths in errors).
# Useful alone for a quick check without lilypond-book / LaTeX.
check-ly:
	docker run --rm --platform linux/amd64 --pull missing \
		-v "$(BOOK_ROOT):/workdir" -w /workdir \
		$(DOCKER_LILYPOND_IMAGE) \
		sh -lc '\
			set -eu; \
			mkdir -p $(OUTPUT_DIR)/lycheck; \
			find chapters -type f \( -path "*/excerpt/*.ly" -o -path "*/inline/*.ly" \) | sort | while IFS= read -r f; do \
				echo ""; echo "==== lilypond $$f ===="; \
				b="$$(basename "$$f" .ly)"; \
				lilypond -dwarning-as-error -I /workdir -I /workdir/source -I /workdir/source/lilyjazz-styles -o "/workdir/$(OUTPUT_DIR)/lycheck/$$b" "/workdir/$$f"; \
			done; \
			echo ""; echo "check-ly: all excerpt/inline .ly files OK."; \
			'

require-pandoc:
	@command -v pandoc >/dev/null 2>&1 || { \
		echo "pandoc is required for DOCX export."; \
		echo "Install it with: brew install pandoc"; \
		exit 1; \
	}

docx: pdf require-pandoc
	@echo "Exporting $(OUTPUT_DIR)/$(MAIN).docx for Google Docs spell checking..."
	cd $(OUTPUT_DIR) && pandoc \
		--standalone \
		--from=latex \
		--to=docx \
		--resource-path=.:.. \
		--metadata=title:"mus-colab" \
		--output=$(MAIN).docx \
		$(MAIN).tex
	@echo "DOCX export complete! Output: $(OUTPUT_DIR)/$(MAIN).docx"

open:
	open $(OUTPUT_DIR)/$(MAIN).pdf

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(OUTPUT_DIR)
	@find . -maxdepth 1 -name "tmp*" -type f -delete 2>/dev/null
	@find . -maxdepth 1 -name "*.tmp" -type f -delete 2>/dev/null
	@echo "Clean complete!"
