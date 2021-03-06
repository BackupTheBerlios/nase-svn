;+
; NAME:
;  LearnUse
;
; AIM: Learn use parameter of dynamical synapses using spike time differences.
;
; PURPOSE:            Aendern von U_se in Abhaengigkeit der
;                     Aktivitaeten in Source- und Targetcluster.
;                     Genauer gesagt:
;
;                       deltaW(post,prae)=Lernfenster(t_post-t_prae)
;                       neuW(post,prae)=altW(post,prae) + deltaW(post,prae)   
;
;                     dabei sind t_post und t_prae die Zeiten prae- bzw.
;                     postsynaptischer Aktivitaet.                    
;                     Das Lernfenster muss vorher mit InitLearnBiPoo definiert worden sein...
;
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE:     LearnUse, G, LP, LearnWindow
;                                  [,DELEARN=delearn] [,/SELF] [,/NONSELF] 
;                                    
; INPUTS:             G           : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder 
;                                   InitWeights erzeugte Struktur) 
;                     LP          : Eine mit InitPrecall initialisierte Lernpotential-Struktur
;                     LearnWindow : Ein mit InitLearnBiPoo erzeugtes Lernfenster
;
; KEYWORD PARAMETERS:
;
;                    
;                     DELEARN   : Gewichte werden jeden Zeitschritt um
;                                 DELEARN verringert, es findet aber keine Umwandlung
;                                 von exc. in inh. Synapsentypen statt, d.h. MIN(wij)=0;
;                                 default is 0.0
;                     SELF      : Verbindungen zwischen Neuronen mit gleichen Index 
;                                 werden gelernt. Dies ist die Default-Einstellung,  
;                                 /SELF muss also nicht angegeben werden
;                     NONSELF   : Verbindungen zwischen Neuronen mit gleichem Index
;                                 werden nicht veraendert,
;                                 aber auch nicht Null-gesetzt.
;                                 (Siehe InitDW)
;
;
; EXAMPLE:      LearnWindow =  InitLearnBiPoo(postv=0.0001,posttau=10,prev=0.0001,pretau=10)
;               LP = InitPrecall(DW_structure,LearnWindow)
;               ...
;               Totalprecall, LP,DW_structure, target_layer
;               LearnUse, DW_structure, LP,LearnWindow
;               ...               
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/09/26 15:13:43  thiel
;         AIMS added.
;
;     Revision 2.1  1999/11/05 13:19:30  alshaikh
;           initial version
;



PRO Learnuse, _DW, _PC, LW, SELF=Self, NONSELF=NonSelf, DELEARN=delearn
  

   Handle_Value, _PC, PC, /NO_COPY
   Handle_Value, PC.postpre, ConTiming, /NO_COPY

   IF ConTiming(0) EQ !NONEl THEN BEGIN
      Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
      Handle_Value, _PC, PC, /NO_COPY, /SET
      RETURN
   END

   Handle_Value, _DW, DW, /NO_COPY

   IF Set(DELEARN) THEN BEGIN
      DW.U_se = (DW.U_se - DELEARN) > 0.0

END



   wi = ConTiming(*,0)
   FOR i=0, N_Elements(wi)-1 DO BEGIN
      DW.U_se(wi(i)) = (((DW.U_se(wi(i)) + LW(2+ConTiming(i,1)+LW(0)))) < 1) > 0


   ENDFOR


   Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
   Handle_Value, _PC, PC, /NO_COPY, /SET
   Handle_Value, _DW, DW, /NO_COPY, /SET

END
