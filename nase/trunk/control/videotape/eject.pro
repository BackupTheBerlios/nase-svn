;+
; NAME:               EJECT
;
; PURPOSE:            Schließen eines mit InitVideo oder LoadVideo geöffneten Array-Videos und
;                     Anfügen eines informativen Labeltextes an das Videoinfo-File.
;
; CATEGORY:           SIMULATION 
;
; CALLING SEQUENCE:   Eject, Video [,/VERBOSE] [,/NOLABEL] [,/SHUTUP]
; 
; INPUTS:             Video: eine mit InitVideo oder LoadVideo initialisierte Videostruktur
;
; KEYWORD PARAMETERS: VERBOSE: Für mehr Freude an der Simulation...
;                     NOLABEL: Unterdrückt die interaktive Abfrage
;                              eines Labeltextes.
;                     SHUTUP:  Unterdrueckt jegliche Ausgabe
;
; SIDE EFFECTS:       Schliesst das .vid- und ev. das .vidinf-File
;
; PROCEDURE:          War das Video zur Aufnahme geöffnet, so wird an das .vidinf-File noch die FrameAnzahl angehängt.
;                     .vid und .vidinf werden geschlossen.
;
; EXAMPLE:            1. Eject, MyVideo, /VERBOSE
;                     2. Eject, MyVideo, /NOLABEL
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.5  1998/03/14 13:32:45  saam
;             now handles zipped and non-zipped videos
;
;
;       Fri Aug 29 18:14:59 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Free_Luns zugefügt, die ich sträflicherweise vergaß...
;
;       Wed Aug 27 17:09:55 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Urversion
;
;-
Pro Eject, Video, VERBOSE=verbose, NOLABEL=nolabel, SHUTUP=shutup

   If Video.VideoMode eq 'RECORD' then begin
      writeu, Video.infounit, Video.FramePointer
      
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
      close, Video.unit
      close, Video.infounit
      Free_Lun, Video.unit
      Free_Lun, Video.infounit
      
      IF video.zipped THEN Zip, Video.filename
   endif else begin             ; VideoMode="PLAY"
      
      if keyword_set(VERBOSE) then begin
         print
         print, '                      E N D E'
         print
         print, '                 (c)'+Video.company+' '+Video.year
      endif ELSE IF NOT Keyword_Set(SHUTUP) THEN  BEGIN
         print, 'Closing Video "'+Video.title+'".'
      end
      
      close, Video.unit
      Free_Lun, Video.unit

      IF Video.zipped THEN ZipFix, Video.filename
         
   endelse

end






