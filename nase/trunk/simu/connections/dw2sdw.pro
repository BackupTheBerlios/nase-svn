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
;     Revision 2.11  1999/10/12 14:36:49  alshaikh
;           neues keyword '/depress'... synapsen mit kurzzeitdepression
;
;     Revision 2.10  1999/07/27 16:23:43  thiel
;         DW.queuehdl: A handle to a spikequeue.
;
;     Revision 2.9  1998/04/06 16:05:10  saam
;           eats up less memory now
;
;     Revision 2.8  1998/03/19 11:38:52  thiel
;            Der .W-Tag ist jetzt immer ein Array, auch wenn er
;            nur ein Element enthaelt.
;
;     Revision 2.7  1998/03/14 14:12:19  saam
;           handling of empty dw-structures now works
;
;     Revision 2.6  1998/02/11 18:03:37  saam
;           neuer Tag brachte keine Effizienz --> wieder weg
;
;     Revision 2.5  1998/02/11 15:46:23  saam
;           Bug korrigiert
;
;     Revision 2.4  1998/02/11 15:43:11  saam
;           Geschwindigkeitsoptimierung durch eine neue Liste
;           die source- auf target-Neuronen abbildet
;
;     Revision 2.3  1998/02/05 14:29:51  saam
;           another int <-> long problem
;
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

   dims = DWDim(_DW, /ALL)
   sS = dims(0) * dims(1)
   tS = dims(2) * dims(3)
   
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

; depression:
; Kompatibilitaet mit alten DW-strukturen. Pruefen, ob 'depress' existiert   
IF NOT ExtraSet(DW,'depress') THEN depress = 0 else depress =  DW.depress

   IF depress EQ 1 THEN BEGIN
      tau_rec =  DW.tau_rec
      U_se    =  DW.U_se
      exp_array = exp(-indgen(4*tau_rec+1)/tau_rec) 
   END ELSE depress = 0


   ; create delay list if needed
   IF eWc NE 0 THEN W = DW.Weights(eW) ELSE W = Make_Array(1,1, /FLOAT, VALUE=!NONE)


   IF depress EQ 1 THEN BEGIN 
   ; relative amount of transmitters for each connection (initial : transm = 1)  
      TRANSM = W * 0 + 1  ; i.e. transm=[1,1,1....]
   ; for each connection : time since last activity   
      LAST_AP = w * 0     ; i.e. last_ap=[0,0,0,0...]    
   END



   IF Contains(Info(DW), 'DELAY') THEN BEGIN            
         IF eWc NE 0 THEN D = DW.Delays(eW) ELSE D = Make_Array(1,1, /FLOAT, VALUE=0)
         
         
         
         DW = 0                 ; limit memory hunger
         DW = {  info    : 'SDW_DELAY_WEIGHT',$
                 source_w: dims(0)           ,$
                 source_h: dims(1)           ,$
                 target_w: dims(2)           ,$
                 target_h: dims(3)           ,$
                 s2c     : s2c               ,$
                 c2s     : c2s               ,$
                 t2c     : t2c               ,$
                 c2t     : c2t               ,$              
                 W       : [W]               ,$
                 D       : [D]               ,$
                 depress : depress           ,$
                

                 queuehdl: Handle_Create(VALUE=InitSpikeQueue( INIT_DELAYS=D )),$
                 Learn   : -1l         }
         
         
      END ELSE BEGIN
         DW = 0                 ; limit memory hunger
         DW = {  info    : 'SDW_WEIGHT',$
                 source_w: dims(0)     ,$
                 source_h: dims(1)     ,$
                 target_w: dims(2)     ,$
                 target_h: dims(3)     ,$
                 s2c     : s2c         ,$
                 c2s     : c2s         ,$
                 t2c     : t2c         ,$
                 c2t     : c2t         ,$              
                 W       : [W]         ,$
                 depress : depress     ,$
               
                 Learn   : -1l         }
      END
      
      IF depress EQ 1 THEN BEGIN
         settag,dw, 'U_se',U_se
         settag,dw, 'tau_rec', tau_rec
         settag,dw, 'transm',[transm]
         settag,dw, 'last_ap',[last_ap]
         settag,dw, 'exp_array', [exp_array]
    
 end

   Handle_Value, _DW, DW, /NO_COPY, /SET



END
