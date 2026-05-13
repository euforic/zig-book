# The Zig Book

A beginner-to-active-project curriculum for Zig 0.16.0.

This repo dogfoods Zig for the book tooling: chapter metadata, site generation, local development serving, and validation all run through `zig build`.

## What This Is

The book is designed for developers who are new to Zig and want to use the language actively in real projects. It teaches the current stable Zig path rather than migration history.

I use Codex to help create and maintain this book as part of my own process for learning Zig deeply.

The curriculum covers:

- Zig 0.16.0 setup and project structure
- language fundamentals through comptime and generics
- memory, allocators, pointers, slices, and safety
- error handling, optionals, unions, packed data, and SIMD
- standard library APIs used by real projects
- build system workflows, packages, tests, generated files, C interop, and cross compilation
- practice labs and cumulative projects

## Repository Layout

- `content/chapters/*.html` contains chapter bodies.
- `src/book_data.zig` defines the part and chapter metadata.
- `src/bookgen.zig` generates the browser book bundle and static site.
- `src/serve.zig` serves the generated site for local development.
- `src/runtime-prefix.js` contains authoring helpers used by chapters.
- `src/runtime-suffix.js` contains browser routing, rendering, search, TOC, and theme behavior.
- `index.html` is the static shell and styling.
- `book.js` is generated locally from the chapter sources and metadata, and is intentionally not tracked.
- `dist/` is the generated publish folder and is intentionally ignored.
- `.github/workflows/pages.yml` builds and deploys the site to GitHub Pages.
- `skills/zig-book-updater/SKILL.md` is the repo-local maintenance workflow for keeping the book aligned with Zig releases.

## Prerequisites

- Zig 0.16.0
- Node.js, used only for JavaScript syntax validation in `zig build check`
- GitHub CLI, only needed for repository and Pages administration

Check the active Zig version:

```sh
zig version
```

## Local Development

Regenerate the browser bundle:

```sh
zig build generate
```

Build the publishable static site into `dist/`:

```sh
zig build site
```

Serve the generated site locally with Zig:

```sh
zig build serve
```

The default local URL is:

```text
http://127.0.0.1:8080/
```

Use another port when needed:

```sh
zig build serve -Dport=8081
```

## Validation

Run the full local gate before publishing changes:

```sh
zig build check
```

For content changes that include nontrivial Zig examples, compile or test the example with Zig 0.16.0 before publishing it. Remove scratch files afterward.

## Editing Rules

- Do not edit `book.js` by hand. It is generated.
- Do not commit `book.js`. It is regenerated locally and in CI.
- Do not edit files under `dist/` by hand. Rebuild with `zig build site`.
- Edit chapters in `content/chapters/*.html`.
- Edit chapter ordering, titles, and part metadata in `src/book_data.zig`.
- Edit runtime helpers in `src/runtime-prefix.js` or `src/runtime-suffix.js`.
- Use the repo-local updater skill before version-sensitive changes: `skills/zig-book-updater/SKILL.md`.

## Keeping Zig Content Current

This book targets stable Zig 0.16.0. For language, standard library, or build-system changes:

1. Confirm the active compiler with `zig version` and `zig env`.
2. Check official Zig download metadata and release notes.
3. Verify API signatures against the installed stdlib source from `zig env`.
4. Prefer official stable docs and installed source over blog posts or stale snippets.
5. Teach the current stable approach directly. Avoid migration framing for beginner-facing chapters.
6. Run `zig build generate`, `zig build site`, and `zig build check`.

## GitHub Pages

The Pages workflow runs on pushes to `main` and on manual dispatch:

```text
.github/workflows/pages.yml
```

It installs Zig 0.16.0, builds `dist/`, validates the generated site, uploads the Pages artifact, and deploys with GitHub Pages Actions.

Published site:

```text
http://gh.euforic.one/zig-book/
```

## Releases

Releases are handled by `.github/workflows/release.yml`.

Create a release by pushing a version tag:

```sh
git tag v0.1.0
git push origin v0.1.0
```

The release workflow installs Zig 0.16.0, builds `dist/`, runs `zig build check`, packages the static site as `.tar.gz` and `.zip`, and creates a GitHub Release with those artifacts.

## License

MIT. See `LICENSE`.
