;+
; NAME:               TvScl
;
; PURPOSE:            Ersetzt die IDL-Routine TV. Bis auf die Skalierung 
;                     gleiche Funktionalitaet wie <A HREF="#UTVSCL#">UTvScl</A>.
;
; PROCEDURE:          Aufruf von UTvScl mit Schluesselwort /NOSCALE
;
; SEE ALSO:           <A HREF="#UTVSCL#">UTvScl</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/12/17 14:38:01  saam
;           Eigentlich nur zur Symmetrie & Klarheit erstellt...
;           in Analogie zum Paar TvScl & Tv
;
;
;-
PRO TvScl, _EXTRA=e

   UTvScl, /NOSCALE, _EXTRA=e
   
END


