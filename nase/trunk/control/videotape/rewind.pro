;+
; NAME: Rewind
;
; PURPOSE: Positionieren des internen FramePointers in einem zuvor
;          aufgezeichneten Array-Video.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Rewind, Video, {FrameNumber | /APPEND} [,/VERBOSE]
; 
; INPUTS: Video: Eine mit LoadVideo iitialisierte Video-Struktur
;         FrameNumber: Neue Position des Framepointers
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS:  VERBOSE: Für mehr Freude am Simulieren...
;                      APPEND : Funktioniert nur bei Videos, die mit
;                               LoadVideo und /EDIT geöffnet wurden.
;                               Setzt den internen Framepointer so,
;                               daß mit folgenden CamCords an das
;                               Video Frames angehängt werden können.
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
;       Revision 2.4  1998/05/13 12:38:21  kupper
;              Das EDIT-Keyword in LoadVideo ist jetzt freigegeben.
;               Es kann zum Ändern von oder Anhängen an Videos benutzt werden.
;               Aber man sollte immer wissen, was man tut...
;
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

Pro Rewind, Video, FrameNumber, VERBOSE=verbose, APPEND=append

   If Keyword_Set(APPEND) then begin
      If Video.VideoMode ne "EDIT" then mesage, "Das Video ist nicht zum Editieren geöffnet - kein Anhängen möglich!"
      Video.FramePointer = Video.Length
   Endif else begin
      If Video.VideoMode ne 'PLAY' then message, 'Das Video ist nicht zur Wiedergabe geöffnet!'
      If FrameNumber ge Video.Length then message, 'Videoende überschritten!'
      
      Video.FramePointer = FrameNumber
   Endelse

   If keyword_set(VERBOSE) then begin
      print, 'Ah! Eine besonders schöne Szene in "'+Video.title+'": Nummer '+strtrim(string(Video.FramePointer), 1)
   endif else begin
      message, /inform, 'Video "'+Video.title+'" is now at Frame #'+strtrim(string(Video.FramePointer), 1)+'.'
   endelse
End
