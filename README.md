# mus-colab — your modern music book template

This is a complete starter kit for writing and producing a serious music book that combines prose with high-quality engraved music notation.

It is built the way modern software teams work: everything is split into separate, easy-to-manage files so multiple people can work at the same time without stepping on each other. Change one thing and the whole book updates cleanly.

Want to actually ship a book with this stack? If you are interested in using this template for a real project, I am happy to give you direct, hands-on help getting set up—environment, first build, structure of your manuscript, whatever is blocking you. **Email me at [kyledickersoncomposer@gmail.com](mailto:kyledickersoncomposer@gmail.com)** (best for a private back-and-forth), or say hello in this repository’s Discussions tab or open an Issue, and we will go from there.

---

## Start here: GitHub template to your first PDF

You will see the word *terminal* a lot below. That only means **a text window where you type a short command and press Enter**—in VS Code it is the panel opened with **Terminal → New Terminal** (a few lines of text and a blinking cursor). It is not your music score, and you do not need programmer jargon: if the instructions say to type something, click in that panel first so the cursor is there, then type it exactly and press Enter.

If you get lost, a chat-style LLM can be very helpful for **explaining this setup**—copy the full text of this README into the chat and ask it to walk you through the steps in plain language, define a term, or troubleshoot an error message you see.

Follow this order the first time. After that you mostly edit in **Visual Studio Code**, commit and push when you want snapshots on GitHub, and run `make pdf` from that **Terminal** panel whenever you want a fresh PDF (with **Docker Desktop** running).

1. **Create your own repository from this template on GitHub.** Open this project on GitHub in the browser. Click **Use this template**, then **Create a new repository**. Choose your account (or organization), give the book a **repository name**, pick **public** or **private**, and confirm. GitHub copies the template into **your** new repo — that copy is what you own from here on.
2. **Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)** and start it. Leave it running in the background whenever you build the PDF; the `make` targets use Docker behind the scenes.
3. **Install [Visual Studio Code](https://code.visualstudio.com/)** (VS Code). You will use it to edit the project and to type build commands in its **Terminal** panel. Once your book folder is open in VS Code, that panel always starts *in that folder*, so you do not have to find paths or “change directory” by hand.
4. Install Git if your computer does not already have it (VS Code’s clone flow needs Git).

    - On macOS (Apple Command Line Tools, includes Git): open VS Code and use **Terminal → New Terminal** (same panel you will use later for `make pdf`). Click in that panel, type `xcode-select --install`, and press Enter. Then follow the instructions in the Terminal window and any on-screen prompts to install the **developer tools** (they include Git). You do not need the full Xcode app from the App Store for this template—only these tools. If macOS says they are already installed, you are done.
    - On Windows or Linux: install Git from [git-scm.com/downloads](https://git-scm.com/downloads) (or use your distribution’s package manager on Linux).
5. Clone your new repository (not the original template): in VS Code, open the Command Palette (Shift+Command+P on macOS, Shift+Ctrl+P on Windows/Linux), run Git: Clone, paste the HTTPS URL from the green Code button on your repo’s GitHub page, pick a parent folder, then when VS Code asks, choose Open (or use File → Open Folder… and select the cloned folder). The workspace root should be the repository root.
6. Build once (PDF step): open the Terminal panel (**Terminal → New Terminal**, or **View → Terminal**; VS Code also shows a keyboard shortcut next to that menu entry). You should already be in your book folder when the panel appears. With Docker Desktop still running, run each line below in order (type or paste the line, press Enter, wait until it finishes, then the next):
  ```bash
    make docker-pull # Pulls the docker image (only run this once, requires docker to be running)
    make pdf # Builds the PDF
    make open # Opens the pdf
  ```
7. Day to day: keep Docker Desktop running when you build. Edit chapters and LilyPond files in VS Code; use Terminal → New Terminal for `make pdf`. Use VS Code’s Source Control view (branch icon in the activity bar) to commit and push when you want a saved snapshot on GitHub. Pushes to `main` can trigger the included Actions workflow so a fresh PDF is built in the cloud the same way `make pdf` does on your machine (see below).

If anything in the build fails, read the end of `bin/main.log` inside the project folder.

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

**Good uses:** Explaining this README, Docker, VS Code, or Git in plain language (paste the whole file into a chat and ask for a slower walkthrough). **Mechanical LaTeX housekeeping**—fixing a broken build, nudging spacing macros, or applying a house rule you already decided on.

**Poor uses:** Do **not** use an LLM to invent your musical examples. LLMs have a very poor understanding of music and an even worse understanding of how to use software like LilyPond. **The same goes for prose** — the more LLM-generated text people read, the stronger the distaste for it. Write your own music and your own prose; keep the book’s voice and the notation yours even if a model helped you understand the toolchain.

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

If you followed Start here above, you already have Docker Desktop, VS Code, and a local clone. To rebuild the book any time:

1. Start Docker Desktop and wait until it is idle (not still starting up).
2. In VS Code, use File → Open Folder… and choose your cloned repository if it is not already open.
3. Open the Terminal panel (**Terminal → New Terminal**), click inside it so the cursor is blinking there, then type:
  ```bash
    make pdf
  ```
    Press Enter after the line appears (you only run it once per rebuild).

Use `make docker-pull` again only if you were told the image changed or a build says the image is missing.

Optional on a Mac after a successful build:

```bash
make open
```

Output is still `bin/main.pdf`; errors still show at the end of `bin/main.log`.

## GitHub, CI, and what you actually get

When this project lives on **GitHub**, you get something most handwritten music books never bother with.

Each time you commit your work—from VS Code, GitHub Desktop, or any other Git client—a saved snapshot with a short message like “added chapter 4 examples” or “fixed beaming in the violin excerpt”, GitHub Actions can rebuild the whole book on GitHub’s machines using the same steps as `make pdf` on your computer. You do not run that by hand for readers; it runs in the background.

**What that usually means in practice:**

- A fresh PDF is built with the same toolchain as your laptop.  
- That PDF is attached to the latest Release on your repository, so anyone with the link can download the current book without waiting for you to export a file by hand.

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