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
;                          
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: MyVideo = InitVideo ( MusterFrame [,Title] [,TITLE] [,SYSTEM] [,STARRING]
;                                                     [,COMPANY] [,PRODUCER] [,YEAR]
;                                                     [,/VERBOSE] )
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
; KEYWORD PARAMETERS: TITLE, SYSTEM, STARRING, COMPANY, PRODUCER, YEAR:
;                            Für mehr Freude an der Simulation...
;                            Alle diese Schlüsselworte können auf Strings gesetzt werden (max. 80 Zeichen)
;                            Für alle sind auch Defaults definiert.
;                            HABEN KEINE WEITERE FUNKTION, AUßER DER ERHEITERUNG UND MUßE!
;
;                     Doch: TITLE legt auch den Filenamen fest!
;
; OUTPUTS: MyVideo: Eine initialisierte Videostruktur
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS:  Öffnet ein .vid- und .vidinf-File
;
; RESTRICTIONS: ---
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
;       Tue Sep 9 13:00:34 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Title-Parameter zugefügt.
;
;       Sun Sep 7 17:17:13 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Nimmt jetzt auch Skalare richtig auf.
;
;       Fri Aug 29 15:04:41 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Der YEAR-Tag enthält jetzt defaultmäßig auch den Tag
;		und Monat der Aufzeichnung.
;
;       Thu Aug 28 15:54:26 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TITEL-Keyword verarbeitet jetzt Pfade richtig.
;
;       Wed Aug 27 17:20:58 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion
;
;-

Function InitVideo, Frame, _Title, TITLE=title, $
                    SYSTEM=system, STARRING=starring, COMPANY=company, PRODUCER=producer, YEAR=year, $
                    VERBOSE=verbose

   If not(set(Frame)) then message, 'Bitte Musterframe angeben!'

   Default, title, _title
   Default, title, "The Spiking Neuron"   
   Default, system, "CVS"
   Default, starring, "Nerd ""die NASE"" Neuron"
   Default, company, "AG Neurophysik"
   Default, producer, GETENV("USER")
   Default, year, strmid(systime(),0,11)+' '+strmid(systime(),20,24)
 
   filename = title+".vid"
   infoname = title+".vidinf"
   Parts = str_sep(title, '/')
   title = Parts(n_elements(Parts)-1)

   If Keyword_set(VERBOSE) then begin
      print
      print, "Welcome to the recording of """+title+"""!"
      print, "This is a "+producer+" film on "+system+"."
   endif else begin
      print, "Initializing Video """+title+"""."
   endelse
   
   leer80 = "                                                                                "
   ltitle = leer80 & strput, ltitle, title
   lsystem = leer80 & strput, lsystem, system
   lstarring = leer80 & strput, lstarring, starring
   lcompany = leer80 & strput, lcompany, company
   lproducer = leer80 & strput, lproducer, producer
   lyear = leer80 & strput, lyear, year


   Get_Lun, infounit
   openw, infounit, infoname
   
   writeu, infounit, size([Frame])   ; Das SIZE-Array eines Frames
   writeu, infounit, ltitle, lsystem, lstarring, lcompany, lproducer, lyear ;Miscellaneous Info...
   ;später wird noch die FrameAnzahl angehängt.
   
   Get_Lun, unit
   openw, unit, filename

  
   return, {VideoMode   : 'RECORD', $
            title       : title, $
            unit        : unit, $
            infounit    : infounit, $
            FrameSize   : size([Frame]), $
            FramePointer: 0l}
            
End
