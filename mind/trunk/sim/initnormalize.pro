;+
; NAME:
;  InitNormalize
;
; VERSION:
;  $Id$
;
; AIM:
;  Prepares weight normalization (used by <A>Sim</A>).
;
; PURPOSE:
; For all learning structures wich contain a 'Normalize' structure
; <A>NormalizeWeights</A> is called one time with paramter '/all'. All
; weights are normalized one time, so the weight sum ist constant from
; the begining on.
;
;
; CATEGORY:
;  Algebra
;  Animation
;  Array
;  Color
;  CombinationTheory
;  Connections
;  DataStorage
;  DataStructures
;  Demonstration
;  Dirs
;  ExecutionControl
;  Files
;  Fonts
;  Graphic
;  Help
;  Image
;  Input
;  Internal
;  IO
;  Layers
;  Math
;  MIND
;  NASE
;  NumberTheory
;  Objects
;  OS
;  Plasticity
;  Startup
;  Statistics
;  Signals
;  Simulation
;  Strings
;  Structures
;  Widgets
;  Windows
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
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
;*
;*>
;
; SEE ALSO:
;  <A>RoutineName</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

PRO InitNormalize, MaxWin,_CON, _LS, _EXTRA=e
   
On_Error, 2

COMMON ATTENTION
COMMON SH_LEARN, LEARNwins, LEARN_1, LEARN_2, LEARN_3, LEARN_4
  
FOR LLoop=0, MaxWin-1 DO BEGIN  ; Layer-Loop
  
    Handle_Value, _LS(LLoop), LS, /NO_COPY
    TestInfo,LS,'LEARN'
    
      
    curDW = Handle_Val(P.DWW(LS.DW))
    
    if ExtraSet(LS, 'NORMALIZE') then begin
        curDW = Handle_Val(_CON(LS.DW))
       NormalizeWeights, _Con(LS.DW), $
                         WeightSum=LS.NORMALIZE.WeightSum,$
                         nolowsum=LS.NORMALIZE.NoLowSum, $
                         quadratic=LS.NORMALIZE.Quadratic, $
                         ALL=1
    endif
   

    Handle_Value, _LS(LLoop),LS,/NO_COPY,/SET
ENDFOR                          ; LLoop
   
  
END
