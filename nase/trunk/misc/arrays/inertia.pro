;+
; NAME:              Inertia
;
; PURPOSE:           Liefert das Traegheitsmoment einer zweidimensionalen
;                    (Massen-)Verteilung relativ zu ihrem Schwerpunkt.
;
; CATEGORY:          MISC, ARRAYS
;
; CALLING SEQUENCE:  I = Inertia (A [,COM=com])
;
; INPUTS:            A  : ein zweidimensionales Array, das die Masseverteilung (oder was auch immer)
;                          in aequidistanten (distanz=1) parallelen Flaechenstuecken enthaelt.
;
; OUTPUTS:           I  : das resultierende Traegheitsmoment
;
; OPTIONAL OUTPUTS:  COM: der Schwepunkt der Verteilung
;
; RESTRICTIONS:      hat aber nicht mehr die Aussage eines Masseschwerpunktes, wenn das Array
;                    negative Wrte enth�lt... (Stichwort: Ladungsschwerpunkt) 
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
;        Revision 1.2  2000/03/22 14:52:52  kupper
;        Changed to use new Distance() function.
;        The old code was wrong! Inertia() will have produced invalid results!
;
;        Revision 1.1  1999/12/02 18:03:43  saam
;              SIC!
;
;
;-
FUNCTION Inertia, A, COM=com

   s = SIZE(A)
   dims = s(0)
   w = s(2)
   h = s(1)

   tA = total(A)
   
   IF dims NE 2 THEN Message, 'only for 2-d array at the moment, sorry!'
   r = FLTARR(dims)

   com = round(Schwerpunkt(A))

   IF com(0) NE !NONE THEN BEGIN
      IF equal(tA, 0.0) THEN $
       return, 0.0 ELSE $
       return, total( A * Distance(h, w, com(0), com(1)) ) / tA
   END ELSE RETURN, !NONE

END
