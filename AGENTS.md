# Repository Guidelines

## Project Structure & Module Organization
The LaTeX sources live in `src/`, with `main.tex` orchestrating shared macros from `base/`. Individual prompts go in `src/questions/q#.tex`, while worked solutions mirror them in `src/answers/a#.tex`. Assets such as diagrams belong in `src/images/`. Generated PDFs and aux files must stay inside `build/`, which the makefile creates per version (A–D and correctifs) to keep artifacts isolated. Helper scripts like `newquestion.sh`, `cleanqna.sh`, and `submods.sh` sit at the repo root for housekeeping.

## Build, Test, and Development Commands
- `make A` (or `B`, `C`, `D`): compiles the chosen exam variant into `build/<name>_<release>_<variant>.pdf`.
- `make correctif_A`: builds the answer-key version by defining `\withanswers` and storing output under `build/corr/A`.
- `make concatenate` / `make concatenate_correctif`: stitches the individual PDFs (plus `corr.docx` via LibreOffice) into combined booklets.
- `make clean`: removes `build/*` and stray LaTeX aux files for a fresh run.
Run commands from the repo root so the included `makefile.conf` variables (`name`, `release`) resolve correctly.

## Coding Style & Naming Conventions
Write LaTeX with two-space indentation and keep macro usage consistent with `base/evaltemplate`. Name question files `q<count>.tex` and answer files `a<count>.tex`; keep numbering aligned across folders so `\qseq` renders in the expected order. Prefer semantic macros (`\hdr`, `\titlebox`) over raw formatting, and colocate version-specific tweaks inside the relevant question file rather than in `main.tex`.

## Testing Guidelines
Every modification must be compiled at least once (`make A` plus any touched variants or correctifs) before requesting approval. Treat build failures as test failures—resolve LaTeX warnings that affect layout, confirm concatenated PDFs open, and verify new images are referenced with the correct relative paths.

## Commit & Pull Request Guidelines
History uses short `[add]`, `[enh]`, `[fix]`-style prefixes from `git log`; keep that format and write imperative messages. No commit may be created without explicit user approval, and no change may be committed until the user confirms the required builds/tests have passed. Pull requests should link the motivating issue, describe affected variants, and include notes on any new assets or scripts that reviewers must install.

## Configuration Tips
Adjust `makefile.conf` to change the `name` (defaults to the repo folder) or `release` tag that shapes output filenames. Keep these values in sync with shared distribution channels so recipients can identify the PDF they received.
