;+
; NAME: InitVideo()
;
; PURPOSE: Initialisierung eines Array-Videos
;
;          Zur Video-Familie gehören: InitVideo()
;                                     CamCord()
;                                     Eject
;                                     LoadVideo()
;                                     Replay()
;                                     Rewind
;
;          Das typische Vorgehen wäre folgendes:
;
;                      - Besorge Dir ein leeres Video mit     InitVideo()
;                      - Nehme beliebig viele Frames auf mit  CamCord()
;                      - Beende die Aufnahme mit              Eject
;                      - Tu was Du willst, bis Du das
;                         Video brauchst, dann 
;                      - Lege das Video ein mit               LoadVideo()    
;                     (- Spule zu einer bestimmten Stelle mit Rewind() )
;                      - Spiele beliebig viele Frames ab mit  Replay() 
;                      - Beende die Wiedergabe mit            Eject
;                     (- Erzeuge nachträglich ein Label mit   Label )
;                          
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: MyVideo = InitVideo ( MusterFrame [,Title] [,TITLE] [,SYSTEM] [,STARRING]
;                                                     [,COMPANY] [,PRODUCER] [,YEAR]
;                                                     [,/VERBOSE] [,/SHUTUP] [,/ZIPPED])
; 
; INPUTS: MusterFrame: Ein Array des Typs und der Größe, die aufgezeichnet werden sollen.
;                      Leider sind StringArrays nicht erlaubt.
;                   Hinweis: Der Musterframe dient wirklich nur als Muster,
;                            wird also NICHT aufgezeichnet!
;
;          Title     : Filename und Videotitel. Dieser Parameter hat
;                      exakt die gleiche Funktion wie das
;                      TITLE-Keyword. Nur eines von beiden muß (und
;                      sollte) angegeben werden! (Bzw. keines für den Defaulttitel.)
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS: TITLE,  SYSTEM, STARRING, COMPANY, PRODUCER, YEAR:
;                             Für mehr Freude an der Simulation...
;                             Alle diese Schlüsselworte können auf Strings gesetzt werden (max. 80 Zeichen)
;                             Für alle sind auch Defaults definiert.
;                             HABEN KEINE WEITERE FUNKTION, AUßER DER ERHEITERUNG UND MUßE!
;                             Doch: TITLE legt auch den Filenamen fest!
;                     SHUTUP: unterdrueckt jegliche Bildschirmausgabe
;                     ZIPPED: erzeugt ein gezipptes Video
;
; OUTPUTS: MyVideo: Eine initialisierte Videostruktur
;
; SIDE EFFECTS:  Öffnet ein .vid- und .vidinf-File
;
; PROCEDURE: Ein Infofile erzeugen (.vidinf)
;            Ein DatenFile erzeugen (.vid), in das später geschrieben wird.
;
; EXAMPLE: 1. MusterFrame = intarr(3)
;             MyVideo = InitVideo( MusterFrame )
;          
;          2. MusterFrame = dblarr(20,20)
;             MyVideo = InitVideo (MusterFrame, TITLE='The quiet Neuron', /VERBOSE)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.12  2000/06/19 13:08:08  saam
;             + replaced string processing by an IDL3.6 compatible version
;
;       Revision 2.11  2000/04/03 12:02:56  saam
;             Changed Default Values:
;       	SYSTEM -> name of the calling routine
;               YEAR   -> includes now hour:minutes:seconds
;
;       Revision 2.10  1998/11/08 14:51:37  saam
;             + video-structure made a handle
;             + ZIP-handling replaced by UOpen[RW]
;
;       Revision 2.9  1998/03/14 13:32:45  saam
;             now handles zipped and non-zipped videos
;
;
;       Tue Sep 9 21:36:58 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Der übergebene Titel wird jetzt nicht mehr verändert.
;
;       Tue Sep 9 13:00:34 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Title-Parameter zugefügt.
;
;       Sun Sep 7 17:17:13 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Nimmt jetzt auch Skalare richtig auf.
;
;       Fri Aug 29 15:04:41 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Der YEAR-Tag enthält jetzt defaultmäßig auch den Tag
;		und Monat der Aufzeichnung.
;
;       Thu Aug 28 15:54:26 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		TITEL-Keyword verarbeitet jetzt Pfade richtig.
;
;       Wed Aug 27 17:20:58 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Urversion
;
;-

Function InitVideo, Frame, _Title, TITLE=__title, $
                    SYSTEM=system, STARRING=starring, COMPANY=company, PRODUCER=producer, YEAR=year, $
                    VERBOSE=verbose, SHUTUP=shutup, ZIPPED=zipped

   On_Error, 2

   ; since videos now use UOpen routines i renamed keyword ZIPPED to ZIP because of constistent keywords

   If not(set(Frame)) then message, 'Bitte Musterframe angeben!'

   Default, ZIPPED, 0
   Default, __title, _title
   Default, __title, "The Spiking Neuron"   

   help, calls=m
   m = m(1)

   _called_by = split(m,'/')
   _called_by = _called_by(N_elements(_called_by)-1)
   _called_by =  strmid(_called_by,0,strpos(_called_by,'.pro'))

   Default, system, STRUPCASE(_called_by)

   Default, starring, "Nerd ""die NASE"" Neuron"
   Default, company, "AG Neurophysik"
   Default, producer, GETENV("USER")
   Default, year, systime()
 
   filename = __title+".vid"
   infoname = __title+".vidinf"
   Parts = str_sep(__title, '/')
   title = Parts(n_elements(Parts)-1)

   If Keyword_set(VERBOSE) then begin
      print
      print, "Welcome to the recording of """+title+"""!"
      print, "This is a "+producer+" film on "+system+"."
   endif ELSE IF NOT Keyword_Set(SHUTUP) THEN  BEGIN
      print, "Initializing Video """+title+"""."
   ENDIF
   
   leer80 = "                                                                                "
   ltitle = leer80 & strput, ltitle, title
   lsystem = leer80 & strput, lsystem, system
   lstarring = leer80 & strput, lstarring, starring
   lcompany = leer80 & strput, lcompany, company
   lproducer = leer80 & strput, lproducer, producer
   lyear = leer80 & strput, lyear, year


   infounit = UOpenW(infoname)
   
   writeu, infounit, size([Frame])   ; Das SIZE-Array eines Frames
   writeu, infounit, ltitle, lsystem, lstarring, lcompany, lproducer, lyear ;Miscellaneous Info...
   ;später wird noch die FrameAnzahl angehängt.
   
   unit = UOpenW(filename, ZIP=ZIPPED)

  
   tmp =  {VideoMode   : 'RECORD', $
           filename    : filename, $
           title       : title, $
           unit        : unit, $
           infounit    : infounit, $
           FrameSize   : size([Frame]), $
           FramePointer: 0l}
           
   RETURN, Handle_Create(!MH, VALUE=tmp, /NO_COPY)
End
