;+
; NAME:
;  InitPrecall()
;
; AIM: Initialize list able to store pre-/postsynaptic spike time differences.
;
; PURPOSE: InitPrecall initialisiert eine Liste von prä- und postsynaptischen
;          Spikezeitpunkten, die später von <A HREF="#TOTALPRECALL">TotalPrecall</A> verwendet wird.
;          Ein Aufruf von InitPrecall ist also immer nötig, falls eine
;          Lernregel verwendet werden soll, die die Zeitdifferenz zwischen
;          prä- und postsynaptischem Spike als Grundlage von Gewichts- oder
;          Delayänderungen benutzt, also beispielsweise <A HREF="#LEARNBIPOO">LearnBiPoo</A> oder
;           <A HREF="#LEARNDELAYS">LearnDelays</A>. 
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE: pc = InitPrecall( dw, lw )
;
; INPUTS: dw: Die DW-Struktur, deren Verbindungen später gelernt werden 
;             sollen. Muß natürlich wie immer mit <A HREF="../CONNECTIONS/'INITDW">InitDW</A> erzeugt worden sein.
;         lw: Das Array, das Informationen über das Lernfenster enthält: 
;             lw=[tmaxpre,tmaxpost,deltapre,deltanull,deltapost]
;              tmaxpre=N_Elements(deltapre)
;             t maxpost=N_Elements(deltapost)
;              deltapre: Ein Array, das die Delayänderungen für die Fälle
;                        angibt, in denen postsynaptischer VOR präsynaptischem
;                        Spike auftritt.
;             deltanull: Die Delayänderung für gleichzeitiges Auftretn von prä-
;                        und postsynaptischem Spike.
;             deltapost: Ein Array, das die Delayänderungen für die Fälle 
;                        angibt, in denen postsynaptischer NACH präsynaptischem
;                        Spike auftritt.
;             Siehe dazu auch <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>.
;
;
; OUTPUTS: pc: Die initialisierte Precall-Struktur zur weiteren Behandlung mit
;              <A HREF="#TOTALPRECALL">TotalPrecall</A>. Folgende Tags sind in
;              pc enthalten:
;          pc = { info : 'precall',$
;                 time : 0l       ,$
;                 pre  : Make_Array(  preSize, deltamin, /LONG, VALUE=!NONEl) ,$
;                 post : Make_Array( postSize, deltamax, /LONG, VALUE=!NONEl) ,$
;                 deltamin : lw(0), $
;                 deltamax : lw(1), $
;                 spikesinpre : 0l, $
;                 spikesinpost: 0l ,$
;                 postpre   : -1l } ;this will become a handle
;
;
; EXAMPLE:
;   CON_L1_L1 = InitDW(S_LAYER=L1, T_LAYER=L1, $
;                      WEIGHT=0.3, /W_TRUNCATE, /W_NONSELF, DELAY=13)
;   LearnWindow = InitLearnBiPoo(POSTV=0.2, PREV=0.2)
;
;   PC_L1_L1 = InitPrecall(CON_L1_L1, LearnWindow)
;
;   <Simulationsschleife>
;      I_L1_L = DelayWeigh(CON_L1_L1, LayerOut(L1))
;
;      TotalPrecall, LP_L1_L1, CON_L1_L1, L1
;      LearnDelays, CON_L1_L1, LP_L1_L1, LearnWindow
; 
;
;      InputLayer, L1, FEEDING=I_L1_F, LINKING=I_L1_L
;      ProceedLayer, L1
;   <Simulationsschleife>
;
; SEE ALSO: <A HREF="#TOTALPRECALL">TotalPrecall</A>, <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>,  <A HREF="#LEARNBIPOO">InitLearnBiPoo</A>, <A HREF="#LEARNDELAYS">LeranDelays</A>.
;
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.3  2000/09/26 15:13:43  thiel
;           AIMS added.
;
;       Revision 1.2  1999/08/05 12:18:53  thiel
;           New structure to save more spikes.
;
;       Revision 1.1  1999/07/21 15:03:42  saam
;             + no docu yet
;

FUNCTION InitPrecall, DW, LW


   
   IF Info(DW) NE 'SDW_DELAY_WEIGHT' AND Info(DW) NE 'SDW_WEIGHT' THEN Message, 'Delay-Weight structure expected, but got a '+Info(DW)
   
   IF Set(LW) THEN BEGIN
      deltaMin = LW(0)
      deltaMax = LW(1)
   ENDIF ELSE BEGIN
      Message, 'Learning Window must be specified!'
   ENDELSE

   postSize = LONG(DWDim(DW, /TW))*LONG(DWDIM(DW, /TH))
   
   IF Info(DW) EQ 'SDW_WEIGHT' THEN preSize = LONG(DWDim(DW, /SW))*LONG(DWDIM(DW, /SH)) ELSE preSize = WeightCount(DW)

   
   PC = { info      : 'precall',$
          time      : 0l       ,$
          pre       : Make_Array(  preSize, lw(0), /LONG, VALUE=!NONEl) ,$
          post      : Make_Array( postSize, lw(1), /LONG, VALUE=!NONEl) ,$
          deltamin  : LW(0)                                   ,$
          deltamax  : LW(1)                                   ,$
          spikesinpre: 0l ,$
          spikesinpost: 0l ,$
          postpre   : -1l } ;this will become a handle
   
   RETURN, Handle_Create(!MH, VALUE=PC, /NO_COPY)

END
