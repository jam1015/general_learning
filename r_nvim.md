# R.nvim Keybindings

`<LocalLeader>` is `\` by default.

## Starting / Stopping R

- `\rf` — Start R
- `\rq` — Quit R
- `:RStop` — Send SIGINT (like Ctrl-C)
- `:RKill` — Force kill R

## Sending Code to R

- `\d` — Send current line
- `\m{motion}` — Send lines from motion (e.g. `\m}` for paragraph, `\m3j` for next 3 lines)
- `\bb` — Send block between manual marks
- `\o` — Print current line and insert output as comments
- `\ao` — Run `R CMD BATCH` on current file, show `.Rout`
- `:RSend` — Type and send a line to R
- `:RSourceDir` — Source all `.R` files in a directory

## Help & Inspection

- `\rh` — Show help for function under cursor
- `\rp` — Print object under cursor
- `\td` — Run `dput()` on object, insert output in new tab
- `\rv` — Run `dput()` (or display data.frame/matrix in tab)
- `:RHelp topic` — Get help on any R topic
- `q` — Close R documentation window
- `\gn` — Jump to next code section in help docs

## Insert Mode

- `Alt+-` — Insert ` <- ` (assignment operator)
- `Alt-r` — Insert R chunk delimiters (in Rmd/Quarto/Rnoweb)

## Other

- `:RMapsDesc` — List all current mappings
