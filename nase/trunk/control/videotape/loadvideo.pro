;+
; NAME: LoadVideo()
;
; PURPOSE: Öffnen eines zuvor aufgezeichneten Array-Videos
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: MyVideo = LoadVideo ( [Title] [,TITLE] [,/VERBOSE] [,/INFO] )
; 
; INPUTS:  Title     : Filename und Videotitel. Dieser Parameter hat
;                      exakt die gleiche Funktion wie das
;                      TITLE-Keyword. Nur eines von beiden muß (und
;                      sollte) angegeben werden! (Bzw. keines für den Defaulttitel.)
;
; KEYWORD PARAMETERS: TITLE: Filename, der auch der Videotitel ist.
;                            Bei nichtangabe wird der Defaulttitel
;                            benutzt.
;                     INFO : Wird dieses Keyword gesetzt, so wird eine
;                            Information über das Format und den
;                            Inhalt des Videos ausgegeben.
;                         Hinweis: In diesem Fall wird das Video NICHT
;                                  geöffnet, und die Funktion liefert
;                                  den Wert 0 zurück.
;
;
; OUTPUTS: MyVideo: Eine initialisierte Videostruktur
;
; SIDE EFFECTS: Öffnet .vid und .vidinf Files zum Lesen
;
; PROCEDURE: Aus dem .vidinf-File die Arrayinformationen lesen und in
;               die Struktur schreiben.
;
; EXAMPLE: 1. MyVideo = LoadVideo (TITLE = 'The quiet Neuron', /VERBOSE)
;          2. Dummy   = LoadVideo (TITLE = 'The unforgettable Firing', /INFO)
;
; MODIFICATION HISTORY:
;
;       Tue Sep 9 13:02:45 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Title-Parameter zugefügt.
;
;       Tue Sep 2 19:05:51 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Free_Luns zugefügt, die ich sträflicherweise vergaß...
;
;       Thu Aug 28 15:55:11 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TITEL-Keyword verarbeitet jetzt Pfade richtig.
;                   INFO-Keyword zugefügt.
;
;       Wed Aug 27 17:49:54 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Function LoadVideo, _Title, TITLE=title, VERBOSE=verbose, INFO=info
   
   Default, title, _Title
   Default, title, "The Spiking Neuron"   
 
   filename = title+".vid"
   infoname = title+".vidinf"
   Parts = str_sep(title, '/')
   title = Parts(n_elements(Parts)-1)

   Get_Lun, infounit
   openr, infounit, infoname
   
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

;---------------- Video Info anzeigen
   type = ["Undefined", "Byte", "Integer", "Longword Integer", "Floating Point", "Double-Precision Floating Point", "Complex Floating Point", "String", "Structure", "Double-precision Complex"]

   If keyword_set(INFO) then begin
      print, '**'
      print, '** Video Information for "'+title+'":'
      print, '**'
      print, '** This Video contains '+strtrim(string(Length), 2)+' Frames'
      print, '**      of a '+strtrim(string(dims), 2)+'-dimensional '+Type(FrameSize(n_elements(FrameSize)-2))+' Array'
      s = "("
      for i=1, n_elements(FrameSize)-3 do s = s+strtrim(string(FrameSize(i)), 2)+","
      s = strmid(s, 0, strlen(s)-1)+")"
      print, '**      of size '+s+'.'
      print, '**'
      print, "** The Video Data File is named  '"+filename+"',"
      print, "**  the Video Info File is named '"+infoname+"'."
      print, '**'
      print, '** Miscellaneous Data Tags:'
      print, '**    SYSTEM  : '+system
      print, '**    COMPANY : '+company
      print, '**    PRODUCER: '+producer
      print, '**    YEAR    : '+year
      print, '**    STARRING: '+starring
      if not eof(infounit) then begin
         print, '**'
         print, '** The Video-Cassette is labeled:'
         print, '**    -----------------------------------------------------------------------------------------'
         l = ""
         while not eof(infounit) do begin
            readf, infounit, l
            print, '**   | '+l
         endwhile
         print, '**    -----------------------------------------------------------------------------------------'
      endif else begin
        print, '**'
        print, '** The Video-Cassette is not labeled.'
      endelse

      close, infounit
      Free_Lun, infounit
      return, 0
   endif
;------------------------------------   
   close, infounit
   Free_Lun, infounit

   Get_Lun, unit
   openr, unit, filename
           

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










