;+
; NAME: Rewind
;
; PURPOSE: Positionieren des internen FramePointers in einem zuvor
;          aufgezeichneten Array-Video.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Rewind, Video, FrameNumber [,/VERBOSE]
; 
; INPUTS: Video: Eine mit LoadVideo iitialisierte Video-Struktur
;         FrameNumber: Neue Position des Framepointers
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS:  VERBOSE: Für mehr Freude am Simulieren...
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Der interne FramePointer wird neu gesetzt.
;
; RESTRICTIONS: Ist die angegebene Position zu gross, so wird ein
;               Fehler ausgegeben.
;
; PROCEDURE: Straightforward, wie man so schön sagt.
;
; EXAMPLE: Rewind, MyVideo, 3
;
; MODIFICATION HISTORY:
;
;       Wed Aug 27 17:59:21 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Pro Rewind, Video, FrameNumber, VERBOSE=verbose

   If Video.VideoMode ne 'PLAY' then message, 'Das Video ist nicht zur Wiedergabe geöffnet!'
   If FrameNumber ge Video.Length then message, 'Videoende überschritten!'

   Video.FramePointer = FrameNumber

   If keyword_set(VERBOSE) then begin
      print, 'Ah! Eine besonders schöne Szene in "'+Video.title+'": Nummer '+strtrim(string(FrameNumber), 1)
   endif else begin
      print, 'Video is now at Frame #'+strtrim(string(FrameNumber), 1)+'.'
   endelse
End
