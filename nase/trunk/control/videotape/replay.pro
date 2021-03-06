;+
; NAME: Replay()
;
; AIM: Reads a formerly recorded array-video.
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
; KEYWORD PARAMETERS: VERBOSE: F�r mehr Freude am Simulieren...
;
; OUTPUTS: Result: Das n�chste Array im Array-Video
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Der interne FramePointer wird weitergesetzt, so da�
;               beim n�chsten Aufruf das n�chste Array gelesen wird.  
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

Function Replay, _Video, Anzahl, VERBOSE=verbose

   ON_Error, 2

   Handle_Value, _Video, Video, /NO_COPY

   If Video.VideoMode ne 'PLAY' then message, 'Das Video ist nicht zur Wiedergabe ge�ffnet!'

   Default, Anzahl, 1
   If Anzahl ne 1 then message, 'Das "Anzahl"-Argument ist noch nicht implementiert!'

   Data = Assoc(Video.unit, Make_Array(SIZE=Video.FrameSize, /NOZERO))

   Video.FramePointer = Video.FramePointer+1
   If Video.FramePointer gt Video.Length then message, 'Videoende �berschritten!'

   If keyword_set(VERBOSE) then print, 'Eine weitere Szene im gro�en Videodrama "'+Video.title+'": Die '+strtrim(string(Video.FramePointer-1), 1)+'.'

   Result = Data(Video.FramePointer-1)
   Handle_Value, _Video, Video, /NO_COPY, /SET

   return, Result

End
