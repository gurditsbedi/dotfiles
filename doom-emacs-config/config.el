;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Gurdit"
      user-mail-address "gurditsbedi@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 14))
(setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "Input Mono Narrow" :size 12)
      doom-big-font (font-spec :family "Fira Mono" :size 19))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(require 'dom)
(defun so-answer-pastew ()
  "Takes the stackoverflow.com url from clipboard and inserts question and 1st answer in the buffer."
  (interactive)
  (with-current-buffer
    (url-retrieve-synchronously (current-kill 0 t))
    (setq parseddom (libxml-parse-html-region (point-min) (point-max)))
  )
  (insert
    (concat
      (string-trim (dom-texts (car (dom-by-class parseddom "question-hyperlink"))))
      (format "\n[[%s][SO answer: ]]\n" (current-kill 0 t))
      (string-trim (dom-texts (nth 1 (dom-by-class parseddom "post-text"))))
    )
  )
)

(map! :mode org-mode
      :n "SPC m x" 'org-latex-preview)

(setq langtool-language-tool-jar "/opt/languagetool/languagetool-commandline.jar")
