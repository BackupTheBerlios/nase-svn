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
;-

FUNCTION MiddleWeights, DW, FROMS=Froms, TOS=Tos, WRAP=Wrap, $
                        PROJECTIVE=projective, RECEPTIVE=receptive


   Default, FROMS, PROJECTIVE
   Default, TOS, RECEPTIVE
   
   IF NOT keyword_set(FROMS) AND NOT keyword_set(TOS) THEN message, 'Eins der Schlüsselwörter PROJECTIVE/FROMS oder RECEPTIVE/TOS muß gesetzt sein!'
   
   IF keyword_set(TOS) THEN BEGIN ; Source- und Targetlayer vertauschen:
      Matrix = {Weights: Transpose(Weights(DW)), $
                sw     : DWDim(DW, /TW)        , $
                sh     : DWDim(DW, /TH)        , $
                tw     : DWDim(DW, /SW)        , $
                th     : DWDim(DW, /SH)        }
   ENDIF ELSE BEGIN
      Matrix = {Weights: Weights(DW)           , $
                sw     : DWDim(DW, /SW)        , $
                sh     : DWDim(DW, /SH)        , $
                tw     : DWDim(DW, /TW)        , $
                th     : DWDim(DW, /TH)        }
   END
   
   
   
   no_connections = WHERE(Matrix.Weights EQ !NONE, count)
   IF count NE 0 THEN Matrix.Weights(no_connections) = 0 ;Damits bei der Berechnung nicht stört!
   
   MatrixMatrix= reform(Matrix.Weights, Matrix.th, Matrix.tw, Matrix.sh, Matrix.sw)
   
   zentrumx = Matrix.sw / 2
   zentrumy = Matrix.sh / 2
   
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
      sum = Matrix.sh*Matrix.sw
      for YY= 0, Matrix.sh-1 do begin
         for XX= 0, Matrix.sw-1 do begin  
            untermatrix = MatrixMatrix(*, *, YY, XX)
            geshiftet = shift(untermatrix,zentrumy-YY,zentrumx-XX)
            middle = middle + geshiftet
         end
      end
   EndElse
   
   
   RETURN, middle/double(sum)
   
END
