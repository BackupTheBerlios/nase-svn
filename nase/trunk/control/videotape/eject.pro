;+
; NAME: Eject
;
; PURPOSE: Schließen eines mit InitVideo oder LoadVideo geöffneten Array-Videos.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Eject, Video [,/VERBOSE]
; 
; INPUTS: Video: eine mit InitVideo oder LoadVideo initialisierte Videostruktur
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS: VERBOSE: Für mehr Freude an der Simulation...
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Schliesst das .vid- und ev. das .vidinf-File
;
; RESTRICTIONS: ---
;
; PROCEDURE: War das Video zur Aufnahme geöffnet, so wird an das .vidinf-File noch die FrameAnzahl angehängt.
;            .vid und .vidinf werden geschlossen.
;
; EXAMPLE: Eject, MyVideo, /VERBOSE
;
; MODIFICATION HISTORY:
;
;       Wed Aug 27 17:09:55 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Pro Eject, Video, VERBOSE=verbose

   If Video.VideoMode eq 'RECORD' then begin
      writeu, Video.infounit, Video.FramePointer
      
      if keyword_set(VERBOSE) then begin
         print
         print, 'KLAPPE! Die Dreharbeiten zu "'+Video.Title+'" sind nach '+strtrim(string(Video.FramePointer),1)+' Einstellungen beendet.'
      endif else begin
         print, 'Closing Video "'+Video.title+'". Recorded Frames: '+strtrim(string(Video.FramePointer),1)
      end
      
      close, Video.unit
      close, Video.infounit
      
   endif else begin             ; VideoMode="PLAY"
      
      if keyword_set(VERBOSE) then begin
         print
         print, '                      E N D E'
         print
         print, '                 (c)'+Video.company+' '+Video.year
      endif else begin
         print, 'Closing Video "'+Video.title+'".'
      endelse
      
      close, Video.unit
         
   endelse

end
