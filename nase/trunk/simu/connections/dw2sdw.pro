;+
; NAME:               DW2SDW
;
; PURPOSE:            Wandelt ein DW[_DELAY]_WEIGHT-Struktur in eine
;                     SDW[_DELAY]_WEIGHT-Struktur um. 
;                     Diese Routine dient der INTERNEN Organisation
;                     der DW-Strukturen und sollte nur benutzt werden,
;                     WENN MAN WIRKLICH WEISS, WAS MAN TUT!!
;
;                     Bemerkung: DW2SDW ersetzt Init_SDW
;
; CATEGORY:           INTERNAL SIMU CONNECTIONS
;
; CALLING SEQUENCE:   DW2SDW, DW
;
; INPUTS:             DW: eine DW[_DELAY]_WEIGHT-Struktur
;
; OUTPUTS:            DW: die neue SDW[_DELAY]_WEIGHT-Struktur
;
; SIDE EFFECTS:       DW wird veraendert
;
; SEE ALSO:           <A HREF='#SDW2DW>SDW2DW</A>, <A HREF='#INITDW>InitDW</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/02/05 14:17:40  saam
;          loop variables now long
;
;     Revision 2.1  1998/02/05 11:36:17  saam
;           Cool
;
;
;-

PRO DW2SDW, _DW

   IF (Info(_DW) NE 'DW_DELAY_WEIGHT') AND (Info(_DW) NE 'DW_WEIGHT') THEN Message, 'DW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_DW))+' !'

   sS = DWDim(_DW, /SW) * DWDim(_DW, /SH)
   tS = DWDim(_DW, /TW) * DWDim(_DW, /TH)
   
   Handle_Value, _DW, DW
   FreeDW, _DW
   _DW = Handle_Create(!MH)

   ; eW : positions existinging weights
   ; eWc: number of existinging weights
   eW = WHERE(DW.Weights NE !NONE, eWc)

   ; iw : array which provides indices to the existing weights
   iW = LonArr(tS, sS)
   IF eWc NE 0 THEN  iW(eW) = LIndGen(eWc)


   ; create  SourceNr->Cons
   s2c = Make_Array(sS, /LONG, VALUE=-1)
   FOR s=0l, sS-1 DO BEGIN
      wtn = WHERE(DW.Weights(*,s) NE !NONE, c)
      IF c NE 0 THEN s2c(s) = Handle_Create(_DW, VALUE=iW(wtn,s))
   ENDFOR 
   
   ; create  TargetNr->Cons
   t2c = Make_Array(tS, /LONG, VALUE=-1)
   FOR t=0l, tS-1 DO BEGIN
      wsn = WHERE(DW.Weights(t,*) NE !NONE, c)
      IF c NE 0 THEN t2c(t) = Handle_Create(_DW, VALUE=iW(t,wsn))
   ENDFOR 
   
   
   ; create Cons->Source and Cons->Target
   IF eWc NE 0 THEN BEGIN
      c2s = eW  /  tS
      c2t = eW MOD tS 
   END ELSE BEGIN
      c2s = -1
      c2t = -1
   END

   ; create delay list if needed
   IF eWc NE 0 THEN W = DW.Weights(eW) ELSE W = -1

   IF Contains(Info(DW), 'DELAY') THEN BEGIN            
      IF eWc NE 0 THEN D = DW.Delays(eW) ELSE D = -1
      

      DW = {  info    : 'SDW_DELAY_WEIGHT',$
              source_w: DW.source_w,$
              source_h: DW.source_h,$
              target_w: DW.target_w,$
              target_h: DW.target_h,$
              s2c     : s2c        ,$
              c2s     : c2s        ,$
              t2c     : t2c        ,$
              c2t     : c2t        ,$              
              W       : W          ,$
              D       : D          ,$
              Queue   : InitSpikeQueue( INIT_DELAYS=D ),$
              Learn   : -1          }
   END ELSE BEGIN
      DW = {  info    : 'SDW_WEIGHT',$
              source_w: DW.source_w,$
              source_h: DW.source_h,$
              target_w: DW.target_w,$
              target_h: DW.target_h,$
              s2c     : s2c        ,$
              c2s     : c2s        ,$
              t2c     : t2c        ,$
              c2t     : c2t        ,$              
              W       : W          ,$
              Learn   : -1          }
   END
   Handle_Value, _DW, DW, /NO_COPY, /SET



END
