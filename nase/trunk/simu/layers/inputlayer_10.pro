;+
; NAME: InputLayer_10
;
; PURPOSE: Addiert Input vom Typ Sparse (siehe <A HREF="#SPASSMACHER">Spassmacher</A>) 
;          auf die Neuronenpotentiale und klingt diese vorher ab. 
;          Ein mehrmaliger Aufruf von InputLayer_10 ist möglich.
;          Danach sollte man auf jeden Fall <A HREF="#PROCEEDLAYER_10">ProceedLayer_10</A>
;          aufrufen.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: InputLayer_10, Layer [,FEEDING=feeding] [,/CORRECT]
;
; INPUTS: Layer : eine mit <A HREF="#INITLAYER_10">InitLayer_10</A> erzeugte Struktur
;
; OPTIONAL INPUTS:  feeding : Sparse-Vektor, der auf das entsprechende Potential
;                             addiert wird.
;
; KEYWORD PARAMETERS: CORRECT: Die Iterationsformel fuer einen Leckintegrator
;                              erster Ordnung lautet korrekterweise: 
;                               F(t+dt)=F(t)*exp(-dt/tau)+Input*V*(1-exp(-dt/tau))
;                              Die Multiplikation des Inputs mit dem Faktor
;                              (1-exp(-1/tau)) wird aber in der gängigen
;                              algorithmischen Formulierung des MMN weg-
;                              gelassen. Dies kann störend sein, denn
;                              diese Formulierung ist nicht invariant
;                              gegenüber einer Änderung der Zeitauflösung.
;                              Das Keyword CORRECT führt die Multiplikation
;                              mit (1-exp(-1/tau)) explizit aus.
;                                
; SIDE EFFECTS: wie so oft wird die Layer-Struktur verändert
;
; RESTRICTIONS: keine Überpüfung der Gültigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;          para10 = InitPara_10(tauf=10.0)
;          InputLayer = InitLayer_10(PROBABILITY=[0.5,0.7], TYPE=para10)
;          FeedingIn = Spassmacher( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;          InputLayer_10, InputLayer, FEEDING=FeedingIn
;          ProceedLayer_10, InputLayer
;
; SEE ALSO: <A HREF="#INITPARA_10">InitPara_10</A>, <A HREF="#INITLAYER_10">InitLayer_10</A>, <A HREF="#PROCEEDLAYER_10">ProceedLayer_10</A>, 
;           <A HREF="../input/#POISSONINPUT">PoissonInput</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.2  1999/07/28 14:59:21  thiel
;           Header updates.
;
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;
;-

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
