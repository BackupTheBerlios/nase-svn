;+
; NAME: InitDW()
;
; PURPOSE: Initialisierung einer Delay-Weight-Struktur
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: My_DWS = ( {S_Layer | S_Width, S_Height} {,T_Layer | T_Width, T_Height}
;                                   [,DELAY  | ,D_RANDOM | ,D_NRANDOM | ,D_LINEAR | ,D_GAUSS]
;                                   [,WEIGHT | ,W_RANDOM | ,W_NRANDOM | ,W_LINEAR | ,W_GAUSS]
;                                   [,D_NONSELF] [,W_NONSELF]
;                                   [,TRUNCATE [,TRUNC_VALUE]] )
; 
; INPUTS: S_Layer, T_Layer: Source-, TagetLayer. Alternativ nur die Ausma�e in S/T_Width/Height
;
; OPTIONAL INPUTS: DELAY, WEIGHT       : Konstanter Wert, mit dem die Gewichte/Delays initialisiert werden. Default f�r WEIGHT ist 0.
;                  D_RANDOM, W_RANDOM  : Array [Min,Max]. Die Gewichte/Delays werden gleichverteilt zuf�llig belegt im Bereich Min..Max.
;                  D_NRANDOM, W_NRANDOM: Array [MW,sigma]. Die Gewichte/Delays werden normalverteilt zuf�llig belegt mit Mittelwert MW und Standardabweichung sigma.
;                  D_LINEAR, W_LINEAR  : (noch nicht implementiert!)
;                            W_GAUSS   : Array [Max,sigma]. Die Gewichte werden von jedem Source-Neuron gau�f�rmig in den Targetlayer gesetzt (mit Maximum Max und Standardabw. sigma in Gitterpunkten), und zwar so, da� die HotSpots dort gleichm��ig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_GAUSS             : (noch nicht implementiert!)
;                  D_NONSELF, W_NONSELF: Sind Source- und Targetlayer gleichgro� (oder identisch), so l��t sich mit diesem Keyword das Gewicht/Delay eines Sourceneurons auf das Targetneuron mit gleichem Index auf 0 setzen.	
;
; KEYWORD PARAMETERS: s.o.
;                     TRUNCATE, TRUNC_VALUE: s. SetWeight.
;
; OUTPUTS: Eine Initialisiert Delay-Weight-Struktur. Wird keines der Delay-Schl�sselw�rter angegeben, so enth�lt die Struktur keine Delays.
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: ---
;
; PROCEDURE: Default, Set
;
; EXAMPLE: 1. My_DWS = InitDW (S_Layer=l1, T_Layer=l2, W_RANDOM=[0,1])
;          2. My_DWS = InitDW (S_Layer=My_Layer, T_Layer=My_Layer, W_GAUSS=[1,4], /W_NONSELF)
;
; MODIFICATION HISTORY:
;
;       Tue Aug 5 18:00:21 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TRUNCATE, TRUNC_VALUE zugef�gt.
;
;       Mon Aug 4 01:31:42 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		W_GAUSS implementiert.
;
;       Sun Aug 3 20:51:50 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt. DELAY, WEIGHT, RANDOM, NRANDOM, NONSELF implementiert.
;
;-

Function InitDW, S_LAYER=s_layer, T_LAYER=t_layer, $
                   S_WIDTH=s_width, S_HEIGHT=s_height, T_WIDTH=t_width, T_HEIGHT=t_height, $
                   DELAY=delay,         WEIGHT=weight, $
                   D_RANDOM=d_random,   W_RANDOM=w_random, $
                   D_NRANDOM=d_nrandom, W_NRANDOM=w_nrandom, $
                   D_GAUSS=d_gauss,     W_GAUSS=w_gauss, $
                   D_LINEAR=d_linear,   W_LINEAR=w_linear, $
                   D_NONSELF=d_nonself, W_NONSELF=w_nonself, $
                   TRUNCATE=truncate,  TRUNC_VALUE=trunc_value
   
   IF set(S_LAYER) THEN BEGIN
      s_width = s_layer.w
      s_height = s_layer.h
   END
   IF set(T_LAYER) THEN BEGIN
      t_width = t_layer.w
      t_height = t_layer.h
   END
   
   
   Default, Weight, 0


   HasDelay = set(DELAY) or set(D_RANDOM) or set(D_NRANDOM) or set(D_GAUSS) or set(D_LINEAR)

;konstante Belegungen:
   if HasDelay then begin
         DelMat = { source_w: s_width,$
                    source_h: s_height,$
                    target_w: t_width,$
                    target_h: t_height,$
                    Weights : Replicate( DOUBLE(weight), t_width*t_height, s_width*s_height ),$
                    Matrix  : BytArr( t_width*t_height, s_width*s_height ) ,$
                    Delays  : Replicate( DOUBLE(delay), t_width*t_height, s_width*s_height ),$
                    Queue   : SpikeQueue( INIT_DELAYS=Replicate( DOUBLE(delay), t_width*t_height, s_width*s_height ) ) $
                  }
      END ELSE BEGIN         
         DelMat = {source_w: s_width,$
                   source_h: s_height,$
                   target_w: t_width,$
                   target_h: t_height,$
                   Weights : Replicate( DOUBLE(weight), t_width*t_height, s_width*s_height ),$
                   Delays  : [-1, -1] $
                  }
   END
   

if set (W_RANDOM) then DelMat.Weights = w_random(0) + (w_random(1)-w_random(0)) * RandomU(seed,t_width*t_height, s_width*s_height) 
if set (D_RANDOM) then DelMat.Delays  = d_random(0) + (d_random(1)-d_random(0)) * RandomU(seed,t_width*t_height, s_width*s_height) 

if set (W_NRANDOM) then DelMat.Weights = w_nrandom(0) + w_nrandom(1) * RandomN(seed,t_width*t_height, s_width*s_height) 
if set (D_NRANDOM) then DelMat.Delays  = d_nrandom(0) + d_nrandom(1) * RandomN(seed,t_width*t_height, s_width*s_height) 

if set (W_GAUSS) then SetGaussWeight, DelMat, w_gauss(0), w_gauss(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=truncate, TRUNC_VALUE=trunc_value
;if set (D_GAUSS) then



if keyword_set(W_NONSELF) then begin
   if t_width*t_height ne s_width*s_height then message, "Schluesselwort NONSELF ist nur sinnvoll bei gleichgro�em Source- und Targetlayer!"
   DelMat.Weights(indgen(t_width*t_height), indgen(s_width*s_height)) = 0
end

if keyword_set(D_NONSELF) then begin
   if t_width*t_height ne s_width*s_height then message, "Schluesselwort NONSELF ist nur sinnvoll bei gleichgro�em Source- und Targetlayer!"
   DelMat.Delays(indgen(t_width*t_height), indgen(s_width*s_height)) = 0
end



return, DelMat

end




