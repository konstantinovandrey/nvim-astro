# My Neovim config (AstroNvim + Jupyter)

Personal Neovim configuration based on [AstroNvim](https://github.com/AstroNvim/AstroNvim),
extended with a Jupyter notebook workflow (`jupytext` + `molten-nvim`).

| | |
|---|---|
| Repo | `github.com/konstantinovandrey/nvim-astro` (private) |
| Windows config path | `%LOCALAPPDATA%\nvim` |
| Windows data path | `%LOCALAPPDATA%\nvim-data` |
| Linux config path | `~/.config/nvim` |
| Linux data path | `~/.local/share/nvim` |
| Verified with | Neovim 0.11.6, Python 3.11 (venv) |

---

## What is in here

```
init.lua                     bootstrap for lazy.nvim (do not edit)
lazy-lock.json               pinned plugin versions — commit this
lua/lazy_setup.lua           lazy.nvim setup + plugin import
lua/polish.lua               machine-specific wiring (venv, python host, PATH)
lua/plugins/astrocore.lua    AstroNvim core options + keybindings
lua/plugins/notebooks.lua    jupytext + molten-nvim + image.nvim
lua/plugins/user.lua         catppuccin/nightfly, which-key group
lua/plugins/astrolsp.lua     LSP setup
lua/plugins/mason.lua        LSP servers
lua/plugins/none-ls.lua      null-ls linters
lua/plugins/treesitter.lua   treesitter
```

## Requirements

- Neovim **>= 0.11**
- git
- Python 3.10+ in a virtualenv (see below)
- A Nerd Font for the icons (optional, only affects glyphs)

The virtualenv must live at `~/.hermes/hermes-agent/venv` or you must edit
`lua/polish.lua` (see *Machine-specific bits*).

## Setup on a new machine

### 1. Clone

```powershell
# Windows — the repo is private, use the authenticated gh CLI
gh repo clone konstantinovandrey/nvim-astro "$env:LOCALAPPDATA\nvim"
```

```bash
# Linux
gh repo clone konstantinovandrey/nvim-astro ~/.config/nvim
```

### 2. Create the Python venv

```powershell
python -m venv "$env:USERPROFILE\.hermes\hermes-agent\venv"
& "$env:USERPROFILE\.hermes\hermes-agent\venv\Scripts\python.exe" -m pip install -U pip
& "$env:USERPROFILE\.hermes\hermes-agent\venv\Scripts\python.exe" -m pip install pynvim jupyter_client ipykernel jupytext plotly pnglatex
& "$env:USERPROFILE\.hermes\hermes-agent\venv\Scripts\python.exe" -m ipykernel install --user --name python3
```

```bash
# Linux
python3 -m venv ~/.hermes/hermes-agent/venv
~/.hermes/hermes-agent/venv/bin/python -m pip install -U pip
~/.hermes/hermes-agent/venv/bin/python -m pip install pynvim jupyter_client ipykernel jupytext plotly pnglatex
~/.hermes/hermes-agent/venv/bin/python -m ipykernel install --user --name python3
```

### 3. Install plugins

```vim
:Lazy sync
```

Then register the molten remote plugin **once** (it needs the venv python as
its host):

```vim
:UpdateRemotePlugins
```

### 4. Verify

```vim
:checkhealth provider   " expect: Using g:python3_host_prog = .../venv/Scripts/python.exe, pynvim OK
:checkhealth molten     " expect: pynvim + jupyter-client OK
```

If `molten` health complains about a missing kernel:

```powershell
jupyter kernelspec list   # expect a "python3" entry pointing at the venv
```

## Machine-specific bits (`lua/polish.lua`)

This file is the only place that knows about *this* machine. It:

1. resolves the hermes venv and sets `g:python3_host_prog` to it, so the
   `python3` remote-plugin host runs inside the venv and can `import pynvim`;
2. prepends the venv's bin dir to `$PATH`, so that
   - `jupytext` (the CLI `jupytext.nvim` shells out to) is found, and
   - the ipykernel spec — which launches a bare `python` — runs in the venv.

Paths are probed in this order:

| Order | Windows | Linux |
|---|---|---|
| 1 | `%USERPROFILE%/.hermes/hermes-agent/venv/Scripts/python.exe` | `~/.hermes/hermes-agent/venv/Scripts/python.exe` |
| 2 | `~/.hermes/hermes-agent/venv/Scripts/python.exe` | `~/.hermes/hermes-agent/venv/bin/python` |

> **Note:** on the Windows dev box `$HOME` points at `E:\Cadence\SPB_Data`
> (set by Cadence SPB_Data), which is why `~` is *not* used as the primary
> source. If your machine has a normal `$HOME`, the fallback still works.

If your venv lives elsewhere, edit the candidate list at the top of
`lua/polish.lua` — nothing else needs to change.

## Jupyter notebooks

### How it works

- **jupytext.nvim** opens a `.ipynb` file as plain Python with `# %%` cell
  markers. Editing and saving the buffer writes the `.ipynb` back.
- **molten-nvim** runs the cells against an `ipykernel` and shows the output
  inline (virtual text) plus an output window.
- **image.nvim** renders figures. On Windows this needs a terminal with the
  Kitty graphics protocol; in other terminals only the text output shows.

### Keys

| Key | Action |
|---|---|
| `<leader>mi` | init kernel (pick `python3`) |
| `<leader>me` | evaluate the cell under the cursor |
| `<leader>mv` | evaluate the visual selection |
| `<leader>ml` | evaluate the current line |
| `<leader>mc` | re-evaluate the current cell |
| `<leader>md` | delete the cell output |
| `<leader>mo` | show the output window |
| `<leader>mh` | hide the output window |
| `<leader>mr` | restart the kernel |

`<leader>` is `<Space>` by default.

### Useful trick

It is usually easier to keep the notebook as a `.py` file with `# %%` markers
and let jupytext produce the `.ipynb` on save:

```python
# %%
import pandas as pd
df = pd.read_csv("data.csv")
df.head()
```

## Tips

- `:Lazy update` updates plugins; `lazy-lock.json` records the result.
- `g:python3_host_prog` is only read when the remote plugin host starts —
  restart nvim after changing it.
- The AstroNvim `opts.mappings` in `lua/plugins/astrocore.lua` is the *base*
  layer; AstroNvim's own plugins extend it, so adding entries there is safe.

---

## Upstream

This config is based on the [AstroNvim template](https://github.com/AstroNvim/AstroNvim).
The original template README is kept verbatim in
[`docs/upstream-template.md`](docs/upstream-template.md).

## License

MIT
