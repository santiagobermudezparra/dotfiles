# dotfiles-chezmoi

# Neovim Tree Explorer Cheat Sheet

## Toggle & Reveal
- **`<Space> e`** → Toggle tree view (neo-tree)
- **`:Neotree reveal`** → Show current file in the tree
- **`<C-w> h`** → Focus tree pane
- **`<C-w> l`** → Go back to editor pane

## Navigation Inside Tree
| Key        | Action                              |
|------------|-------------------------------------|
| `h`        | Collapse folder                     |
| `l` / `<CR>` | Expand folder / open file         |
| `o`        | Open file                           |
| `-`        | Go to parent directory              |
| `a`        | Add new file                        |
| `d`        | Delete file/folder                  |
| `r`        | Rename file/folder                  |
| `y`        | Copy file path                      |
| `i`        | Search / focus input                |
| `q` / `<Esc>` | Close tree                       |

## Reveal Current File
- **Neo-tree:** `:Neotree reveal`
- **Nvim-tree:** `:NvimTreeFindFile`

## Search in Files
- **`<Space> /`** → Global text search in current folder (grep)
  - `<Tab>` → Next result
  - `<S-Tab>` → Previous result
  - `<CR>` → Open selected file

## Moving Between Windows
- `<C-w> h` → Move to left pane (tree)
- `<C-w> l` → Move to right pane (editor)
- `<C-w> j` → Move down
- `<C-w> k` → Move up
