;+
; NAME:
;  seqobjinput__define
;
; VERSION:
;  $Id$
;
; AIM:
;  handle multiple sequence objects
;
; PURPOSE:
; <C>seqobjinput__define</C> provides an object, which can handle
; multiple sequence objects.  It creates an set of input objects (see
; <A>seqobject__define</A>). Each input object consists of a grid of
; sequence elements (see <A>seqelement__define</A>).
;
; CATEGORY:
;  Input
;  MIND
;  NASE
;  Objects
;  Simulation
;
; CALLING SEQUENCE:
;*result = obj_new('seqobjinput')
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
;  <A>seqobject__define</A>, <A>seqelement__define</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

;;;;;;;;;;;;;;;;;;;;JUMP
pro Seqobjinput::Jump
COMMON COMMON_Random, seed

self.CurGroup =  floor(self.AnzGroups*randomu(seed))
;print, self.curgroup
;if self.CurGroup eq 1 then stop
self.CurNum = (*self.groupsPtr)[0,self.CurGroup] + $
                        floor((1+(*self.groupsPtr)[1,self.CurGroup] - $
                        (*self.groupsPtr)[0,self.CurGroup])*randomu(seed))

end


;;;;;;;;;;;;;;;;;DRIFT
pro Seqobjinput::Drift
COMMON COMMON_Random, seed

if self.direction eq 1 then begin
    if (self.CurNum ge (*self.groupsPtr)[1,self.CurGroup]) or (self.CurNum lt (*self.groupsPtr)[0,self.CurGroup]) then begin
        self.CurNum =  (*self.groupsPtr)[0,self.CurGroup] 
    endif else begin
        self.CurNum = self.CurNum + 1
    endelse
endif else begin
    if (self.CurNum le (*self.groupsPtr)[0,self.CurGroup]) or (self.CurNum gt (*self.groupsPtr)[1,self.CurGroup]) then begin
        self.CurNum =  (*self.groupsPtr)[1,self.CurGroup] 
    endif else begin
        self.CurNum = self.CurNum - 1
    endelse
endelse 

self.nextDrift =  randomu(seed, poisson=self.DriftSpeed)
end

;;;;;;;;;;;;;;;;;DRIFTJUMP
pro Seqobjinput::DriftJump
COMMON COMMON_Random, seed


self.CurNum =  (*self.groupsPtr)[0,self.CurGroup] + $
                           floor((1+(*self.groupsPtr)[1,self.CurGroup] - $
                           (*self.groupsPtr)[0,self.CurGroup])*randomu(seed))

self.nextDrift =  randomu(seed, poisson=self.DriftSpeed)
end

;;;;;;;;;;;;;;;;;;;,DIRCHG
pro Seqobjinput::DirChg
COMMON COMMON_Random, seed

self.Direction = self.Direction*(-1)
self.NextDirChg = randomu(seed, poisson=self.DirChgSpeed)

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;RANDOM JUMP
function Seqobjinput::NextRandom, Nr
COMMON COMMON_Random, seed

self.nextJump = Self.NextJump -1 
if self.nextJump lt 1 then begin
    self->jump
    self.NextJump = randomu(seed, poisson=self.DriftSpeed)  ;;;dies ist keine Verwechslung!!
endif

Nr = Self.CurNum
Return, reform((*Self.InputArrayPtr)[Nr,*,*,*,*])

end


;;;;;;;;;;;;;;;;;;;;;;;;PSTH

function Seqobjinput::PSTH, Nr
;COMMON COMMON_Random, seed

self.nextDrift = Self.NextDrift -1 
if self.nextDrift lt 1 then begin
    Self.CurElementNr = (Self.CurElementNr+1)
    if Self.CurElementNr ge (*Self.SeqObjectArrayPtr)[Self.CurSeqObject]->GetAnzElements() then begin
            Self.CurSeqObject = (Self.CurSeqObject + 1) mod Self.AnzSeqObjects
            Self.CurElementNr = 0
    endif
    Self.CurElement = (*Self.SeqObjectArrayPtr)[Self.CurSeqObject]->GetElementNr(Self.CurElementNr)
    self.nextDrift =  self.DriftSpeed
end

if SElf.NextDrift gt Self.DriftSpeed-Self.PsthSpeed then begin
    Nr = Self.CurElement->GetNumber() + (*Self.SeqObjectNumberOffsetPtr)[Self.CurSeqObject]
    Return, Self.CurElement->GetPattern()
endif else begin
    nr=Self.NullElementNumber
    Return, 0*Self.CurElement->GetPattern()
endelse

end



;;;;;;;;;;;;;;;;;;;;;;;;;;;NEXT
function Seqobjinput::Next, Nr
COMMON COMMON_Random, seed

if Self.PSTHSpeed ne -1 then return, self->psth(nr) else begin
    self.NextDirChg = self.NextDirChg -1
    if self.nextDirChg lt 1 then begin    
        p = floor(3.3*randomu(seed)) -1
        self.Direction = (self.Direction + 4 + p) mod 4
        self.NextDirChg = randomu(seed, poisson=self.DirChgSpeed)
    endif

    self.nextDrift = Self.NextDrift -1 
    if self.nextDrift lt 1 then begin
        Self.CurElement = Self.CurElement->GetNextElement(Self.Direction)
        self.nextDrift =  randomu(seed, poisson=self.DriftSpeed)
    end

    self.nextJump = Self.NextJump -1 
    if self.nextJump lt 1 then begin
        (*Self.SeqObjectArrayPtr)[Self.CurSeqObject]->SetCurElement, Self.CurElement
        Self.CurSeqObject = (Self.CurSeqObject + 1) mod Self.AnzSeqObjects
        Self.CurElement =(*Self.SeqObjectArrayPtr)[Self.CurSeqObject]->GetCurElement()
        self.NextJump = randomu(seed, poisson=self.JumpSpeed)
        print, "switched to object ", Self.CurSeqObject
    endif

    Nr = Self.CurElement->GetNumber() + (*Self.SeqObjectNumberOffsetPtr)[Self.CurSeqObject]
    Return, Self.CurElement->GetPattern()
endelse

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DESTRUCTOR
pro Seqobjinput::Cleanup

For ObjNr=0, Self.AnzSeqObjects-1 do $
  Obj_Destroy, (*Self.SeqObjectArrayPtr)[ObjNr]

ptr_free, Self.SeqObjectArrayPtr


end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CONSTRUCTOR
function Seqobjinput::init, Width, Height,  FILENAMES=FileNames, DefaultPattern=DefaultPattern, $
JUMPSPEED=JumpSpeed, DRIFTSPEED=DriftSpeed, AnzSeqObjects=AnzSeqObjects, $
DIRCHGSPEED=DirChgSpeed, PSTHSpeed=PSTHSpeed,AnzX=AnzX, AnzY=AnzY,StimSize=StimSize,   _EXTRA = e
;AnzX=AnzX, AnzY=AnzY, AnzElements=AnzElements

Default, Width, 5
Default, Height, 5
Default, AnzSeqObjects, 1
Self.AnzSeqObjects = AnzSeqObjects

Default, JumpSpeed, 100 ;jump = switch to another object
Default, DriftSpeed, 10 ;drift = go to neighboring number of same object
Default, DirChgspeed, 40 ;change direction (left, right, up, down)
Default, PSTHSpeed, -1

Self.Width = Width
Self.Height= Height

default, DefaultPattern, 1

if keyword_set(FileNames) then  Self.AnzSeqObjects = n_elements(FileNames)
SeqObjectArray = objarr(Self.AnzSeqObjects)
Self.SeqObjectArrayPtr = ptr_new(SeqObjectArray)
ObjectNumberOffset = intarr(Self.AnzSeqObjects)
Self.SeqObjectNumberOffsetPtr = ptr_new(ObjectNumberOffset)
For ObjNr=0, Self.AnzSeqObjects-1 do begin
    if keyword_set(FileNames) then  (*Self.SeqObjectArrayPtr)[ObjNr] = obj_new('seqobject', load=1, FileName=FileNames[ObjNr]) $
    else  case DefaultPattern of
        1: (*Self.SeqObjectArrayPtr)[ObjNr] = obj_new('seqobject', AnzX=anzX, AnzY=AnzY, DefaultPattern=1, _Extra=e)
        2: (*Self.SeqObjectArrayPtr)[ObjNr] = obj_new('seqobject', AnzX=AnzX, AnzY=AnzY, DefaultPattern=2, StimSize=StimSize, YRange=[ObjNr*floor(AnzY/Self.AnzSeqObjects), (ObjNr+1)*floor(AnzY/Self.AnzSeqObjects)-1], _Extra=e)
    endcase

    if ObjNr eq 0 then (*Self.SeqObjectNumberOffsetPtr)[ObjNr] = 0 $
    else (*Self.SeqObjectNumberOffsetPtr)[ObjNr] = $
      (*Self.SeqObjectNumberOffsetPtr)[ObjNr-1] $
      + (*Self.SeqObjectArrayPtr)[ObjNr-1]->GetAnzElements()
endfor


;NullElementNumber =  (*Self.SeqObjectNumberOffsetPtr)[Self.AnzSeqObjects-1] + (*Self.SeqObjectArrayPtr)[Self.AnzSeqObjects-1]->GetAnzElements()
(*Self.SeqObjectNumberOffsetPtr) = (*Self.SeqObjectNumberOffsetPtr)+1
NullElementNumber=0L
print, "nullelementNumber=", nullelementNumber
Self.NullElementNumber = nullelementnumber
print,  "inputoffset", (*Self.SeqObjectNumberOffsetPtr)

Self.CurSeqObject=0
Self.CurElement =(*Self.SeqObjectArrayPtr)[Self.CurSeqObject]->GetCurElement()
Self.CurElementNr=0

Self.DriftSpeed=DriftSpeed
Self.JumpSpeed=JumpSpeed
Self.DirChgSpeed = DirChgSpeed
Self.Direction=0
Self.PSTHSpeed = PsthSpeed


return, 1
end




;;;;;;;;;;;;;DEFINE
pro Seqobjinput__Define

STRUCT = {SEQOBJINPUT, $
          AnzSeqObjects:0,$
          SeqObjectArrayPtr:ptr_new(),$
          SeqObjectNumberOffsetPtr: Ptr_new(),$
          Width:0,$
          Height:0,$
          CurElementNr:0,$
          CurSeqObject:0,$
          CurElement:Obj_new(),$
          Direction:1,$
          DirChgSpeed:0,$
          DriftSpeed:0,$
          JumpSpeed:0,$
          PSTHSpeed:0,$
          PSTHStimTime:0,$
          NullElementNumber:0L,$
          NextJump:0,$
          NextDrift:0,$
          NextDirChg:0$
}

end
