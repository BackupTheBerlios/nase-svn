;+
; NAME: LoadVideo()
;
; PURPOSE: Öffnen eines zuvor aufgezeichneten Array-Videos
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: MyVideo = LoadVideo ( [TITLE] [,/VERBOSE] )
; 
; INPUTS: ---
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS: TITLE: Filename und Videotitel
;
; OUTPUTS: MyVideo: Eine initialisierte Videostruktur
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Öffnet .vid und .vidinf Files zum Lesen
;
; RESTRICTIONS: ---
;
; PROCEDURE: Aus dem .vidinf-File die Arrayinformationen lesen und in
;               die Struktur schreiben.
;
; EXAMPLE: MyVideo = LoadVideo (TITLE = 'The quiet Neuron', /VERBOSE)
;
; MODIFICATION HISTORY:
;
;       Wed Aug 27 17:49:54 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Function LoadVideo, TITLE=title, VERBOSE=verbose
   
   Default, title, "The Spiking Neuron"   
 
   filename = title+".vid"
   infoname = title+".vidinf"


   openr, infounit, /GET_LUN, infoname
   
   dims = 0l & readu, infounit, dims
   rest = lonarr(dims+2) & readu, infounit, rest
   FrameSize = [dims, rest] ; Das SIZE-Array eines Frames

   leer80 = "                                                                                "
   ltitle = leer80 
   lsystem = leer80
   lstarring = leer80
   lcompany = leer80
   lproducer = leer80
   lyear = leer80
   readu, infounit, ltitle, lsystem, lstarring, lcompany, lproducer, lyear ;Miscellaneous Info...
   title    = strtrim(ltitle, 2)
   system   = strtrim(lsystem, 2)
   starring = strtrim(lstarring, 2)
   company  = strtrim(lcompany, 2)
   producer = strtrim(lproducer, 2)
   year     = strtrim(lyear, 2)

   Length = 0l & readu, infounit, Length ;Anzahl der Frames
   
   close, infounit

   openr, unit, /GET_LUN, filename

  
            

   If Keyword_set(VERBOSE) then begin
      print
      print, "-------------------------------------------------------------"
      print, company+' presents:'
      print
      print, "           A "+producer+" film on "+system+"."
      print
      print
      print, '             > > > '+title+' < < <'
      print
      print
      print, "    Starring: "+starring
      print, "-------------------------------------------------------------"
   endif else begin
      print, 'Opening Video "'+title+'".'
   end


   return, {VideoMode   : 'PLAY', $
            title       : title, $
            year        : year, $
            company     : company, $
            unit        : unit, $
            FrameSize   : FrameSize, $
            Length      : Length, $
            FramePointer: 0l}
   
End
