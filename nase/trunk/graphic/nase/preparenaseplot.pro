;+
; NAME: PrepareNASEPlot
;
; PURPOSE: Einstellen der Plot-Parameter für das Plotten von NASE-Arrays
;
; CATEGORY: Graphik, Darstellung
;
; CALLING SEQUENCE: PrepareNASEPlot, { (Height, Width [,/CENTER]
;                                             [,/X_ONLY | ,/Y_ONLY] [,GET_OLD=alteParameter])
;                                     | (RESTORE_OLD=alteParameter) }
;
; INPUTS: Height,Width: Ausmaße des Arrays (beachte Reihenfolge!)
;
; OPTIONAL INPUTS: alteParameter in RESTORE_OLD: Die beim vorangegengenen Aufruf mit
;                                                GET_OLD geretteten Plot-Parameter.
;
; KEYWORD PARAMETERS: /CENTER: Wenn gesetzt, werden die Tickmarks so
;                              verschoben, daß sie in die Mitte der
;                              ArrayPunkte zeigen ( 0 liegt also
;                              nicht im Koordinatenursprung, sondern
;                              um einen halben "Pixel" verschoben).
;                     /?_ONLY: Parametzer werden nur für x- oder nur
;                              für y-Achse gesetzt.
;
; OPTIONAL OUTPUTS:      alteParameter in GET_OLD: Die Plotparameter, so, wie
;                                         sie vor dem Aufruf waren,
;                                         zur späteren
;                                         Wiederherstellung mit RESTORE_OLD.
;
; SIDE EFFECTS: !X und !Y werden verändert.
;
; PROCEDURE: Knifflige Rumrechnerei mit Tickzahlen und -werten...
;
; EXAMPLE: array=gauss_2d( 31, 31 )
;          PrepareNASEPlot, 31, 31
;          Surface, array, ax=80, az=10
;
;          PrepareNASEPlot, 31, 31, /CENTER    ;für die LEGO-Option
;                                              ;müssen die Ticks
;                                              verschoben werden!
;          Surface, array, ax=80, az=10, /LEGO
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/03/29 16:11:08  kupper
;               Schöpfung - endlich! Oft hab ich's mir schon gewünscht...
;
;-

Pro PrepareNasePlot, Height, Width, GET_OLD=get_old, RESTORE_OLD=restore_old, $
                 X_ONLY=x_only, Y_ONLY=y_only, $
                 CENTER=center

   If Keyword_Set(RESTORE_OLD) then begin
      !X = restore_old.old_X
      !Y = restore_old.old_Y
      return
   endif
   
   get_old = {old_X : !X, $
              old_Y : !Y}


   If not Keyword_Set(y_only) then begin
      !X.MINOR = (Width-1) / 30 +1
      !X.TICKS = round((Width-1) / float(!X.MINOR))
      !X.STYLE = 1
      !X.TICKV = findgen(!X.TICKS+1)*!X.MINOR
      If Keyword_Set(CENTER) then !X.TICKV = !X.TICKV + 0.5
      !X.TICKNAME = str(indgen(!X.TICKS+1)*!X.MINOR)
   endif
   If not Keyword_Set(x_only) then begin
      !Y.MINOR = (Height-1) / 30 +1
      !Y.TICKS = round((Height-1) / float(!Y.MINOR))
      !Y.STYLE = 1
      !Y.TICKV = findgen(!Y.TICKS+1)*!Y.MINOR
      If Keyword_Set(CENTER) then !Y.TICKV = !Y.TICKV + 0.5
      !Y.TICKNAME = str( Height-1-indgen(!Y.TICKS+1)*!Y.MINOR )
   endif
end

