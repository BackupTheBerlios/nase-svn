;+
; NAME:
;  MovieInput__Define
;
; VERSION:
;  $Id$
;
; AIM:
;  proviedes object to load and play crystal movie
;  
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
;* tvscl, a->next()
;*
;*>
;
; SEE ALSO:
;  <A>RoutineName</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


function MovieInput::GetFrame, nr, width=width, height=height
if nr lt Self.NFilters then begin
    if Width eq (*Self.OutputWidthArrayPtr)[nr] then begin
        return, *(*Self.LastFileFramePtr)[nr]
    endif else begin
        if Width gt (*Self.OutputWidthArrayPtr)[nr]  then begin    
            outframe = fltarr(width,height)
            outframe[0:(*Self.OutputWidthArrayPtr)[nr]-1, 0:(*Self.OutputHeightArrayPtr)[nr]-1]=*(*Self.LastFileFramePtr)[nr]
            return, outframe
        endif else begin
            return, (*(*Self.LastFileFramePtr)[nr])[0:self.width-1,0:self.height-1]
        endelse
    endelse
endif

end

function MovieInput::Next, Nr
if Self.HoldFrameCount le 1 then begin
    Self.HoldFrameCount = Self.HoldFrameTime
    if (self.Fileloaded eq 1) then begin
        if not eof(self.lun) then begin
        endif else begin
            self->FreePtr
            self->LoadFile
 ;           return, fltarr(self.width, self.height)            
        endelse
    endif else begin
        self->FreePtr
        self->LoadFile
;        return, fltarr(self.width, self.height)
    endelse

    for i=0, Self.nfilters-1 do begin
;            outframe = fltarr((*Self.OutputWidthArrayPtr)[i], (*Self.OutputHeightArrayPtr)[i])
;            readu, self.lun, outframe
        readu, self.lun, *(*Self.LastFileFramePtr)[i]
    endfor


    
    if self.Abs then frame=Self.FilterGain*abs(*(*Self.LastFileFramePtr)[0]) else frame = Self.FilterGain * (*(*Self.LastFileFramePtr)[0]) > 0

    if self.Width eq (*Self.OutputWidthArrayPtr)[0] then begin
        *Self.LastFramePtr = frame
    endif else begin
        if self.Width gt (*Self.OutputWidthArrayPtr)[0]  then begin    
            (*Self.LastFramePtr)[0:(*Self.OutputWidthArrayPtr)[0]-1, 0:(*Self.OutputHeightArrayPtr)[0]-1]=frame
        endif else begin
            (*Self.LastFramePtr) = frame[0:self.width-1,0:self.height-1]
        endelse
    endelse
endif else begin
    Self.HoldFrameCount = Self.HoldFrameCount - 1    
endelse

return, *Self.LastFramePtr

end


pro MovieInput::Loadfile

odepth=0l
owidth=0l
oheight=0l
fwidth=0l
fheight=0l
nfilters=0l
outputwidth=0l
outputheight=0l

wshift=0l
hshift=0l
if Self.FileLoaded eq 0 then begin
    openr, lun, Self.filename, /get_lun
    self.lun=lun
    MindFileHeader = csMindMovieFileHeader()
;    readu,  lun, odepth, owidth, oheight, nfilters
    readu,  lun, MindFileHeader
    nFilters = MindFileHeader.Nfilter
    owarray = lonarr(nfilters)
    oharray = lonarr(nfilters)
    Self.LastFileFramePtr = ptr_new(ptrarr(nfilters))   
    for i=0, nfilters-1 do begin
        readu, lun, fwidth, fheight
        readu, lun, wshift, hshift
        readu, lun, outputwidth, outputheight
        print, "ow=", outputwidth, "  oh=", outputheight
;        print, "wshift=", wshift, " hshift=", hshift
        owarray[i] = outputwidth
        oharray[i] = outputheight
        filter = fltarr(fwidth,fheight)
        readu, lun, filter
        (*Self.LastFileFramePtr) [i]= ptr_new(fltarr(owarray[i], oharray[i]))
    endfor
endif else print, "movieinput::loadfile: File allready loaded"

Self.OutputWidthArrayPtr = ptr_new(owarray)
Self.OutputHeightArrayPtr = ptr_new(oharray)
Self.Nfilters = Nfilters

self.fileLoaded= 1
;return, 1
end

pro MovieInput::FreePtr
if self.FileLoaded eq 1 then begin
    Close, Self.Lun
    Free_Lun, Self.Lun
    Self.FileLoaded=0
endif
ptr_free, self.OutputWidthArrayPtr, self.OutputHeightArrayPtr
for i=0, self.nfilters-1 do ptr_free, (*Self.LastFileFramePtr)[i]
ptr_free, self.lastfileframeptr
end

pro MovieInput::Cleanup
self->freePtr
end

function MovieInput::init, AnzX=Width, AnzY=Height, FileName=FileName, FilterGain=FilterGain, HoldFrameTime=HoldFrameTime, Abs=ABS
default, filename, "/home/frank/prog/crystal/csobjmovie/crystal000.idlmov"
default, Width, 40
default, Height, 40
default, HoldFrameTime, 10
default, Abs, 0
Self.Abs=Abs
default, FilterGain, 1
Self.filterGain = filterGain
print, "init movieinput"
Self.Width=Width
Self.Height=Height
Self.FileName=fileName
Self.FileLoaded=0
Self.HoldFrameTime=HoldFrameTime
Self.HoldFrameCount=Self.HoldFrameTime
Self.LastFramePtr = ptr_new(fltarr(Self.Width, Self.Height))
self->LoadFile
return, 1
end


pro MovieInput__define

STRUCT = {MOVIEINPUT, $
          Width:0,$
          Height:0,$
          FileName: 'outupt.vid',$
          FileLoaded:0,$
          Lun: 0L,$
          Nfilters:0,$
          HoldFrameTime:0,$
          HoldFrameCount:0,$
          FilterGain: 0.0,$
          Abs:0,$
          LastFramePtr: Ptr_new(),$
          LastFileFramePtr: ptr_new(),$
          OutputWidthArrayPtr: Ptr_new(),$
          OutputHeightArrayPtr: Ptr_new(),$
          FrameNumber:0L}
end
