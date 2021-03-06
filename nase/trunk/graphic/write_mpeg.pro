;+
; NAME: 
;  Write_MPEG
;
; VERSION:
;  $Id$
;
; AIM:
;  Write a sequence of images as an mpeg movie.
;
; PURPOSE: 
;  Writes a sequence of images as an mpeg movie. Either truecolor or
;  pseudocolor images may be written. Since the MPEG format consists
;  of a sequence of truecolor-images, pseudocolor images are passed
;  through the currently loaded colortable before writing.
;
; CATEGORY:
;  Animation
;  Graphic
;
; CALLING SEQUENCE: 
;  If you have the whole movie sequence in a three dimensional array,
;  just call 
;* WRITE_MPEG, ims [,MPEGFILENAME=...] [,/TRUE] [,TMPDIR=...] [,/DELAFT] [,REP=REP] 
;
;  <BR>If the data is a sequence of image frames  (perhaps because the
;  whole movie would be too large for your working memory) use:
;
;* WRITE_MPEG, INIT=... [,MPEGFILENAME=...] [,TMPDIR=...] [,/DELAFT] [,REP=..] 
;* WRITE_MPEG, image, /WRITE [,/TRUE]
;* WRITE_MPEG, /CLOSE
;
; INPUTS:
;  ims:: sequence of images. For pseudocolor-images, this is a 3D array
;        with dimensions [xsize, ysize, #frames]. For
;        truecolor-images, this is a 4D array
;        with dimensions [3, xsize, ysize, #frames].
;  image:: image. For pseudocolor-images, this is a 2D array
;        with dimensions [xsize, ysize]. For
;        truecolor-images, this is a 3D array
;        with dimensions [3, xsize, ysize].    
;
; INPUT KEYWORDS:
;  CLOSE::        calls write_mpeg to produce a mpeg
;  DELAFT::       if set. the routine deletes the temporary array after movie was created.
;                  You should actually always do it otherwise you get
;                  problems with permissions on multiuser machines (since
;                  <*>/tmp</*> normally has the sticky bit set)
;  INIT::          calls write_mpeg to initialize image writing,
;                  where INIT is the number of images (default: 0)
;  MPEGFILENAME:: name of mpeg file (default: "test.mpg")
;  REP::          if given means repeat every image 'rep' times
;                  (as a workaround to modify replay speed)
;  TMPDIR::        directory for temporary data (default: provided by <A>TmpNam</A>)
;  WRITE::         calls write_mpeg to write the image
;  TRUE::         Set this keywrod to indicate that the image(s) to be
;                 written is a truecolor image.
;
; COMMON BLOCKS:
;  COMMON WRITE_MPEG_BLOCK , info
;
; SIDE EFFECTS:
;          creates some files in TMPDIR which are only removed when
;          the DELAFT keyword is used
;
; RESTRICTIONS:
;          depends on the program mpeg_encode from University of
;          California, Berkeley, which must be installed in a directory, 
;          which is used in the PATH environment.
;
; PROCEDURE:
;         writes a parameter file based on the dimensions of the image
;         array + the sequence of images in ppm format into a
;         temporary directory; finally spawns mpeg_encode to build the
;         movie
;
; EXAMPLE:
;first method:
;*frames=findgen(100,75,100) ;; 100 frames (3D array)
;*write_mpeg,frames                 
;
;<BR>second method:
;*;;here with function TVRD
;*write_mpeg,init=100
;*window,xsiz=100,ysize=75
;
;*FOR i =0l ,100-1 DO BEGIN
;*   utvscl,findgen(100,75)*reform(randomu(S,1))
;*   image=tvrd(/order)
;*   write_mpeg,image,/write
;*ENDFOR
;                     
;*write_mpeg,/close
;
;-

FUNCTION pseudo_to_true, image8

s = SIZE(image8)
IF s(0) NE 2 THEN BEGIN
  MESSAGE, 'input array must be 2D BYTE array.'
  RETURN, -1
ENDIF

width = s(1)
height = s(2)

; Load current color table into byte arrays
TVLCT, red, green, blue, /GET

image24 = BYTARR(3,width, height)
image24(0,*,*) = red(image8(*,*))
image24(1,*,*) = green(image8(*,*))
image24(2,*,*) = blue(image8(*,*))

RETURN, image24

END


PRO WRITE_MPEG, image_array,mpegFileName=mpegFileName,delaft=delaft, $
                rep=rep,TMPDIR=TMPDIR,INIT=INIT,WRITE=WRITE,CLOSE=CLOSE, TRUE=TRUE
COMMON WRITE_MPEG_BLOCK,info




default,status_flag,0
default,init,0
default,write,0
default,close,0
default,rep,1
default,delaft,0
default,TMPDIR , '/tmp/idl2mpeg.frames'
default,mpegfilename,'test.mpg'
default,framenum,0
default,nFrames,0
IF init GT 0 THEN undef,info
default,info,{status_flag: status_flag,$
              init: init,$
              rep: rep,$
              TMPDIR: TMPDIR,$
              framenum: framenum,$
              delaft: delaft,$
              mpegfilename: mpegfilename,$
              nFrames:nFrames}


IF init GT 0 THEN BEGIN 
   info.status_flag = 1
   info.framenum = 0
ENDIF

IF write EQ 1 THEN info.status_flag = 2
IF close EQ 1 THEN info.status_flag = 3
IF (info.init EQ 0 AND write EQ 1) OR (info.init EQ 0 AND close EQ 1) THEN $
 message,"You must call WRITE_MPEG  first with KEYWORD INIT" 

IF info.STATUS_FLAG EQ 0 OR  info.STATUS_FLAG EQ 2 THEN BEGIN
   movieSize = SIZE(image_array)
   If Keyword_Set(TRUE) then begin
      assert, movieSize(1) eq 3, $
              "True color images must have first dimension=3 !"
      xSize = movieSize(2)
      ySize = movieSize(3)
   endif else begin
      xSize = movieSize(1)
      ySize = movieSize(2)
   endelse
ENDIF




ON_IOERROR, badWrite


IF info.status_flag LE 1 THEN BEGIN
   ;; Make a temporary directory if necessary or clear it otherwise'

   SPAWN, 'if test -d ' + info.TMPDIR + '; then echo "exists"; fi', result, /SH
   dirExists = result(0) EQ 'exists'
   IF dirExists THEN command = 'rm -f ' + info.TMPDIR + '/*' $
   ELSE command = 'mkdir ' + info.TMPDIR
   SPAWN, command
   ;;so das reicht fuer init
   IF info.status_flag EQ 1 THEN BEGIN
      info.nFrames = info.init * info.rep 
      return 
   END ELSE info.nFrames = movieSize(3)*info.rep

ENDIF
nDigits = 1+FIX(ALOG10(info.nFrames))
formatString = STRCOMPRESS('(i'+STRING(nDigits)+'.'+STRING(nDigits)$
             +             ')', /REMOVE_ALL)


CASE 1  OF

   info.status_flag EQ 2: BEGIN
      If Keyword_Set(TRUE) then $
        image = image_array else $
        image = pseudo_to_true(image_array(*,*)) 
      for j=0,info.rep-1 do begin
         fileName = info.TMPDIR + '/frame.' + STRING(info.frameNum,FORMAT=formatString)$
          + '.ppm'
         IF j EQ 0 THEN begin
            WRITE_PPM, fileName, image
            zip,filename
            firstfileName = fileName+".gz"

         END ELSE BEGIN
            spawn, "ln -s " +firstfileName+ " " + fileName+ ".gz"
         ENDELSE
         PRINT, 'Wrote temporary PPM file for frame ', info.frameNum+1
         info.framenum=info.framenum+1
      ENDFOR
  
      IF info.framenum GT info.nFrames THEN BEGIN
         print,'Warning:Deleting temporally written files'
         SPAWN, 'rm -r ' + TMPDIR
          ;stop
         undef,info
         
         message,"Written more files than given with init!!"

      ENDIF
      return
   END 
   info.status_flag EQ 0 OR (info.status_flag EQ 3): BEGIN
      IF  info.status_flag EQ 0 THEN BEGIN
         ;; Write each frame into TMPDIR as a 24-bit .ppm image file
         info.framenum=0
         ;; get number of frames:
         If Keyword_Set(TRUE) then length = movieSize(4) else length = movieSize(3)
         FOR ino = 0, length-1 DO BEGIN
            If Keyword_Set(TRUE) then $
              image = image_array(*, *, *, ino) else $
              image = pseudo_to_true(image_array(*,*,ino))
            for j=0,info.rep-1 do begin
               fileName = info.TMPDIR + '/frame.' + STRING(info.frameNum,FORMAT=formatString)$
                + '.ppm'
               IF j EQ 0 THEN begin
                  WRITE_PPM, fileName, image
                  zip,filename
                  firstfileName = fileName + ".gs"
               END ELSE BEGIN
                  spawn, "ln -s " +firstfileName+ " " + fileName + ".gz"
               ENDELSE
               PRINT, 'Wrote temporary PPM file for frame ', info.frameNum+1
               info.framenum=info.framenum+1
            ENDFOR
         ENDFOR
      ENDIF
      ;; Build the mpeg parameter file
      paramFile = info.TMPDIR + '/idl2mpeg.params'
      OPENW, unit, paramFile, /GET_LUN
      PRINTF, unit, 'PATTERN		IBBBBBBBBBBP'
      PRINTF, unit, 'OUTPUT		' + info.mpegFileName
      PRINTF, unit, 'GOP_SIZE	16'
      PRINTF, unit, 'SLICES_PER_FRAME	1'
      PRINTF, unit, 'BASE_FILE_FORMAT	PNM'

      PRINTF, unit, 'INPUT_CONVERT gunzip -c *'

      PRINTF, unit, 'INPUT_DIR	'+ info.TMPDIR
      PRINTF, unit, 'INPUT'
      PRINTF, unit, 'frame.*.ppm ['+string(FORMAT=formatString,0) + $
       '-' + string(FORMAT=formatString,info.nFrames-1) + ']'
      PRINTF, unit, 'END_INPUT'
      PRINTF, unit, 'PIXEL		FULL'
      PRINTF, unit, 'RANGE		5'
      PRINTF, unit, 'PSEARCH_ALG	LOGARITHMIC'
      PRINTF, unit, 'BSEARCH_ALG	SIMPLE'
      PRINTF, unit, 'IQSCALE		5'
      PRINTF, unit, 'PQSCALE		5'
      PRINTF, unit, 'BQSCALE		5'
      PRINTF, unit, 'REFERENCE_FRAME	ORIGINAL'
      PRINTF, unit, 'FORCE_ENCODE_LAST_FRAME'
      FREE_LUN, unit
   
      ;; spawn a shell to process the mpeg_encode command
      SPAWN, 'mpeg_encode '  + paramFile

      IF info.delaft EQ 1 THEN $
       SPAWN, 'rm -r ' + info.TMPDIR
      undef,info
      RETURN
   END
ENDCASE
badWrite:
undef,info
message, 'Unable to write MPEG file!'

END
