;+
; NAME: PrepareNASEPlot
;
; AIM: Set plot parameters (e.g. tickmarks) suitable for a plotting a
;      NASE array.
;
; PURPOSE: Einstellen der Plot-Parameter für das Plotten von NASE-Arrays
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* PrepareNASEPlot, Height, Width [,/CENTER] [,/OFFSET] [,/NONASE]
;*                   [,/X_ONLY | ,/Y_ONLY] 
;*                   [, XTICKNAMESHIFT=xshift] [,YTICKNAMESHIFT=yshift]       
;*                   [,GET_OLD=alteParameter]
;* PrepareNASEPlot, RESTORE_OLD=alteParameter
;
; INPUTS:
;  Height,Width:: Ausmaße des Arrays (beachte Reihenfolge!)
;
; OPTIONAL INPUTS:
;  RESTORE_OLD:: Die beim vorangegengenen Aufruf mit
;                GET_OLD geretteten Plot-Parameter.
;  xshift, yshift:: hilft, wenn man nicht will, dass die
;                  Beschriftung von 0 bis Breite/Hoehe des Arrays
;                  geht. Gibt man x/yshift an, so wird die
;                  Beschriftung um den angegebenen Wert verschoben.
;                  Soll zB die Null in der Mitte der X-Achse stehen,
;                  wuerde XTICKNAMESHIFT = -width/2 den Job tun.
;
; KEYWORD PARAMETERS:
;  /CENTER:: Wenn gesetzt, werden die Tickmarks so
;            verschoben, daß sie in die Mitte der
;            ArrayPunkte zeigen ( 0 liegt also
;            nicht im Koordinatenursprung, sondern
;            um einen halben "Pixel" verschoben).
;            Nötig z.B. für einen LEGO-SurfacePlot
;            oder für das Beschriften eines TV, wenn 
;            die Achsen unmittelbar am Array anliegen.
;            (s.OFFSET)
;   /OFFSET:: Ähnlich CENTER, wenn gesetzt werden die 
;            Tickmarks geeignet gesetzt für die
;            Beschriftung eines TV, wenn die Achsen
;            einen halben "Pixel" vom Array entfernt 
;            gezeichnet werden sollen.
;   /?_ONLY:: Parametzer werden nur für x- oder nur
;            für y-Achse gesetzt.
;   /NONASE:: Tickbeschriftungen werden IDL-üblich gesetzt.
;
; OPTIONAL OUTPUTS:      
;  GET_OLD:: Die Plotparameter, so, wie
;            sie vor dem Aufruf waren,
;            zur späteren
;            Wiederherstellung mit RESTORE_OLD.
;
; SIDE EFFECTS: !X und !Y werden verändert.
;
; RESTRICTIONS: Ich kenne im Augenblick keinen Fall, in dem sowohl
;               /CENTER old auch /OFFSET sinnvol verwendet werden
;               könnte. Es geht aber.
;
; PROCEDURE: Knifflige Rumrechnerei mit Tickzahlen und -werten...
;
; EXAMPLE: 
;*array=gauss_2d( 31, 31 )
;*PrepareNASEPlot, 31, 31
;*Surface, array, ax=80, az=10
;*
;*PrepareNASEPlot, 31, 31, /CENTER    ;für die LEGO-Option
;*                                    ;müssen die Ticks
;*                                    verschoben werden!
;*Surface, array, ax=80, az=10, /LEGO
;-

Pro PrepareNasePlot, Height, Width, GET_OLD=get_old, RESTORE_OLD=restore_old, $
                 X_ONLY=x_only, Y_ONLY=y_only, $
                 CENTER=center, OFFSET=offset, NONASE=nonase, $
                 XTICKNAMESHIFT = xticknameshift, YTICKNAMESHIFT = yticknameshift

   If Keyword_Set(RESTORE_OLD) then begin
      !X.MINOR = restore_old.old_X_MINOR
      !X.TICKS = restore_old.old_X_TICKS
      !X.STYLE = restore_old.old_X_STYLE
      !X.TICKV = restore_old.old_X_TICKV
      !X.RANGE = restore_old.old_X_RANGE
      !X.TICKNAME = restore_old.old_X_TICKNAME
      !Y.MINOR = restore_old.old_Y_MINOR
      !Y.TICKS = restore_old.old_Y_TICKS
      !Y.STYLE = restore_old.old_Y_STYLE
      !Y.TICKV = restore_old.old_Y_TICKV
      !Y.RANGE = restore_old.old_Y_RANGE
      !Y.TICKNAME = restore_old.old_Y_TICKNAME
      return
   endif
   
   get_old = {old_X_MINOR : !X.MINOR, $
              old_X_TICKS : !X.TICKS, $
              old_X_STYLE : !X.STYLE, $
              old_X_TICKV : !X.TICKV, $
              old_X_RANGE : !X.RANGE, $
              old_X_TICKNAME : !X.TICKNAME, $
              old_Y_MINOR : !Y.MINOR, $
              old_Y_TICKS : !Y.TICKS, $
              old_Y_STYLE : !Y.STYLE, $
              old_Y_TICKV : !Y.TICKV, $
              old_Y_RANGE : !Y.RANGE, $
              old_Y_TICKNAME : !Y.TICKNAME}

   Default, xticknameshift, 0
   Default, yticknameshift, 0

;   If Keyword_Set(OFFSET) then begin
;      Height = Height+2
;      Width = Width+2
;   EndIf

   If not Keyword_Set(y_only) then begin
      !X.MINOR = (Width-1) / 30 +1
      !X.TICKS = fix((Width-1) / float(!X.MINOR))
      !X.STYLE = 1
      !X.TICKV = findgen(!X.TICKS+1)*!X.MINOR
      If Keyword_Set(CENTER) then begin
         !X.TICKV = !X.TICKV + 0.5
         !X.RANGE = [0, Width]
      endif else If Keyword_Set(OFFSET) then begin
         !X.TICKV = !X.TICKV + 1
         !X.RANGE = [0, Width+1]
      endif else !X.RANGE = [0, Width-1]
;      If Keyword_Set(OFFSET) then !X.TICKNAME = [' ', str(!X.MINOR-1+indgen(!X.TICKS-1)*!X.MINOR), ' '] $
;       else !X.TICKNAME = str(indgen(!X.TICKS+1)*!X.MINOR)
      !X.TICKNAME = str((indgen(!X.TICKS+1))*!X.MINOR+xticknameshift)
   endif
   If not Keyword_Set(x_only) then begin
      !Y.MINOR = (Height-1) / 30 +1
      !Y.TICKS = fix((Height-1) / float(!Y.MINOR))
      !Y.STYLE = 1
      !Y.TICKV = findgen(!Y.TICKS+1)*!Y.MINOR
      If Keyword_Set(CENTER) then begin
         !Y.TICKV = !Y.TICKV + 0.5
         !Y.RANGE = [0, Height]
      endif else If Keyword_Set(OFFSET) then begin
         !Y.TICKV = !Y.TICKV + 1
         !Y.RANGE = [0, Height+1]
      endif else !Y.RANGE = [0, Height-1]
      If Keyword_Set(NONASE) then begin
;         If Keyword_Set(OFFSET) then  !Y.TICKNAME = [' ', str(indgen(!Y.TICKS-1)*!Y.MINOR), ' '] $
;         else !Y.TICKNAME = str(indgen(!Y.TICKS+1)*!Y.MINOR)
         !Y.TICKNAME = str(indgen(!Y.TICKS+1)*!Y.MINOR+yticknameshift)
      endif else begin
;         If Keyword_Set(OFFSET) then !Y.TICKNAME = [' ', str( Height-3-indgen(!Y.TICKS-1)*!Y.MINOR ), ' '] $
;         else !Y.TICKNAME = str( Height-1-indgen(!Y.TICKS+1)*!Y.MINOR )
         !Y.TICKNAME = str( Height-1-indgen(!Y.TICKS+1)*!Y.MINOR+yticknameshift)
      endelse
   endif
end

