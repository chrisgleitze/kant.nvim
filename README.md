# kant.nvim

Search and browse the works of Immanuel Kant in German directly from Neovim.

Combine the powerful search capabilities of Neovim with the large text corpus of one of the most influential philosophers of all time.

kant.nvim ships with a structured plaintext corpus of Kant's writings and
integrates with fuzzy finders like [fzf-lua](https://github.com/ibhagwan/fzf-lua)
and [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for
full-text search, work browsing, and serendipitous discovery.

> [!NOTE]
> This is a very early stage plugin!\
> I've only added a few short texts to create a proof of concept.\
> That worked well so far, so I'll add more shortly.\

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

If you'd like to edit the default config:

```lua
{
  "chrisgleitze/kant.nvim",
    config = function()
        require("kant").setup({
        -- your own config
    end,
}
```

### [vim.pack](https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack)

(since Neovim 0.12 the built-in Neovim plugin manager)

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
  keymap = {
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

The plugin ships with selected passages from Kant's major works as plaintext files. Each file includes a YAML-style metadata header with the work title, section name, Akademie-Ausgabe volume and page range, and year of first publication.

### Currently included

- **Kritik der reinen Vernunft** — Vorrede (B), Einleitung
- **Grundlegung zur Metaphysik der Sitten** — Vorrede, Erster Abschnitt

### Adding texts

Place additional `.txt` files in a subdirectory under `texts/`. Each
subdirectory represents one work. Files should follow this format:

```
---
Werk: Title of the Work
Abschnitt: Section Name
Akademie-Ausgabe: Bd. III, S. 49-80
Erstausgabe: 1781
---

Text content here...
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
│   ├── kritik-der-reinen-vernunft/
│   │   ├── vorrede-b.txt
│   │   └── einleitung.txt
│   └── grundlegung-zur-metaphysik-der-sitten/
│       ├── vorrede.txt
│       └── erster-abschnitt.txt
├── scripts/                # Text fetching utilities (planned)
└── README.md
```

## Roadmap

- [ ] Expand corpus with all three Critiques and minor works
- [ ] `scripts/fetch_texts.sh` to download texts from Project Gutenberg / DTA
- [ ] `:KantStelle III:52` — look up passages by Akademie-Ausgabe page number
- [ ] Begriffregister (concept index) for key philosophical terms
- [ ] A/B edition parallel view for Kritik der reinen Vernunft
- [ ] Custom `ft=kant` syntax highlighting for footnotes and page breaks
- [ ] Citation export to clipboard

## License

The plugin code is released under the MIT License.

Kant's texts are in the public domain.
