;+
; NAME:
;  LoadVideo()
;
; VERSION:
;  $Id$
;
; AIM:
;  Opens an existing video.
;
; PURPOSE:
;  Opens an existing video on hard disk. This routine automatically
;  detects if the video is compressed.
;
; CATEGORY:
;  DataStorage
;  DataStructures
;  Files
;  IO
;
; CALLING SEQUENCE:
;*  V = LoadVideo ( [Title] [,TITLE=...]  [,/INFO] [,/EDIT]
;*                  [,GET_LENGTH=...] [,GET_SIZE=...] [,GET_TITLE=...]
;*                  [,GET_SYSTEM=...] [,GET_STARRING=...]
;*                  [,GET_COMPANY=...] [,GET_PRODUCER=...] [,GET_YEAR=...] 
;*                  [,UDS=...]
;*                  [,{/VERBOSE | /SHUTUP}] [,ERROR=error])
;
; INPUTS:
;  title      :: Filename and title of the video. This parameter is
;                identical with the TITLE keyword. You should only set
;                one of both.
;
; INPUT KEYWORDS:
;   TITLE:: filename and title of the video. This parameter is
;           identical with the title parameter. You should only set
;           one of both.
;   INFO :: Only information about format and content of the
;           video will be displayed. The video will not be opened!
;   EDIT :: The video will be opened for <I>editing</I> (e.g. to append or
;           modify certain frames). <B>Take care!</B> Appending must be the 
;           last operation before the final <A>Eject</A>.
;   SHUTUP:: Supresses all informational messages.
;  
;
; OUTPUTS:
;  V:: A valid video structure.
;  
; OPTIONAL OUTPUTS:
;   GET_xxx:: Determine properties of the video.
;   ERROR:: True if an error occurred during opening.
;   UDS  :: Will contain parameters (saved as structure) saved during
;           video creation.
;           This can be used to preserve simulation or other
;           relevant parameters.
;  
; SIDE EFFECTS:
;   Open <*>.vid</*> and <*>.vidinf</*> files for read (write with /EDIT).
;
; PROCEDURE:
;  Nothing known about this at the moment.
;
; EXAMPLE:
;* V = LoadVideo (TITLE = 'The quiet Neuron', /VERBOSE)
;* dummy = LoadVideo (TITLE = 'The unforgettable Firing', /INFO)
;
; SEE ALSO:
;  <A>InitVideo</A>, <A>Camcord</A>, <A>Rewind</A>, <A>Eject</A>.
;-



Function LoadVideo, _Title, TITLE=__title, VERBOSE=verbose, INFO=info, $
                    GET_LENGTH=get_length, GET_SIZE=get_size, $
                    GET_TITLE=get_title ,GET_SYSTEM=get_system, GET_STARRING=get_starring, $
                    GET_COMPANY=get_company, GET_PRODUCER=get_producer, GET_YEAR=get_year, $
                    EDIT=edit, SHUTUP=shutup, ERROR=error, UDS=uds
   

   ON_ERROR, 2
   
   Default, __title, _Title
   Default, __title, "The Spiking Neuron"   
   Default, error  , 0

   filename = __title+".vid"
   infoname = __title+".vidinf"
   Parts = str_sep(__title, '/')
   title = Parts(n_elements(Parts)-1)


   IF NOT fileExists(infoname) THEN BEGIN
      error = 1
      RETURN, -1
   END

   infounit = UOpenR(infoname)
   
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

   ;; UDS part
   IF NOT EOF(infounit) THEN UDS = LoadStruc(infounit) ELSE BEGIN
       IF Set(UDS) THEN Undef, UDS
   END

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

      UClose,infounit
      return, 0
   endif
;------------------------------------   
   UClose, infounit

           


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


   If Keyword_Set(EDIT) then begin
      unit = UOpenU(filename)
      VideoMode = 'EDIT'

      leer80 = "                                                                                "
      ltitle = leer80 & strput, ltitle, title
      lsystem = leer80 & strput, lsystem, system
      lstarring = leer80 & strput, lstarring, starring
      lcompany = leer80 & strput, lcompany, company
      lproducer = leer80 & strput, lproducer, producer
      lyear = leer80 & strput, lyear, year
      
      infounit = UOpenW(infoname)
      
      writeu, infounit, FrameSize ; Das SIZE-Array eines Frames
      writeu, infounit, ltitle, lsystem, lstarring, lcompany, lproducer, lyear ;Miscellaneous Info...
                                ;später wird noch die FrameAnzahl angehängt.
      
   endif else begin
      unit = UOpenR(filename)
      VideoMode = 'PLAY'
      infounit = -1
   endelse

   tmp = {VideoMode   : VideoMode, $
          filename    : filename,$
          title       : title, $
          year        : year, $
          company     : company, $
          unit        : unit, $
          infounit    : infounit, $
          FrameSize   : FrameSize, $
          Length      : Length, $
          FramePointer: 0l}
   
   RETURN, Handle_Create(!MH, VALUE=tmp, /NO_COPY)

END










