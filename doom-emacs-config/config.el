;;; .doom.d/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "Input Mono Narrow" :size 12)
      doom-big-font (font-spec :family "Fira Mono" :size 19))

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
