;(setq comment-start-skip ";+\\*?[ \t]*")



;(defun idlwave-nase-fill-paragraph (&optional nohang)
;  "Fills paragraphs in comments.
;A paragraph is made up of all contiguous lines having the same comment
;leader (the leading whitespace before the comment delimiter and the
;comment delimiter).  In addition, paragraphs are separated by blank
;line comments. The indentation is given by the hanging indent of the
;first line, otherwise by the minimum indentation of the lines after
;the first line. The indentation of the first line does not change.
;Does not effect code lines. Does not fill comments on the same line
;with code.  The hanging indent is given by the end of the first match
;matching `idlwave-hang-indent-regexp' on the paragraph's first line . If the
;optional argument NOHANG is non-nil then the hanging indent is
;ignored."
;  (interactive "P")
;  ;; check if this is a line comment
;  (if (save-excursion
;        (beginning-of-line)
;        (skip-chars-forward " \t")
;        (looking-at comment-start))
;      (let
;          ((indent 999)
;           pre here diff fill-prefix-reg bcl first-indent
;           hang start end)
;        ;; Change tabs to spaces in the surrounding paragraph.
;        ;; The surrounding paragraph will be the largest containing block of
;        ;; contiguous line comments. Thus, we may be changing tabs in
;        ;; a much larger area than is needed, but this is the easiest
;        ;; brute force way to do it.
;        ;;
;        ;; This has the undesirable side effect of replacing the tabs
;        ;; permanently without the user's request or knowledge.
;        (save-excursion
;          (backward-paragraph)
;          (setq start (point)))
;        (save-excursion
;          (forward-paragraph)
;          (setq end (point)))
;        (untabify start end)
;        ;;
;        (setq here (point))
;        (beginning-of-line)
;        (setq bcl (point))
;        (re-search-forward
;         (concat "^[ \t]*" comment-start "+")
;         (save-excursion (end-of-line) (point))
;         t)
;        ;; Get the comment leader on the line and its length
;        (setq pre (current-column))
;        ;; the comment leader is the indentation plus exactly the
;        ;; number of consecutive ";".
;        (setq fill-prefix-reg
;              (concat
;               (setq fill-prefix
;                     (regexp-quote
;                      (buffer-substring (save-excursion
;                                          (beginning-of-line) (point))
;                                        (point))))
;               "[^;]"))
	
;        ;; Mark the beginning and end of the paragraph
;        (goto-char bcl)
;        (while (and (looking-at fill-prefix-reg)
;                    (not (looking-at paragraph-separate))
;                    (not (bobp)))
;          (forward-line -1))
;        ;; Move to first line of paragraph
;        (if (/= (point) bcl)
;            (forward-line 1))
;        (setq start (point))
;        (goto-char bcl)
;        (while (and (looking-at fill-prefix-reg)
;                    (not (looking-at paragraph-separate))
;                    (not (eobp)))
;          (forward-line 1))
;        (beginning-of-line)
;        (if (or (not (looking-at fill-prefix-reg))
;                (looking-at paragraph-separate))
;            (forward-line -1))
;        (end-of-line)
;        ;; if at end of buffer add a newline (need this because
;        ;; fill-region needs END to be at the beginning of line after
;        ;; the paragraph or it will add a line).
;        (if (eobp)
;            (progn (insert ?\n) (backward-char 1)))
;        ;; Set END to the beginning of line after the paragraph
;        ;; END is calculated as distance from end of buffer
;        (setq end (- (point-max) (point) 1))
;        ;;
;        ;; Calculate the indentation for the paragraph.
;        ;;
;        ;; In the following while statements, after one iteration
;        ;; point will be at the beginning of a line in which case
;        ;; the while will not be executed for the
;        ;; the first paragraph line and thus will not affect the
;        ;; indentation.
;        ;;
;        ;; First check to see if indentation is based on hanging indent.
;        (if (and (not nohang) idlwave-hanging-indent
;                 (setq hang
;                       (save-excursion
;                         (goto-char start)
;                         (idlwave-calc-hanging-indent))))
;            ;; Adjust lines of paragraph by inserting spaces so that
;            ;; each line's indent is at least as great as the hanging
;            ;; indent. This is needed for fill-paragraph to work with
;            ;; a fill-prefix.
;            (progn
;              (setq indent hang)
;              (beginning-of-line)
;              (while (> (point) start)
;                (re-search-forward comment-start-skip
;                                   (save-excursion (end-of-line) (point))
;                                   t)
;                (if (> (setq diff (- indent (current-column))) 0)
;                    (progn
;                      (if (>= here (point))
;                          ;; adjust the original location for the
;                          ;; inserted text.
;                          (setq here (+ here diff)))
;                      (insert (make-string diff ? ))))
;                (forward-line -1))
;              )
	  
;          ;; No hang. Instead find minimum indentation of paragraph
;          ;; after first line.
;          ;; For the following while statement, since START is at the
;          ;; beginning of line and END is at the the end of line
;          ;; point is greater than START at least once (which would
;          ;; be the case for a single line paragraph).
;          (while (> (point) start)
;            (beginning-of-line)
;            (setq indent
;                  (min indent
;                       (progn
;                         (re-search-forward
;                          comment-start-skip
;                          (save-excursion (end-of-line) (point))
;                          t)
;                         (current-column))))
;            (forward-line -1))
;          )
;        (setq fill-prefix (concat fill-prefix
;                                  (make-string (- indent pre)
;                                               ? )))
;        ;; first-line indent
;        (setq first-indent
;              (max
;               (progn
;                 (re-search-forward
;                  comment-start-skip
;                  (save-excursion (end-of-line) (point))
;                  t)
;                 (current-column))
;               indent))
	
;        ;; try to keep point at its original place
;        (goto-char here)

;        ;; In place of the more modern fill-region-as-paragraph, a hack
;        ;; to keep whitespace untouched on the first line within the
;        ;; indent length and to preserve any indent on the first line
;        ;; (first indent).
;        (save-excursion
;          (setq diff
;                (buffer-substring start (+ start first-indent -1)))
;          (subst-char-in-region start (+ start first-indent -1) ?  ?~ nil)
;          (fill-region-as-paragraph
;           start
;           (- (point-max) end)
;           (current-justification)
;           nil)
;          (delete-region start (+ start first-indent -1))
;          (goto-char start)
;          (insert diff))
;        ;; When we want the point at the beginning of the comment
;        ;; body fill-region will put it at the beginning of the line.
;        (if (bolp) (skip-chars-forward (concat " \t" comment-start "\\*?")))
;        (setq fill-prefix nil))))






;; --tell XEmacs to use idlwave-mode for *.pro files--
;; -- this is probably already done in the user's .emacs file,
;; -- but it won't hurt if it is two times in the list.
(autoload 'idlwave-mode "idlwave" "IDLWAVE Mode" t)
(autoload 'idlwave-shell "idlw-shell" "IDLWAVE Shell" t)
(setq auto-mode-alist (cons '("\\.pro\\'" . idlwave-mode) auto-mode-alist))
;; --End: tell XEmacs to use idlwave-mode for *.pro files--

;; --tell idlwave mode to use font lock--
(add-hook 'idlwave-mode-hook 'turn-on-font-lock)
;; --End: tell idlwave mode to use font lock--



;; --define NASE-specific functions--

;; --function for making templates--

;; Statement templates. This is taken from the idlwave.el file,
;; with small modifications (no case changes are done, and no
;; new line is opened).
;; A comment in the idlwave.el file said:
;;   "Replace these with a general template function, something like
;;    expand.el (I think there was also something with a name similar to
;;    dmacro.el)"



(defun idlwave-nase-template (s1 s2 &optional prompt noindent)
  "Build a template with optional prompt expression.

This is the NASE version of the idlwave-template function. It differs
only in that no case changes are done, and no new line is opened.

S1 and S2 are strings.  S1 is inserted at point followed
by S2.  Point is inserted between S1 and S2. If optional argument
PROMPT is a string then it is displayed as a message in the
minibuffer.  The PROMPT serves as a reminder to the user of an
expression to enter.

The lines containing S1 and S2 are reindented using `indent-region'
unless the optional second argument NOINDENT is non-nil."
;   (cond ((eq idlwave-abbrev-change-case 'down)
;	 (setq s1 (downcase s1) s2 (downcase s2)))
;	(idlwave-abbrev-change-case
;	 (setq s1 (upcase s1) s2 (upcase s2))))
  (let ((beg (save-excursion (beginning-of-line) (point)))
        end)
    ;(if (not (looking-at "\\s-*\n"))
    ;    (open-line 1))

    (if (not (region-active-p))
        ;;then (one expression only!)
        (insert s1)
      ;;else (n expressions)
      (save-excursion
        (goto-char (region-beginning))
        (insert s1)
        )
      )

    (save-excursion
      (insert s2)
      (setq end (point)))
    (if (not noindent)
        (indent-region beg end nil))
    (if (stringp prompt)
        (message prompt))))

;--End: function for making templates--


;; --templates--
(defun idlwave-nase-doclink ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<A>")
   (idlwave-rw-case "</A>")
   "type routine name" t))

(defun idlwave-nase-complexdoclink ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<A NREF=")
   (idlwave-rw-case "></A>")
   "type routine name, then insert text" t))

(defun idlwave-nase-commandref ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<C>")
   (idlwave-rw-case "</C>")
   "type routine name" t))

(defun idlwave-nase-typewriterface ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<*>")
   (idlwave-rw-case "</*>")
   "insert typewriter text" t))

(defun idlwave-nase-boldface ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<B>")
   (idlwave-rw-case "</B>")
   "insert bold text" t))

(defun idlwave-nase-italicface ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<I>")
   (idlwave-rw-case "</I>")
   "insert bold text" t))

(defun idlwave-nase-superscriptface ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<SUP>")
   (idlwave-rw-case "</SUP>")
   "insert superscript text" t))

(defun idlwave-nase-subscriptface ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<SUB>")
   (idlwave-rw-case "</SUB>")
   "insert subscript text" t))

(defun idlwave-nase-commonrandom ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "Common Common_Random, seed\n")
   (idlwave-rw-case "")
   "common block inserted" t))

(defun idlwave-nase-commentedblock ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case ";;-- ")
   (idlwave-rw-case " --\n;;-- End:  --")
   "type description" t))

(defun idlwave-nase-linebreak ()
  (interactive)
  (idlwave-nase-template
   (idlwave-rw-case "<BR>\n")
   (idlwave-rw-case (concat comment-start " "))
   "linebreak inserted" t))
;; --End: templates--


;; --End: define NASE-specific functions--


	
;; --define nase hook--  
(defun install-nase ()
  (interactive)
  (message "Installing NASE idlwave extention...")
  
  ;; --add key bindings--
  ;; document header is bound to "\C-c\C-h" by default. We want to
  ;; change this, hence undefine it first.
  ;; "\C-c\C-h" is the old notation, and it has two meanings, which are
  ;; both bound in the keymap. We have to release both.
  (local-unset-key [(control c) (backspace)])
  (local-unset-key [(control c) (control h)])
  ;; now (re)define bindings:
  (local-set-key [(control n) (h)] 'idlwave-doc-header)
  (local-set-key [(control n) (l)] 'idlwave-nase-doclink)
  (local-set-key [(control n) (control l)] 'idlwave-nase-complexdoclink)
  (local-set-key [(control n) (c)] 'idlwave-nase-commandref)
  (local-set-key [(control n) (t)] 'idlwave-nase-typewriterface)
  (local-set-key [(control n) (b)] 'idlwave-nase-boldface)
  (local-set-key [(control n) (i)] 'idlwave-nase-italicface)
  (local-set-key [(control n) (up)] 'idlwave-nase-superscriptface)
  (local-set-key [(control n) (down)] 'idlwave-nase-subscriptface)
  (local-set-key [(control n) (return)] 'idlwave-nase-linebreak)
  (local-set-key [(control n) (r)] 'idlwave-nase-commonrandom)
  (local-set-key [(control n) (\;)] 'idlwave-nase-commentedblock)
;  (local-set-key "\C-nf" 'idlwave-fill-paragraph)
  ;; --End: add key bindings--
  
  ;; --Add Menus - using easymenu.el--
  (defvar idlwave-mode-nase-menu-def
    '("NASE"
      ["Doc Header" idlwave-doc-header t]
      ["Documentation Link (simple)" idlwave-nase-doclink t]
      ["Documentation Link (complex)" idlwave-nase-complexdoclink t]
      ["Command Reference" idlwave-nase-commandref t]
      "--"
      ["Typewriter Face" idlwave-nase-typewriterface t]
      ["Bold Face" idlwave-nase-boldface t]
      ["Italic Face" idlwave-nase-italicface t]
      ["Superscript" idlwave-nase-superscriptface t]
      ["Subscript" idlwave-nase-subscriptface t]
      "--"
      ["Linebreak" idlwave-nase-linebreak t]
      "--"
      ["fill paragraph" idlwave-fill-paragraph t]
      "--"
      ["Insert Common_Random" idlwave-nase-commonrandom t]
      ["Commented Block" idlwave-nase-commentedblock t]
      "--"
      ["CVS annotate this buffer" vc-annotate t]
      )
    )
  
  (if (or (featurep 'easymenu) (load "easymenu" t))
      (progn
        (easy-menu-define idlwave-mode-nase-menu idlwave-mode-map 
                          "IDL NASE editing menu" 
                          idlwave-mode-nase-menu-def)
        )
    )
  
  (when (featurep 'easymenu)
    (easy-menu-add idlwave-mode-nase-menu idlwave-mode-map)
    )
  ;; --End: Add Menus--


  ;; --set location of the document header template--
  (setq headerfile (concat (getenv "NASEPATH") "/header.pro") )
  (setq idlwave-file-header (list headerfile "") )
  ;; --End: set location of the document header template--

  ;; --relax idl prompt matching--
  (setq idlwave-shell-prompt-pattern "^ ?\\(IDL\\|NASE\\|IDL/NASE\\)> ")
  ;; this allows for anything, followed by "> ".
  ;; --End: relax idl prompt matching--


  ;; ---- speedbar support functions: ----

  ;; The following function is an exact copy of "idlwave-find-key" from
  ;; idlwave.el 4.5. The only difference is that it will also search
  ;; inside comments (using "idlwave-in-quote" instead of "idlwave-quoted".
  (defun idlwave-nase-find-key (key-re &optional dir nomark limit)
    "Move to next match of the regular expression KEY-RE.
Matches inside string constants will be ignored. Matches inside
comments will be found.
If DIR is negative, the search will be backwards.
At a successful match, the mark is pushed unless NOMARK is non-nil.
Searches are limited to LIMIT.
Searches are case-insensitive and use a special syntax table which
treats `$' and `_' as word characters.
Return value is the beginning of the match or (in case of failure) nil."
    (message "idlwave-nase-find-key")
    (setq dir (or dir 0))
    (let ((case-fold-search t)
          (search-func (if (> dir 0) 're-search-forward 're-search-backward))
          found)
      (idlwave-with-special-syntax
       (save-excursion
         (catch 'exit
           (while (funcall search-func key-re limit t)
             (if (not (idlwave-in-quote))
                 (throw 'exit (setq found (match-beginning 0))))))))
      (if found
          (progn
            (if (not nomark) (push-mark))
            (goto-char found)
            found)
        nil)))


  ;; overwrite "idlwave-prev-index-position". This works exactly like
  ;; idlwave version 4.5, but uses "idlwave-nase-find-key" and searches
  ;; for NASEMARKs.
  (defun idlwave-prev-index-position ()
    "Search for the previous procedure, function or NASE mark.
Return nil if not found.  For use with imenu.el and nase.el"
    (message "idlwave-prev-index-position")
    (save-match-data
      (cond
       ((idlwave-nase-find-key "\\(\\<\\(^pro\\|^function\\|nasemark\\)\\>\\)" -1 'nomark))
       ;;   ((idlwave-find-key idlwave-begin-unit-reg 1 'nomark)
       (t nil))))

  ;; End: ---- speedbar support functions ----

  (message "NASE idlwave extention ($Revision$).")

  )


;; -- add nase hook to the idlwave hooklist--
(add-hook 'idlwave-mode-hook 'install-nase)
;; -- end add nase hook to the idlwave hooklist--



;; --End: define nase hook--
