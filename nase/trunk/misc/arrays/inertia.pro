;+
; NAME:              Inertia
;
; PURPOSE:           Liefert das Traegheitsmoment einer zweidimensionalen
;                    (Massen-)Verteilung relativ zu einem gegebenen Punkt oder
;                    ihrem Schwerpunkt.
;
; CATEGORY:          MISC, ARRAYS
;
; CALLING SEQUENCE:  I = Inertia (A [,origin] [,COM=com])
;
; INPUTS:            A  : ein zweidimensionales Array, das die Masseverteilung
;                          (oder was auch immer) in aequidistanten (distanz=1)
;                          parallelen Flaechenstuecken enthaelt.
;
; OPTIONAL INPUTS:   origin: Ursprung, bezüglich dessen das Trägheitsmoment
;                            berechnet werden soll. 
;                            Ein zweidimensionales Array, das vom Typ Integer
;                            sein sollte. (Nachkommastellen werden
;                            abgeschnitten.)
;                            Default: Scherpunkt der Verteilung.
;
; OUTPUTS:           I  : das resultierende Traegheitsmoment
;
; OPTIONAL OUTPUTS:  COM: Sofern origin nicht spezifiziert wurde, wird hier der
;                         Schwerpunkt der Verteilung, bezüglich dessen das
;                         Trägheitsmoment berechnet wurde, zurückgegeben.
;                         Zweidimensionales Array.
;
; RESTRICTIONS:      hat aber nicht mehr die Aussage eines Masseschwerpunktes, wenn das Array
;                    negative Wrte enthält... (Stichwort: Ladungsschwerpunkt) 
;
; PROCEDURE:         nach Definition, benutzt Schwerpunkt
;
; EXAMPLE:           print, Inertia(Gauss_2D(21,21),COM=com)
;                    --> 19.244749 
;                    print, com
;                    -->  9.9999946       9.9999946
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.5  2000/03/22 16:11:11  kupper
;        Added origin parameter.
;
;        Revision 1.4  2000/03/22 15:52:36  kupper
;        Using eq instead of equal() for checking if total sum is zero.
;        equal tended to produce floating illeqal operands when using the Floor()
;        function.
;        I think eq will do fine here.
;
;        Revision 1.3  2000/03/22 14:57:39  kupper
;        Oops, put in a little error...
;        fixed.
;
;        Revision 1.2  2000/03/22 14:52:52  kupper
;        Changed to use new Distance() function.
;        The old code was wrong! Inertia() will have produced invalid results!
;
;        Revision 1.1  1999/12/02 18:03:43  saam
;              SIC!
;
;
;-
FUNCTION Inertia, A, in_com, COM=com

   s = SIZE(A)
   dims = s(0)
   w = s(2)
   h = s(1)

   tA = total(A)
   
   IF dims NE 2 THEN Message, 'only for 2-d array at the moment, sorry!'
   r = FLTARR(dims)

   If n_params() eq 2 then $
    com = round(in_com) else $
    com = round(Schwerpunkt(A))
   
   IF com(0) NE !NONE THEN BEGIN
      IF (tA eq 0.0) THEN $
       return, 0.0 ELSE $
       return, total( A * Distance(h, w, com(0), com(1))^2 ) / tA
   END ELSE RETURN, !NONE

END
