;+
; NAME: GaussRing()
;
; PURPOSE: Belegt ein Array mit einem Ring aus G‰uﬂen. (klingt komisch...)
;
; CATEGORY: Arrays, Simulation, miscellaneous
;
; CALLING SEQUENCE: Array = GaussRing( Height, Width, r, HWB)
;
; INPUTS: Height, Width: Ausmaﬂe des Arrays.
;                        Man beachte die NASEtypische Reihenfolge!
;
;                     r: Radius des Ringes (hier liegen die Maxima der 
;                        G‰uﬂe)
;
; OPTIONAL INPUTS:  HWB: Halbwertsbreite der G‰uﬂe. (Default: r*0.75)
;
; OUTPUTS: Array: Das entsprechende Array, Maximum=1.
;                 Der Mittelpunkt des Ringes liegt immer in der Mitte
;                 des Arrays.
;
; PROCEDURE: Zinelich brute force: Einen Gauss machen und dann in
;                                  10∞-Schritten rotieren.
;
; EXAMPLE: SurfIt, GaussRing (32, 32, 8)
;
; SEE ALSO: <A HREF="#GAUSS_2D">Gauss_2D()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/05/26 12:30:34  kupper
;               Meine persˆnliche GaussRing-Routine ist jetzt auf Andreas` Wunsch
;                Teil der NASE-Distribution... viel Spaﬂ damit!
;
;-

Function GaussRing, Height, Width, r, HWB

   Default, HWB, r*0.75

   g = Gauss_2d(Height, Width, HWB=HWB)
   g = shift(g, r, 0)

   erg = fltarr(Height, Width)

   for w=0., 360., 0.1 do erg = erg+rot(g, w, /Interp)

   return, erg/max(erg)

end
   
   
