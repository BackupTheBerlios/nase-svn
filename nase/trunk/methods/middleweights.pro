;+
; NAME: MiddleWeights
;
;
; PURPOSE: Mittelung ueber eine Gewichtsmatrix
;
; CATEGORY: STATISTICS
;
; CALLING SEQUENCE: Gemittelt = MiddleWeights ( Matrix 
;                                               {,/FROMS | ,/TOS |, PROJECTIVE |, /RECEPTIVE }
;                                               [,/WRAP] )
;
; INPUTS: Matrix: Eine DW-Struktur
;
; OPTIONAL INPUTS: ---
;
; KEYWORD PARAMETERS: PROJECTIVE(FROMS) / RECEPTIVE(TOS) :
;                                   Gibt an, ob ueber einlaufende oder
;                                   auslaufende Verbindugen gemittelt
;                                   werden soll. (siehe ShowWeights)
;                     WRAP: Fuer zyklische Randbedingungen.
;                     
; OUTPUTS: Gemittelt: eine zweidimensionale Matrix (Source_H x
;                     Source_W bzw. Target_H x Target_W, je nachdem, ob TOS oder FROMS
;                     angegeben wurden)
;
; RESTRICTIONS: Bisher kann nur ueber die gesamte Gewichtsmatrix
;               gemittelt werden.
;
; PROCEDURE: Set() mal wieder
;
; EXAMPLE: BeispielMatrix = InitDW(t_width=10, t_height=10, s_width=7, s_height=5, W_Linear=[1,5])
;          showweights, Beispielmatrix, /tos, groesse=7 
;          window, /free
;          shade_surf, middleweights(BeispielMatrix,/ tos, /wrap), ax=16.62, az=67.06
;          window, /free
;          shade_surf, middleweights(BeispielMatrix, /tos), ax=16.62, az=67.06
;
;          Das Beispielprogramm erzeugt eine DW-Struktur und stellt
;          diese zunaechst zur Kontrolle mit ShowWeights dar.
;          Ueber die Gewichte in der DW-Struktur wird dann gemittelt,
;          einmal mit zyklischen Randbedingungen, einmal ohne.
;
; MODIFICATION HISTORY:
;
;       $Log$
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
;-



FUNCTION MiddleWeights, _Matrix, FROMS=Froms, TOS=Tos, WRAP=Wrap, $
                        PROJECTIVE=projective, RECEPTIVE=receptive

   Default, FROMS, PROJECTIVE
   Default, TOS, RECEPTIVE

   If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schlüsselwörter PROJECTIVE/FROMS oder RECEPTIVE/TOS muß gesetzt sein!'

if keyword_set(TOS) then begin  ; Source- und Targetlayer vertauschen:
   IF _Matrix.Info EQ 'DW_DELAY_WEIGHT' THEN BEGIN 
    Matrix = {Weights: Transpose(_Matrix.Weights), $
              Delays : Transpose(_Matrix.Delays),$
              source_w: _Matrix.target_w, $
              source_h: _Matrix.target_h, $
              target_w: _Matrix.source_w, $
              target_h: _Matrix.source_h}
    ENDIF ELSE BEGIN 
    Matrix = {Weights: Transpose(_Matrix.Weights), $
              source_w: _Matrix.target_w, $
              source_h: _Matrix.target_h, $
              target_w: _Matrix.source_w, $
              target_h: _Matrix.source_h}
    ENDELSE 

endif else Matrix = _Matrix



no_connections = WHERE(Matrix.weights EQ !NONE, count)
IF count NE 0 THEN Matrix.weights(no_connections) = 0 ;Damits bei der Berechnung nicht stört!

MatrixMatrix= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)

zentrumx = Matrix.source_w / 2
zentrumy = Matrix.source_h / 2

middle = fltarr(Matrix.target_h,Matrix.target_w)


If Not Set(WRAP) Then Begin
    sum = fltarr(Matrix.target_h,Matrix.target_w)
    for YY= 0, Matrix.source_h-1 do begin
        for XX= 0, Matrix.source_w-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = norot_shift(untermatrix,zentrumy-YY,zentrumx-XX)
            middle = middle + geshiftet
            sum = sum + norot_shift(bytarr(Matrix.target_h,Matrix.target_w)+1, zentrumy-YY,zentrumx-XX)
        end
    end
Endif Else Begin
    sum = Matrix.source_h*Matrix.source_w
    for YY= 0, Matrix.source_h-1 do begin
        for XX= 0, Matrix.source_w-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = shift(untermatrix,zentrumy-YY,zentrumx-XX)
            middle = middle + geshiftet
        end
    end
    EndElse

RETURN, middle/double(sum)

END
