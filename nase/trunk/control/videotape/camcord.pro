;+
; NAME: CamCord() 
;
; AIM: Recording of an Array-Video.
;
; PURPOSE: Aufnehmen eines "Array-Videos"
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: FrameNumber = CamCord ( Video, NewFrame [,Anzahl] [,/VERBOSE] )
; 
; INPUTS: Video:    Eine mit InitVideo erstellte Videostruktur oder
;                   ein mit LoadVideo und /EDIT zum Editieren
;                   geöffnetes Video.
;         NewFrame: Ein aufzubnehmendes Array geeigneter Größe
;
; OPTIONAL INPUTS: Anzahl: zur Aufnahme mehrerer Szenen - NOCH NICHT IMPLEMENTIERT
;	
; KEYWORD PARAMETERS: VERBOSE: Für mehr Freude an der Simulation...
;
; OUTPUTS: FrameNumber: Index des aufgenommenen Frames
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Schreibt ins .vid-File
;               Der interne FramePointer wird weitergesetzt, so daß
;               beim nächsten Aufruf das nächste Array gelesen wird. 
;
; RESTRICTIONS: Das übergebene Array muß das gleiche Format haben, wie bei InitVideo angegeben.
;
; PROCEDURE: Ein geeigenetes Array wird mit dem .vid-File assoziiert und dann beim nächsten freien Index beschrieben.
;
; EXAMPLE: FrameNumber = CamCord ( MyVideo, [23,23], /VERBOSE )
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.10  2000/09/28 13:23:26  alshaikh
;             added AIM
;
;       Revision 2.9  1998/11/08 14:51:35  saam
;             + video-structure made a handle
;             + ZIP-handling replaced by UOpen[RW]
;
;       Revision 2.8  1998/05/13 12:38:20  kupper
;              Das EDIT-Keyword in LoadVideo ist jetzt freigegeben.
;               Es kann zum Ändern von oder Anhängen an Videos benutzt werden.
;               Aber man sollte immer wissen, was man tut...
;
;       Revision 2.7  1998/04/06 16:06:52  saam
;             now leaves procedure when an error occurs
;
;
;       Sun Sep 7 17:16:49 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;	      Nimmt jetzt auch Skalare richtig auf.
;
;       Wed Aug 27 17:05:23 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;	      Urversion.	
;
;-

Function CamCord, _Video, Frame, Anzahl, VERBOSE=verbose
   
   On_Error, 2

   Handle_Value, _Video, Video, /NO_COPY

   If Video.VideoMode ne 'RECORD' and Video.VideoMode ne "EDIT" then message, 'Das Video ist nicht zum Schreiben geöffnet!'
   If a_ne(size([Frame]), Video.FrameSize) then message, 'Frame ist inkompatibel mit dem in InitVideo() angegebenen Muster!'

   Default, Anzahl, 1
   If Anzahl ne 1 then message, 'Das "Anzahl"-Argument ist noch nicht implementiert!'

   Data = Assoc(Video.unit, Make_Array(SIZE=Video.FrameSize, /NOZERO))
   Data(Video.FramePointer) = [Frame]

   Video.FramePointer = Video.FramePointer+1

   If keyword_set(VERBOSE) then print, 'Eine weitere Szene im großen Videodrama "'+Video.title+'": Die '+strtrim(string(Video.FramePointer-1), 1)+'.'

   Result = Video.FramePointer-1
   Handle_Value, _Video, Video, /NO_COPY, /SET

   Return, Result

End

   
