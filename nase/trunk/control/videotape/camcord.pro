;+
; NAME: CamCord()
;
; PURPOSE: Aufnehmen eines "Array-Videos"
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: FrameNumber = CamCord ( Video, NewFrame [,Anzahl] [,/VERBOSE] )
; 
; INPUTS: Video:    Eine mit InitVideo erstellte Videostruktur
;         NewFrame: Ein aufzubnehmendes Array geeigneter Gr��e
;
; OPTIONAL INPUTS: Anzahl: zur Aufnahme mehrerer Szenen - NOCH NICHT IMPLEMENTIERT
;	
; KEYWORD PARAMETERS: VERBOSE: F�r mehr Freude an der Simulation...
;
; OUTPUTS: FrameNumber: Index des aufgenommenen Frames
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Schreibt ins .vid-File
;               Der interne FramePointer wird weitergesetzt, so da�
;               beim n�chsten Aufruf das n�chste Array gelesen wird. 
;
; RESTRICTIONS: Das �bergebene Array mu� das gleiche Format haben, wie bei InitVideo angegeben.
;
; PROCEDURE: Ein geeigenetes Array wird mit dem .vid-File assoziiert und dann beim n�chsten freien Index beschrieben.
;
; EXAMPLE: FrameNumber = CamCord ( MyVideo, [23,23], /VERBOSE )
;
; MODIFICATION HISTORY:
;
;       Wed Aug 27 17:05:23 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;	  Urversion.	
;
;-

Function CamCord, Video, Frame, Anzahl, VERBOSE=verbose
   
   If Video.VideoMode ne 'RECORD' then message, 'Das Video ist nicht zum Schreiben ge�ffnet!'

   Default, Anzahl, 1
   If Anzahl ne 1 then message, 'Das "Anzahl"-Argument ist noch nicht implementiert!'

   Template = Make_Array(SIZE=Video.FrameSize)
   Data = Assoc(Video.unit, Template)

   Data(Video.FramePointer) = Frame

   Video.FramePointer = Video.FramePointer+1

   If keyword_set(VERBOSE) then print, 'Eine weitere Szene im gro�en Videodrama "'+Video.title+'": Die '+strtrim(string(Video.FramePointer-1), 1)+'.'

   Return, Video.FramePointer-1

End

   
