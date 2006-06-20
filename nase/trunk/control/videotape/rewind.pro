;+
; NAME:
;  Rewind
;
; VERSION:
;  $Id$
;
; AIM:
;  Positions the frame-pointer of a formerly recorded array-video.
;
; PURPOSE:
;  <C>Rewind</C> is used to position the internal frame-pointer of a
;  formerly recorded and now reopened array-video. This enables
;  reading or writing data beginning at an arbitrary position inside the
;  video by a following <A>Replay()</A> or <A>CamCord()</A>
;  instruction. 
;
; CATEGORY:
;  DataStorage
;  DataStructures
;  Files
;  IO
;
; CALLING SEQUENCE:
;* Rewind, video, {framenumber | /APPEND} [,/VERBOSE] [,/SHUTUP]
;
; INPUTS:
;  video:: Video-structure initialized by <A>LoadVideo()</A>.
;  framenumber:: Desired position of the frame-pointer. Note that the 
;  first frame is position 0.
;
; INPUT KEYWORDS:
;  VERBOSE:: More fun during simulation...
;  APPEND:: Automatically set the internal frame-pointer to the end of
;           the video to enable appending of new frames with the
;           <A>CamCord()</A>-function. <B>Attention:</B> Only possible
;           in videos opened with the <C>/EDIT</C>-option of
;           <A>LoadVideo()</A>.
;  SHUTUP:: Dont print any messages at all.
;
; SIDE EFFECTS:
;  The frame-pointer is modified of course.
;
; RESTRICTIONS:
;  New position of the frame-pointer must not be larger than length of
;  video.
;
; PROCEDURE:
;  Straightforward
;
; EXAMPLE:
;* Rewind, MyVideo, 3
;
; SEE ALSO:
;  <A>InitVideo()</A>, <A>Camcord()</A>, <A>LoadVideo()</A>,
;  <A>Replay()</A>, <A>Eject</A>.
;
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.10  2001/05/21 13:22:56  thiel
;          Nicer header, also in english now.
;
;       Revision 2.9  2000/09/28 13:23:29  alshaikh
;             added AIM
;
;       Revision 2.8  1999/01/14 16:13:28  niederha
;       Header geaendert
;
;       Revision 2.7  1999/01/14 15:53:41  niederha
;       haelt jetzt auf Wunsch auch die Klappe
;
;       Revision 2.6  1998/11/08 14:51:40  saam
;             + video-structure made a handle
;             + ZIP-handling replaced by UOpen[RW]
;
;       Revision 2.5  1998/05/13 12:52:08  kupper
;              Schreibfehler.
;
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


PRO Rewind, _Video, FrameNumber, VERBOSE=verbose, SHUTUP=shutup, APPEND=append

   ON_ERROR, 2

   Handle_Value, _Video, Video, /NO_COPY

   IF Keyword_Set(APPEND) THEN BEGIN
      IF Video.VideoMode NE "EDIT" THEN $
       Console, /FATAL $
                , "Video has not been openend for editing. Appending not possible!"
      Video.FramePointer = Video.Length
   ENDIF ELSE BEGIN 
      IF Video.VideoMode NE 'PLAY' THEN $
       Console, /FATAL, 'Video not opened for replay!'
      IF FrameNumber GE Video.Length THEN $
       Console, /FATAL, 'End of video has been passed!'
      
      Video.FramePointer = FrameNumber
   ENDELSE 


   IF keyword_set(VERBOSE) THEN BEGIN
      Print, 'Ah! An exceptionally beautiful scene in "'+Video.title+'": Number '+strtrim(string(Video.FramePointer), 1)
   ENDIF ELSE IF NOT keyword_set(shutup) THEN BEGIN
      Console, /MSG, 'Video "'+Video.title+'" is now at Frame #'+strtrim(string(Video.FramePointer), 1)+'.'
   END 

   Handle_Value, _Video, Video, /NO_COPY, /SET

END
