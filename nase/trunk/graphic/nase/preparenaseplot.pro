;+
; NAME: PrepareNASEPlot
;
; PURPOSE: Einstellen der Plot-Parameter für das Plotten von NASE-Arrays
;
; CATEGORY: Graphik, Darstellung
;
; CALLING SEQUENCE: PrepareNASEPlot, { (Height, Width [,/CENTER] [,/OFFSET] [,/NONASE]
;                                             [,/X_ONLY | ,/Y_ONLY] 
;                                       [, XTICKNAMESHIFT=xshift] [,YTICKNAMESHIFT=yshift]       
;                                             [,GET_OLD=alteParameter])
;                                     | (RESTORE_OLD=alteParameter) }
;
; INPUTS: Height,Width: Ausmaße des Arrays (beachte Reihenfolge!)
;
; OPTIONAL INPUTS: alteParameter in RESTORE_OLD: Die beim vorangegengenen Aufruf mit
;                                                GET_OLD geretteten Plot-Parameter.
;                  xshift, yshift: hilft, wenn man nicht will, dass die
;                                  Beschriftung von 0 bis Breite/Hoehe des Arrays
;                                  geht. Gibt man x/yshift an, so wird die
;                                  Beschriftung um den angegebenen Wert verschoben.
;                                  Soll zB die Null in der Mitte der X-Achse stehen,
;                                  wuerde XTICKNAMESHIFT = -width/2 den Job tun.
;
; KEYWORD PARAMETERS: /CENTER: Wenn gesetzt, werden die Tickmarks so
;                              verschoben, daß sie in die Mitte der
;                              ArrayPunkte zeigen ( 0 liegt also
;                              nicht im Koordinatenursprung, sondern
;                              um einen halben "Pixel" verschoben).
;                              Nötig z.B. für einen LEGO-SurfacePlot
;                              oder für das Beschriften eines TV, wenn 
;                              die Achsen unmittelbar am Array anliegen.
;                              (s.OFFSET)
;                     /OFFSET: Ähnlich CENTER, wenn gesetzt werden die 
;                              Tickmarks geeignet gesetzt für die
;                              Beschriftung eines TV, wenn die Achsen
;                              einen halben "Pixel" vom Array entfernt 
;                              gezeichnet werden sollen.
;                     /?_ONLY: Parametzer werden nur für x- oder nur
;                              für y-Achse gesetzt.
;                     /NONASE: Tickbeschriftungen werden IDL-üblich gesetzt.
;
; OPTIONAL OUTPUTS:      alteParameter in GET_OLD: Die Plotparameter, so, wie
;                                         sie vor dem Aufruf waren,
;                                         zur späteren
;                                         Wiederherstellung mit RESTORE_OLD.
;
; SIDE EFFECTS: !X und !Y werden verändert.
;
; RESTRICTIONS: Ich kenne im Augenblick keinen Fall, in dem sowohl
;               /CENTER old auch /OFFSET sinnvol verwendet werden
;               könnte. Es geht aber.
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
;        Revision 2.7  1998/06/30 20:38:14  thiel
;               Neue Keywords X/YTICKNAMESHIFT eingebaut.
;
;        Revision 2.6  1998/04/17 15:24:02  kupper
;               fix statt round...
;
;        Revision 2.5  1998/04/01 14:32:47  kupper
;               Bug in OFFSET-Behandlung.
;
;        Revision 2.4  1998/03/30 23:30:17  kupper
;               OFFSET-Schlüsselwort hinzugefügt.
;
;        Revision 2.3  1998/03/30 23:04:20  kupper
;               X/Y-Range wird jetzt auch richtig gesetzt.
;
;        Revision 2.2  1998/03/29 18:48:51  kupper
;               NONASE-Keyword hinzugefügt.
;
;        Revision 2.1  1998/03/29 16:11:08  kupper
;               Schöpfung - endlich! Oft hab ich's mir schon gewünscht...
;
;-

Pro PrepareNasePlot, Height, Width, GET_OLD=get_old, RESTORE_OLD=restore_old, $
                 X_ONLY=x_only, Y_ONLY=y_only, $
                 CENTER=center, OFFSET=offset, NONASE=nonase, $
                 XTICKNAMESHIFT = xticknameshift, YTICKNAMESHIFT = yticknameshift

   If Keyword_Set(RESTORE_OLD) then begin
      !X = restore_old.old_X
      !Y = restore_old.old_Y
      return
   endif
   
   get_old = {old_X : !X, $
              old_Y : !Y}

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

