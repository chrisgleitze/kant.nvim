# kant.nvim

Search and browse the works of Immanuel Kant in German directly from Neovim.

The plugin combines Neovim's powerful search capabilities with a local corpus of the works of one of the most influential philosophers of all time.

The texts are arranged, so you can cite the exact page of the Akademie Ausgabe, the authoritative edition of Kant's works. It is one text file per page of the Akademie Ausgabe.

## What is it?

kant.nvim ships with a structured plaintext corpus of Kant's writings and
integrates with fuzzy finders like [fzf-lua](https://github.com/ibhagwan/fzf-lua)
and [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for
full-text search, work browsing, and serendipitous discovery.

## Why?

This plugin is useful for people writing about Kant in Neovim. Neovim users usually like to do as much as possible without leaving the editor. A local corpus of Kant's works is a natural fit. It is likely the quickest way to find a passage or a term in his writings.

Kant is notoriously hard to understand, so you need ro re-read his works again and again. Often you need to revisit what he actually wrote to make sure you have a definition right. You might also want to re-read entire passages of the original to check whether the interpretation you have in mind is compatible with the original.

## Features

- **Full-text search** across all of Kant's works via `:KantSearch`
- **Browse by work** with `:KantWerke`
- **Random passage** for inspiration with `:KantZufall`
- Texts annotated with **Akademie-Ausgabe** references
- Opens texts in **read-only** mode by default
- Works with **fzf-lua** (default) or **telescope.nvim**

## Requirements

- Neovim >= 0.8
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) or
  [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (used by both pickers)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

To use the default config:

```lua
{
  "chrisgleitze/kant.nvim",
  config = true,
}
```

If you'd like to edit the default configuration:

```lua
{
  "chrisgleitze/kant.nvim",
  config = function()
    require("kant").setup({
      -- your own config
    })
  end,
}
```

### [vim.pack](https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack)

Since Neovim 0.12, this is the built-in plugin manager.

```lua
vim.pack.add({
  "https://github.com/chrisgleitze/kant.nvim",
})
require("kant").setup()
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "chrisgleitze/kant.nvim",
  config = function()
    require("kant").setup()
  end,
}
```

## Configuration

```lua
require("kant").setup({
  -- Directory containing the text corpus.
  -- Defaults to the texts/ directory bundled with the plugin.
  texts_dir = vim.fn.stdpath("data") .. "/kant-texte",

  -- Picker backend: "fzf-lua" or "telescope"
  picker = "fzf-lua",

  -- Open texts in read-only mode
  readonly = true,

  -- Show Akademie-Ausgabe references
  show_references = true,

  -- Key mappings (set to false to disable)
  keymaps = {
    search = "<leader>ks",   -- Open search prompt
    werke  = "<leader>kw",   -- Browse works
    zufall = "<leader>kz",   -- Random passage
  },
})
```

## Commands

| Command               | Description                        |
| --------------------- | ---------------------------------- |
| `:KantSearch [query]` | Full-text search across all works  |
| `:KantWerke`          | Pick a work, then search within it |
| `:KantZufall`         | Jump to a random passage           |

## Default Keymaps

| Keymap       | Action        |
| ------------ | ------------- |
| `<leader>ks` | `:KantSearch` |
| `<leader>kw` | `:KantWerke`  |
| `<leader>kz` | `:KantZufall` |

## Text Corpus

The plugin ships with plaintext files from Kant's major works. Each file includes a YAML-style metadata header with the work title, section name, Akademie-Ausgabe volume, page range, and year of first publication.

For the _Kritik der reinen Vernunft_, the corpus distinguishes the two relevant editions explicitly in separate top-level directories under `texts/`:

- `1781-kritik-der-reinen-vernunft-a-ausgabe` for the first edition
- `1787-kritik-der-reinen-vernunft-b-ausgabe` for the second edition

This matters especially for the prefaces and the introduction, which differ substantially between A and B.

### Currently included

- **Kritik der reinen Vernunft**
- **Kritik der praktischen Vernunft**
- **Kritik der Urteilskraft**
- **Idee zu einer allgemeinen Geschichte in weltbürgerlicher Absicht**
- **Beantwortung der Frage: Was ist Aufklärung?**
- **Prolegomena zu einer jeden künftigen Metaphysik**
- **Über den Gemeinspruch: Das mag in der Theorie richtig sein, taugt aber nicht für die Praxis**
- **Religion innerhalb der Grenzen der bloßen Vernunft**
- **Metaphysische Anfangsgründe der Rechtslehre**
- **Das Ende aller Dinge**
- **Bestimmung des Begriffs einer Menschenrace**
- **Grundlegung zur Metaphysik der Sitten**
- **Metaphysische Anfangsgründe der Tugendlehre**
- **Der Streit der Facultäten**
- **Anthropologie in pragmatischer Hinsicht**
- **Über ein vermeintes Recht aus Menschenliebe zu lügen**
- **Zum ewigen Frieden**

### Adding texts

Place additional `.txt` files in a subdirectory under `texts/`. Each
subdirectory represents one work. Files should follow this format:

Use simple page-based filenames such as `seite-001.txt`, `seite-002.txt`.

```
---
Werk: Title of the Work
Abschnitt: Section Name
Akademie-Ausgabe: Bd. III, S. 49-80
Erstausgabe: 1781
---

Text content here...
```

For edition-sensitive texts such as the _Kritik der reinen Vernunft_, add explicit edition metadata:

```
---
Werk: Kritik der reinen Vernunft
Ausgabe: B
Auflage: 1787
Sigle: B27
Abschnitt: Einleitung
Akademie-Ausgabe: Bd. III, S. 27
Erstausgabe: 1781
---
```

## Project Structure

```
kant.nvim/
├── lua/
│   └── kant/
│       ├── init.lua        # Plugin setup and configuration
│       ├── search.lua      # Full-text search (fzf-lua / telescope)
│       └── picker.lua      # Work browser and random passage
├── plugin/
│   └── kant.vim            # Vim command definitions
├── texts/
│   ├── 1781-kritik-der-reinen-vernunft-a-ausgabe/
│   ├── 1783-prolegomena-zu-einer-jeden-kuenftigen-metaphysik/
│   ├── 1784-idee-zu-einer-allgemeinen-geschichte-in-weltbuergerlicher-absicht/
│   ├── 1784-beantwortung-der-frage-was-ist-aufklaerung/
│   ├── 1785-bestimmung-des-begriffs-einer-menschenrace/
│   ├── 1785-grundlegung-zur-metaphysik-der-sitten/
│   ├── 1787-kritik-der-reinen-vernunft-b-ausgabe/
│   ├── 1788-kritik-der-praktischen-vernunft/
│   ├── 1790-kritik-der-urteilskraft/
│   ├── 1793-ueber-den-gemeinspruch-das-mag-in-der-theorie-richtig-sein/
│   ├── 1793-religion-innerhalb-der-grenzen-der-blossen-vernunft/
│   ├── 1794-das-ende-aller-dinge/
│   ├── 1795-zum-ewigen-frieden/
│   ├── 1797-metaphysische-anfangsgruende-der-rechtslehre/
│   ├── 1797-metaphysische-anfangsgruende-der-tugendlehre/
│   ├── 1797-ueber-ein-vermeintes-recht-aus-menschenliebe-zu-luegen/
│   ├── 1798-der-streit-der-facultaeten/
│   ├── 1798-anthropologie-in-pragmatischer-hinsicht/
├── scripts/                # Text fetching utilities (planned)
└── README.md
```

## Roadmap

- [x] Expand corpus with more works and minor texts
- [ ] `scripts/fetch_texts.sh` to download texts from Project Gutenberg / DTA
- [ ] `:KantStelle III:52` — look up passages by Akademie-Ausgabe page number
- [ ] Begriffregister (concept index) for key philosophical terms
- [ ] A/B edition parallel view for Kritik der reinen Vernunft
- [ ] Custom `ft=kant` syntax highlighting for footnotes and page breaks
- [ ] Citation export to clipboard

## License

The plugin code is released under the MIT License.

Kant's texts are in the public domain.
