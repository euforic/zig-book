# Zig Book Agent Notes

This project dogfoods Zig for site generation.

- Do not edit `book.js` by hand. It is generated.
- Do not commit `book.js`; it is generated locally and in CI.
- Edit chapter content under `content/chapters/*.html`.
- Edit part/chapter metadata in `src/book_data.zig`.
- Edit runtime helpers in `src/runtime-prefix.js` or `src/runtime-suffix.js`.
- Regenerate with `zig build generate`.
- Build the publishable static site with `zig build site`; output goes to ignored `dist/`.
- Serve the generated static site locally with `zig build serve`; override the default port with `-Dport=8081`.
- Validate with `zig build check`.
- For version-sensitive Zig facts, verify against the installed Zig stdlib and official Zig release notes before changing prose or examples.
- Repo-local workflow skill: `skills/zig-book-updater/SKILL.md`.
