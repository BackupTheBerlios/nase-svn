;+
; NAME: asso_filesave
;
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:37:42  alshaikh
;           initial version
;
;
;-
PRO asso_FILESAVE, dataptr, group

   ; wenn etwas schiefgeht, zu skip springen
   ON_IOERROR, skip


   filename = DIALOG_PICKFILE(/WRITE, FILTER='*.dat', $
      TITLE='Speichern einer Einstellung', GROUP=group)

   ; Do nothing if the filename is empty because user pressed CANCEL-button.
   ; Else convert data if necessary and call IDL-save-routine:
   IF filename NE '' THEN BEGIN

      save_koppl_inhib = (*dataptr).kinhib
      save_koppl_feed = (*dataptr).kfeed
      save_taus =  (*dataptr).prepara2.taus
      save_vs =  (*dataptr).prepara2.vs
      save_th0 =  (*dataptr).prepara2.th0
      save_pattern_number =  (*dataptr).pattern_number
     
      save_con_asso_asso_feed = SaveDW((*dataptr).con_asso_asso_feed)
      save_con_asso_asso_inhib = SaveDW((*dataptr).con_asso_asso_inhib)

      Save, FILENAME=filename, $
       save_koppl_inhib, $
       save_koppl_feed, $
       save_con_asso_asso_feed, $
       save_con_asso_asso_inhib, $
       save_taus, save_vs, save_th0, $
       save_pattern_number 
        

      Message, /INFO, 'Speichern der Einstellung in der Datei '+filename
   ENDIF ELSE $
      Message, /INFO, 'NICHTS GESPEICHERT.' 
    
   GOTO, done

   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR
         Message, /INFO, 'NICHTS GESPEICHERT.' 

   done: 


END
