;+
; NAME:
;  ObjMovieFrame__define
;
; VERSION:
;  $Id$
;
; AIM:
;  proviedes object to load and play crystal movie
;
; PURPOSE:
;  (When referencing this very routine in the text as well as all IDL
;  routines, please use <C>RoutineName</C>.)
;
; CATEGORY:
;  Animation
;  Files
;  Graphic
;  Input
;  NASE
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
;*a = obj_new("movieinput", anzx=AnzX, anzy=AnzY, filtergain=1., HoldFrameTime=1)
;*b = obj_new("objmovieframe", anzx=AnzX, anzy=AnzY, ExtractObjRef=a, frameNr=0, filterGain=-1)
;* tvscl, a->next()
;* tvscl, b->next()
;
; SEE ALSO:
;  <A>MovieInput__Define</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function Objmovieframe::next, nr
output = fltarr(self.anzX, self.anzY)
frame = (Self.ExtractObjRef)->GetFrame(Self.FrameNr, width=self.anzx, height=self.anzy)
if Self.Abs then frame = Self.filterGain*abs(frame) else frame = Self.filterGain*frame > 0
return, frame
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CONSTRUCTOR
function Objmovieframe::init, AnzX=AnzX, AnzY=AnzY, ExtractObjRef=ExtractObjRef, FilterGain=FilterGain, FrameNr=FrameNr, Abs=Abs, _EXTRA = e
;AnzX=AnzX, AnzY=AnzY, AnzElements=AnzElements

Default, AnzX, 5
Default, AnzY, 5
Default, ExtractionMode, 0
Default, FrameNr, 0
Default, Abs, 0
Self.Abs=Abs
Default, filterGain, 1.0
Self.FilterGain=FilterGain
Self.FrameNr=FrameNr

Self.AnzX = AnzX
Self.AnzY= AnzY
Self.ExtractObjRef = ExtractObjRef

return, 1
end




;;;;;;;;;;;;;DEFINE
pro Objmovieframe__Define

STRUCT = {OBJMOVIEFRAME, $
          ExtractObjRef: Obj_new(),$
          FrameNr:0L,$
          FilterGain:0.0,$
          Abs: 0,$
          AnzX:0,$
          AnzY:0}
end
