;+
; NAME:                UTvLCt
;
; VERSION: $Id$
;
; AIM: Same as TvLct, but works for all devices (including NULL).
;
; PURPOSE:             Ersatz fuer TvLCt mit gleichen Aufrufoptionen,
;                      stellt aber sicher, dass Farbdarstellung auf
;                      allen Displays funktioniert.
;
; CATEGORY:            GRAPHIC GENERAL
;
; CALLING SEQUENCE:
;*                     utvlct,v1 [,v2][,v3][,start][,/sclct][,/GET] [,/HLS | ,/HSV]
;
; INPUTS:
;              v1::    see IDL Help for tvlct
;
; OPTIONAL INPUTS:
;
;              v2::     see IDL Help for tvlct
;              v3::     see IDL Help for tvlct
;              start::  see IDL Help for tvlct
; 
; INPUT KEYWORDS: 
;              
;              SCLCT::  scales a given color table with respect to
;                       !TOPCOLOR without overwriting the color entries
;                       from !TOPCOLOR to 255
;
;              GET::    see IDL Help for tvlct
;              HLS::    see IDL Help for tvlct
;              HSV::    see IDL Help for tvlct
;
; SEE ALSO:            <A HREF="#ULOADCT">ULoadCt</A>, <A HREF="#UTVSCL">UTvScl</A>
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.6  2000/10/30 18:24:54  gabriel
;          SCLCT Keyword new
;
;     Revision 2.5  2000/10/01 14:50:57  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.4  1999/11/04 17:31:41  kupper
;     Kicked out all the Device, BYPASS_TRANSLATION commands. They
;     -extremely- slow down performance on True-Color-Displays when
;     connecting over a network!
;     Furthermore, it seems to me, the only thing they do is to work
;     around a bug in IDL 5.0 that wasn't there in IDL 4 and isn't
;     there any more in IDL 5.2.
;     I do now handle this special bug by loading the translation table
;     with a linear ramp. This is much faster.
;     However, slight changes in behaviour on a True-Color-Display may
;     be encountered.
;
;     Revision 2.3  1998/05/25 12:51:57  kupper
;            Also, bei Postscripts einfach gar nicht zu tun, das war aber kein gutes Benehmen...
;
;     Revision 2.2  1998/02/27 13:20:57  saam
;           na was?? Bug in den HREFs
;
;     Revision 2.1  1998/02/27 13:15:44  saam
;           hoffentlich hat sich's bald mit den U-Dingern
;
;
;
PRO UTvLCt, v1, v2, v3, v4, SCLCT=SCLCT , _EXTRA=extra
   default, sclct, 0
   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      if not extraset(extra,'get') then begin
       
         
         if N_Params() GE 3 then v = [ [v1], [v2], [v3] ] else v = v1
         
         if sclct eq 1 then begin
            _v = BYTARR(256, 3)
            utvlct, _V, /get
            
            _v(*, 0)= [ congrid(v(*, 0), !TOPCOLOR+1), _v(!TOPCOLOR+1:*, 0)]
            _v(*, 1)= [ congrid(v(*, 1), !TOPCOLOR+1), _v(!TOPCOLOR+1:*, 1)]
            _v(*, 2)= [ congrid(v(*, 2), !TOPCOLOR+1), _v(!TOPCOLOR+1:*, 2)]
         end else if set(v) then _v = v
         
         CASE N_Params() OF
            1 : TvLCt, _v,     _EXTRA=extra
            2 : TvLCt, _v, v2, _EXTRA=extra
            3 : TvLCt, _v,     _EXTRA=extra
            4 : TvLCt, _v, v4, _EXTRA=extra
            ELSE: Message, 'wrong number of arguments'
         ENDCASE
         
      END ELSE BEGIN

         CASE N_Params() OF
            1 : TvLCt, v1,             _EXTRA=extra
            2 : TvLCt, v1, v2,         _EXTRA=extra
            3 : TvLCt, v1, v2, v3,     _EXTRA=extra
            4 : TvLCt, v1, v2, v3, v4, _EXTRA=extra
            ELSE: Message, 'wrong number of arguments'
         ENDCASE

      ENDELSE
   END
   
END
