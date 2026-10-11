# Neovim Cheatsheet

Keybindings from your `~/.config/nvim/init.lua`. Leader = Space.

Language references: [Python](python-cheatsheet.md) · [Go](golang-cheatsheet.md)

## LSP Navigation (active in any LSP-enabled buffer)

| Key | Action |
|-----|--------|
| `grr` | **Go to references** (Telescope) |
| `grd` | Go to definition |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grD` | Go to declaration |
| `gO` | Document symbols (functions, types in current file) |
| `gW` | Workspace symbols (search across project) |
| `grn` or `<leader>rn` | Rename symbol |
| `gra` or `<leader>ca` | Code action |
| `<leader>F` | Format buffer |
| `K` | Hover docs (built-in default) |

## Symbols

| Key / Command | Lists |
|---------------|-------|
| `gO` | Symbols in the **current buffer** (Telescope, fuzzy filter) |
| `gW` | Symbols across the **project** (Telescope; type a name, results update as you type) |
| `:Telescope lsp_document_symbols symbols=function` | Current-buffer symbols of one kind (`function`, `method`, `class`, `struct`, `variable`, ...) |
| `:Telescope treesitter` | Current-buffer symbols without LSP (uses treesitter) |
| `:lua vim.lsp.buf.document_symbol()` | Current-buffer symbols into the location list (no Telescope) |
| `:lua vim.lsp.buf.workspace_symbol()` | Project symbols into the quickfix list (prompts for a query) |

Tip: in `gO`/`gW`, press `<CR>` to jump to the symbol.

## Diagnostics

| Key | Action |
|-----|--------|
| `<leader>q` | Open diagnostics in quickfix list |
| `<leader>sd` | Search diagnostics (Telescope) |
| `[d` / `]d` | Prev/next diagnostic (built-in default) |

## Telescope Search

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files |
| `<leader>sg` | Live grep |
| `<leader>sk` | Search keymaps (all keys with descriptions; type to filter) |
| `<leader>sc` | Search commands |
| `<leader>sh` | Search help tags |
| `<leader>sd` | Search diagnostics |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Open buffers |
| `:TodoTelescope` | List TODO/FIX/NOTE comments in project |

## Finding Shortcuts

- `<leader>sk`: the fastest way. Search by what you want to do (`rename`, `format`, `comment`).
- Press `<leader>` and pause: which-key lists the leader mappings. Works for `g`, `[`, `]` too.
- `:verbose map gc`: shows the mapping and the file/line that defines it.
- Built-in Vim keys: `:help gc`, `:help [t`.

## Commenting

Built-in (Neovim 0.10+), no plugin. Comment string comes from the filetype (`#` Python, `//` Go).

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on current line |
| `{count}gcc` | Toggle comment on `count` lines (e.g. `3gcc`) |
| `gc{motion}` | Toggle comment over a motion (e.g. `gcap` paragraph, `gc2j`) |
| `gc` (visual) | Toggle comment on selected lines |
| `.` | Repeat last comment toggle |

- Comment a block: `V` to select, then `gc`.
- Python docstrings aren't comments; `gc` won't touch them.
- Todo markers: `]t` / `[t` jump to next / previous TODO, FIX, NOTE (todo-comments.nvim).

## General Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between splits |
| `<leader>c` | Close quickfix |
| `<Esc>` (in terminal) | Exit terminal mode |

## Python Constructor Fill (`lua/custom/fill_args.lua`)

| Key | Mode | Action |
|-----|------|--------|
| `<C-l>` | Insert | Fill required args inside empty `Foo(|)` as tab-stops |
| `<leader>fa` | Normal | Same, with cursor inside the empty parens |

Example: `P(` on a `@dataclass` with fields `x`, `y`, `z: int = 0` → `P(x=x, y=y)`, `x` selected; `<Tab>` moves to `y`. Parameters with defaults are skipped. Does nothing if the parens already contain text.
