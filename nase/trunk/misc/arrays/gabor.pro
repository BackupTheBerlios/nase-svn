;+
; NAME: Gabor
;
; PURPOSE: Liefert ein Array mit einem Gabor-Patch bel. Frequenz,
;          phase, Groesse und Orientierung
;
; CATEGORY: Array, Simulation
;
; CALLING SEQUENCE: result = Gabor (  size
;                                    [, HWB         = hwb ]
;                                    [,/MAXONE ]
;                                    [, ORIENTATION = orientation ]
;                                    [, PHASE       = phase ]
;                                    [, WAVELENGTH  = wavelength ] )
;
; INPUTS: size: Die Groesse des quadratischen Ergebnisarrays
;
; OPTIONAL INPUTS: HWB         : Durchmesser des Patches
;                                (Halbwertsbreite der multiplizierten
;                                Gaussmaske)
;                                Default: wird von <A HREF="#GAUSS_2D">Gauss_2d()</A> uebernommen.
;
;                  ORIENTATION : Orientierung des Patches in Grad.
;                                Als Default wird ein konzentrischer
;                                Patch ohne Orientierung erzeugt. Wird 
;                                ein auf 0 Grad orientierter Patch
;                                gewuenscht, so muss ORIENTATION=0
;                                explizit angegeben werden.
;
;                  PHASE       : Phasenverschiebung des verwendeten
;                                Cosinus in Rad. Fuer einen 0 Grad Patch 
;                                bedeuten positive Werte eine
;                                Verschiebung nach oben.
;                                Default: Maximum im Zentrum.
;
;                  WAVELENGTH  : Wellenlaenge des zugrundeliegenden
;                                Cosinus.
;                                Default: Groesse des Arrays (size).
;
; KEYWORD PARAMETERS: MAXONE : Wird PHASE ungleich 0 angegeben, so
;                              liegen die Maxima des Cosinus und der
;                              Gaussmaske nicht mehr
;                              uebereinander. Per default wird stets
;                              das Maximum der Gaussmaske auf 1
;                              normiert. In diesem Fall ist dann das
;                              Maximum des Gabor-Patches kleiner als
;                              0. In Faellen, in denen gewuenscht ist, 
;                              dass das Maximum des Ergebnisses
;                              unabhaengig von der Phasenlage 1 ist,
;                              kann /MAXONE gesetzt werden.
;
; OUTPUTS: Ein (size x size) double-Array mit entsprechendem Inhalt.
;
; RESTRICTIONS:
;
; PROCEDURE: Verschobene lineare bzw. konzentrische Cosinusfunktion erzeugen und mit Gaussmaske
;            multiplizieren.
;
; EXAMPLE: 1. PlotTVScl, /NASE, Gabor(100)
;          2. PlotTVScl, /NASE, Gabor(100, ORIENTATION=0)
;          3. PlotTVScl, /NASE, Gabor(100, ORIENTATION=30, PHASE=0.5*!DPI)
;          4. PlotTVScl, /NASE, Gabor(100, ORIENTATION=30, PHASE=0.5*!DPI, WAVELENGTH=50)
;
; SEE ALSO: <A HREF="#DOG">DOG()</A>, <A HREF="#GAUSS_2D">Gauss_2d()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/06/28 14:02:19  kupper
;        Initial Revision.
;
;-

Function Gabor, size, PHASE=phase, ORIENTATION=orientation, WAVELENGTH=wavelength, HWB=hwb, $
                MAXONE=maxone

   Default, WAVELENGTH, size
   Default, PHASE, 0

   If Set(ORIENTATION) then begin
      result = [indgen(round(size/2.0)), -1-reverse(indgen(fix(size/2.0)))]
      result = rebin(result, size, size, /SAMPLE)
   Endif else begin
      result = dist(size)
   Endelse

   result = cos(phase + shift(result, size/2, size/2)*2*!PI/float(wavelength))
   result = result*gauss_2d(size, size, HWB=hwb)
   
   If set(ORIENTATION) then result = rot(result, -ORIENTATION, CUBIC=-0.5)
 
   ;max of gaussmask was 1
   offset = total(result)/(size*size) ;Volume of gabor
   result = result-offset       ;Volume=0
   If Keyword_Set(MAXONE) then result = result/max(result) $
    else result = result/(1-offset) ;Thus max of gaussmask is 1 again

   return, result
End
