;+
; NAME:               EJECT
;
; PURPOSE:            Schlie�en eines mit InitVideo oder LoadVideo ge�ffneten Array-Videos und
;                     Anf�gen eines informativen Labeltextes an das Videoinfo-File.
;
; CATEGORY:           SIMULATION 
;
; CALLING SEQUENCE:   Eject, Video [,/VERBOSE] [,/NOLABEL] [,/SHUTUP]
; 
; INPUTS:             Video: eine mit InitVideo oder LoadVideo initialisierte Videostruktur
;
; KEYWORD PARAMETERS: VERBOSE: F�r mehr Freude an der Simulation...
;                     NOLABEL: Unterdr�ckt die interaktive Abfrage
;                              eines Labeltextes.
;                     SHUTUP:  Unterdrueckt jegliche Ausgabe
;
; SIDE EFFECTS:       Schliesst das .vid- und ev. das .vidinf-File
;
; PROCEDURE:          War das Video zur Aufnahme ge�ffnet, so wird an das .vidinf-File noch die FrameAnzahl angeh�ngt.
;                     .vid und .vidinf werden geschlossen.
;
; EXAMPLE:            1. Eject, MyVideo, /VERBOSE
;                     2. Eject, MyVideo, /NOLABEL
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.8  1998/11/08 14:51:36  saam
;             + video-structure made a handle
;             + ZIP-handling replaced by UOpen[RW]
;
;       Revision 2.7  1998/05/13 12:38:20  kupper
;              Das EDIT-Keyword in LoadVideo ist jetzt freigegeben.
;               Es kann zum �ndern von oder Anh�ngen an Videos benutzt werden.
;               Aber man sollte immer wissen, was man tut...
;
;       Revision 2.6  1998/04/29 17:35:19  kupper
;              sagt jetzt, wenns zippt.
;
;       Revision 2.5  1998/03/14 13:32:45  saam
;             now handles zipped and non-zipped videos
;
;
;       Fri Aug 29 18:14:59 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Free_Luns zugef�gt, die ich str�flicherweise verga�...
;
;       Wed Aug 27 17:09:55 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Urversion
;
;-
Pro Eject, _Video, VERBOSE=verbose, NOLABEL=nolabel, SHUTUP=shutup

   ON_Error, 2

   Handle_Value, _Video, Video, /NO_COPY

   If Video.VideoMode eq 'RECORD' or Video.VideoMode eq 'EDIT' then begin
      If Video.VideoMode eq 'EDIT' then writeu, Video.infounit, max([Video.FramePointer, Video.Length]) else writeu, Video.infounit, Video.FramePointer
      
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






