;+
; NAME:               UTv
;
; PURPOSE:            Ersetzt die IDL-Routine TV. Bis auf die Skalierung 
;                     gleiche Funktionalitaet wie <A HREF="#UTVSCL#">UTvScl</A>.
;
; PROCEDURE:          Aufruf von UTvScl mit Schluesselwort /NOSCALE
;
; SEE ALSO:           <A HREF="#UTVSCL">UTvScl</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/12/17 14:47:06  saam
;             Birth
;             Nur Aufrufkompatibilitaet zu TV & TVSCL
;
;
;-
PRO UTv, _EXTRA=e

   UTvScl, /NOSCALE, _EXTRA=e
   
END


