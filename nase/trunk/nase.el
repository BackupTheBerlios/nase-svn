
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
;; --end templates--
;; --end define NASE-specific functions--


	
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
  ;; --end add key bindings--
  
  ;; --Add Menus - using easymenu.el--
  (defvar idlwave-mode-nase-menu-def
    '("NASE"
      ["Doc Header" idlwave-doc-header t]
      ["Documentation Link" idlwave-nase-doclink t]
      ["Command Reference" idlwave-nase-commandref t]
      ["Typewriter Face" idlwave-nase-typewriterface t]
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
  ;; --end Add Menus--


  ;; --set location of the document header template--
  (setq headerfile (concat (getenv "NASEPATH") "/header.pro") )
  (setq idlwave-file-header (list headerfile "") )
  ;; --end set location of the document header template--


  (message "NASE idlwave extention $version$")

  )

;; -- add nase hook to the idlwave hooklist--
(add-hook 'idlwave-mode-hook 'install-nase)
;; -- end add nase hook to the idlwave hooklist--



;; --end define nase hook--
 
