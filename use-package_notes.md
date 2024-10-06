# Loading Packages

```el

(use-package foo)
(use-package foo
  :defer t)

(use-package foo
  :defer 30)


(setq use-package-always-defer t)


(use-package evil :defer t)
(use-package evil :demand t)

;; checks for graphics system
(use-package foo
  :if (display-graphic-p))
;;:if (eq system-type 'gnu/linux)
;;:if (memq window-system '(ns x))
;;:if (package-installed-p 'foo)
;;:if (locate-library "foo.el")
```
There is also `unless`. `when` is an alias for `if`.


has it outside

```el
(when (memq window-system '(mac ns))
  (use-package foo
    :ensure t))



```


## package order


```el
(use-package hydra)

(use-package ivy)

(use-package ivy-hydra :after (ivy hydra))
```

same here
```el
:after (foo bar)
:after (:all foo bar)
:after (:any foo bar)
```

When using `use-package-always-defer` be careful;  remember to use `:hook`, `:bind` or `:demand`.

## dependencies on features


```el
(use-package abbrev
  :requires foo)

;;This is the same as:

(use-package abbrev
  :if (featurep 'foo))

As a convenience, a list of such packages may be specified:

(use-package abbrev
  :requires (foo bar baz))
```

add directories to load path

```el
(use-package org
  :load-path "site-lisp/org/lisp/"
  :commands org-mode)


(eval-and-compile ;; to tell the byte compiler where to look
  (defun ess-site-load-path ()
    (shell-command-to-string "find ~ -path ess/lisp")))


(use-package ess-site
  :load-path (lambda () (list (ess-site-load-path)))
  :commands R)
```



`autoload` for non interactive, otherwise `commands`

```el
(use-package org-crypt
  :autoload org-crypt-use-before-save-magic)
```

# configuring packages

## use lisp code
`:preface` run first except for `:ensure` and `:disabled`
run both at byte and compile time. Use for necessary function/variable definitions.

`:init` run before package loads.
`:config` is after.

better to use `:preface`, `:config`, and `:init`. Will learn about those. 

## key bindings

```el
(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(use-package hi-lock
  :bind (("M-o l" . highlight-lines-matching-regexp)
         ("M-o r" . highlight-regexp)
         ("M-o w" . highlight-phrase)))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("M-<f5>" . helm-find-files)
         ([f10] . helm-buffers-list) ;; standalone can use bracket
         ([S-f10] . helm-recentf)))
```


### remappin3g

```el
(use-package unfill
  :bind ([remap fill-paragraph] . unfill-toggle)) ;;gets passed
```

Works because the vector gets passed to define-key so its consistent with section 23.14 of the manual.



### how it works

all these are equivalent:

```el
(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))
```

This could be expressed in a much more verbose way with the :commands and :init keywords:

```el
(use-package ace-jump-mode
  :commands ace-jump-mode
  :init
  (bind-key "C-." 'ace-jump-mode))
```

Without using even the :commands keyword, we could also write the above like so:

```el
(use-package ace-jump-mode
  :defer t
  :init
  (autoload 'ace-jump-mode "ace-jump-mode" nil t) ;; last two are doc string and interactive
  (bind-key "C-." 'ace-jump-mode))
```


### binds of package-local maps

```el
(use-package helm
  :bind (:map helm-command-map
         ("C-c h" . helm-execute-persistent-action)))

(use-package term
  :bind (("C-c t" . term)
         :map term-mode-map
         ("M-p" . term-send-up)
         ("M-n" . term-send-down)
         :map term-raw-map
         ("M-o" . other-window)
         ("M-p" . term-send-up)
         ("M-n" . term-send-down)))
```

### prefix map keymaps

kind of like a prefix prefix key:

```
(use-package foo
  :bind-keymap ("C-c p" . foo-command-map))
```

### Binding of Repeat Maps


```el
(use-package git-gutter+
  :bind
  (:repeat-map my/git-gutter+-repeat-map
   ("n" . git-gutter+-next-hunk)
   ("p" . git-gutter+-previous-hunk)
   ("s" . git-gutter+-stage-hunks)
   ("r" . git-gutter+-revert-hunk)
   :exit       ;; can use from within repeat but then exits repeat
   ("c" . magit-commit-create)
   ("C" . magit-commit)
   ("b" . magit-blame)))
```


equivalent to:

```el
(use-package git-gutter+
  :bind
  (:repeat-map my/git-gutter+-repeat-map
   :exit
   ("c" . magit-commit-create)
   ("C" . magit-commit)
   ("b" . magit-blame)
   :continue
   ("n" . git-gutter+-next-hunk)
   ("p" . git-gutter+-previous-hunk)
   ("s" . git-gutter+-stage-hunks)
   ("r" . git-gutter+-revert-hunk)))
```

### see personal keybindings

`M-x describe-personal-keybindings` shows info about all this.


## hooks



These are equivalent:

```el
(use-package company
  :commands company-mode
  :init
  (add-hook 'prog-mode-hook #'company-mode))
```

Using :hook, this can be simplified to:

```el
(use-package company
  :hook (prog-mode . company-mode)
```

which is further simplified to:

```el
(use-package company
  :hook prog-mode)
```


all these are the same:

```el
(use-package company
  :hook (prog-mode text-mode))


(use-package company
  :hook ((prog-mode text-mode) . company-mode))


(use-package company
  :hook ((prog-mode . company-mode)
         (text-mode . company-mode)))


(use-package company
  :commands company-mode
  :init
  (add-hook 'prog-mode-hook #'company-mode)
  (add-hook 'text-mode-hook #'company-mode))
```


## modes and interpreters


```el
(use-package ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby")
```


```el
;; funny naming business;; The package is "python" but the mode is "python-mode":
;; so we have to use a cons cell
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))
```

Interpreter is for what comes after `#!`.


Can use regex.

```el
(use-package foo
  ;; Equivalent to "\\(ba[rz]\\)\\'":
  :mode ("\\.bar\\'" "\\.baz\\'")
  ;; Equivalent to "\\(foo[ab]\\)":
  :interpreter ("fooa" "foob"))
```

## magic handlers

`magic-mode-alist` is based on the text at the beginning of a file.
`magic-fallback-mode-alist` runs only if `auto-mode-alist` doesn't have anything for the current file. Remember `auto-mode-alist` is usually for fie suffixes.

```el
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query)) ;;happens after the package is loaded
```

# user options

```el
(use-package comint
  :defer t
  :custom
  (comint-buffer-maximum-size 20000 "Increase comint buffer size.")
  (comint-prompt-read-only t "Make the prompt read only."))
```


Better than using `setq`  in `:config` because `custom` might trigger some other emacs code.
`setopt` macro in emacs 29 also works. Different than `customize-set-variable` because you don't have to quote.

## faces

```el
(use-package eruby-mode
  :custom-face
  (eruby-standard-face ((t (:slant italic)))))


(use-package example
  :custom-face
  (example-1-face ((t (:foreground "LightPink"))))
  (example-2-face ((t (:foreground "LightGreen"))) face-defspec-spec))


(use-package zenburn-theme
  :preface
  (setq my/zenburn-colors-alist
        '((fg . "#DCDCCC") (bg . "#1C1C1C") (cyan . "#93E0E3")))
  :custom-face
  (region ((t (:background ,(alist-get my/zenburn-colors-alist 'cyan)))))
  :config
  (load-theme 'zenburn t))
```

## diminish/delight

hide minor modes, cn lokk at later


# Installing Packages Automatically

## Installing Package

```el
(use package magit
    :ensure t)
```

ensure another package:

```el
(use package tex
    :ensure auctex)
```

Make it global:

```el
(require 'use-package-ensure)
(setq use-package-always-ensure t)
```

## Pinning packages


```el
(use-package company
  :ensure t
  :pin gnu)  ; Installs from GNU ELPA
```


Makes you have to install it manually:

```el
(use-package org
  :ensure t
  :pin manual)  ; Ignores updates from upstream, uses manual version
```



```el
(setq use-package-always-pin "nongnu")
(setopt use-package-always-pin "nongnu")
(customize-set-variable 'use-package-always-pin "nongnu")
```

# Byte Compiling


Says it's not recommended so I won't.

# Troubleshooting

emacs `--debug-init`

and include this in config:

```el
(when init-file-debug
  (setq use-package-verbose t
        use-package-expand-minimally nil
        use-package-compute-statistics t
        debug-on-error t))
```

 > M-x pp-macroexpand-last-sexp, or wrap the use-package declaration in macroexpand

## helpful options

see the `catch` keyword

## gathering statistics
`use-package-verbose`

customize the user option `use-package-compute-statistics` to a non-`nil` value.  Do this after loading `use-package` but before calling `use-package`.

`M-x use-package-report` to see output

`M-x use-package-reset-statistics`

## disabling

`:disabled` keyword. like commenting out.

# appendix: keyword extensions

## use-package-ensure-system-package
`(use-package use-package-ensure-system-package)` immediately after loading `use-package`
On macos if gui emacs can't find an executable: [exec-path-from-shell](https://github.com/purcell/exec-path-from-shell)

will also need:

```el
(use-package system-packages
  :ensure t)
```

```el
(use-package foo
  :ensure-system-package foo)
```

will expect a binary package on the system, `foo` and if not found it will use the elpa package `system-packages` to try to try to install it.


if command has different name than the package:

```el
(use-package foo
  :ensure-system-package
  (foocmd . foo))
```
Uses `executable-find`, which I can use myself

can use an explicit command:

```el
(use-package tern
  :ensure-system-package (tern . "npm i -g tern"))
```

can take multiple keywords
```el
(use-package ruby-mode
  :ensure-system-package
  ((rubocop     . "gem install rubocop")
   (ruby-lint   . "gem install ruby-lint")
   (ripper-tags . "gem install ripper-tags")
   (pry         . "gem install pry")))
```
if not globally executable:

```el
(use-package dash-at-point
  :if (eq system-type 'darwin)
  :ensure-system-package
  ("/Applications/Dash.app" . "brew cask install dash"))
```

Uses `system-packages-install` from `system-packages`, or `async-shell-command` for custom commands.
 `system-packages-package-manager` and `system-packages-use-sudo` options are respected, but not for custom commands.

## making my own keyword

Manual is difficult, will require re-visitation after more learning.

