# mus-colab

A **starter template** for your own **open, free, permissively licensed** music documents—scores, methods, coursework, or anything you want to ship as a proper PDF—without forcing contributors to install LilyPond and a full LaTeX stack by hand.

Use Git for collaboration, **Docker + Make** for identical local and CI builds, and **GitHub Actions** to publish PDFs automatically. Fork or copy this repo, rename things for your project, replace the placeholder book sources with your content, and keep the same flow.

## What you get

- **One command to build**: `make pdf` runs everything inside a pinned container image (LilyPond, `lilypond-book`, LaTeX, bibliography tooling).
- **CI that matches your laptop**: the workflow on `main` runs the same `make pdf`, then attaches a timestamped PDF to a `latest` GitHub Release so readers can grab builds without cloning.
- **A conventional repo layout** for `lilypond-book` + LaTeX monorepos—easy to grow with parts, chapters, and shared notation styles.

This project is not tied to any specific pedagogy or existing book; it is only the **machinery and layout** you can reuse for *your* document.

## Repository layout (template)

Organize sources like this (add files as you grow the book):

- `main.lytex` — spine only: document class, shared `\input` for LaTeX primitives, then an ordered list of chapter prose files (avoid long body text here)
- `title-page.lytex`, `source-note.lytex`, `preface.lytex` — front-of-book pieces kept at the repository root next to `main.lytex`
- `chapters/<chapter-name>/` — section prose as small `.lytex` files at the chapter root
- `chapters/<chapter-name>/inline/`, `excerpt/`, `full-music/` — **music-only** fragments (LilyPond blocks, tall height-box spreads). Prose files should `\input` them so text edits and engraving edits rarely touch the same file
- `source/latex/` — shared LaTeX: packages, page style, numbered examples, `\MusicChord` helpers, glossary entries. Tall LilyPond blocks use `\beginStretchHeightMusicExample{<dim>}` … `\finishStretchHeightMusicExample`: a fixed-height `\vbox` with `\vfil` between systems (normal page margins, no `\newgeometry`)
- `source/lily/` — shared LilyPond layout snippets (`\include` targets; the Makefile passes `-I` for `source/`)
- `references.bib` — bibliography for `biber`
- `bin/` — build output (gitignored; produced by `make pdf`)

The repository ships with a minimal sample book so `make pdf` works immediately; swap in your own chapters and tune `source/` as the document grows.

## Building (Docker + Make)

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or any environment where `docker` runs) so contributors share one toolchain.

### Commands

```sh
make pdf    # build bin/main.pdf inside the container
make open   # open bin/main.pdf (macOS)
make clean  # remove bin/ and common temp files
```

What `make pdf` does:

1. Runs `kyledickersoncomposer/docker-lilypond:latest` with the repo mounted at `/workdir`.
2. Runs `lilypond-book` on `main.lytex`, emitting TeX and processed notation into `bin/`.
3. Copies `references.bib` into `bin/` for the LaTeX run.
4. Runs `pdflatex`, `biber`, `makeglossaries`, and further `pdflatex` passes until the PDF is stable.

Use your own image when you are ready:

```sh
make pdf DOCKER_LILYPOND_IMAGE=your-registry/your-image:tag
```

### Troubleshooting

- If the container never starts, confirm Docker is running.
- LaTeX errors usually show up in `bin/main.log` after a partial build.

## GitHub Actions

On every push to `main`, [.github/workflows/main.yml](.github/workflows/main.yml):

1. Checks out the repository.
2. Runs `make pdf` (same Docker image as local).
3. Copies `bin/main.pdf` to a timestamped filename.
4. Publishes that file to the GitHub Release tagged `latest` via [`ncipollo/release-action`](https://github.com/ncipollo/release-action).

Treat the **Makefile** as the contract between humans and CI; adjust the workflow only when you change how the book is built.

## Making this yours

- Rename the PDF prefix in the workflow, release title, and any `pandoc` metadata in the `Makefile` (`docx` target) to match your project.
- Replace `LICENSE` if you need a different permissive license (keep SPDX clarity for downstream users).
- Point `DOCKER_LILYPOND_IMAGE` at an image you control if you customize the TeX or LilyPond versions.

## Contributing

Improvements to the template itself (clearer defaults, safer CI, better docs) are welcome via issues and pull requests.

## License

See [LICENSE](LICENSE).
