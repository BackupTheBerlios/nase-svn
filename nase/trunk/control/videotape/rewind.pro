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
; SIDE EFFECTS: Der interne FramePointer wird neu gesetzt.
;
; RESTRICTIONS: Ist die angegebene Position zu gross, so wird ein
;               Fehler ausgegeben.
;
; PROCEDURE: Straightforward, wie man so schön sagt.
;
; EXAMPLE: Rewind, MyVideo, 3
;
; SEE ALSO: <A HREF="#INITVIDEO">InitVideo()</A>, <A HREF="#CAMCORD">CamCord</A>,
;           <A HREF="#LOADVIDEO">LoadVideo()</A>, <A HREF="#REPLAY">Replay()</A>,
;           <A HREF="#EJECT">Eject</A>, <A HREF="#LABEL">Label</A>,
;           <A HREF="#INFORMATIONOVERKILL">InformationOverkill()</A>.
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.3  1997/11/27 14:50:56  kupper
;              Hyperlinks in Header geschrieben.
;              Kosmetische Änderungen im Output.
;
;       Revision 2.2  1997/10/14 15:30:01  kupper
;              Kosmetische Änderung beim Textoutput.
;
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
      message, /inform, 'Video "'+Video.title+'" is now at Frame #'+strtrim(string(FrameNumber), 1)+'.'
   endelse
End
