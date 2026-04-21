# mus-colab — your modern music book template

This is a complete starter kit for writing and producing a serious music book that combines prose with high-quality engraved music notation.

It is built the way modern software teams work: everything is split into separate, easy-to-manage files so multiple people can work at the same time without stepping on each other. Change one thing and the whole book updates cleanly.

## Start here: GitHub template to your first PDF

Follow this order the first time. After that you mostly edit the text, create a commit in GitHub Desktop, push, and run `make pdf` when you want a fresh PDF locally.

1. **Create your own repository from this template on GitHub.** Open this project on GitHub in the browser. Click **Use this template**, then **Create a new repository**. Choose your account (or organization), give the book a **repository name**, pick **public** or **private**, and confirm. GitHub copies the template into **your** new repo — that copy is what you own from here on.
2. **Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)** and start it. Leave it running in the background.
3. **Install [GitHub Desktop](https://desktop.github.com/)** and sign in with the **same GitHub account** that owns the new repository.
4. **Clone your new repository to your computer** (not the original template): in GitHub Desktop use **File → Clone repository…**, pick your repo on the **GitHub.com** tab *or* paste its HTTPS URL from the green **Code** button on **your** repo’s page, choose a **Local path**, then **Clone**.
5. **Build once from a terminal** (only for the PDF step): with your repository **open and selected** in GitHub Desktop, open a shell **already in your project folder** so you never have to type `cd` or drag the folder into Terminal. Use the menu bar **Repository** menu:
   - **macOS:** **Repository → Open in Terminal**
   - **Windows:** **Repository → Open in Command Prompt** or **Repository → Open in PowerShell** (the exact label depends on your GitHub Desktop version)

   There is no built-in “right-click this file in GitHub Desktop and open Terminal here” for arbitrary paths; this menu item is the supported way to land in the repo root. Then run:

   ```bash
   make docker-pull
   make pdf
   ```

   Your PDF is `bin/main.pdf`. On a Mac you can run `make open` afterward if you like.
6. **Day to day:** edit files in any editor you like; use GitHub Desktop to **commit** and **Push origin** when you want a saved snapshot on GitHub. Pushes to `main` can trigger the included **Actions** workflow so a fresh PDF is built in the cloud the same way `make pdf` does on your machine (see below).

If anything in step 5 fails, read the end of `bin/main.log` inside the project folder.

## Why this setup works well for musicians

### Professional results

The template uses LaTeX for the book layout and LilyPond for engraving the music. The output tends to look sharper and more consistent than what you get from typical word-processor workflows or rushed house typesetting.

### Real collaboration

You are not emailing giant Word files or guessing which attachment was “final.” Chapters and examples live in their own files, so more than one person can work at once and the assembled book still matches one house style.

### You stay in control of the music

Prose stays in simple text files. Each printed example lives in its own LilyPond file, wired to shared layout rules in this template so the book reads as one publication.

**Learning LilyPond is one of the best technical investments you can make** for a serious music book: the language is a straight description of the score, and you keep every slur, beam, dynamic, and spacing choice where you can see and revise it.

---

### LLMs and this project

Do **not** use an LLM to invent your musical examples. LLMs have a very poor understanding of music and an even worse understanding of how to use software like LilyPond. **The same goes for prose** — the more LLM-generated text people read, the stronger the distaste for it. Write your own music and your own prose.

The only valuable role for an LLM here is **mechanical LaTeX housekeeping** — fixing a broken build, nudging spacing macros, or applying a house rule you already decided on. Your words and your notation should still come from you.

---

A sample chapter is included so you can see how everything comes together. Replace it with your own content whenever you are ready.

## LilyPond — what it is and how to learn it

LilyPond is free software that turns a text description of music (pitches, rhythms, dynamics, lyrics, articulations, etc.) into beautifully engraved printed notation — similar in quality to what a professional engraver would produce.

You describe exactly what you mean in a logical, text-based language instead of dragging notes with a mouse. It feels slow at first but gives you precise, repeatable, and easily fixable results.

**Recommended way to learn:**

1. Skim the **Learning Manual** to understand how a LilyPond file is structured and how a basic score is built.
2. Keep the **Notation Reference** open as your dictionary while you work — look up symbols and tweaks as needed.
3. Start by copying and adapting the small examples included in this template (inline excerpts, block examples, tall spreads, etc.).
4. Rebuild often with `make pdf` so you catch mistakes while they are still small.

**Official resources (matching the version this template uses):**

- [Learning Manual](https://lilypond.org/doc/v2.24/Documentation/learning/index) — start here  
- [Notation Reference](https://lilypond.org/doc/v2.24/Documentation/notation/index) — every symbol and command you will need  
- [Music Glossary](https://lilypond.org/doc/v2.24/Documentation/music-glossary/index) — terms explained in plain language  
- [LilyPond website](https://lilypond.org) — main site, downloads, and community  
- [LilyPond Snippet Repository](https://lsr.di.unimi.it/LSR/) — useful short examples you can adapt (check against your LilyPond version)

The long-term goal for this template is to grow into a full practical guide covering book structure, LilyPond usage, and LaTeX layout together. Until then, treat the official manuals as the ground truth and the sample chapters here as working recipes you can study and modify.

## Rebuild the PDF on your computer

If you followed **Start here** above, you already have **Docker**, **GitHub Desktop**, and a local clone. To rebuild the book any time:

1. In **GitHub Desktop**, select your book repository.
2. **Repository → Open in Terminal** (macOS) or **Repository → Open in Command Prompt** / **Open in PowerShell** (Windows) — same as in **Start here**; the shell opens in the project root with no `cd` step.
3. Run:

```bash
make pdf
```

Use `make docker-pull` again only if you were told the image changed or a build says the image is missing.

Optional on a Mac after a successful build:

```bash
make open
```

Output is still `bin/main.pdf`; errors still show at the end of `bin/main.log`.

### GitHub Desktop reminder (clone, commit, push)

If you skipped the details earlier: **File → Clone repository…** → your repo on the **GitHub.com** tab or paste the **Code** HTTPS URL → pick **Local path** → **Clone**. After edits: left column shows changes → bottom **Summary** → **Commit to main** → **Push origin**. For local PDF builds, remember **Repository → Open in Terminal** (or the Windows equivalent) so the shell starts in the right folder.

## GitHub, CI, and what you actually get

When this project lives on **GitHub**, you get something most handwritten music books never bother with.

Each time you **commit** your work — from **GitHub Desktop** or any other tool — (a saved snapshot with a short message like “added chapter 4 examples” or “fixed beaming in the violin excerpt”), **GitHub Actions** can rebuild the whole book on GitHub’s machines using the **same** steps as `make pdf` on your computer. You do not run that by hand for readers; it runs in the background.

**What that usually means in practice:**

- A fresh PDF is built with the same toolchain as your laptop.  
- That PDF is attached to the **latest** **Release** on your repository, so anyone with the link can download the current book without waiting for you to export a file by hand.

Your book can stay **current**: a meaningful change in the repo can produce a new, clean PDF for collaborators, editors, students, or proofreaders.

GitHub may also list its own automatic **source** downloads next to your PDF on the release page. That is normal; this project does not control it. Point people at the **PDF** the workflow uploads.

**In one glance, this template is aiming for:**

- Serious book layout (LaTeX)  
- Serious music engraving (LilyPond)  
- Prose and notation kept in separate files  
- A repeatable PDF build locally (`make pdf`)  
- An optional path to an always-fresh PDF via GitHub when you wire Actions up like this repo

Think of it as a small publishing pipeline you own end to end.

## Making it yours

Search the whole project folder for `mus-colab` and replace it with your book’s real title (and the same string in your GitHub Actions workflow if you use it).

**License and selling your work**

Replace the **LICENSE** file that ships with this repo with one that matches how you actually distribute the book. If you want a simple permissive default for a free project, **MIT** is a common choice — but **do not** use MIT (or similar “do whatever”) terms if you intend to **sell** the book or keep the manuscript private. In that case, make the GitHub repository **private** and pick a license (or contract language) that **reserves the rights you care about**. When in doubt, talk to someone who handles rights for books, not only software.

## Want to improve the template?

Open a discussion or submit a suggestion on the original project page where you downloaded this starter.

## License

See the [LICENSE](LICENSE) file.