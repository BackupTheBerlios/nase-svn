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
;     Revision 2.2  1997/12/17 15:08:31  saam
;           alte Rev leif nicht
;
;     Revision 2.1  1997/12/17 14:47:06  saam
;             Birth
;             Nur Aufrufkompatibilitaet zu TV & TVSCL
;
;
;-
PRO UTv, Image, XNorm, YNorm, _EXTRA=e

   CASE N_Params() OF
      0: Message, 'incorrect number of arguments'
      1: UTvScl, /NOSCALE, Image, _EXTRA=e
      2: UTvScl, /NOSCALE, Image, XNorm, _EXTRA=e
      3: UTvScl, /NOSCALE, Image, XNorm, YNorm, _EXTRA=e
      ELSE: Message, 'too many arguments'
   END
END


