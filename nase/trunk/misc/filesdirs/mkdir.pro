;+
; NAME:               MkDir
;
; AIM:                creates a directory
;  
; PURPOSE:            A Directory is created. UNIX-Specific!
;  
; CATEGORY:           FILES DIRS MISC
;  
; CALLING SEQUENCE:   mkdir, dir
;  
; INPUTS:             dir: the directory to be created (string)
;  
; RESTRICTIONS:       only works under UNIX-like environments
;  
; EXAMPLE:
;                     mkdir, '/tmp/sillyExample'
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/10/12 13:46:17  saam
;        added experimental windows support
;
;        Revision 1.1  2000/06/19 14:43:13  saam
;              hmmm, what should i say
;
;-

PRO Mkdir, _dir

ON_Error, 2
IF N_Params() NE 1 THEN Console, 'wrong argument count', /FATAL


dir = StrReplace(_dir, "/", !FILESEP, /G)
dir = StrReplace(dir, "\", !FILESEP, /G)
dir = StrReplace(dir, !FILESEP+!FILESEP, !FILESEP, /G)

IF (fix(!VERSION.Release) GE 4) THEN OS_FAMILY=!version.OS_FAMILY ELSE OS_FAMILY='unix'
CASE OS_FAMILY OF
    "unix"   : BEGIN
                 c = Command('test')+' -d '+dir+' || '+Command('mkdir')+' -p '+dir
                 spawn, c, e
               END
    "Windows": BEGIN


;                 IF (StrMid(Dir,strLen(Dir),1) NE '/') OR $
;                   (StrMid(Dir,strLen(Dir),1) NE '\') THEN BEGIN
;                     Dir = Dir + '\'
;                 ENDIF
;                 test = findfile(Dir+'*.')
;                 If test(0) NE Dir+'.\' THEN BEGIN
;                     aux = StrArr(strLen(Dir))
;                     For i=0,N_elements(aux)-1 DO BEGIN
;                         aux(i) = StrMid(Dir,i,1)
;                     endfor
;                     marker = WHERE((aux EQ '/') or (aux EQ '\'))
;                     aux(marker) = '\'
;                     auxStr = ''
;                     For i=0,N_elements(aux)-1 DO auxStr = auxStr + aux(i)
;                     For i=1,N_Elements(marker)-1 DO BEGIN
;                         print, 'mkdir '+StrMid(auxstr,0,marker(i))
;                     endfor
;                 ENDIF
                  cd, CURRENT=oldpwd
                  subdirs = split(dir, !FILESEP)
                  FOR i=0,N_Elements(subdirs)-1 DO BEGIN
                      IF subdirs(i) EQ '' THEN cd, !FILESEP ELSE BEGIN
                          spawn, "mkdir "+subdirs(i)
                          cd, subdirs(i)
                      END
                  END
                  cd, oldpwd
               END
    ELSE     : Console, [OS_FAMILY, " not supported...yet"], /FATAL
END


END
