;+
; NAME: Replay()
;
; PURPOSE: Auslesen eines zuvor aufgezeichneten Array-Videos
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Result = Replay ( Video [,Anzahl] [,/VERBOSE] )
; 
; INPUTS: Video: Eine mit LoadVideo() initialisierte Videostruktur
;
; OPTIONAL INPUTS: Anzahl: Anzahl der wiederzugebenden Frames. - NOCH NICHT IMPLEMENTIERT!
;	
; KEYWORD PARAMETERS: VERBOSE: Für mehr Freude am Simulieren...
;
; OUTPUTS: Result: Das nächste Array im Array-Video
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Der interne FramePointer wird weitergesetzt, so daß
;               beim nächsten Aufruf das nächste Array gelesen wird.  
;
; RESTRICTIONS: Ist das Fileende erreicht, so wird ein Fehler ausgegeben
;
; PROCEDURE: Array mit dem .vid-File assoziieren und an geeigneter
;            Stelle auslesen.
;
; EXAMPLE: Array = Replay ( MyVideo )
;
; MODIFICATION HISTORY:
;
;       Wed Aug 27 17:55:37 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Function Replay, Video, Anzahl, VERBOSE=verbose

   If Video.VideoMode ne 'PLAY' then message, 'Das Video ist nicht zur Wiedergabe geöffnet!'

   Default, Anzahl, 1
   If Anzahl ne 1 then message, 'Das "Anzahl"-Argument ist noch nicht implementiert!'

   Template = Make_Array(SIZE=Video.FrameSize)
   Data = Assoc(Video.unit, Template)

   Video.FramePointer = Video.FramePointer+1
   If Video.FramePointer gt Video.Length then message, 'Videoende überschritten!'

   If keyword_set(VERBOSE) then print, 'Eine weitere Szene im großen Videodrama "'+Video.title+'": Die '+strtrim(string(Video.FramePointer-1), 1)+'.'

   return, Data(Video.FramePointer-1)

End
