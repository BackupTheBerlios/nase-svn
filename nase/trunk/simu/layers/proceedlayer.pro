;+
; NAME:                 ProceedLayer
;
; PURPOSE:              Führt einen Simulationszeitschritt durch (Schwellenvergleich), 
;                       der Input fuer die Layer muß vorher mit den jeweiligen
;                       Prozeduren InputLayer_x übergeben werden.
;                       ProceedLayer ist nur eine Rahmenprozedur, die dem
;                       Benutzer die Angabe des Layer-Typs erspart. 
;                       
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     ProceedLayer, Layer [,/CORRECT]  
;
; INPUTS:               Layer: eine durch InitLayer_x initialisierte Layer
;
; KEYWORD PARAMETERS:   CORRECT: Die Iterationsformel fuer den Leaky-Integrator erster Ordnung
;                               lautet korrekterweise: 
;                                           F(t+1)=F(t)*exp(-1/tau)+V/tau
;                               Das tau wird aber oft vergessen, was sehr stoerend sein kann, denn
;                               die Normierung bleibt so nicht erhalten. Das Keyword CORRECT fuehrt diese
;                               Division explizit aus.
;                       (VORSICHT: Dieses Keyword ist nicht bei allen Neuronentypen implementiert!) 
;
; COMMON BLOCKS:        common_random
;
; PROCEDURE:            ProceedLayer schaut nach dem Typ des übergebenen Layers (aus dem
;                       Layer.Type-String und ruft mit CALL_PROCEDURE die
;                       jeweilige spezielle ProceedLayer_x-Prozedur auf
;
; EXAMPLE:
;                       para1         = InitPara_1(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_1(5,5, para1)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_1, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer, InputLayer
;                       Print, 'Output: ', Out2Vector(InputLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.2  1998/11/04 14:45:28  thiel
;              Variablenzuweisung gespart.
;
;       Revision 2.1  1998/11/04 14:19:07  thiel
;              Neue Rahmenprozedur, die die korrekte
;              ProceedLayer_x-Prozedur selbstaendig
;              aufruft.
;
;- 

PRO ProceedLayer, Layer, CORRECT=correct

	Call_Procedure, 'ProceedLayer_'+Layer.Type, Layer, CORRECT=correct

END