;+
; NAME:
;  seqobject__define
;
; VERSION:
;  $Id$
;
; AIM:
;  handling input sequence elements
;
; PURPOSE:
;<C>seqobject__define</C> provides an object for handling seqelements
;(see <A>seqelement__define</A>). It creates a grid of interconnected sequence elements
;
; CATEGORY:
;  Input
;  MIND
;  NASE
;  Objects
;  Simulation
;  Strings
;
; CALLING SEQUENCE:
;*result = obj_new('seqobject', AnzX=5, AnzY=5, DefaultPattern=2, StimSize=3)
;
;
; OBJECT METHODS:
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
;  <A>seqelement__define</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Save
pro Seqobject::Save, filename=FileName
default, FileName, 'data/sim/seqobj.dat'
openw, lun, filename, /get_lun
WriteU, lun, Self.AnzElements
for objNr=0, Self.AnzElements-1 do (*Self.ElementListPtr)[objNr]->save, lun
close, lun
free_lun, lun
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Load
pro Seqobject::Load, FileName=FileName
default, FileName, 'data/sim/seqobj.dat'

;;Cleanup
for i=0, Self.AnzElements-1 do begin
    Obj_destroy, (*Self.ElementListPtr)[i]
endfor
ptr_free, Self.ElementListPtr


openr, lun, filename, /get_lun
AnzElements=0L
ReadU, lun, AnzElements
Self.AnzElements=AnzElements


;; Create new ElementList
ElementList = ObjArr(AnzElements)
Self.ElementListPtr = Ptr_new(ElementList)
for i=0, Self.AnzElements-1 do begin
    (*Self.ElementListPtr)[i] = obj_new('seqelement', IndexNr=i)
endfor


for objNr=0, Self.AnzElements-1 do (*Self.ElementListPtr)[objNr]->load, lun
close, lun
free_lun, lun

Self.CurElement = (*Self.ElementListPtr)[0]

;;;jetzt noch die Connections entsprechend der geladenen
;;;ConnectionNumbers setzen

for objNr=0, Self.AnzElements-1 do begin
    CurConNumbers = (*Self.ElementListPtr)[objNr]->GetConnectionNumbers()
    for CurCon=0, N_Elements(CurConNumbers)-1 do $
      (*Self.ElementListPtr)[objNr]->Connect, CurCon, (*Self.ElementListPtr)[CurConNumbers[CurCon]]
endfor

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SetCurrentObj
pro Seqobject::SetCurElement, CurElement

Self.CurElement = CurElement

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetElementNr
function Seqobject::GetElementNr, nr

return, (*Self.ElementListPtr)[nr]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetCurElement
function Seqobject::GetCurElement

return, Self.CurElement

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GetAnzElements
function Seqobject::GetAnzElements

return, Self.AnzElements

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Test
pro Seqobject::Test

print, "Hallo Welt"
print, "My Number is ...", self.IndexNr
;if self.connections[1] ne obj_new() then (Self.Connections[1]->getnextelement())->test

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DESTRUCTOR
pro SeqObject::Cleanup

for i=0, Self.AnzElements-1 do begin
    Obj_destroy, (*Self.ElementListPtr)[i]
endfor
ptr_free, Self.ElementListPtr

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MakeCircle
pro SeqObject::MakeCircle

for i=0, Self.AnzElements-1 do begin
    source=i
    if source lt Self.AnzElements-1 then target=i+1 else target=0
    (*Self.ElementListPtr)[source]->connect, 0, (*Self.ElementListPtr)[target]
    (*Self.ElementListPtr)[target]->connect, 1, (*Self.ElementListPtr)[source]
endfor

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SetGridPattern
pro SeqObject::SetGridPattern, AnzX=AnzX, AnzY=AnzY

default, AnzX, floor(sqrt(Self.AnzElements))
default, AnzY, ceil(Self.AnzElements/float(AnzX))

CurElementNr=0
for X=0, AnzX-1 do begin
    for Y=0, AnzY-1 do begin
        Grid = intarr(AnzX, AnzY)
        grid[x,y]=1
        if CurElementNr lt Self.AnzElements then (*Self.ElementListPtr)[CurElementNr]->SetPattern, Grid
        CurElementNr = CurElementNr+1
    endfor
endfor

if CurElementNr lt Self.AnzElements then begin
    Grid = intarr(AnzX, AnzY)
    for i=CurElementNr, Self.AnzElements-1 do  (*Self.ElementListPtr)[i]->SetPattern, Grid
endif

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SetGridPattern2
pro SeqObject::SetGridPattern2, AnzX=AnzX, AnzY=AnzY, AnzStimX=AnzStimX, AnzStimY=AnzStimY,$
  XRange=XRange, YRange=YRange, StimSize=StimSize, XStimSize=XStimSize, YStimSize=YStimSize $
  ,StimIntensity=StimIntensity

default, AnzX, floor(sqrt(Self.AnzElements))
default, AnzY, ceil(Self.AnzElements/float(AnzX))
default, AnzStimX, floor(sqrt(Self.AnzElements))
default, AnzStimY, ceil(Self.AnzElements/float(AnzStimX))
default, XRange, [0, AnzX-1]
default, YRange, [0, AnzY-1]
default, StimSize, 1
default, StimIntensity, 1
default, XStimSize, StimSize
default, YStimSize, XStimSize
if AnzStimX eq 1 then XDist =0 else default, XDist, (XRange[1]-XRange[0]-XStimSize+1)/float(AnzStimX-1)
if AnzStimY eq 1 then YDist = 0 else default, YDist, (YRange[1]-YRange[0]-YStimSize+1)/float(AnzStimY-1)

CurElementNr=0
for X=0, AnzStimX-1 do begin
    for Y=0, AnzStimY-1 do begin
        Grid = fltarr(AnzX, AnzY)
        CurX = XRange[0]+round(x*XDist)
        CurY = YRange[0]+round(y*YDist)
        grid[CurX:CurX+XStimSize-1,CurY:CurY+YStimSize-1]=StimIntensity
        if CurElementNr lt Self.AnzElements then (*Self.ElementListPtr)[CurElementNr]->SetPattern, Grid
        CurElementNr = CurElementNr+1
    endfor
endfor

if CurElementNr lt Self.AnzElements then begin
    Grid = intarr(AnzX, AnzY)
    for i=CurElementNr, Self.AnzElements-1 do  (*Self.ElementListPtr)[i]->SetPattern, Grid
endif

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MakeToroidalRectangle
pro SeqObject::MakeToroidalRectangle, Debug=debug

AnzX = floor(sqrt(Self.AnzElements))
AnzY = ceil(Self.AnzElements/float(AnzX))

Grid = intarr(AnzX, AnzY)
Grid[*,*]=-1


;Alle Objekt-Nummern im Netz einsortieren
CurElementNr=0
for X=0, AnzX-1 do begin
    for Y=0, AnzY-1 do begin
        if CurElementNr lt Self.AnzElements then Grid[X,Y] = CurElementNr
        CurElementNr = CurElementNr+1
    endfor
endfor

if keyword_set(debug) then print, grid

;Gitterpunkte verknüpfen
CurElementNr=0
for X=0, AnzX-1 do begin
    for Y=0, AnzY-1 do begin
        if CurElementNr lt Self.AnzElements then begin
            ConRight  = Grid[(x+1+AnzX) mod AnzX, Y] ;right
            ConLeft    = Grid[(x-1+AnzX) mod AnzX, Y] ;left
            ConUp      = Grid[X, (y+1+AnzY) mod AnzY] ; up
            ConDown = Grid[X, (y-1+AnzY) mod AnzY]; down
            if ConRight eq -1 then ConRight = Grid[0,y]
            if ConUp eq -1 then ConUp = Grid[x,0]
            if ConLeft eq -1 then ConLeft = Grid[max(where(Grid[*,y] ne -1)),y]
            if ConDown eq -1 then ConDown = Grid[x,max(where(Grid[x,*] ne -1))]
            ConList = [ConLeft, ConUp, ConRight, ConDown]
            if keyword_set(debug) then print, conlist
            for con=0, 3 do begin
                (*Self.ElementListPtr)[CurElementNr]->connect, Con, (*Self.ElementListPtr)[ConList[con]]
                if keyword_set(debug) then (*Self.ElementListPtr)[CurElementNr]->SetPattern, [x,y] ;for debuging only
            endfor
        endif
        CurElementNr = CurElementNr +1
    endfor
endfor

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MakeSphere
;; alle Punkte werden gleichmäßit auf einer Kugeloberfläche angeordnet
;; d.h. sie sind  durch zwei Winkel definiert
;; damit kann der Abstand zwischen zwei Punkten auf der Oberfläche
;; berechnet werden, sowie die Richtung
;; vom Source-Punkt aus wird die Oberfläche in n Sektoren eingeteilt
;; aus jedem Sektor wird eine Verbindung zu dem Punkt aufgebaut, der
;; den geringsten Abstand hat

pro SeqObject::MakeSphere

end

pro SeqObject::MakeSurface

AnzZeilen = floor(sqrt(self.AnzElements))
CurNr = 0
CurSpalte=0
CurZeile = 0
while CurNum lt Self.AnzElements do begin
    (*Self.ElementListPtr)[source]->connect, 0, (*Self.ElementListPtr)[target]    
    CurNr = CurNr+1
    CurSpalte = CurSpalte+1
endwhile


end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ChainTest
pro SeqObject::ChainTest, Anz
default, anz, 2
for i=0, Anz-1 do begin
    Self.CurElement->test
    Self.CurElement = Self.CurElement->GetNextElement(1)
endfor

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CONSTRUCTOR
function SeqObject::init, AnzElements=anzElements, LOAD=Load, FILENAME=FileName, $
  DefaultPattern=DefaultPattern, AnzX=AnzX, AnzY=AnzY, XRange=XRange, YRange=YRange, StimSize=StimSize, _Extra=e

default, AnzElements, 6
Self.AnzElements = AnzElements

ElementList = ObjArr(AnzElements)
Self.ElementListPtr = Ptr_new(ElementList)

for i=0, Self.AnzElements-1 do begin
    (*Self.ElementListPtr)[i] = obj_new('seqelement', IndexNr=i)
endfor

Self.CurElement = (*Self.ElementListPtr)[0]

if keyword_set(load) then self->load, FileName=Filename else begin
    Case DefaultPattern of
        1: begin 
            self->maketoroidalrectangle
            self->setgridpattern, anzX=AnzX, AnzY=AnzY
        end
        2: begin
            self->maketoroidalrectangle
            self->setgridpattern2, AnzX=AnzX, AnzY=AnzY, StimSize=StimSize, XRange=XRange, YRange=YRange, _Extra=e
        end
        else: 
    endcase
endelse 

return, 1

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DEFINE

pro Seqobject__Define
STRUCT = {SEQOBJECT, $
          AnzElements:0l,$
          CurElement:Obj_new(),$
          ElementListPtr:ptr_new()$
}
end
