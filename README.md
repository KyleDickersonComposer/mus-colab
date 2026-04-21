# mus-colab

A **GitHub template** for open, permissively licensed **music + prose books** (methods, coursework, anthologies, anything you want as a real PDF) without asking every contributor to install LilyPond and a full LaTeX stack locally.

On the GitHub repo page, choose **Use this template** to create a new repository, then rename branding, swap in your chapters, and keep the same build story. Collaboration stays in Git; **Docker + Make** keep local builds aligned with CI; **GitHub Actions** can publish each successful build of `main` as a downloadable PDF on a `latest` release.

## What you get

- **One command**: `make pdf` runs LilyPond, lilypond-book, and LaTeX inside a pinned Docker image (same image CI uses).
- **Words and music separated**: chapter commentary lives in small `.lytex` files; engraved fragments live under `inline/`, `excerpt/`, and `full-music/` so editors and engravers rarely edit the same lines.
- **House style for examples**: numbered musical examples, optional list at the front, centered systems where it matters, inline music that can follow baseline or vertical-center rules, and tall excerpts in a **fixed-height** frame with stretch **between** systems (not one dead zone under the last staff).
- **Shared engraving defaults**: LilyPond include files for block vs inline snippets (staff size, line width, no default LilyPond footer on snippets). Put `\version` in each fragment you care about; shared layout stays in the includes.
- **Bibliography + glossary hooks** wired the usual LaTeX way.

This repo is **machinery and sample content**, not a tied-to-one-title product. Delete or replace the introduction walkthrough when you are ready.

## Repository layout

| Area | Role |
|------|------|
| `main.lytex` | Spine only: document setup, shared LaTeX inputs, front matter, chapter order. Keep long prose out of here. |
| Root front matter | `title-page.lytex`, `source-note.lytex`, `preface.lytex` next to the spine. |
| `chapters/<name>/` | Section prose as small `.lytex` files. |
| `chapters/<name>/inline/`, `excerpt/`, `full-music/` | Music-only fragments. Prose files should pull them in by reference so engraving and text churn independently. |
| `source/latex/` | Packages, page style, **music-examples** (numbered examples, tall fixed-height blocks, multi-page stretch helpers), chord helpers, glossary inputs. |
| `source/lily/` | Shared LilyPond layout for block and inline snippets (Makefile adds this tree to LilyPond’s include path). |
| `references.bib` | Bibliography source for `biber`. |
| `bin/` | PDF and intermediate build output (ignored by git; created by `make pdf`). |

The sample introduction demonstrates inline cells, a block excerpt, and a tall in-flow example. Treat it as living documentation, then replace it with your own material.

## Building (Docker + Make)

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (e.g. Docker Desktop on macOS). The Makefile requests `linux/amd64` so Apple Silicon Macs match CI via emulation when needed.

### Pull the build image (once)

After Docker Desktop is running, pull the toolchain image **once** so it shows under **Images** and the first `make pdf` does not spend forever on a surprise download:

```sh
make docker-pull
```

That uses the same `DOCKER_LILYPOND_IMAGE` (and `linux/amd64` platform) as `make pdf`. `make pdf` still passes `--pull missing`, so pre-pull is optional; it is just the friendly explicit step for collaborators. If you override the image when building, run `make docker-pull DOCKER_LILYPOND_IMAGE=your-registry/your-image:tag` instead.

### Commands

```sh
make docker-pull   # optional: pull toolchain image once into Docker Desktop
make pdf           # writes bin/main.pdf
make open          # opens bin/main.pdf (macOS)
make clean         # removes bin/ and common temp files
```

`make pdf` mounts the repo in the container, runs **lilypond-book** on `main.lytex` into `bin/`, copies the bibliography in place, then runs **pdflatex**, **biber**, **makeglossaries**, and enough extra LaTeX passes for a stable PDF.

Override the image when you maintain your own toolchain:

```sh
make pdf DOCKER_LILYPOND_IMAGE=your-registry/your-image:tag
```

### Troubleshooting

- If nothing runs, confirm the Docker daemon is up.
- LaTeX diagnostics land in `bin/main.log` after a partial build.

## GitHub Actions

On every push to `main`, [.github/workflows/main.yml](.github/workflows/main.yml) runs the same `make pdf`, renames the artifact with a timestamp, and uploads it to the **latest** release (via [ncipollo/release-action](https://github.com/ncipollo/release-action)) so readers can download a PDF without cloning.

Keep the **Makefile** as the single source of truth for how the book is built; change the workflow when the build contract changes.

## After you use the template

- Rename release titles, artifact prefixes, and any `docx` export metadata in the `Makefile` to match your project (search for `mus-colab`).
- Update [.github/workflows/main.yml](.github/workflows/main.yml) release name/body strings if you do not want “mus-colab” in the GitHub UI.
- Replace `LICENSE` only if you need a different permissive choice; keep licensing obvious for downstream forks.
- Point `DOCKER_LILYPOND_IMAGE` at an image you control when you pin different TeX or LilyPond versions.

## Contributing

Template improvements (clearer defaults, safer CI, better docs) are welcome via issues and pull requests.

## License

See [LICENSE](LICENSE).
