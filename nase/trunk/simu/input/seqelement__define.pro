;+
; NAME:
;  seqelement__define
;
; VERSION:
;  $Id$
;
; AIM:
;  object, providing a sequence element for generating complex input patterns 
;
; PURPOSE:
;  <C>seqelement__define</C> proviedes a sequence element object for
;  generating input sequences. A seqelement stores an input pattern
;  and connections to other seqelements. With a set of seqelements you
;  can create a grid of connected input patterns. There is also an
;  seqobject, which helps to organize such a grid of  seqelements.
;
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
;*result = obj_new('seqelement', IndexNr=0, INPUTPATTERN=InputPattern)
;
;
; OBJECT METHODS:
;    init:: initializes the sequence element
;    load:: loads a stored sequence element
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
;  <A>seqobject__define</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Save
pro SeqElement::Save, lun

StrucToSave = {nr:Self.IndexNr, AMC:Self.AnzMotorCommands, Pat:*Self.InputPatternPtr, ConNumbers:*Self.ConnectionNumbersPtr}
SaveStruc, lun, StrucToSave

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Load
pro SeqElement::Load, lun

u = loadstruc(lun)
Self.IndexNr = u.nr
Self->SetPattern, u.pat

ptr_free, Self.ConnectionsPtr
ptr_free, Self.ConnectionNumbersPtr

Self.AnzMotorCommands = u.amc
connections = ObjArr(Self.AnzMotorCommands)
Self.ConnectionsPtr = Ptr_New(Connections)
Self.ConnectionNumbersPtr = Ptr_new(u.ConNumbers)

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Connect
pro SeqElement::Connect, MotorNr, NextSeqElement
if MotorNr lt Self.AnzMotorCommands then begin
    Obj_Destroy, (*Self.ConnectionsPtr)[MotorNr]
    (*Self.ConnectionsPtr)[MotorNr] = Obj_New('seqconnection', NextSeqElement=NextSeqElement)
    (*Self.ConnectionNumbersPtr)[MotorNr] = NextSeqElement->GetNumber()
endif
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DisConnect
pro SeqElement::DisConnect, MotorNr
if MotorNr lt Self.AnzMotorCommands then begin
    Obj_Destroy, (*Self.ConnectionsPtr)[MotorNr]
    (*Self.ConnectionsPtr)[MotorNr] = obj_new()
    (*Self.ConnectionNumbersPtr)[MotorNr]=-1
endif
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Test
pro SeqElement::Test

print, "Hallo Welt"
print, "My Number is ...", self.IndexNr
print, "MyConnections:", *Self.ConnectionNumbersPtr
print, "MyPattern:", *Self.InputPatternPtr
;if self.connections[1] ne obj_new() then (Self.Connections[1]->getnextelement())->test

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetNextElement

function SeqElement::GetNextElement, MotorCommand

if MotorCommand lt Self.AnzMotorCommands then begin
    if (*self.connectionsPtr)[MotorCommand] ne obj_new() then return, (*Self.ConnectionsPtr)[MotorCommand]->getnextelement()
endif

return, Obj_new()

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetNextElementNumber

function SeqElement::GetNextElementNumber, MotorCommand

if MotorCommand lt Self.AnzMotorCommands then begin
    return, (*Self.ConnectionNumbersPtr)[MotorCommand]
endif

return, -1

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetNumber
function SeqElement::GetNumber

return, self.IndexNr

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetConnectionNumbers
function SeqElement::GetConnectionNumbers

return, *self.ConnectionNumbersPtr

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetPattern
function SeqElement::GetPattern

return, *self.InputPatternPtr

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SetPattern
pro SeqElement::SetPattern, Pattern

ptr_free, self.InputPatternPtr
Self.InputPatternPtr = Ptr_New(Pattern)

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DESTRUCTOR
pro SeqElement::Cleanup

print, "SeqElement::Cleanup  ", self.IndexNr
ptr_free, Self.InputPatternPtr
ptr_free, Self.ConnectionsPtr
ptr_free, Self.ConnectionNumbersPtr

end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CONSTRUCTOR
function SeqElement::init, $
  INDEXNR=IndexNr, $
  INPUTPATTERN=InputPattern, $
  ANZMOTORCOMMANDS=AnzMotorCommands

default, IndexNr, 0
self.IndexNr = IndexNr

default, InputPattern, 1
self.InputPatternPtr = ptr_new(InputPattern)

Default, AnzMotorCommands, 4
Self.AnzMotorCommands = AnzMotorCommands

connections = ObjArr(Self.AnzMotorCommands)
Self.ConnectionsPtr = Ptr_New(Connections)

ConnectionNumbers = intarr(Self.AnzMotorcommands)
Self.ConnectionNumbersPtr = Ptr_new(ConnectionNumbers)

print, "SeqElement::init  ", IndexNr

return, 1

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DEFINE

pro SeqElement__Define
STRUCT = {SEQELEMENT, $
          IndexNr:0l,$
          AnzMotorCommands:4,$
          InputPatternPtr:ptr_new(),$
          ConnectionsPtr: Ptr_new(),$
          ConnectionNumbersPtr: ptr_new()$
;          ,Connections: ObjArr(4)$
}
end
