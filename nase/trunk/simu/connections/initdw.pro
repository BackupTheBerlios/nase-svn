;+
; NAME: InitDW()
;
; PURPOSE: Initialisierung einer Delay-Weight-Struktur
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: My_DWS = ( {S_Layer | S_Width, S_Height} {,T_Layer | T_Width, T_Height}
;                                   [,DELAY  | ,D_RANDOM | ,D_NRANDOM | ,D_CONST | ,D_LINEAR | ,D_GAUSS] 
;                                   [,WEIGHT | ,W_RANDOM | ,W_NRANDOM | ,W_CONST | ,W_LINEAR | ,W_GAUSS, W_DOG]
;                                   [,D_NONSELF] [,W_NONSELF] 
;                                   [,W_TRUNCATE [,W_TRUNC_VALUE]]
;                                   [,D_TRUNCATE [,D_TRUNC_VALUE]] )
; 
; INPUTS: S_Layer, T_Layer: Source-, TagetLayer. Alternativ nur die Ausmaße in S/T_Width/Height
;
; OPTIONAL INPUTS: DELAY,     WEIGHT    : Konstanter Wert, mit dem die Gewichte/Delays initialisiert werden. Default für WEIGHT ist 0.
;                  D_RANDOM,  W_RANDOM  : Array [Min,Max]. Die Gewichte/Delays werden gleichverteilt zufällig belegt im Bereich Min..Max. Diese Belegung wirkt additiv, wenn zusätzlich zu diesem Schlüsselwort noch ein anderes angegeben wird.
;                  D_NRANDOM, W_NRANDOM : Array [MW,sigma]. Die Gewichte/Delays werden normalverteilt zufällig belegt mit Mittelwert MW und Standardabweichung sigma. Diese Belegung wirkt additiv, wenn zusätzlich zu diesem Schlüsselwort noch ein anderes angegeben wird.
;                             W_CONST   : Array [Value,Range]. Die Gewichte werden von jedem Soure-Neuron konstant mit Radius Range in den Targetlayer gesetzt (mit Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_CONST              : Array [Value,Range]. Die Delays werden von jedem Soure-Neuron konstant mit Radius Range in den Targetlayer gesetzt (mit Minimum Min, Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                             W_LINEAR   : Array [Max,Range]. Die Gewichte werden von jedem Soure-Neuron kegelförmig in den Targetlayer gesetzt (mit Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_LINEAR             : Array [min,max,Range]. Die Delays werden von jedem Soure-Neuron umgekehrt kegelförmig in den Targetlayer gesetzt (mit Minimum Min, Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                             W_GAUSS   : Array [Max,sigma]. Die Gewichte werden von jedem Source-Neuron gaußförmig in den Targetlayer gesetzt (mit Maximum Max und Standardabw. sigma in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_GAUSS              : Array [Min,Max,sigma]. Die Delays werden von jedem Source-Neuron umgekehrt gaußförmig in den Targetlayer gesetzt (mit Minimum Min, Maximum Max und Standardabw. sigma in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                             W_DOG     : Array [Amp,on_sigma,off_sigma]. Die Gewichte werden von jedem Source-Neuron Maxican-Hat-förmig in den Targetlayer gesetzt (mit Zentrumsamplitude Amp, on_sigma,off_sigma in Gitterpunkten), und zwar so, daß die HotSpots dort göeichmäßig verteilt sind (Keyword ALL)
;                  D_NONSELF, W_NONSELF : Sind Source- und Targetlayer gleichgroß (oder identisch), so läßt sich mit diesem Keyword das Gewicht/Delay eines Sourceneurons auf das Targetneuron mit gleichem Index auf 0 setzen.	
;                  LEARN_TAUP, LEARN_VP : Zeitkonstante und Verstaerkung f"ur das Lernpotential (Leckintegrator 1. Ordnung) 
;                                            LEARN_TAUP muss zur Initialisierung gesetzt werden, LEARN_VP hat Default 1.0 
;
;
;
;                  Man beachte, daß die Angabe mehrerer W_-
;                  bzw. mehrerer D_- Schlüsselworte i.d.R. nicht
;                  sinnvoll ist. Eine Ausnahme bilden hier die
;                  RANDOM-Schlüsselworte, die so implementiert wurden,
;                  daß ihre Wirkung ADDITIV ist. Auf diese Weise ist
;                  es leicht möglich, etwa eine gaußförmige
;                  Gewichtsverteilung mit einem überlagerten Rauschen
;                  zu erzeugen.
;
; KEYWORD PARAMETERS: s.o.
;                     TRUNCATE, TRUNC_VALUE: s. SetWeight.
;
; OUTPUTS: Eine Initialisiert Delay-Weight-Struktur. Wird keines der Delay-Schlüsselwörter angegeben, so enthält die Struktur keine Delays.
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: ---
;
; PROCEDURE: Default, Set, SetGaussWeight, SetGaussDelay,
;            SetLinearWeight, SetLinearDelay, SetDOGWeight.
;
;         ----------------------------------------------------------
;            Zur Abhängigkeit der ganzen Delay/Weight-Funktionen:
;
;
;                            ___SetConstDelay__
;                           /                  \
;                          /  SetLinearDelay__  \
;                         /  /                \  \
;                        /  /                  SetDelay  -> DWS.Delays
;                       /  /  SetGaussDelay___/
;                      /  /  /
;               InitDW--------SetLinearWeight
;                      \  \ \                \
;                       \  \ \                \
;                        \  \ SetGaussWeight---SetWeight -> DWS.Weights
;                         \  \                /  /
;                          \  SetDOGWeight___/  /
;                           \                  /
;                            \_SetConstWeight_/
;
;
;           ->->->-Richtung zunehmender Flexibilität->->->
;
;           InitDW() bietet nur eine eingeschränkte Flexibilität in der
;           Gewichts-/Delaybelegung. Wird eine detailliertere Angabe der
;           Verknüpfungseigenschaften gewünscht, so kann je nach
;           Bedarf jede der obigen Funktionen genutzt werden.
;           Natürlich kann nach wie vor auch direkt auf die Felder
;           .Delays und .Weights in der Delay-Weight-Struktur zugegriffen
;           werden.
;         ----------------------------------------------------------
;
;
; EXAMPLE: 1. My_DWS = InitDW (S_Layer=l1, T_Layer=l2, W_RANDOM=[0,1])
;          2. My_DWS = InitDW (S_Layer=My_Layer, T_Layer=My_Layer, W_GAUSS=[1,4], /W_NONSELF)
;          3. Vollständiges Beispiel:
;                  My_Neuronentyp = InitPara_1()
;                  My_Layer       = InitLayer_1(Type=My_Neuronentyp, WIDTH=21, HEIGHT=21)   
;                  My_DWS         = InitDW (S_Layer=My_Layer, T_Layer=My_Layer, $
;                                           D_LINEAR=[1,2,10], /D_TRUNCATE, $
;                                            D_NRANDOM=[0,0.1], /D_NONSELF, $
;                                           W_GAUSS=[1,5], /W_TRUNCATE, $
;                                            W_RANDOM=[0,0.3], /W_NONSELF)
;                  ShowWeights, My_DWS, /FROMS, Titel="Gewichte"
;                  ShowWeights, /DELAYS, My_DWS, /FROMS, Titel="Delays"
;        
; MODIFICATION HISTORY:
;
;       Thu Aug 14 11:23:99 1997, Mirko Saam
;       <Mirko.Saam@physik.uni-marburg.de>
;       
;               Erweiterung um Lernpotentiale analog zu DelayWeigh, Schluesselworte LEARN_TAUP, LEARN_VP
;               Erweiterung um konstante Gewichte/Delays mit Cutoff-Reichweite
;
;       Thu Aug 7 14:02:04 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		RANDOM-Schlüsselworte wirken jetzt additiv
;                   Header erweitert.
;
;       Wed Aug 6 14:31:07 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		W_DOG implementiert.
;
;       Tue Aug 5 18:00:21 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TRUNCATE, TRUNC_VALUE zugefügt.
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
                 DELAY=delay,                 WEIGHT=weight, $
                 D_RANDOM=d_random,           W_RANDOM=w_random, $
                 D_NRANDOM=d_nrandom,         W_NRANDOM=w_nrandom, $
                 D_GAUSS=d_gauss,             W_GAUSS=w_gauss, $
                 W_DOG=w_dog, $
                 D_CONST=d_const,             W_CONST=w_const, $
                 D_LINEAR=d_linear,           W_LINEAR=w_linear, $
                 D_NONSELF=d_nonself,         W_NONSELF=w_nonself, $
                 D_TRUNCATE=d_truncate,       W_TRUNCATE=w_truncate, $
                 D_TRUNC_VALUE=d_trunc_value, W_TRUNC_VALUE=w_trunc_value,$
                 LEARN_TAUP=learn_taup,       LEARN_VP=learn_vp



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
      
                                ; es gibt Delays, also muessen die Lernpotentiale nun in den Verbindungen stehen,
                                ; (falls gelernt werden soll)
      IF Keyword_Set(learn_taup) THEN BEGIN
         Default, learn_vp, 1.0
         lp = FltArr( t_width*t_height, s_width*s_height )
      END ELSE BEGIN
         lp = -1
      END
      
      
      Default, delay, 0
      
      DelMat = { source_w: s_width,$
                 source_h: s_height,$
                 target_w: t_width,$
                 target_h: t_height,$
                 Weights : Replicate( DOUBLE(weight), t_width*t_height, s_width*s_height ),$
                 Matrix  : BytArr( t_width*t_height, s_width*s_height ) ,$
                 Delays  : Replicate( DOUBLE(delay), t_width*t_height, s_width*s_height ),$
                 Queue   : InitSpikeQueue( INIT_DELAYS=Replicate( DOUBLE(delay), t_width*t_height, s_width*s_height ) ), $
                 VP      : FLOAT(learn_vp),$
                 DP      : exp(-1.0/FLOAT(learn_taup)),$
                 LP      : lp $
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
   


if set (W_GAUSS) then SetGaussWeight, DelMat, w_gauss(0), w_gauss(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
if set (D_GAUSS) then SetGaussDelay,  DelMat, d_gauss(1), min=d_gauss(0), d_gauss(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

if set (W_CONST) then SetConstWeight, DelMat, w_const(0), w_const(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
if set (D_CONST) then SetConstDelay,  DelMat, d_const(1), min=d_const(0), d_const(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

if set (W_LINEAR) then SetLinearWeight, DelMat, w_linear(0), w_linear(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
if set (D_LINEAR) then SetLinearDelay,  DelMat, d_linear(1), min=d_linear(0), d_linear(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

if set (W_DOG) then SetDOGWeight, DelMat, w_dog(0), w_dog(1), w_dog(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
 
; Die Random-Initialisierungen sollen additiv sein:
if set (W_RANDOM) then DelMat.Weights = DelMat.Weights + w_random(0) + (w_random(1)-w_random(0)) * RandomU(seed,t_width*t_height, s_width*s_height) 
if set (D_RANDOM) then DelMat.Delays  = DelMat.Delays  + d_random(0) + (d_random(1)-d_random(0)) * RandomU(seed,t_width*t_height, s_width*s_height) 

if set (W_NRANDOM) then DelMat.Weights = DelMat.Weights + w_nrandom(0) + w_nrandom(1) * RandomN(seed,t_width*t_height, s_width*s_height) 
if set (D_NRANDOM) then DelMat.Delays  = DelMat.Delays  + d_nrandom(0) + d_nrandom(1) * RandomN(seed,t_width*t_height, s_width*s_height) 


if keyword_set(W_NONSELF) then begin
   if t_width*t_height ne s_width*s_height then message, "Schluesselwort NONSELF ist nur sinnvoll bei gleichgroßem Source- und Targetlayer!"
   DelMat.Weights(indgen(t_width*t_height), indgen(s_width*s_height)) = 0
end

if keyword_set(D_NONSELF) then begin
   if t_width*t_height ne s_width*s_height then message, "Schluesselwort NONSELF ist nur sinnvoll bei gleichgroßem Source- und Targetlayer!"
   DelMat.Delays(indgen(t_width*t_height), indgen(s_width*s_height)) = 0
end



return, DelMat

end




