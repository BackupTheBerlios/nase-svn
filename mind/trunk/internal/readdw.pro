;+
; NAME:
;   ReadDW()
; 
; VERSION:
;   $Id$
;  
; AIM:
;   reads weight matrices created by <A>Sim</A>
;
; PURPOSE:
;   Reads weight matrices used/learned by a 
;   MIND simulation. This routine is used by
;   high-level routines like showdw.
;
; CATEGORY:
;  DataStorage
;  MIND
;
; CALLING SEQUENCE:
;*dw = ReadDW(DWindex [,/INIT] [,FILE=...])
;
; INPUTS:
;  DWindex:: the index of the weight matrix to be read
;
; INPUT KEYWORDS:
;  INIT:: reads the initial version of the weight matrix
;        (before the simulation modifies it)
;
; OUTPUTS:
;  dw:: the recovered DelayWeigh structure 
;
; OPTIONAL OUTPUTS:
;  FILE:: returns the filename used for loading
;
; SEE ALSO:
;  <A>ShowDW</A>, <A>UReadU</A>, <A>RestoreDW</A>
;        
;-
FUNCTION ReadDW, DWindex, INIT=init, FILE=file

   COMMON ATTENTION
   
   curDW = Handle_Val(P.DWW(DWindex))
   file = P.file+'.'+curDW.file
   IF Keyword_Set(INIT) THEN file = file + '.ini.dw' ELSE file = file + '.dw'
   
   tmp = UReadU(file, /COMPRESS)
   DW = RestoreDW(tmp)
   
   RETURN, DW
END
