;+
; NAME: Gabor
;
; AIM: constructs a gabor patch
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
;                                    [, WAVELENGTH  = wavelength ]
;                                    [,/NICEDETECTOR ] )
; 
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
;                              1. In Faellen, in denen gewuenscht ist, 
;                              dass das Maximum des Ergebnisses
;                              unabhaengig von der Phasenlage gleich 1 ist,
;                              kann /MAXONE gesetzt werden.
;
;               NICEDETECTOR : Gabor-Wavelets eignen sich nur
;                              begrenzt als
;                              Orientierungsdetektor, da
;                              beispielsweise bei einem
;                              0°-Detektor zwar das
;                              Gesamtintegral null ist, nicht
;                              aber auch jede einzelne
;                              Spaltensulle. Daher reagiert ein
;                              solcher 0°-Detektor auch
;                              eingeschränkt auf senkrecht dazu
;                              orientierte Kanten.
;                              Wird dieses Schlüsselwort
;                              gesetzt, so werden die einzelnen
;                              Spaltensummen auf 0 normiert. Das 
;                              ist dann zwar kein richtiges
;                              Gabor-Wavelet mehr, wohl aber ein 
;                              "sauberer" Orientierungsdetektor.
;                              Man handlet sich damit allerdings 
;                              Normierungsschwierigkeiten ein,
;                              da die Spaltennormierung vor
;                              einer eventuellen Rotation
;                              gemacht wird. (Das Gesamtintegral 
;                              könnte aufgrund von
;                              Rotationsfehlern dann etwas von
;                              null abweichen). Für vielfache
;                              von 90° treten keine solchen
;                              Fehler auf.
;
; OUTPUTS: Ein (size x size) double-Array mit entsprechendem Inhalt.
;
; RESTRICTIONS: Diese Routine leidet wie alle Routinen, bei
;               denen Arrays rotiert werden, unter
;               Diskretisierungsproblemen. In diesem Fall hat
;               das zur Folge, daß bei der Verwendung der
;               /NICEDETECTOR-Option das Gesamtintegral
;               geringfügig von null abweichen kann.
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
;        Revision 1.4  2000/09/25 09:12:54  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.3  1999/11/19 15:35:18  kupper
;        Added a "temporary" here and there.
;        Implemented NICEDETECTOR option.
;
;        Revision 1.2  1999/06/28 14:18:14  kupper
;        Corrected Misttypings...
;
;        Revision 1.1  1999/06/28 14:02:19  kupper
;        Initial Revision.
;
;-

Pro Gabor_rotate_array, result, orientation
   ;;we use "rotate" where possible, as it works cleaner
   case orientation of 
      90 : result = rotate(temporary(result), 1)
      180: result = rotate(temporary(result), 2)
      270: result = rotate(temporary(result), 3)
      else: begin
         missing = result(0, 0) ; This is hopefully a better substitute for missing pixels than zero
         result = rot(temporary(result), -ORIENTATION, CUBIC=-0.5, MISSING=missing)
      endelse
   endcase
End

Function Gabor, size, PHASE=phase, ORIENTATION=orientation, WAVELENGTH=wavelength, HWB=hwb, $
                MAXONE=maxone, NICEDETECTOR=nicedetector

   Default, WAVELENGTH, size
   Default, PHASE, 0

   If Set(ORIENTATION) then begin
      result = [indgen(round(size/2.0)), -1-reverse(indgen(fix(size/2.0)))]
      result = rebin(temporary(result), size, size, /SAMPLE)
   Endif else begin
      result = dist(size)
   Endelse

   result = cos(phase + shift(temporary(result), size/2, size/2)*2*!PI/float(wavelength))
   result = temporary(result)*gauss_2d(size, size, HWB=hwb)


   If Keyword_Set(NICEDETECTOR) then begin ; adjust eauch column to have total 0
      ;; in this case, we rotate last

      If not set(ORIENTATION) then begin
         on_error, 2            ;return to caller
         message, "Option NICEDETECTOR used on non-oriented patch."
      endif
      correction = total(result, 1)/float(size)
      for col=0, size-1 do result(*, col) = result(*, col)-correction(col)

      center_offset = correction(size/2)

      If keyword_set(ORIENTATION) then begin ;nothing to be done for orientation=0...
         Gabor_rotate_array, result, orientation
      endif

   endif else begin; adjust whole array to have total 0
      ;; in this case, we can rotate first!
      
      If keyword_set(ORIENTATION) then begin ;nothing to be done for orientation=0...
         Gabor_rotate_array, result, orientation
      endif

      ;;max of gaussmask was 1
      total_offset = total(result)/(size*size) ;Volume of gabor
      result = temporary(result)-total_offset ;Volume=0
      center_offset = total_offset

   endelse

   
   If Keyword_Set(MAXONE) then result = result/max(result) $
    else result = temporary(result)/(1-center_offset) ;Thus max of gaussmask is 1 again

   return, result
End
