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
; KEYWORD PARAMETERS:  VERBOSE: F�r mehr Freude am Simulieren...
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
; PROCEDURE: Straightforward, wie man so sch�n sagt.
;
; EXAMPLE: Rewind, MyVideo, 3
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.2  1997/10/14 15:30:01  kupper
;              Kosmetische �nderung beim Textoutput.
;
;
;       Wed Aug 27 17:59:21 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Pro Rewind, Video, FrameNumber, VERBOSE=verbose

   If Video.VideoMode ne 'PLAY' then message, 'Das Video ist nicht zur Wiedergabe ge�ffnet!'
   If FrameNumber ge Video.Length then message, 'Videoende �berschritten!'

   Video.FramePointer = FrameNumber

   If keyword_set(VERBOSE) then begin
      print, 'Ah! Eine besonders sch�ne Szene in "'+Video.title+'": Nummer '+strtrim(string(FrameNumber), 1)
   endif else begin
      message, /inform, 'Video is now at Frame #'+strtrim(string(FrameNumber), 1)+'.'
   endelse
End
