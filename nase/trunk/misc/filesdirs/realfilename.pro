;+
; NAME:
;  RealFilename()
;
; VERSION:
;  $Id$
;
; AIM:
;  Cleans a pathname from automounter artifacts.
;
; PURPOSE:
;  <C>RealFilename()</C> is used to manipulate a filename according to
;  certain requirements. It was originally developed to clean
;  pathnames from automounter artifacts specific for the Marburgian UNIX
;  environment. By setting the system variable <C>!CHANGEFILENAME</C>
;  to <I>'marburg'</I>, <C>RealFilename()</C> still works in this way. This
;  is also the default setting, done during execution of
;  <A>DefGlobVars</A>.<BR>
;  It is
;  possible to implement new desired behaviors by adding
;  instructions for other values of <C>!CHANGEFILENAME</C>. Currently,
;  there is one variation of the <I>'marburg'</I> mode, called
;  <I>'moderatemarburg'</I>. It differs from the standard
;  <I>'marburg'</I> behaviour only insofar as to leave the
;  filename-prefix '/home' unchanged. (In <I>'marburg'</I> mode,
;  '/home' is replaced by '/usr').<BR> 
;  Another value is 'off', which
;  results in <C>RealFilename()</C> doing nothing. 
;
; CATEGORY:
;  Dirs
;  Files
;  OS
;
; CALLING SEQUENCE:
;* newname = RealFilename( filepath )
;
; INPUTS:
;  filepath:: The complete filename as a string variable.
;
; OUTPUTS:
;  newname:: The manipulated filename, also a string.  
;
; PROCEDURE:
;  Execute commands according to <C>!CHANGEFILENAME</C>'s
;  value in a CASE statement.
;
; EXAMPLE:
;*  !CHANGEFILENAME='marburg'
;*  Print, RealFilename('/a/ax1319/usr/ax1319.a/...')
;*> /usr/ax1319.a/..
;*  Print, RealFilename('/home/athiel/IDL/...')
;*> /usr/athiel/IDL/...
;*  !CHANGEFILENAME='off'
;*  Print, RealFilename('/home/athiel/IDL/...')
;*> /home/athiel/IDL/...
;
; SEE ALSO:
;  <A>DefGlobVars</A>.
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.7  2001/05/08 16:09:24  kupper
;     Added 'moderatemarburg' mode.
;
;     Revision 2.6  2001/05/08 15:37:18  thiel
;        !CHANGEFILENAME is now defined in DEFGLOBVARS.
;
;     Revision 2.5  2001/05/08 13:44:23  thiel
;        RealFileName can be turned off now.
;
;     Revision 2.4  2000/09/25 09:13:03  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.3  1999/07/28 08:38:12  saam
;           fixed a bug with slashes
;
;     Revision 2.2  1999/03/11 14:06:10  saam
;           + uses the much more flexible StrRepeat command
;           + completely rewritten
;           + works now!!
;
;     Revision 2.1  1998/11/13 21:16:02  saam
;           created because of several problems with
;           automounted directories, a wrong PWD-resolutions
;           leads to access to the internal automount-dirctories
;           with the consequence that paths which are
;           currently unmounted are and will not be availible,
;           this small routine fixes this problem. All other
;           routines in this directory use it...
;

FUNCTION RealFilename, FilePath

   ON_Error, 2

   IF N_Params() NE 1 THEN Console, 'Wrong calling syntax.', /FATAL
   
   Renorm = FilePath

   ;; Is !CHANGEFILENAME defined at all?
   ;; This should have happended in DefGlobVars.
   DefSysV, '!CHANGEFILENAME', EXISTS=ex

   IF ex THEN BEGIN ;; !CHANGEFILENAME is defined

      CASE !CHANGEFILENAME OF ;; execute actions according to value of 
                              ;; !CHANGEFILENAME 

         'marburg' : BEGIN ;; Marburg Unix specific actions
            Renorm = StrReplace(Renorm, '/tmp_mnt/', '/')
            slashified = Str_Sep(Renorm, '/')
            IF N_Elements(slashified) GT 1 THEN BEGIN
               IF ((slashified(0) EQ '') AND (slashified(1) EQ 'a')) THEN  $
                Renorm = StrReplace(Renorm, '/'+slashified(1)+'/'+ $
                                    slashified(2)+'/', '/')
            ENDIF
            Renorm = StrReplace(Renorm, '/home/', '/usr/')
            Renorm = StrReplace(Renorm, '/gonzo/', '/ax1317/')
            Renorm = StrReplace(Renorm, '/./','/')
            Renorm = RemoveDup(Renorm, '/')
         END ;; Marburg Unix specific actions

         'moderatemarburg' : BEGIN ;; Marburg Unix specific actions
            ;; only difference to 'marburg'-mode: /home/ is NOT changed.
            Renorm = StrReplace(Renorm, '/tmp_mnt/', '/')
            slashified = Str_Sep(Renorm, '/')
            IF N_Elements(slashified) GT 1 THEN BEGIN
               IF ((slashified(0) EQ '') AND (slashified(1) EQ 'a')) THEN  $
                Renorm = StrReplace(Renorm, '/'+slashified(1)+'/'+ $
                                    slashified(2)+'/', '/')
            ENDIF
            Renorm = StrReplace(Renorm, '/gonzo/', '/ax1317/')
            Renorm = StrReplace(Renorm, '/./','/')
            Renorm = RemoveDup(Renorm, '/')
         END ;; Marburg Unix specific actions

         'off' : BEGIN ;; do nothing
            ; Console, 'Filename change turned OFF.', /MSG
         END ;; do nothing

         ELSE: BEGIN;; none of the above?
            Console, 'Unknown !CHANGEFILENAME. Filename NOT changed.',  /MSG
         END

      ENDCASE

   ENDIF ELSE BEGIN ;;!CHANGEFILENAME is not defined. Shouldnt happen!
      Console, '!CHANGEFILENAME not defined. Did you call DEFGLOBVARS?', /FATAL
   ENDELSE
     
   Return, Renorm
   
END





