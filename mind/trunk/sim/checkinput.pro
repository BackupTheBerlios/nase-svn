;+
; NAME:
;  CheckInput
;
; VERSION:
;  $Id$
; 
; AIM:
;  runs a simulation only generating and visualizing input
;
; PURPOSE:
;  allows to simulate the generated input within one period
;  without simulating learning, connections...  
;
; CATEGORY:
;  Input
;  MIND
;  Simulation
;
; CALLING SEQUENCE: 
;  CheckInput [,NUMBER=number] [,VIZ_MODE=viz_mode] [,/DYNAMIC]
;
; 
; INPUT KEYWORDS:
;   NUMBER   :: index of the input
;   VIZ_MODE :: array of #FILTER int's,
;                       determines visualization-mode :
;                       plottvscl (1), 
;                       surface (2),
;                       trainspottingscope (3)
;   DYNAMIC:: normally only one sample input is shown. If you want
;             to watch the dynamics of your input, use this option.    
; 
; SEE ALSO:
;   have a look at <A>Sim</A> for additional keywords
;
;-

PRO _CHECKINP, WSTOP=WSTOP, _EXTRA=e,NUMBER=number,viz_mode=viz_mode, DYNAMIC=dynamic



Default, viz_mode, [1,1,1,1,1,1,1,1,1]
Default, NUMBER, 0


   COMMON SH_SIM, SIMwins, CSIM_1, CSIM_2, CSIM_3, CSIM_4, CSIM_5, CSIM_6, CSIM_7, CSIM_8
   COMMON COMMON_Random, seed
   COMMON ATTENTION
   COMMON SH_INPUT, INPUTwins, INPUT_1

 
   
  ;----->
  ;-----> GLOBAL DEFINES
  ;----->
  
   uclose, /all

   IF ExtraSet(e, 'NOGRAPHIC') THEN graphic = 0 ELSE graphic = 1

   Lmax  = N_Elements(P.LW)-1
   OS = 1./(1000*P.SIMULATION.SAMPLE)

   ;-------------> INIT LAYERS
   L = LonArr(Lmax+1)
   FOR i=0, Lmax DO BEGIN
      curLayer = Handle_Val(P.LW(i))
      tmp = curLayer.NPW
      ;tmp2 = InitPara_6(TAUF=[tmp.tf1,tmp.tf2], TAUL=[tmp.tl1,tmp.tl2], TAUI=tmp.ti, VS=tmp.vs, TAUS=tmp.ts, VR=tmp.vr, TAUR=tmp.tr, TH0=tmp.t0, SIGMA=tmp.n, NOISYSTART=tmp.ns, OVERSAMPLING=os, SPIKENOISE=tmp.sn, FADE=tmp.fade)

       ; this line was replaced by the following three

      NAME = tmp.INFO           ; name of init-routine
      deltag, tmp, 'INFO'     ; remove this name from structure
      tmp2 =  CALL_FUNCTION(NAME,_EXTRA=tmp)


      L(i) = InitLayer(WIDTH=curLayer.w, HEIGHT=curLayer.h, TYPE = tmp2)
      console,P.CON, 'LAYER: '+curLayer.NAME+ ', '+STR(curLayer.w)+'x'+ STR(curLayer.h),/msg
   END
   
   console,P.CON, 'Initializing simulation...',/msg

   ;--------------> INIT INPUT
   INmax = N_Elements(P.INPUT)-1
   IN = LonArr(INmax+1)
 
   FOR i=0,INmax DO BEGIN
      callstring = ''
      IN(i) = InitInput(L, P.INPUT(i), calls, calll, _EXTRA=e)
   END
   
   handle_value,in(number),inn
   period = inn.period
   IF period EQ -1 THEN period = P.SIMULATION.time
   delta_t =   INN.delta_t      ; resolution in ms
   IF delta_t EQ -1 THEN delta_t = P.SIMULATION.SAMPLE*1000.0
   Handle_Value, P.INPUT(INN.INDEX), INP
   curLayer = Handle_Val(P.LW(INP.LAYER))
   w  = curLayer.w
   h  = curLayer.h
   
   window,0,/Pixmap, XSize=256, YSize=256
   
   ts = lonarr(inn.number_filter)
   j = INn.number_filter
   
   sheet =  DefineSheet(/window,/verbose,xsize=256,ysize=256,colors=256,xpos=10,ypos=10,multi=[j,3,(1+j)MOD 3])
   




   number_filter =  INn.number_filter
   FOR j=0,INn.number_filter-1 DO BEGIN    
      IF viz_mode[j] EQ 3 THEN BEGIN
         opensheet,sheet,j
         TS(j) = InitTrainspottingScope(NEURONS=w*h, TIME=period*FIX(1./delta_t)+1,/nonase, OVERSAMPLING=FIX(1./delta_t))
         closesheet,sheet,j
      END 
      
   ENDFOR 

;------------->
;-------------> MAIN SIMULATION ROUTINE
;------------->

   console, P.CON, 'Starting main simulation loop...',/msg
   


   

   number_filter =  INn.number_filter

   ; to display what the filters itself have to show
   FilterSheet =  DefineSheet(/window,TITLE='Filter Definitions', xsize=512,ysize=512,colors=256,multi=[j,3,(1+j)MOD 3])



   IF Keyword_Set(DYNAMIC) THEN BEGIN
       FOR time=0l, (p.simulation.time/(1000.0*P.SIMULATION.SAMPLE))-1 DO BEGIN 
           
           act_time =  round(time*1000*1000*P.SIMULATION.SAMPLE) MOD round(period*1000) ; time in microsec ;-)
           
           IF ((act_time) MOD round(delta_t*1000) EQ 0) THEN BEGIN
               
               pattern = fltarr(h,w) ; initialize input-matrix
               
               filter_list = ''
               FOR i=0, number_filter-1 DO BEGIN
                   Handle_Value,INn.filters(i),act_filter 
                   IF i NE 0 THEN filter_list =  filter_list +'*'
                   filter_list = filter_list + act_filter.NAME
                   
                   IF ((act_time/1000.0 GE act_filter.start) AND (act_time/1000.0 LE act_filter.stop)) THEN BEGIN 
                       IF act_time/1000.0 EQ act_filter.start THEN BEGIN ; initialize filter
                           OpenSheet, FilterSheet, i
                           IF ExtraSet(act_filter, 'PARAMS') THEN BEGIN
                               temp = CALL_FUNCTION(act_filter.NAME,$
                                                    MODE=0,PATTERN=pattern,WIDTH=w,HEIGHT=h,_EXTRA=act_filter.params,$
                                                    temp_vals=INn.temps(i),DELTA_T=delta_t) 
                               dummy = CALL_FUNCTION(act_filter.NAME,$
                                                     MODE=3,PATTERN=pattern,WIDTH=w,HEIGHT=h,_EXTRA=act_filter.params,$
                                                     temp_vals=INn.temps(i),DELTA_T=delta_t) 
                           END ELSE BEGIN
                               temp = CALL_FUNCTION(act_filter.NAME,$
                                                    MODE=0,PATTERN=pattern,WIDTH=w,HEIGHT=h,$
                                                    temp_vals=INn.temps(i),DELTA_T=delta_t) 
                               dummy = CALL_FUNCTION(act_filter.NAME,$
                                                     MODE=3,PATTERN=pattern,WIDTH=w,HEIGHT=h,$
                                                     temp_vals=INn.temps(i),DELTA_T=delta_t) 
                           ENDELSE  
                           ULoadct,0
                           CloseSheet, FilterSheet, i
                       ENDIF  
                                ; ELSE NextStep 
                       IF ((act_time/1000.0 GE act_filter.start) AND (act_time/1000.0 LE act_filter.stop)) THEN $
                         pattern = CALL_FUNCTION(act_filter.NAME,$
                                                 PATTERN=pattern, temp_vals=INn.temps(i)) 
                       
                       IF act_time/1000.0 eq act_filter.stop THEN console, P.CON,'INPUT:filter '''+act_filter.NAME+''' inactive',/msg
                       
                       INn.pattern = pattern ; store for future use
                       
                       
                       IF viz_mode[i] EQ 3 THEN BEGIN 
                           opensheet,sheet,i
                           trainspottingscope,ts(i),INN.pattern
                           closesheet,sheet,i
                       END ELSE BEGIN 
                           
                           IF i NE 0 THEN title = filter_list $
                           ELSE $
                             title = filter_list+string((act_time/1000.0))
                           wset,0
                           IF viz_mode[i] EQ 1 THEN $
                             PlotTvScl, INn.pattern,TITLE=title
                           IF viz_mode[i] EQ 2 THEN $
                             surface, INn.pattern,TITLE=title
                           
                           opensheet, sheet,i               
                           Device,Copy=[0,0,256,256,0,0,0]
                           closesheet,sheet,i
                       END
                       
                   ENDIF  
               ENDFOR 
           ENDIF 
           
           
           handle_value,in(number),inn,/set
                                ;INn.t = INn.t + 1
           
           
       ENDFOR  
   END ELSE BEGIN
       pattern = fltarr(h,w)    ; initialize input-matrix
       FOR i=0, number_filter-1 DO BEGIN
           Handle_Value,INn.filters(i),act_filter 
           filter_list = ''
           IF i NE 0 THEN filter_list =  filter_list +'*'
           filter_list = filter_list + act_filter.NAME
           
           OpenSheet, FilterSheet, i
           IF ExtraSet(act_filter, 'PARAMS') THEN BEGIN
               temp = CALL_FUNCTION(act_filter.NAME,$
                                    MODE=0,PATTERN=pattern,WIDTH=w,HEIGHT=h,_EXTRA=act_filter.params,$
                                    temp_vals=INn.temps(i),DELTA_T=delta_t) 
               dummy = CALL_FUNCTION(act_filter.NAME,$
                                     MODE=3,PATTERN=pattern,WIDTH=w,HEIGHT=h,_EXTRA=act_filter.params,$
                                     temp_vals=INn.temps(i),DELTA_T=delta_t) 
           END ELSE BEGIN
               temp = CALL_FUNCTION(act_filter.NAME,$
                                    MODE=0,PATTERN=pattern,WIDTH=w,HEIGHT=h,$
                                    temp_vals=INn.temps(i),DELTA_T=delta_t) 
               dummy = CALL_FUNCTION(act_filter.NAME,$
                                     MODE=3,PATTERN=pattern,WIDTH=w,HEIGHT=h,$
                                     temp_vals=INn.temps(i),DELTA_T=delta_t) 
           ENDELSE  
           ULoadct,0
           CloseSheet, FilterSheet, i

           pattern = CALL_FUNCTION(act_filter.NAME,$
                                       PATTERN=pattern, temp_vals=INn.temps(i)) 
           pattern = CALL_FUNCTION(act_filter.NAME,$
                                       PATTERN=pattern, temp_vals=INn.temps(i)) 
           
           IF viz_mode[i] EQ 3 THEN BEGIN 
               opensheet,sheet,i
               trainspottingscope,ts(i),pattern
               closesheet,sheet,i
           END ELSE BEGIN 
               
               IF i NE 0 THEN title = filter_list $
               ELSE $
                 title = filter_list
               wset,0
               IF viz_mode[i] EQ 1 THEN $
                 PlotTvScl, pattern,TITLE=title
               IF viz_mode[i] EQ 2 THEN $
                 surface, pattern,TITLE=title
               
               opensheet, sheet,i               
               Device,Copy=[0,0,256,256,0,0,0]
               closesheet,sheet,i
           END
           
       ENDFOR  
   END
   

    
    IF ExtraSet(e,'WAIT') THEN BEGIN
       print, "--> I'm waiting for you <--"
      dummy =  get_kbrd(1)
   END

   ;-------------> FREE MEMORY
   FOR i=0, INmax DO FreeInput, IN(i)
   FOR i=0, Lmax DO FreeLayer, L(i)

   ;-------------> FREE SHEETS AND TRAINSPOTTINGSCOPES
   FOR j=0,INn.number_filter-1 DO BEGIN
      IF viz_mode(j) EQ 3 THEN FreeTrainspottingscope,ts(j)
   ENDFOR 
   
   
   print, "--> d: deletes sheets, other key to continue<--"
   dummy =  get_kbrd(1)
   IF dummy EQ 'd' THEN BEGIN
       DestroySheet,sheet
       DestroySheet, FilterSheet
   END
END 
 


PRO CHECKINPUT, _EXTRA=e
   
   iter = foreach('_CHECKINP', _EXTRA=e)

END
