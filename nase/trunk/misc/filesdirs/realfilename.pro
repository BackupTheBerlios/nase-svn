;+
; NAME:
;  RealFileName()
;
; VERSION:
;  $Id$
;
; AIM:
;  Cleans a pathname from automounter artifacts.
;
; PURPOSE:
;  <C>RealFileName()</C> is used to manipulate a filename according to
;  certain requirements. It was originally developed to clean
;  pathnames from automounter artifacts specfic for the Marburgian UNIX
;  environment. By setting the system variable <C>!CHANGEFILENAME</C>
;  to 'marburg', <C>RealFileName()</C> still works in this way. It is
;  possible to implement new desired behaviors by adding
;  instructions for other values of <C>!CHANGEFILENAME</C>. Currently,
;  the only other value is 'off', which
;  results in <C>RealFileName()</C> doing nothing.
;
; CATEGORY:
;  Dirs
;  Files
;  OS
;
; CALLING SEQUENCE:
;*newname = RealFileName( filepath )
;
; INPUTS:
;  filepath:: The complete filename as a string variable.
;
; OUTPUTS:
;  newname:: The manipulated filename, also a string.  
;
; RESTRICTIONS:
;  Currently, if <C>!CHANGEFILENAME</C> is not set,
;  <C>RealFileName()</C> executes the Marburg specific commands like
;  it always did.
;
; PROCEDURE:
;  - Check if <C>!CHANGEFILENAME</C> is set.<BR>
;  - If yes, execute commans according to <C>!CHANGEFILENAME</C>'s
;  value.<BR>
;  - If not, behave like always.
;
; EXAMPLE:
;*  DefSysV, '!CHANGEFILENAME', 'marburg'
;*  Print, RealFileName('/a/ax1319/usr/ax1319.a/...')
;*> /usr/ax1319.a/..
;*  Print, RealFileName('/home/athiel/IDL/...')
;*> /usr/athiel/IDL/...
;*  !CHANGEFILENAME='off'
;*  Print, RealFileName('/home/athiel/IDL/...')
;*> /home/athiel/IDL/...
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
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

FUNCTION RealFileName, FilePath

   ON_Error, 2

   IF N_Params() NE 1 THEN Message, 'wrong calling syntax'
   
   Renorm = FilePath

   ;; Is !CHANGEFILENAME defined at all?
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

         'off' : BEGIN ;; do nothing
            Console, 'Filename change turned OFF.', /MSG
         END 

         ELSE: BEGIN
            Console, 'Unknown !CHANGEFILENAME. Filename NOT changed.',  /MSG
         END

      ENDCASE

   ENDIF ELSE BEGIN ;;!CHANGEFILENAME is not defined

      ;; Execute Marburg Unix specific actions like before
      Renorm = StrReplace(Renorm, '/tmp_mnt/', '/')
      slashified = Str_Sep(Renorm, '/')
      IF N_Elements(slashified) GT 1 THEN BEGIN
         IF ((slashified(0) EQ '') AND (slashified(1) EQ 'a')) THEN $
          Renorm = StrReplace(Renorm, '/'+slashified(1)+'/'+ $
                              slashified(2)+'/', '/')
      ENDIF 
      Renorm = StrReplace(Renorm, '/home/', '/usr/')
      Renorm = StrReplace(Renorm, '/gonzo/', '/ax1317/')
      Renorm = StrReplace(Renorm, '/./','/')
      Renorm = RemoveDup(Renorm, '/')

      Console, 'Please choose a value for !CHANGEFILENAME.', /MSG

   ENDELSE
     
   Return, Renorm
   
END





