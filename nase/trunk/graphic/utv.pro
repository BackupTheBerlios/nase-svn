;+
; NAME:               UTv
;
; AIM:
;  Device independent, color coded display of two-dimensional array
;  contents.
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
;     Revision 2.5  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.4  1999/06/07 14:29:46  kupper
;     CUBIC, INTERP, MINUS_ONE are now passed explecitely.
;     My IDL crashed, if passed through _EXTRA. Don't know, why, but works...
;
;     Revision 2.3  1997/12/17 15:28:57  saam
;           Ergaenzung um optionalen Output Dimension
;
;     Revision 2.2  1997/12/17 15:08:31  saam
;           alte Rev leif nicht
;
;     Revision 2.1  1997/12/17 14:47:06  saam
;             Birth
;             Nur Aufrufkompatibilitaet zu TV & TVSCL
;
;
;-
PRO UTv, Image, XNorm, YNorm, Dimension, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, _EXTRA=e
;Don't ask me why CUBIC,INTERP,MINUS_ONE have to be passed
;explicitely. My IDL crashes, if not! (Segmentation Fault)...
; Rüdiger
   CASE N_Params() OF
      0: Message, 'incorrect number of arguments'
      1: UTvScl, /NOSCALE, Image, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, _EXTRA=e
      2: UTvScl, /NOSCALE, Image, XNorm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, _EXTRA=e
      3: UTvScl, /NOSCALE, Image, XNorm, YNorm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, _EXTRA=e
      4: UTvScl, /NOSCALE, Image, XNorm, YNorm, Dimension, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, _EXTRA=e
      ELSE: Message, 'too many arguments'
   END
END
