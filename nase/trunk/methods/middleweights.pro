;+
; NAME:               MiddleWeights
;
; AIM:                mean of a DW-structure                   
;
; PURPOSE:            Mittelung ueber eine Gewichtsmatrix
;
; CATEGORY:           STATISTICS WEIGHTS DELAYS 
;
; CALLING SEQUENCE:   Gemittelt = MiddleWeights ( Matrix [,sd] 
;                                                 {,/FROMS | ,/TOS |, PROJECTIVE |, /RECEPTIVE }
;                                                 [,/NODW]
;                                                 [,/WRAP] [,/ROWS] [,/COLS] 
;                                                 [,/DEBUG] [,/DELAYS])
;
; INPUTS:             Matrix: Eine DW-Struktur
;
; KEYWORD PARAMETERS: PROJECTIVE(FROMS) / RECEPTIVE(TOS) :
;                                   Gibt an, ob ueber einlaufende oder
;                                   auslaufende Verbindungen gemittelt
;                                   werden soll. (siehe ShowWeights)
;                     WRAP: Fuer zyklische Randbedingungen.
;                     ROWS: Es wird nur über die Reihen gemittelt. Das 
;                           Ergebnis ist dann  eine vierdimensionale Matrix,
;                           die bei Bedarf direkt an InitDW() über das
;                           W_INIT-Schlüsselwort übergeben werden
;                           kann. (Liefert dann eine normale
;                           DW-Struktur mit nur noch einer Reihe.)
;                    (COLS: Entsprechend für Spalten.
;                           *** NOCH NICHT IMPLEMENTIERT! ***)
;                    DELAYS: mittelt ueber Delays statt ueber Gewichte 
;                    DEBUG : da diese Routine sehr kompliziert ist, ist es SEHR SINNVOLL
;                            das richtige funktionieren zu ueberpruefen. Mit Debug wird
;                            jeder einzelne Summand dargestellt...die RFs muessen exakt
;                            uebereinander liegen
;                    NODW:   Die uebergebene Matrix kann mit diesem Argument eine 4-dimensionale
;                            Matrix sein und muss kein DW-Struktur sein.
;
;
; OUTPUTS:            Gemittelt: eine zweidimensionale Matrix (Source_H x
;                                Source_W bzw. Target_H x Target_W, je nachdem, ob TOS oder FROMS
;                                angegeben wurden).
;                                Wenn /ROWS oder /COLS angegeben wird, ist das
;                                Ergebnis eine vierdimensionale Matrix.
;                                (s. Beschreibung von ROWS)
;
; OPTIONAL OUTPUTS:   sd : gibt die Matrix der zugehoerigen Standardabweichungen zurueck. Falls Keyword
;                          WRAP nicht gesetzt, wird nur ueber tatsaechlich vorhandene Matrixelemente
;                          standardabgeweicht, da die Zahl der eingehenden Messwerte zum Rand hin abfaellt.
;                          Das Ganze funktioniert (bisher) NICHT fuer Keywords COLS/ROWS.
;                          
;
; RESTRICTIONS: 
;               - Bisher kann nur ueber die gesamte Gewichtsmatrix gemittelt werden.
;               - Mittelung nur ueber gleichdimensionierte Target- und Source-Cluster
;
; PROCEDURE:    Set() mal wieder
;
; EXAMPLE:      BeispielMatrix = InitDW(t_width=10, t_height=10, s_width=7, s_height=5, W_Linear=[1,5])
;               showweights, Beispielmatrix, /tos, groesse=7 
;               window, /free
;               shade_surf, middleweights(BeispielMatrix,/ tos, /wrap), ax=16.62, az=67.06
;               window, /free
;               shade_surf, middleweights(BeispielMatrix, /tos), ax=16.62, az=67.06
;
;               Das Beispielprogramm erzeugt eine DW-Struktur und stellt
;               diese zunaechst zur Kontrolle mit ShowWeights dar.
;               Ueber die Gewichte in der DW-Struktur wird dann gemittelt,
;               einmal mit zyklischen Randbedingungen, einmal ohne.
;-
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.14  2000/09/28 09:45:45  gabriel
;            AIM tag added, message <> console
;
;       Revision 1.13  2000/09/05 19:15:00  kupper
;       Old typo.
;
;       Revision 1.12  1999/12/02 15:05:56  saam
;             + keyword NODW added
;
;       Revision 1.11  1998/12/15 13:01:14  saam
;             + new keywords DELAYS, DEBUG
;             + averaging across different target- and source-layer dimensions
;               implemented but it has to be tested a little bit more
;
;       Revision 1.10  1998/07/06 21:39:53  saam
;             + restricted to target and source clusters of same dimension
;             + new optional output for standard deviation
;
;       Revision 1.9  1998/05/19 19:33:58  kupper
;              ROWS implementiert.
;
;       Revision 1.8  1998/03/04 19:49:51  thiel
;              Jetzt mit KEYWORD_SET beim WRAP.
;
;       Revision 1.7  1998/01/05 14:49:54  saam
;             Anpassung an neue DWDim-Routine
;
;       Revision 1.6  1997/12/12 12:57:42  thiel
;              Middleweights arbeitet jetzt auch mit
;              Handles auf DW-Strukturen.
;
;       Revision 1.5  1997/10/30 13:01:21  kupper
;              PROJECTIVE, RECEPTIVE als Alternative zu TOS, FROMS eingeführt.
;
;       Revision 1.4  1997/09/30 11:37:23  thiel
;       *** empty log message ***
;
;
;       Wed Sep 3 16:54:06 1997, Andreas Thiel
;		Normierung im WRAP-Fall korrigiert.
;
;       Wed Sep 3 15:14:49 1997, Andreas Thiel
;		Die erste Version erblickt das Licht der Welt.
;
;

FUNCTION MiddleWeights, DW, sd, FROMS=Froms, TOS=Tos, WRAP=Wrap, NODW=nodw, $
                        PROJECTIVE=projective, RECEPTIVE=receptive, $
                        ROWS=rows, COLS=cols, DEBUG=debug, STOP=stop, DELAYS=DELAYS

   
   IF Keyword_Set(FROMS) THEN Console, /WARNING, 'keyword FROMS wurde durch PROJECTIVE ersetzt, bitte aendern!'
   IF Keyword_Set(TOS) THEN Console, /WARNING, 'keyword TOS wurde durch RECEPTIVE ersetzt, bitte aendern!'

   Default, PROJECTIVE, FROMS
   Default, RECEPTIVE, TOS
   

   IF NOT keyword_set(PROJECTIVE) AND NOT keyword_set(RECEPTIVE) THEN Console, /fatal, 'Eins der Schlüsselwörter PROJECTIVE oder RECEPTIVE muß gesetzt sein!'

   IF Keyword_Set(NODW) THEN BEGIN
      Matrix = {Weights: DW           ,$
                sw     : (SIZE(DW))(1),$
                sh     : (SIZE(DW))(2),$
                tw     : (SIZE(DW))(3),$
                th     : (SIZE(DW))(4)}
   END ELSE BEGIN
      IF Keyword_Set(Delays) THEN W = Delays(DW) ELSE W = Weights(DW)
      
      IF keyword_set(RECEPTIVE) THEN BEGIN ; Source- und Targetlayer vertauschen:
         Matrix = {Weights: TRANSPOSE(W)          , $
                   sw     : DWDim(DW, /TW)        , $
                   sh     : DWDim(DW, /TH)        , $
                   tw     : DWDim(DW, /SW)        , $
                   th     : DWDim(DW, /SH)        }
      ENDIF ELSE BEGIN
         Matrix = {Weights: W                     , $
                   sw     : DWDim(DW, /SW)        , $
                   sh     : DWDim(DW, /SH)        , $
                   tw     : DWDim(DW, /TW)        , $
                   th     : DWDim(DW, /TH)        }
      END
   END
;   IF (Matrix.sw NE Matrix.tw) OR (Matrix.sh NE Matrix.th) THEN Message, 'if you are sure the median makes sense in the case of different target & source layer dimensions THEN comment out this message or ask Mirko'
   
   
   no_connections = WHERE(Matrix.Weights EQ !NONE, count)
   IF count NE 0 THEN Matrix.Weights(no_connections) = 0 ;Damits bei der Berechnung nicht stört!
   
   MatrixMatrix= reform(Matrix.Weights, Matrix.th, Matrix.tw, Matrix.sh, Matrix.sw)
   
   zentrumx = (Matrix.tw / 2)
   zentrumy = (Matrix.th / 2)
   
   IF Keyword_Set(DEBUG) THEN BEGIN
      Window, /FREE
      wid = !D.WINDOW
   END

   
   ;;------------------> Über Reihen mitteln:
   If Keyword_Set(ROWS) then begin

      middle = fltarr(Matrix.th,Matrix.tw, 1, Matrix.sw)
      If Not Keyword_Set(WRAP) Then Begin
         sum = fltarr(Matrix.th,Matrix.tw, 1, Matrix.sw)
         for YY= 0, Matrix.sh-1 do begin
               untermatrix = MatrixMatrix(*, *, YY, *)
               geshiftet = norot_shift(untermatrix, zentrumy-YY,0, 0, 0)
               middle = middle + geshiftet
               sum = sum + norot_shift(bytarr(Matrix.th,Matrix.tw, 1, Matrix.sw)+1, zentrumy-YY,0, 0, 0)
         end
      Endif Else Begin
         sum = Matrix.sh
         for YY= 0, Matrix.sh-1 do begin
               untermatrix = MatrixMatrix(*, *, YY, *)
               geshiftet = shift(untermatrix, zentrumy-YY, 0, 0, 0)
               middle = middle + geshiftet
         end
      EndElse
      
      middle = middle/double(sum)
      If Keyword_Set(RECEPTIVE) then begin ;Matrix wurde oben vertauscht, das wird nun rückgängig gemacht:
         middle = reform(/OVERWRITE, middle, Matrix.th*Matrix.tw, Matrix.sw)
         middle = transpose(middle)
         middle = reform(/OverWrite, middle, 1, Matrix.sw, Matrix.th, Matrix.tw)
      end
      RETURN, middle

   EndIf
   ;;--------------------------------

   ;;------------------> Über Reihen mitteln:
   If Keyword_Set(COLS) then begin
      Console, /WARNING , "Das COLS-Keyord ist noch nicht implementiert..."
      Console, /FATAL , " Aber das könntest Du mal machen: Orientiere Dich an der Implementierung von ROWS!"
   EndIf
   ;;--------------------------------

   ;;------------------> Über alle Source-Neuronen mitteln:
   th = Matrix.th
   sh = Matrix.sh
   tw = Matrix.tw
   sw = Matrix.sw
   IF sh GT th THEN Console, /fatal, 'it only works for target- >= sourceheight'
   IF sw GT tw THEN Console, /fatal, 'it only works for target- >= sourcewidth'

   stepw = tw/(sw-1)
   steph = th/(sh-1)

;   stop

;   zentrumx = zentrumx-(tw MOD sw)
;   zentrumy = zentrumy-(th MOD sh)

;   stop

   middle = fltarr(Matrix.th,Matrix.tw)
   If Not Keyword_Set(WRAP) Then Begin
      sum = fltarr(Matrix.th,Matrix.tw)
      for YY= 0, Matrix.sh-1 do begin
         for XX= 0, Matrix.sw-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = norot_shift(untermatrix,zentrumy-YY,zentrumx-XX)
            middle = middle + geshiftet
            sum = sum + norot_shift(bytarr(Matrix.th,Matrix.tw)+1, zentrumy-YY,zentrumx-XX)
         end
      end
   Endif Else Begin
      IF Keyword_Set(DEBUG) THEN print, ''
      sum = sh*sw
      for YY= 0, sh-1 do begin
         for XX= 0, sw-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = shift(untermatrix,zentrumy-YY*steph,zentrumx-XX*stepw)
            IF Keyword_Set(DEBUG) THEN BEGIN
               UWSet, wid
               !P.Multi = [0,0,1]
               PlotTvScl, geshiftet, /LEGEND
               print, !KEY.UP, !KEY.UP, 'Matrix: ', XX, YY, '   Shift:', zentrumx-XX*stepw, zentrumy-YY*steph
               print, 'Total: ', XX+zentrumx-XX*stepw, YY+zentrumy-YY*steph
               IF Keyword_Set(Stop) THEN stop ELSE dummy = get_kbrd(1)
            END
            middle = middle + geshiftet
         end
      end
   EndElse

   m = middle/double(sum)

   ; compute the standard deviation for each matrix element
   var = fltarr(Matrix.th,Matrix.tw)
   If Not Keyword_Set(WRAP) Then Begin
      for YY= 0, Matrix.sh-1 do begin
         for XX= 0, Matrix.sw-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = norot_shift(untermatrix,zentrumy-YY,zentrumx-XX, WEIGHT=!NONE)
            var = var + (geshiftet GT !NONE)*(geshiftet - m)^2
         end
      end
   Endif Else Begin
      for YY= 0, Matrix.sh-1 do begin
         for XX= 0, Matrix.sw-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = shift(untermatrix,zentrumy-YY*steph,zentrumx-XX*stepw)
            var = var + (geshiftet - m)^2
         end
      end
   EndElse
   var = var / double(sum)
   sd = sqrt(var)


   IF Keyword_Set(DEBUG) THEN WDelete, wid
   
   RETURN, m
   ;;--------------------------------
   
END
