;+
; NAME: IFInputObjWrapper
;
; VERSION:
;  $Id$
;
; AIM: A Wrapper for using an Input-Generator-Object as Input-Filter
; in Mind  
;
; PURPOSE: A Wrapper for using an Input-Generator-Object as Input-Filter
; in Mind. It creates an set of input objects (see
; <A>seqobjinput__define</A> and <A>seqobject__define</A>). Each input object consists of a grid of
; sequence elements (see <A>seqelement__define</A>).
;
; CATEGORY:
;  Input
;  Internal
;  MIND
;  NASE
;  Objects
;  Simulation
;
; CALLING SEQUENCE:
;*result = FunctionName( par [,optpar] [,/SWITCH] [,KEYWORD=...] )
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*  MFILTER(2) = Handle_Create(!MH, $
;*                              VALUE={NAME: 'ifinputobjwrapper', $
;*                              start: 0L, $
;*                              stop: 20000L, $
;*                              params: {InputObjName:'SeqObjInput',$
;*                                       AnzElements:3,$
;*                                       AnzStimX:3,$
;*                                       AnzStimY:1,$
;*                                       AnzSeqObjects:2,$
;*                                       AnzX:InputWidth,$
;*                                       AnzY:InputHeight,$
;*                                       StimSize:2,$
;*                                       DefaultPattern:2,$
;*                                       StimIntensity:0.4,$
;*                                       DriftSpeed: 100,$
;*                                       JumpSpeed: 2000}})
;*
;
; SEE ALSO:
;  <A>seqobjinput__define</A>, <A>seqobject__define</A>, <A>seqelement__define</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document



FUNCTION IFInputObjWrapper, $
  MODE=mode, $
  PATTERN=pattern, $
  InputIndexNumber=nr,$
  WIDTH=w, $
  HEIGHT=h, $
  TEMP_VALS=_TV, $
  DELTA_T=delta_t, $
  FILE=file, $
  WRAP=wrap, $
;  INPUTPATTERNS = ipa, $
  InputObjName=InputObjName, $
  _EXTRA = e

   COMMON ATTENTION
   ON_ERROR, 2

   Default, mode , 1          ; i.e. step
   Default, R    , !NONE
   Default, op   , 'ADD'
   Default, value, 0.0
   Default, file, ''
   Default, wrap, 0

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      

          ;;ToDo: Parameter auf Konsistenz prüfen!!
;          Sipa = size(ipa)
;          if ((Sipa[0] ne 3) or (Sipa[2] ne w) or (Sipa[3] ne h)) then stop
;          input = obj_new('InputGen', ipa, _Extra=e)
;          input = obj_new(InputObjName, ipa, _Extra=e)  ;
          dummy = typeOf(TV, Index=TVtype)
          if TVType ne 8 then begin
              input = obj_new(InputObjName, _Extra=e) ;
              TV =  { MyInputObject   : input}
          endif
      END
      
      ; STEP
      1: BEGIN                             
          R = TV.MyInputObject->next(nr)
      END
      
      ; FREE
      2: BEGIN
          obj_destroy, TV.MyInputObject
         console, P.CON, 'done'
      END 

      ; PLOT
      3: BEGIN
         console, P.CON, 'display mode not implemented, yet', /WARNING
      END
      ELSE: BEGIN
         console, P.CON, 'unknown mode', /FATAL
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
