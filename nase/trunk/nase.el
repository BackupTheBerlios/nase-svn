
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
;; --templates--
(defun idlwave-nase-doclink ()
  (interactive)
  (idlwave-template
   (idlwave-rw-case "<A>")
   (idlwave-rw-case "</A>")
   "type routine name"))

(defun idlwave-nase-commandref ()
  (interactive)
  (idlwave-template
   (idlwave-rw-case "<C>")
   (idlwave-rw-case "</C>")
   "type routine name"))

(defun idlwave-nase-typewriterface ()
  (interactive)
  (idlwave-template
   (idlwave-rw-case "<*>")
   (idlwave-rw-case "</*>")
   "insert typewriter text"))

(defun idlwave-nase-commonrandom ()
  (interactive)
  (idlwave-template
   (idlwave-rw-case "common commonrandom, seed\n")
   (idlwave-rw-case "")
   "common block inserted"))

(defun idlwave-nase-commentedblock ()
  (interactive)
  (idlwave-template
   (idlwave-rw-case ";;-- ")
   (idlwave-rw-case " --\n;;-- End:  --")
   "type description"))
;; --End: templates--
;; --End: define NASE-specific functions--


	
;; --define nase hook--  
(defun install-nase ()

  (message "Installing NASE idlwave extention...")
  
  ;; --add key bindings--
  ;; document header is bound to \C-c\C-h by default. We want to
  ;; change this, hence undefine it first
  (local-unset-key "\C-c\C-h")
  ;; now (re)define bindings:
  (local-set-key "\C-nh" 'idlwave-doc-header)
  (local-set-key "\C-nl" 'idlwave-nase-doclink)
  (local-set-key "\C-nc" 'idlwave-nase-commandref)
  (local-set-key "\C-nt" 'idlwave-nase-typewriterface)
  (local-set-key "\C-nr" 'idlwave-nase-commonrandom)
  (local-set-key "\C-n;" 'idlwave-nase-commentedblock)
  ;; --End: add key bindings--
  
  ;; --Add Menus - using easymenu.el--
  (defvar idlwave-mode-nase-menu-def
    '("NASE"
      ["Doc Header" idlwave-doc-header t]
      ["Documentation Link" idlwave-nase-doclink t]
      ["Command Reference" idlwave-nase-commandref t]
      ["Typewriter Face" idlwave-nase-typewriterface t]
      "--"
      ["Insert commonrandom" idlwave-nase-commonrandom t]
      ["Commented Block" idlwave-nase-commentedblock t]
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


  (message "NASE idlwave extention ($Revision$).")

  )

;; -- add nase hook to the idlwave hooklist--
(add-hook 'idlwave-mode-hook 'install-nase)
;; -- end add nase hook to the idlwave hooklist--



;; --End: define nase hook--
 
