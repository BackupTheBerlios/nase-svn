;+
; NAME:
;  Eject
;
; AIM:
;  closes a video opened by <A>initvideo</A> or <A>loadvideo</A>
;
; PURPOSE:
;  Closes a video created with <A>InitVideo</A> or opened by
;  <A>LoadVideo</A>. The video can be labelled with useful informations.
;
; CATEGORY:
;  DataStorage
;  DataStructures
;  Files
;  IO
;
; CALLING SEQUENCE:
;  Eject, Video [,/NOLABEL]  [,UDS=...] [, {/VERBOSE | /SHUTUP }] 
; 
; INPUTS:
;  V:: a valid video structure
;
; KEYWORD PARAMETERS: 
;   NOLABEL:: supresses interactive labelling of the video
;   VERBOSE:: talks about everything no one will want to hear about...
;   SHUTUP:: supresses every informational messages
;
; INPUT KEYWORDS:
;   UDS   :: an arbitrary structure that will also be saved on
;            disk. It can be used to preserve simulation or other
;            relevant parameters. Please set this option only if you
;            haven't set a value for it, when calling <A>InitVideo</A>.
;
; SIDE EFFECTS:
;  closes .vid and .vidinf files
;
; EXAMPLE:
;* Eject, MyVideo, /VERBOSE
;* Eject, MyVideo, /NOLABEL
;
;-
Pro Eject, _Video, VERBOSE=verbose, NOLABEL=nolabel, SHUTUP=shutup, UDS=uds

   ON_Error, 2

   Handle_Value, _Video, Video, /NO_COPY

   If Video.VideoMode eq 'RECORD' or Video.VideoMode eq 'EDIT' then begin
      If Video.VideoMode eq 'EDIT' then writeu, Video.infounit, max([Video.FramePointer, Video.Length]) else writeu, Video.infounit, Video.FramePointer

      ;; UDS part
      IF (Set(UDS) OR ExtraSet(VIDEO, "UDS")) THEN BEGIN
          IF (Set(UDS) AND ExtraSet(VIDEO, "UDS")) THEN Console, 'you specified UDS twice, taking the most recent version',/WARN
          IF NOT Set(UDS) THEN Default, UDS, Video.UDS ;;  UDS remains an IN parameter, since if the THEN part is executed, the user didn't specify UDS
          IF TypeOf(UDS) NE "STRUCT" THEN Console, "UDS must be a structure", /FATAL
          SaveStruc, Video.infounit, UDS
      END
      

      if keyword_set(VERBOSE) then begin
         print
         print, 'KLAPPE! Die Dreharbeiten zu "'+Video.Title+'" sind nach '+strtrim(string(Video.FramePointer),1)+' Einstellungen beendet.'
      endif else IF NOT Keyword_Set(SHUTUP) THEN  BEGIN 
         print, 'Closing Video "'+Video.title+'". Recorded Frames: '+strtrim(string(Video.FramePointer),1)
      end
      
      if not keyword_set(NOLABEL) then begin ; Label schreiben
         print
         print, "Please enter a Label for this Video (End with '*') -"
         l = ""
         Read, l, PROMPT="LABEL: "
         While l ne "*" do begin
            Writeu, Video.infounit, l
            Writeu, Video.infounit, 10b ;LineFeed
            Read, l, PROMPT="LABEL: "
         endwhile 
      endif
      UClose, Video.unit
      UClose, Video.infounit
      
   endif else begin             ; VideoMode="PLAY"
      
      if keyword_set(VERBOSE) then begin
         print
         print, '                      E N D E'
         print
         print, '                 (c)'+Video.company+' '+Video.year
      endif ELSE IF NOT Keyword_Set(SHUTUP) THEN  BEGIN
         print, 'Closing Video "'+Video.title+'".'
      end
      UClose, Video.unit

   endelse

   Handle_Value, _Video, Video, /NO_COPY, /SET
   Handle_Free, _Video

end






