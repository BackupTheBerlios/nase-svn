;+
; NAME: InitDW()
;
; AIM: Init and define a connection matrix (SDW struct).
;
; PURPOSE: Create a connection matrix that will be used by the
;          DelayWeigh() Function to propagate spikes from one layer to
;          the next.
;          Optionally, weights, delays, synaptic depression parameters
;          and the combination method for conjunctive connections can
;          be specified.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: My_DWS = ( {S_Layer | S_Width, S_Height} {,T_Layer | T_Width, T_Height}
;                                   [,/SOURCE_TO_TARGET | /TARGET_TO_SOURCE]
;                                   [,DELAY  | ,D_INIT | ,D_RANDOM | ,D_NRANDOM | ,D_CONST | ,D_LINEAR | ,D_GAUSS] 
;                                   [,WEIGHT | ,W_INIT | ,W_RANDOM | ,W_NRANDOM | ,W_CONST | ,W_LINEAR | ,W_GAUSS, W_DOG]
;                                   [,/D_NONSELF] [,/W_NONSELF] 
;                                   [,/W_TRUNCATE [,W_TRUNC_VALUE]]
;                                   [,/D_TRUNCATE [,D_TRUNC_VALUE]]
;                                   [,NOCON]
;                                   [,/OLDSTYLE]
;                                   [,/DEPRESS [, TAU_REC] [, U_SE] ,[REALSCALE] ]
;                                   [CONJUNCTION_METHOD={"SUM","MAX"} )
; 
; INPUTS: S_Layer, T_Layer: Source-, TagetLayer. Alternativ nur die Ausmaße in S/T_Width/Height
;                                                oder implizit int W_INIT/D_INIT
;
; OPTIONAL INPUTS: SOURCE_TO_TARGET     : Dies ist der Default: Die folgenden Verbindungs- und Delay-Schlüsselworte
;                                         definieren Verbindungen vom Source- in den Targetlayer.
;                  TARGET_TO_SOURCE     : Die folgenden Verbindungs- und Delay-Schlüsselworte definieren Verbindungen
;                                         vom Target- in den Source-Layer. 
;
;                  DELAY,     WEIGHT    : Konstanter Wert, mit dem die Gewichte/Delays initialisiert werden. Default für WEIGHT ist 0.
;                  D_INIT,    W_INIT    : Array vom Ausmaß (Target_Height,Taget_Width, Source_Height,Source_Width), der die Werte für die Initialisierung enthält. Die Ausmaße werden aus diesem Array abgeleitet und brauchen nicht explizit angegeben zu werden. Werden beide Arrays angegeben, müssen die Ausmaße natürlich gleich sein.                                        
;                  D_RANDOM,  W_RANDOM  : Array [Min,Max]. Die Gewichte/Delays werden gleichverteilt zufällig belegt im Bereich Min..Max. Diese Belegung wirkt additiv, wenn zusätzlich zu diesem Schlüsselwort noch ein anderes angegeben wird.
;                  D_NRANDOM, W_NRANDOM : Array [MW,sigma]. Die Gewichte/Delays werden normalverteilt zufällig belegt mit Mittelwert MW und Standardabweichung sigma. Diese Belegung wirkt additiv, wenn zusätzlich zu diesem Schlüsselwort noch ein anderes angegeben wird.
;                             W_CONST   : Array [Value,Range]. Die Gewichte werden von jedem Soure-Neuron konstant mit Radius Range in den Targetlayer gesetzt (mit Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_CONST              : Array [Value,Range]. Die Delays werden von jedem Soure-Neuron konstant mit Radius Range in den Targetlayer gesetzt (mit Minimum Min, Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                             W_IDENT   : fuehrt eine 1:1 Verknüpfung von Source- und Targetlayer mit Wert W_IDENT durch, wenn diese gleiche Dimensionen haben
;                             W_LINEAR  : Array [Max,Range]. Die Gewichte werden von jedem Soure-Neuron kegelförmig in den Targetlayer gesetzt (mit Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_IDENT              : setzt die 1:1-Verbindungen von Source- zu Targetlayer auf die Verzoegerung D_IDENT, wenn diese gleiche Dimensionen haben
;                  D_LINEAR             : Array [min,max,Range]. Die Delays werden von jedem Soure-Neuron umgekehrt kegelförmig in den Targetlayer gesetzt (mit Minimum Min, Maximum Max und Reichweite Range in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                             W_GAUSS   : Array [Max,sigma]. Die Gewichte werden von jedem Source-Neuron gaußförmig in den Targetlayer gesetzt (mit Maximum Max und Standardabw. sigma in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                  D_GAUSS              : Array [Min,Max,sigma]. Die Delays werden von jedem Source-Neuron umgekehrt gaußförmig in den Targetlayer gesetzt (mit Minimum Min, Maximum Max und Standardabw. sigma in Gitterpunkten), und zwar so, daß die HotSpots dort gleichmäßig verteilt sind (Keyword ALL in SetWeight. Siehe dort!) 
;                             W_DOG     : Array [Amp,on_sigma,off_sigma]. Die Gewichte werden von jedem Source-Neuron Maxican-Hat-förmig in den Targetlayer gesetzt (mit Zentrumsamplitude Amp, on_sigma,off_sigma in Gitterpunkten), und zwar so, daß die HotSpots dort göeichmäßig verteilt sind (Keyword ALL)
;                  D_NONSELF, W_NONSELF : Sind Source- und Targetlayer gleichgroß (oder identisch), so läßt sich mit diesem Keyword das Gewicht/Delay eines Sourceneurons auf das Targetneuron mit gleichem Index auf 0 setzen.	
;                  NOCON                : Neuronen, deren Abstand vom HotSpot groesser als NOCON ist, werden nicht verbunden;
;                                         zwischen diesen Neuronen koennen auch keine Gewichte gelernt werden
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
;                  CONJUNCTION_METHOD: The operation that is used if
;                                      more than one spike at a time
;                                      arrive at a target
;                                      neuron. Possible value are
;                               "SUM": (default). Linear summation of
;                                      weight values.
;                               "MAX": Pick the greatest weight of all
;                                      spikes. See REFERENCES for
;                                      details.
;
; KEYWORD PARAMETERS: s.o.
;                     TRUNCATE, TRUNC_VALUE: s. SetWeight.
;                     OLDSTYLE: Ist dieses Schlüsselwort gesetz, so
;                               wird keine SDW, sondern eine
;                               DW-Struktur zurückgeliefert. (Die ist
;                               für Simulationen ungeeignet, aber alle 
;                               Gewichtsmodifikationen darauf sind
;                               wesentlich schneller!)
;                               Die beiden Typen können mittels
;                               <A HREF="#SDW2DW">SDW2DW</A> und <A HREF="#DW2SDW">DW2SDW</A>
;                               (weitgehend) ineinander umgewandelt werden.
;                     DEPRESS:  Aktivierung der synaptischen Kurzzeitdepression. Als Parameter
;                               koennen die Zeitkonstante tau_rec, sowie die 'Synaptische Effizienz'
;                               U_se uebergeben werden.
;                               Jede Synapse wird durch ihre (relative) Zahl an freisetzbaren
;                               Transmitterquanten transm(0<=transm<=1), und durch die
;                               Freisetzungswahrscheinlichkeit U_se' charakterisiert. 
;                               Bei Ausloesung eines APs wird der Bruchteil 'transm'
;                               ausgeschuettet, und 'transm' erniedrigt sich um den Betrag
;                               U_se*transm. Die Zahl der freisetzbaren Transmitter regeneriert sich
;                               mit der Zeitkonstanten tau_rec exponentiell bis zur Saettigung (=1).
;                               Default : tau_rec=200ms, u_se=0.35
;                               ACHTUNG : Laufzeitvergleich mit/ohne Depression :
;                               1) 100 Neuronen, 1:1 Verbindung :
;                                   10 Hz : Laufzeiten in etwa gleich
;                                  100 Hz : Depression ca. 6% langsamer  
;                               2) 100 Neuronen, vollst. Verknuepfung:
;                                   10 Hz : Depression ca. 30% langsamer
;                                  100 Hz : Depression ca. 30% langsamer       
;                      REALSCALE: ist REALSCALE gesetzt, so ist bei depression fuer transm=1 der
;                                 output U_se(i) * W(i), andernfalls ist der output W(i)...
;
; OUTPUTS: Eine Initialisiert Delay-Weight-Struktur. Wird keines der Delay-Schlüsselwörter angegeben, so enthält die Struktur keine Delays.
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
;       !!  Inzwischen kann übrigens NICHT MEHR direkt auf die Felder
;       !!  .Delays und .Weights in der Delay-Weight-Struktur zugegriffen
;       !!  werden!
;         ----------------------------------------------------------
;
;
; RESTRICTIONS: The MAX operation is sign-sensitive (mathematical
;               correct "greater than", no absolute value). Hence,
;               negative weights values should not be used with the
;               MAX operation.
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
; REFERENCES: The MAX operation for conjunctive connections is
;             described in: Riesenhuber, Poggio, "Hierarchical models
;                           of object recognition in cortex", nature
;                           neurosc., 2(11), Nov. 1999
;                           (Papyrus #6409)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.21  2000/07/18 16:52:08  kupper
;       Deletet empty line in header.
;
;       Revision 2.20  2000/07/18 16:38:46  kupper
;       Implemented Poggio&Riesenhuber-like MAX conjuction operation.
;
;       Fixed bug in SDW2DW that currupted synaptic depression data.
;
;       Englishified headers (Sorry, InitDW still mostly german, it's just too
;       long...)
;
;       Revision 2.19  2000/01/20 15:05:02  saam
;             D_NONSELF is ignored if delays are not activated
;
;       Revision 2.18  1999/11/05 13:09:58  alshaikh
;             1)jede synapse hat jetzt ihr eigenes U_se
;             2)keyword REALSCALE
;
;       Revision 2.17  1999/10/12 14:36:50  alshaikh
;             neues keyword '/depress'... synapsen mit kurzzeitdepression
;
;       Revision 2.16  1999/07/28 08:23:09  saam
;             some memory optimizations in the delay-part
;
;       Revision 2.15  1998/12/15 13:02:18  saam
;             multiple bugfixes
;
;       Revision 2.14  1998/11/08 17:49:45  saam
;             + wrong implementation with TARGET_TO_SOURCE, SOURCE_TO_TARGET
;
;       Revision 2.13  1998/03/24 11:32:21  kupper
;              ?_Init implementiert.
;
;       Revision 2.12  1998/02/26 17:24:18  kupper
;              OLDSTYLE-Schlüsselwort hinzugefügt.
;
;       Revision 2.11  1998/02/11 14:56:08  saam
;             Handle-Hierarchie vervollstaendigt
;
;       Revision 2.10  1998/02/05 13:16:02  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 2.9  1997/12/10 15:53:39  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 2.8  1997/09/17 10:25:50  saam
;       Listen&Listen in den Trunk gemerged
;
; 
;       Thu Sep 11 18:08:17 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Zwei neue Tags SSource, STarget die Array von Handles sind und folg. Funktion haben:
;                 SSource(target) liefert ein Array, der zum Neuron target gehoerenden Source-Neurone
;                 STarget(source) liefert ein Array, der zum Neuron source gehoerenden Target-Neurone
;               Matrix-Tag entfernt, da Verwendung unklar
;               Delay-Tag in DW_WEIGHT entfernt, da info-tag Auskunft ueber dessen Existenz gibt
;
;       Sun Sep 7 16:36:04 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Delays nichtexistierender Verbindungen werden jetzt
;		auch auf !NONE gesetzt.
;
;       Thu Sep 4 17:11:25 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Es gibt nun einen learn-tag, der
;                 a) bei unverzoegerten Verbindungen: die Aktivitaet des praesynaptischen Layers
;                 b) bei verzoegerten Verbindungen: das Ergebis der SpikeQueue
;               enthaelt. Die ist f"ur Update des Lernpotentials notwendig.
;
;       Thu Sep 4 14:39:19 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Strukturen haben jetzt den info-Tag.
;
;       Wed Sep 3 11:46:43 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		NOCON-Keyword entfernt
;               IDENT-Doku ergaenzt
;               Lernpotentiale herausgenommen -> neue Routine
;               
;
;       Tue Sep 2 02:07:23 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		kann jetzt auch Target->Source-Verbindungen setzen.
;
;       Thu Aug 28 21:51:10 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Weights und Delays sind jetzt Floats und keine Doubles
;		mehr.
;
;       Tue Aug 19 15:24:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		NOCON durch W_NOCON ersetzt, damit alles einheitlich
;		ist. NOCON kann zur Zeit noch benutzt werden, wird
;		jedoch in einer der kommenden Versionen entfernt.
;
;       Mon Aug 18 16:39:12 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Behandlung von nicht vorhandenen Connections
;               Bug bei Initialisierung von Delays korrigiert
;               Schluesselwort NOCON zur Erstellung nicht vorhandener Cons
;
;       Fri Aug 15 15:57:12 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schluesselwort W_IDENT, D_IDENT fuer Identitaetsabbildung hinzugefuegt
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
                 D_INIT=d_init,               W_INIT=w_init, $
                 D_RANDOM=d_random,           W_RANDOM=w_random, $
                 D_NRANDOM=d_nrandom,         W_NRANDOM=w_nrandom, $
                 D_GAUSS=d_gauss,             W_GAUSS=w_gauss, $
                 W_DOG=w_dog, $
                 D_CONST=d_const,             W_CONST=w_const, $
                 D_IDENT=d_ident,             W_IDENT=w_ident, $
                 D_LINEAR=d_linear,           W_LINEAR=w_linear, $
                 D_NONSELF=d_nonself,         W_NONSELF=w_nonself, $
                 D_TRUNCATE=d_truncate,       W_TRUNCATE=w_truncate, $
                 D_TRUNC_VALUE=d_trunc_value, W_TRUNC_VALUE=w_trunc_value,$
                 W_NOCON=w_nocon, NOCON=nocon, $
                 SOURCE_TO_TARGET=source_to_target, TARGET_TO_SOURCE=target_to_source, $
                 OLDSTYLE=oldstyle, depress=depress, tau_rec= tau_rec, U_se= U_se_const, $ 
                 REALSCALE=realscale, $
                 CONJUNCTION_METHOD=conjunction_method

   Default, nocon, w_nocon
   Default, tau_rec, 200.0
   Default, U_se_const, 0.35
   default, depress, 0
   Default, realscale, 0
   Default, conjunction_method, "MAX"

   Case strupcase(conjunction_method) of
      "SUM": cm = 1
      "MAX": cm = 2
      else: Message, "Unknown conjunction method specified: " +"'"+conjunction_method+"'."
   EndCase

   IF keyword_set(depress) THEN depress = 1

   IF ((U_se_const LT 0) OR (U_se_const GT 1)) THEN message, "Ungueltiger Wert fuer U_se!"
   IF tau_rec LT 1 THEN message,"Ungueltiger Wert fuer tau_rec!"

   if keyword_set(w_nocon) then message, /INFORM, "Das W_NOCON-Schlüsselwort ist übrigens seit Version 2.7 wieder in NOCON umbenannt. Bitte den Aufruf entsprechend ändern. Rüdiger."


   IF set(S_LAYER) THEN BEGIN
      s_width = LayerWidth(S_LAYER)
      s_height = LayerHeight(S_LAYER)
   END
   IF set(T_LAYER) THEN BEGIN
      t_width = LayerWidth(T_LAYER)
      t_height = LayerHeight(T_LAYER)
   END
   
   If keyword_Set(D_INIT) then begin
      s = size(D_INIT)
      if s(0) ne 4 then message, "D_INIT erwartet ein vierdimensionales Array der Form (target_height,target_width, source_height,source_width)!"
      t_height = s(1)
      t_width  = s(2)
      s_height = s(3)
      s_width  = s(4)
   endif
   If keyword_Set(W_INIT) then begin
      s = size(W_INIT)
      if s(0) ne 4 then message, "W_INIT erwartet ein vierdimensionales Array der Form (target_height,target_width, source_height,source_width)!"
      t_height = s(1)
      t_width  = s(2)
      s_height = s(3)
      s_width  = s(4)
   endif

   Default, Weight, 0
   

   HasDelay = set(DELAY) or set(D_INIT) or set(D_RANDOM) or set(D_NRANDOM) or set(D_GAUSS) or set(D_LINEAR) OR set(D_CONST) OR set(D_IDENT)


   ;konstante Belegungen:
   
         if HasDelay then begin
         
         Default, delay, 0
         
         Default, w_init, Replicate( FLOAT(weight), t_width*t_height, s_width*s_height )
         Default, d_init, Replicate( FLOAT(delay),  t_width*t_height, s_width*s_height )
         
         w_init = reform(w_init, t_height*t_width, s_height*s_width, /OVERWRITE)
         d_init = reform(d_init, t_height*t_width, s_height*s_width, /OVERWRITE)
         
         tmp = { info    : 'DW_DELAY_WEIGHT',$
                 source_w: s_width,$
                 source_h: s_height,$
                 target_w: t_width,$
                 target_h: t_height,$
                 Weights : temporary(w_init) ,$
                 depress : depress, $
                 Delays  : temporary(d_init), $
                 conjunction_method: cm }

         IF depress EQ 1 THEN BEGIN
            settag,tmp, 'tau_rec', tau_rec
            settag,tmp, 'U_se_const', U_se_const
            settag,tmp, 'realscale', realscale         
         END
   
         _DW = Handle_Create(!MH, VALUE=tmp, /NO_COPY)
      END ELSE BEGIN         
         Default, W_INIT, Replicate( FLOAT(weight), t_width*t_height, s_width*s_height )
         
         tmp = {info    : 'DW_WEIGHT', $
                source_w: s_width,$
                source_h: s_height,$
                target_w: t_width,$
                target_h: t_height,$
                Weights : reform(w_init, t_height*t_width, s_height*s_width, /OVERWRITE), $
                depress : depress, $
                conjunction_method: cm}
 
IF depress EQ 1 THEN BEGIN

            settag,tmp, 'tau_rec', tau_rec
            settag,tmp, 'U_se_const', U_se_const
            settag,tmp, 'realscale', realscale         
         END
         
         _DW = Handle_Create(!MH, VALUE=tmp, /NO_COPY)
      END
      
      




; ================================ Initialisierung von Delays und Weights ===========================================================

if keyword_set(TARGET_TO_SOURCE) and keyword_set(SOURCE_TO_TARGET) then message, 'Bitte nur eins der Schluesselworte SOURCE_TO_TARGET und TARGET_TO_SOURCE angeben!'

; --------------------- Gauss, Linear, Const, DOG: -----------------------------------------------
   If keyword_set(TARGET_TO_SOURCE) then begin ;------------Target -> Source: 
      if set (W_GAUSS) then BEGIN
         IF N_Elements(w_Gauss) EQ 3 THEN SetGaussWeight, _DW, w_gauss(0), w_gauss(1), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value, /NORM $
          ELSE SetGaussWeight, _DW, w_gauss(0), w_gauss(1), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      END
      if set (D_GAUSS) then SetGaussDelay,  _DW, d_gauss(1), min=d_gauss(0), d_gauss(2), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value
      
      if set (W_CONST) then SetConstWeight, _DW, w_const(0), w_const(1), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      if set (D_CONST) then SetConstDelay,  _DW, d_const(0), d_const(1), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

      if set (W_LINEAR) then SetLinearWeight, _DW, w_linear(0), w_linear(1), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      if set (D_LINEAR) then SetLinearDelay,  _DW, d_linear(1), min=d_linear(0), d_linear(2), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

      if set (W_DOG) then SetDOGWeight, _DW, w_dog(0), w_dog(1), w_dog(2), T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      
   endif else begin             ;------------------------------Source -> Target:
      if set (W_GAUSS) then BEGIN
         IF N_Elements(w_Gauss) EQ 3 THEN SetGaussWeight, _DW, w_gauss(0), w_gauss(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value, /NORM $
          ELSE SetGaussWeight, _DW, w_gauss(0), w_gauss(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      END
      if set (D_GAUSS) then SetGaussDelay,  _DW, d_gauss(1), min=d_gauss(0), d_gauss(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value
      
      if set (W_CONST) then SetConstWeight, _DW, w_const(0), w_const(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      if set (D_CONST) then SetConstDelay,  _DW, d_const(0), d_const(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

      if set (W_LINEAR) then SetLinearWeight, _DW, w_linear(0), w_linear(1), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
      if set (D_LINEAR) then SetLinearDelay,  _DW, d_linear(1), min=d_linear(0), d_linear(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value

      if set (W_DOG) then SetDOGWeight, _DW, w_dog(0), w_dog(1), w_dog(2), S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
   endelse
; ----------------------------------------------------------------------------------------------------------------------
      

   Handle_Value, _DW, DW, /NO_COPY   
; ---------------Die Random-Initialisierungen sollen additiv sein: -----------------------------------------------------
      if set (W_RANDOM) then DW.Weights = DW.Weights + w_random(0) + (w_random(1)-w_random(0)) * RandomU(seed,t_width*t_height, s_width*s_height) 
      if set (D_RANDOM) then DW.Delays  = DW.Delays  + d_random(0) + (d_random(1)-d_random(0)) * RandomU(seed,t_width*t_height, s_width*s_height) 

      if set (W_NRANDOM) then DW.Weights = DW.Weights + w_nrandom(0) + w_nrandom(1) * RandomN(seed,t_width*t_height, s_width*s_height) 
      if set (D_NRANDOM) then DW.Delays  = DW.Delays  + d_nrandom(0) + d_nrandom(1) * RandomN(seed,t_width*t_height, s_width*s_height) 
; ----------------------------------------------------------------------------------------------------------------------

; ---------------NONSELF und IDENT: -----------------------------------------------------
      if keyword_set(W_NONSELF) then begin
         if t_width*t_height ne s_width*s_height then message, "Schluesselwort NONSELF ist nur sinnvoll bei gleichgroßem Source- und Targetlayer!"
         DW.Weights(indgen(t_width*t_height), indgen(s_width*s_height)) = !NONE
      end

      if (hasDelay AND keyword_set(D_NONSELF)) then begin
         if t_width*t_height ne s_width*s_height then message, "Schluesselwort NONSELF ist nur sinnvoll bei gleichgroßem Source- und Targetlayer!"
         DW.Delays(indgen(t_width*t_height), indgen(s_width*s_height)) = 0
      end

      if set (W_IDENT) then BEGIN
         if t_width*t_height ne s_width*s_height then message, "Schluesselwort W_IDENT ist nur sinnvoll bei gleichgroßem Source- und Targetlayer!"
;         SetConstWeight, DW, w_ident, 1, S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=w_trunc_value
         DW.Weights(indgen(t_width*t_height), indgen(s_width*s_height)) = w_ident
      END
      if (HasDelay AND set (D_IDENT)) then BEGIN
         if t_width*t_height ne s_width*s_height then message, "Schluesselwort D_IDENT ist nur sinnvoll bei gleichgroßem Source- und Targetlayer!"
;         SetConstDelay,  DW, d_ident, 1, 1, S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=d_truncate, TRUNC_VALUE=d_trunc_value
         DW.Delays(indgen(t_width*t_height), indgen(s_width*s_height)) = d_ident
      END
; ----------------------------------------------------------------------------------------------------------------------
      Handle_Value, _DW, DW, /NO_COPY, /SET
      

; ------------------------- NOCON: ----------------------------------------------------------------
      IF keyword_set(NOCON) THEN BEGIN
         If keyword_set(TARGET_TO_SOURCE) then begin ;------------Target -> Source: 
            SetConstWeight, _DW, !NONE, nocon, T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=!NONE, /INVERSE, TRANSPARENT=0
            if HasDelay then begin
               SetConstDelay, _DW, !NONE, nocon, T_ROW=t_height/2, T_COL=t_width/2, S_HS_ROW=s_height/2, S_HS_COL=s_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=!NONE, /INVERSE, TRANSPARENT=0
            endif
         END ELSE BEGIN
            SetConstWeight, _DW, !NONE, nocon, S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=!NONE, /INVERSE, TRANSPARENT=0
            if HasDelay then begin
               SetConstDelay, _DW, !NONE, nocon, S_ROW=s_height/2, S_COL=s_width/2, T_HS_ROW=t_height/2, T_HS_COL=t_width/2, /ALL, TRUNCATE=w_truncate, TRUNC_VALUE=!NONE, /INVERSE, TRANSPARENT=0
            endif
         END
      END
; ----------------------------------------------------------------------------------------------------------------------

; ================================ Ende der Initialisierungen ====================================================================================================================


      ;;------------------> Want DW or SDW?
      If not Keyword_Set(OLDSTYLE) then DW2SDW, _DW ;init lists
      ;;--------------------------------
      
      RETURN, _DW
      
END
