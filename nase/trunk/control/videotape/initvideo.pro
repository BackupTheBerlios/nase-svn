;+
; NAME:
;  InitVideo()
;
; AIM:
;  initializes a video structure
;
; PURPOSE:
;  Initializes a video. There are severval routines concerning videos,
;  as <A>InitVideo</A>, <A>CamCord</A>, <A>Eject</A>,
;  <A>LoadVideo</A>, <A>Replay</A> and <A>Rewind</A>.<BR>
;
;  The typical usage of the video routines is as follows:<BR>
;     * <*>open a new video</*> using <A>InitVideo</A> <BR>
;     * <*>record numerous frames</*> using <A>CamCord</A><BR>
;     * <*>finish your record</*> using  <A>Eject</A><BR>
;*
;     * <*>open an existing video</*> using <A>LoadVideo</A><BR>
;     * <*>fast forward to a specific frame</*> using <A>Rewind</A><BR>
;     * <*>restore several frames</*> using <A>Replay</A><BR>
;     * <*>finish playback</*> with <A>Eject</A>
;
; CATEGORY:
;  DataStorage
;  DataStructures
;  Files
;  IO
;  OS
;
; CALLING SEQUENCE:
;*  V = InitVideo ( sampleFrame [,title] [,TITLE=...] [,SYSTEM=...] [,STARRING=...]
;*                              [,COMPANY=...] [,PRODUCER=...] [,YEAR=...]
;*                              [,UDS=uds]
;*                              [,{/VERBOSE | /SHUTUP}] [,/ZIPPED])
; 
; INPUTS: 
;  sampleFrame:: Sample array, defining the size and type of all
;                following frames. No string arrays are allowed,
;                sorry. The sampleFrame is just a template and will not
;                be recorded.
;
;  title      :: filename and title of the video. This parameter is
;                identical with the TITLE keyword. You should only set
;                one of both.
;
; INPUT KEYWORDS: 
;   TITLE,  SYSTEM, STARRING, COMPANY, PRODUCER, YEAR::
;     information will be stored in the video and can be
;     restored. Each keyword has to be a string (80 chars max).
;     These keywords have no real function, except telling the user 
;     what data will be restored
;   VERBOSE:: talks about everything no one will want to hear about...
;   SHUTUP:: supresses every informational messages
;   ZIPPED:: the video will be gzipped on the hard disk.
;   UDS   :: an arbitrary structure that will also be saved on
;            disk. It can be used to preserve simulation or other
;            relevant parameters.
;
; OUTPUTS:
;  V:: a valid video structure
;
; SIDE EFFECTS:
;  opens .vid and .vidinf files
;
; EXAMPLE:
;* sampleFrame = dblarr(20,20)
;* V = InitVideo (sampleFrame, TITLE='The quiet Neuron', /VERBOSE)
;
;-
Function InitVideo, Frame, _Title, TITLE=__title, $
                    SYSTEM=system, STARRING=starring, COMPANY=company, PRODUCER=producer, YEAR=year, $
                    VERBOSE=verbose, SHUTUP=shutup, ZIPPED=zipped, UDS=uds

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

   ;; UDS part
   IF Set(UDS) THEN BEGIN
       IF TypeOf(UDS) NE "STRUCT" THEN Console, "UDS must be a structure", /FATAL
       SetTag, tmp, "UDS", UDS       
   END
           
   RETURN, Handle_Create(!MH, VALUE=tmp, /NO_COPY)
End
