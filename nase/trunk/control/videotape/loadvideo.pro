;+
; NAME: LoadVideo()
;
; PURPOSE: Öffnen eines zuvor aufgezeichneten Array-Videos, die Routine erkennt
;          dabei automatisch, ob das Video gezippt ist oder nicht.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: MyVideo = LoadVideo ( [Title] [,TITLE] [,/VERBOSE] [,/INFO] [,/EDIT]
;                                         [,GET_LENGTH] [,GET_SIZE]
;                                         [,GET_TITLE] [,GET_SYSTEM] [,GET_STARRING]
;                                         [,GET_COMPANY] [,GET_PRODUCER] [,GET_YEAR] 
;                                         [,/SHUTUP] [,ERROR=error])
; 
; INPUTS:  Title     : Filename und Videotitel. Dieser Parameter hat
;                      exakt die gleiche Funktion wie das
;                      TITLE-Keyword. Nur eines von beiden muß (und
;                      sollte) angegeben werden! (Bzw. keines für den Defaulttitel.)
;
; KEYWORD PARAMETERS: TITLE:  Filename, der auch der Videotitel ist.
;                             Bei nichtangabe wird der Defaulttitel
;                             benutzt.
;                     INFO :  Wird dieses Keyword gesetzt, so wird eine
;                             Information über das Format und den
;                             Inhalt des Videos ausgegeben.
;                         Hinweis: In diesem Fall wird das Video NICHT
;                                  geöffnet, und die Funktion liefert
;                                  den Wert 0 zurück.
;                     EDIT:   Ein bestehendes Video wird zum Editieren geöffnet.
;                             (Z.B. um Frames anzuhängen oder zu ändern.
;                             VORSICHT! Anhängen muss immer als letzte Operation vor dem eject erfolgen!)
;                     SHUTUP: falls gesetzt, gibt es ueberhaupt keine
;                             Informationen aus
; 
; OPTIONAL OUTPUT:
;                     error: ist TRUE(=1), falls ein Fehler auftrat und
;                            FALSE(=0) falls nicht
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
;       $Log$
;       Revision 2.12  1998/05/13 12:38:21  kupper
;              Das EDIT-Keyword in LoadVideo ist jetzt freigegeben.
;               Es kann zum Ändern von oder Anhängen an Videos benutzt werden.
;               Aber man sollte immer wissen, was man tut...
;
;       Revision 2.11  1998/04/29 17:36:35  kupper
;              Sagt jetzt, wenns zippt.
;
;       Revision 2.10  1998/03/31 12:27:38  saam
;             if zipped and unzipped version exists
;             now the zipped version is the reference
;
;       Revision 2.9  1998/03/19 14:53:09  saam
;             new keyword 'ERROR'
;
;       Revision 2.8  1998/03/14 13:32:45  saam
;             now handles zipped and non-zipped videos
;
;
;       Tue Sep 9 21:37:38 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Der übergebene Titel wird jetzt nicht mehr verändert.
;
;       Tue Sep 9 13:02:45 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Title-Parameter zugefügt.
;
;       Tue Sep 2 19:05:51 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Free_Luns zugefügt, die ich sträflicherweise vergaß...
;
;       Thu Aug 28 15:55:11 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		TITEL-Keyword verarbeitet jetzt Pfade richtig.
;                   INFO-Keyword zugefügt.
;
;       Wed Aug 27 17:49:54 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Urversion
;
;-

Function LoadVideo, _Title, TITLE=__title, VERBOSE=verbose, INFO=info, $
                    GET_LENGTH=get_length, GET_SIZE=get_size, $
                    GET_TITLE=get_title ,GET_SYSTEM=get_system, GET_STARRING=get_starring, $
                    GET_COMPANY=get_company, GET_PRODUCER=get_producer, GET_YEAR=get_year, $
                    EDIT=edit, SHUTUP=shutup, ERROR=error
   
   Default, __title, _Title
   Default, __title, "The Spiking Neuron"   
   Default, error  , 0

   filename = __title+".vid"
   infoname = __title+".vidinf"
   Parts = str_sep(__title, '/')
   title = Parts(n_elements(Parts)-1)

   c = ZipStat(filename, ZIPFILES=zf, NOZIPFILES=nzf, BOTHFILES=bf)
   IF nzf(0) NE '-1'  THEN zipped = 0 ELSE zipped = 1

   IF NOT fileExists(infoname) THEN BEGIN
      error = 1
      RETURN, -1
   END

   Get_Lun, infounit
   openr, infounit, infoname
   
   dims = 0l & readu, infounit, dims
   rest = lonarr(dims+2) & readu, infounit, rest
   FrameSize = [dims, rest] & GET_SIZE=FrameSize ; Das SIZE-Array eines Frames

   leer80 = "                                                                                "
   ltitle = leer80 
   lsystem = leer80
   lstarring = leer80
   lcompany = leer80
   lproducer = leer80
   lyear = leer80
   readu, infounit, ltitle, lsystem, lstarring, lcompany, lproducer, lyear ;Miscellaneous Info...
   title    = strtrim(ltitle, 2)      & GET_TITLE=title
   system   = strtrim(lsystem, 2)     & GET_SYSTEM=system
   starring = strtrim(lstarring, 2)   & GET_STARRING=starring
   company  = strtrim(lcompany, 2)    & GET_COMPANY=company
   producer = strtrim(lproducer, 2)   & GET_PRODUCER=producer
   year     = strtrim(lyear, 2)       & GET_YEAR=year

   Length = 0l & readu, infounit, Length & GET_LENGTH=length ;Anzahl der Frames

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
   endif else IF NOT keyword_set(shutup) THEN begin
      print, 'Opening Video "'+title+'".'
   end
   IF zipped THEN begin
      message, /INFORM, " ...unzipping..."
      Unzip, filename
      if not !QUIET then print, !key.up+"                                                          "+!key.up
   EndIf

   Get_Lun, unit
   If Keyword_Set(EDIT) then begin
      openu, unit, filename
      VideoMode = 'EDIT'

      leer80 = "                                                                                "
      ltitle = leer80 & strput, ltitle, title
      lsystem = leer80 & strput, lsystem, system
      lstarring = leer80 & strput, lstarring, starring
      lcompany = leer80 & strput, lcompany, company
      lproducer = leer80 & strput, lproducer, producer
      lyear = leer80 & strput, lyear, year
      
      Get_Lun, infounit
      openw, infounit, infoname
      
      writeu, infounit, FrameSize ; Das SIZE-Array eines Frames
      writeu, infounit, ltitle, lsystem, lstarring, lcompany, lproducer, lyear ;Miscellaneous Info...
                                ;später wird noch die FrameAnzahl angehängt.
      
   endif else begin
      openr, unit, filename
      VideoMode = 'PLAY'
      infounit = -1
   endelse

   return, {VideoMode   : VideoMode, $
            filename    : filename,$
            title       : title, $
            year        : year, $
            company     : company, $
            unit        : unit, $
            infounit    : infounit, $
            FrameSize   : FrameSize, $
            Length      : Length, $
            FramePointer: 0l,$
            zipped      : zipped}
   
End










