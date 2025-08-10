---
title: "Practical Vim Examples"
author: Jordan Mandel
date: 2021_11_01
geometry: margin=2.54cm
---
# Intro

I very much like the book 'Practical Vim' by Drew Neil, but the examples are scattered through many text files.  This brings them together under a single markdown document that someone could work through similarly to the vimtutor document that comes with vim.
Also included are summaries of tips that don't have accompanying examples; tips with examples are marked *Example*.
To learn Vim I first recommend going through the vimtutor document a few times, then going through this document while reading the full text of Practical Vim.
I may consider splitting this file into several by sections if having it all in one document makes limiting the scope of commands to the example we are working on cumbersome.


## 1. The Vim Way

### Tip 1 *Example*: The dot command 
- Indent the lines with `>G`
- Delete with `x`.
- Delete lines with `dd`
- Repeat any of these with `.`

---

*the_vim_way/0_mechanics.txt*
```
Line one
Line two
Line three
Line four
```
---

### Tip 2 *Example*: Don't Repeat Yourself
Append semicolons with `A;`, use `j.` to repeat.

---

*the_vim_way/2_foo_bar.js*
```
var foo = 1
var bar = 'a'
var foobar = foo + bar
```
---

We also have 
- `C` same as `c$`
- `cc` same as `^C`. `S` does this too but  the keybinding might be taken up by the plugin `lightspeed` for neovim.
- `I` inserts at betinning of line.
- `A` inserts at end of line.
- `o` opens line below
- `O` pushes current line down and opens new line on curren line

### Tip 3 *Example*: Take One Step Back, Then Three Forward
- start at betinning and use `f+` to get to the first `+`
- then `s + <esc>` followed by `;` and `.`.  Note that `lightspeed` might break this.

---

*the_vim_way/3_concat.js*
```
var foo = "method("+argument1+","+argument2+")";
```
---


### Tip 4: Act, Repeat, Reverse
Goes over `.`/`u`, `;`/`,` and `n`/`N`. Ways of repeating and reversing.
For substitution the repeat/reverse pair is `&`/`u`. There is also `&x`/`u` for macros, which will be covered later.

More advanced content for `:s/target/replacement`: `&`/`u` and 
`qx{changes}q`: `@x`/`u` is mentioned later in the book.

### Tip 5 *Example*: Find and Replace by Hand
Can't use `:%s/content/copy/g` because the word `content` has two meanings.
Instead `*` to search for word under cursor, make change with `cw`, get to next occurrence with `n` and decide whether to make changes with `.` .
Do this starting on the second line

---

*the_vim_way/1_copy_content.txt*
```
...We're waiting for content before the site can go live...
...If you are content with this, let's go ahead with it...
...We'll launch as soon as we have the content...
```
---


### Tip 6: Meet the Dot Formula
One keystroke (some motion repeater like `n` or `;`) to move, and one keystroke (`.`) to execute.

# Part 1 - Modes

## 2. Normal Mode

### Tip 7: Pause With your Brush Off The Page
A painter doesn't have his brush on the canvas the whole time.  Vim is like that too with normal mode.

### Tip 8: Chunk Your Undos
`u` undoes a change.  A change is an edit done while in insert mode, or an edit using commands in normal or command line mode.  Might want to leave insert mode from time to time to break an edit into multiple changes to give undo more granularity.

### Tip 9 *Example*: Compose Repeatable Changes
The idea here is to choose between (starting on `h`) `dbx`, `bdw`, or `daw`. `daw` wins because it is repeatable with `.`.


---

*normal_mode/the_end.txt*

```
The end is nigh
```
---

### Tip 10 *Example*: Use Counts to Do Simple Arithmetic
`<C-a>` and `<C-x>` respectively increment or decrement numbers, and we can use a count.
It looks for the next occurrence of the number in th buffer.
By default numbers starting with a zero are seen as octal.
To avoid this you might have to include `set nrformats-=octal` in your vimrc. Note that `<C-a>` is a common tmux prefix. If it is a tmux prefix you will have to press `<C-a>` twice.

The instructions here are (starting on the first `.` of the second line) `yyp`, `cW.news<Esc>` to add a new line and change `.blog` to `.news` and then `180<C-x>` to decrement.

---

*normal_mode/sprite.css*
```
.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }
.news { background-position: 0px 0px }
```
---


### Tip 11: Don't Count When You Can Repeat
To delete two words, `dw.` is better than `2dw` or `d2w` because it is more granular. Pressing `.` over and over again can be good too; in case you go too far you can just press `u` once or twice.

But consider `I have a couple of questions` to `I have some more questions`, starting on `a`.  Use `c3w` for a clean change, rather than the dot command twice. The granular change is the right size with this method.

### Tip 12: Combine and Conquer
We have motions followed by operators. Or operators followed by text objects. Duplicating an operator makes it work linewise.


- `c`  is change
- `d`  is delete
- `y`  is yank
- `g~` is swap case
- `gu` is make lowercase; repeat with guu.
- `gU` is make uppercase
- `>`  is indent right
- `<`  is indent left
- `=`  is autoindent
- `!`  filter lines through external program

Be aware of perator pending mode is.

## 3. Insert Mode

### Tip 13: Make Corrections Instantly from Insert Mode
- `<C-h>` works as backspae
- `<C-w>` delete back one word
- `<C-u>` delete back to start of line
These can be used other places like in various terminal emulators.

### Tip 14: Get Back To Normal Mode
Can use `<Esc>` or `<C-[>` to get to normal mode from insert mode.
Can use `<C-o>` to get into *insert-normal mode*, which allows us a single command. For example we could use `<C-o>zz` to quickly center the screen.

### Tip 15 *Example*: Paste from a Register Without Leaving Insert Mode
First it gives advice on remapping the caps-lock key. I've followed the advice of mapping it to *control* and use `<C-[>` in place of escape.

Then the basic idea of this hint is that you can paste from a register with `<C-r>{register}`, but it might not respect autoindentation or textwidth, and inserts as if it's being typed. `<C-r><C-p>{register}` is smarter; it inserts all at once and without some of the problems mentioned but it is difficult to type.

- Start on `P`.
- Editing commands: `yt,`. `jA ` 
- Pasting from the register: `<C-r>0`.

---

*insert_mode/practical_vim.txt*
```
Practial Vim, by Drew Neil
Read Drew Neil's
```
---


### Tip 16 *Example*: Do Back-of-the-Envelope Calculations in Place
The expression register, `=`, evaluates any vimscript code and returns the result, including for arithmetic expressions.

- `A` to get to the end of the line.
- `<C-r>=6*35<CR>` to get into expression register, evaluate and paste.

---

*insert_mode/back-of-envelope.txt*
```
6 chairs, each costing $35, totals $
```
---


I'll add that you can access this register from normal mode as well. For example `"=3*3<CR>p` will insert nine.

### Tip 17: Insert Unusual Character by Character Code
Insert unusual character with `<C-v>{code}`.  Code for uppercase `A` for example is `065`.

Insert longer character code with `<C-v>u{code}`. Uses hexadecimal code.

`ga` will give codes for character under cursor.  Lookup unicode tables for code otherwise. Or can use `:h digraphs-table` to look up.


### Tip 18: Insert Unusual Characters by Digraph
- `<C-k>{char1}{char2}` inserts character by digraph.
- The digraphs can be induitive, for example `12` inserts `½`. `<<` and `>>` insert `«` and `»`. `?I` inserts `¿` (*I*nverted). 
- `:h digraphs-default` describes the conventions.
- `:digraphs` puts out a complete list.
- `:h digraphs-table` is more user-friendly than `:digraphs`

### Tip 19 *Example*: Overwrite Existing Text with Replace Mode

- Start on `T`
- `f.` to get to the period.
- `R, b<Esc>` to ovwerwrite.


---

*insert_mode/replace.txt*
```
Typing in Insert mode extends the line. But in Replace mode
the line length doesn't change.
```

---

- `gR` will treat tab characters as multiple spaces.  There is also `r` and `gr` for single character replacement.

## 4. Visual Mode

### Tip 20: Grok Visual Mode
- Visual mode has a lot of motions like normal mode
- We define area to operate on first, then call the operator.  This is the opposite of normal mode.
- For example `viwc` to change a word.

### Tip 21: Define a Visual Selection
- character-wise (`v`), line-wise (`V`), and block-wise visual modes (`<C-v>`).
- `gv` re-selects the last selection regardless of what mode was used. 
- You can toggle between visual modes while in a particular visual mode; just press one of the commands mentioned. Press the command for the mode you are in, or `<Esc>` to get out.
- `o` switches the end of the visual selection. `O` goes to the other end of the visual selection in blok visual mode.

### Tip 22 *Example*: Repeat Line-Wise Visual Commands

The idea here is to select the line with `print` and the line below, linewise with `V` and then you can indent them once with `>` and then again with `.`. Could use `gv` to reselect but better to use the dot formula.

---

*visual_mode/fibonacci-malformed.py*
```
def fib(n):
    a, b = 0, 1
	    while a < n:
print a,
a, b = b, a+b
fib(42)
```

---



### Tip 23 *Example*: Prefer Operators to Visual Commands Where Possible

The idea here is to make the contents of the tags uppercase.
- `vitU` uppsrcases `one` and `two` but then only the first three letters of three.
- `gUit` would be better because we can then just go `j.j.` to uppercase the next two tabs.

---

*visual_mode/list-of-links.html*
```
<a href="#">one</a>
<a href="#">two</a>
<a href="#">three</a>
```

---

### Tip 24 *Example*: Edit Tabular Data with Visual-Block Mode

- Start in middle of first line
- `<C-v>3j` to select a column. `x...` do delete some columns.
- `gv` to select the column again. `r|` to insert vertical bars.
- `yyp` to duplicate first line. `Vr-` to replace with dashes.

---

*visual_mode/chapter-table.txt*
```
Chapter            Page
Normal mode          15
Insert mode          31
Visual mode          44
```

---

Note that `r` replaces every visually selected character. Works in Block mode too.


### Tip 25 *Example*: Change Columns of Text

With cursor in first `i` of `images`, select text with `<C-v>jje`, `c`, then type a new directory name.  All the text in the selected column will change on each line.

---

*visual_mode/sprite.css*
```
li.one   a{ background-image: url('/images/sprite.png'); }
li.two   a{ background-image: url('/images/sprite.png'); }
li.three a{ background-image: url('/images/sprite.png'); }
```

---

### Tip 26 *Example*: Append after a Ragged Visual Block

Start on `1`. `<C-v>jj$` to select to end of each line. `A;` to append `;`, but could append whatever text we want.

---

*the_vim_way/2_foo_bar.js*
```
var foo = 1
var bar = 'a'
var foobar = foo + bar
```
---
