;+
; NAME: asso_fileopen
;
; AIM: Module of assoziativ.pro (see also  <A>faceit</A>)
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;-
;
;     $Log$
;     Revision 1.3  2000/09/28 11:49:38  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 12:14:06  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:41  alshaikh
;           initial version
;
;
;
PRO asso_FILEOPEN, dataptr, displayptr, group

  ; falls irgendwas schiefgeht :
   ON_IOERROR, skip

   filename = DIALOG_PICKFILE(/READ, FILTER='*.dat', $
      TITLE='Laden einer Einstellung', $
      GROUP=group, /MUST_EXIST)

; wiederherstellung der gespeicherten daten :
   Restore, filename 

; diese daten werden in die datenstruktur eingefuegt :  

   (*dataptr).kinhib = save_koppl_inhib    ; verbindungsstaerken
   (*dataptr).kfeed = save_koppl_feed;

   FreeDW, (*dataptr).con_asso_asso_feed   ; verbindungsmatritzen free-en 
   FreeDW, (*dataptr).con_asso_asso_inhib
  
   Handle_Value, (*dataptr).l2, layer, /NO_COPY  ; neuron-parameter setzen
   layer.para.ds = Exp(-1./save_taus)
   layer.para.vs = save_vs
   layer.para.th0 = save_th0
   Handle_Value, (*dataptr).l2, layer, /NO_COPY, /SET
   (*dataptr).prepara2.taus = save_taus
   (*dataptr).prepara2.vs = save_vs
   (*dataptr).prepara2.th0 = save_th0
   (*dataptr).pattern_number =  save_pattern_number   ; welches muster soll praesentiert werden?
;  ;;;


   (*dataptr).con_asso_asso_feed = RestoreDW(save_con_asso_asso_feed) ; verbindungen ersetzen
   (*dataptr).con_asso_asso_inhib = RestoreDW(save_con_asso_asso_inhib)
   
   
   asso_ResetSliders, dataptr, displayptr ; bildschirm aktualisieren


   Message, /INFO, 'Wiederherstellung der Daten aus der Datei '+filename
   GOTO, done
   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR
   done: 
END
