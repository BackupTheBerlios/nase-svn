;+
; NAME:
;  InputLayer_10
;
; AIM:
;  Transfer input to Poisson Neuron synapses of given layer. 
;
; PURPOSE: Addiert Input vom Typ Sparse (siehe <A>Spassmacher</A>) 
;          auf die Neuronenpotentiale und klingt diese vorher ab. 
;          Ein mehrmaliger Aufruf von InputLayer_10 ist m�glich.
;          Danach sollte man auf jeden Fall <A>ProceedLayer_10</A>
;          aufrufen.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: InputLayer_10, Layer [,FEEDING=feeding] [,/CORRECT]
;
; INPUTS: Layer : eine mit <A>InitLayer_10</A> erzeugte Struktur
;
; OPTIONAL INPUTS:  feeding : Sparse-Vektor, der auf das entsprechende Potential
;                             addiert wird.
;
; KEYWORD PARAMETERS: CORRECT: Die Iterationsformel fuer einen Leckintegrator
;                              erster Ordnung lautet korrekterweise: 
;                               F(t+dt)=F(t)*exp(-dt/tau)+Input*V*(1-exp(-dt/tau))
;                              Die Multiplikation des Inputs mit dem Faktor
;                              (1-exp(-1/tau)) wird aber in der g�ngigen
;                              algorithmischen Formulierung des MMN weg-
;                              gelassen. Dies kann st�rend sein, denn
;                              diese Formulierung ist nicht invariant
;                              gegen�ber einer �nderung der Zeitaufl�sung.
;                              Das Keyword CORRECT f�hrt die Multiplikation
;                              mit (1-exp(-1/tau)) explizit aus.
;                                
; SIDE EFFECTS: wie so oft wird die Layer-Struktur ver�ndert
;
; RESTRICTIONS: keine �berp�fung der G�ltigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;          para10 = InitPara_10(tauf=10.0)
;          InputLayer = InitLayer_10(PROBABILITY=[0.5,0.7], TYPE=para10)
;          FeedingIn = Spassmacher( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;          InputLayer_10, InputLayer, FEEDING=FeedingIn
;          ProceedLayer_10, InputLayer
;
; SEE ALSO: <A>InitPara_10</A>, <A>InitLayer_10</A>, <A>ProceedLayer_10</A>, 
;           <A>PoissonInput</A>
;
;-
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.4  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 1.3  2000/09/27 15:59:40  saam
;       service commit fixing several doc header violations
;
;       Revision 1.2  1999/07/28 14:59:21  thiel
;           Header updates.
;
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;
;

PRO InputLayer_10, _Layer, FEEDING=feeding, CORRECT=correct

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))*(1.-Layer.para.df)
         END ELSE BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
         END
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET

END
