;+
; NAME:
;  UTvLCt
;
; VERSION:
;  $Id$
;
; AIM:
;  Version of TvLct that is compatible with the NASE color management guidelines
;
; PURPOSE:
;  Replacement for the original IDL routine
;  <C>TvLCT</C> with compatible, but extended
;  calling conventions. The topmost colors
;  in the private colormap 
;  (ranging from
;  <*>!TOPCOLOR+1...!D.TABLESIZE-1</*>) are
;  reserved by the NASE color management. Loading
;  of a user defined colormap with <C>TVLCT</C>
;  breaks this conventions because colormaps
;  usually have more entries than color availible
;  under NASE. Therefore <C>UTvLCT</C> offers two
;  possibilities to handle this problem. Either,
;  surplus colors are simply ignored, or the color
;  table is compressed to the available number of
;  free color cells. Note, that most NASE routines like
;  <A>UTVSCL</A> scale colors from
;  <*>0...!TOPCOLOR</*>, therefore it is advisable
;  to compress the colormap when loading, or to
;  define the colormap using only
;  <*>!TOPCOLOR+1</*> entries. <BR>
;  Unlike IDL's <C>TVLCT</C>, <C>UTvLct</C> does not break if it is
;  called on the NULL device. The call is simply skipped. <BR>
;  The call is skipped also, if the current device is the X device,
;  and connecting to the X server is not allowed during this session
;  (see <A>XAllowed()</A> for details).
;                                          
; CATEGORY:
;  Color
;  NASE
;  
; CALLING SEQUENCE:
;* UTvLCt, v1 [,v2] [,v3] [,start] [, {/SCLCT | /OVER} ] [,/GET] [,/HLS | ,/HSV]
;
; INPUTS:
;  v1::    see IDL Help for tvlct
;
; OPTIONAL INPUTS:
;  v2::     see IDL Help for tvlct
;  v3::     see IDL Help for tvlct
;  start::  see IDL Help for tvlct
; 
; INPUT KEYWORDS:               
;              SCLCT::  scales a given color table with respect to
;                       !TOPCOLOR without overwriting the color entries
;                       from !TOPCOLOR to 255
;              OVER::   Allows to overwrite the color map entries from <*>!TOPCOLOR+1...!D.TABLE_SIZE-1</*>.<BR>
;                       <B>WARNING!!</B> This option breaks compatibility with
;                       NASE color management and is for <B>internal use only</B>.
;
;              GET::    see IDL Help for tvlct. If device is the NULL
;                       device, or connecting to the X device is not
;                       allowed, (an) array(s) of !VALUES.F_NAN is returned.
;              HLS::    see IDL Help for tvlct
;              HSV::    see IDL Help for tvlct
;
; SEE ALSO:
;  <A>ULoadCt</A>, <A>UTvScl</A>, <A>XAllowed()</A>.
;
;-

PRO UTvLCt, v1, v2, v3, v4, SCLCT=SCLCT, OVER=over, GET=get, _EXTRA=extra

   ;; ----------------------------
   ;; Do absolutely nothing in the following cases, as code will break
   ;; otherwise:
   ;;
   ;; Device is the NULL device:
   If Contains(!D.Name, 'NULL', /IGNORECASE) then begin
      printf, -2, "% WARN: (UTVLCT) "+ $
        "Skipping call on 'NULL' device. If /GET was set, returning array of !VALUES.F_NAN."
      flush, -2
      if keyword_set(get) and (N_Params() eq 1) then v1 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE, 3)
      if keyword_set(get) and (N_Params() eq 3) then begin v1 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE) & v2 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE) & v3 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE) & end
      return
   endif
   ;; Device is the X device, but connecting to the X-Server is forbidden:
   If (!D.Name eq 'X') and not XAllowed() then begin
      printf, -2, "% WARN: (UTVLCT) "+ $
        "Connecting to X server is forbidden. Skipping call on 'X' device. If /GET was set, returning array of !VALUES.F_NAN."
      flush, -2
      if keyword_set(get) and (N_Params() eq 1) then v1 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE, 3)
      if keyword_set(get) and (N_Params() eq 3) then begin v1 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE) & v2 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE) & v3 = replicate(!VALUES.F_NAN, !D.TABLE_SIZE) & end
      return
   endif
   ;; ----------------------------



   default, sclct, 0

   if not keyword_set(get) then begin
      
      assert, (N_Params() GE 1) AND (N_Params() LE 4), 'wrong number of arguments'
      
      if N_Params() GE 3 then v = [ [v1], [v2], [v3] ] else v = v1
      
      if sclct eq 1 then begin
         _v = BYTARR(256, 3)
         utvlct, _V, /get
         
         _v(*, 0)= [ congrid(v(*, 0), !TOPCOLOR+1), _v(!TOPCOLOR+1:*, 0)]
         _v(*, 1)= [ congrid(v(*, 1), !TOPCOLOR+1), _v(!TOPCOLOR+1:*, 1)]
         _v(*, 2)= [ congrid(v(*, 2), !TOPCOLOR+1), _v(!TOPCOLOR+1:*, 2)]
      end else begin
;              _v = v           ;if set(v) then _v = v  this is always fulfilled because of line:  if N_Params() GE 3 then v = [ [v1], [v2], [v3] ] else v = v1
                                ; cut table if required, because it
                                ; MUST NOT overwrite !TOPCOLOR+1...

         IF NOT KEYWORD_SET(OVER) THEN BEGIN
            CASE N_Params() OF 
               1: _v = v(0:MIN([(SIZE(v))(1)-1, !TOPCOLOR]),*)                     
               2: _v = v(0:MIN([(SIZE(v))(1)-1, !TOPCOLOR-v2]),*)
               3: _v = v(0:MIN([(SIZE(v))(1)-1, !TOPCOLOR]),*)                     
               4: _v = v(0:MIN([(SIZE(v))(1)-1, !TOPCOLOR-v4]),*)
            END
         END ELSE _V =  V
      end

      CASE N_Params() OF
         1 : TvLCt, _v,     GET=get, _EXTRA=extra
         2 : TvLCt, _v, v2, GET=get, _EXTRA=extra
         3 : TvLCt, _v,     GET=get, _EXTRA=extra
         4 : TvLCt, _v, v4, GET=get, _EXTRA=extra
      ENDCASE
      
   END ELSE BEGIN
      CASE N_Params() OF
         1 : BEGIN
             v1 = bytarr(256,3) 
             TvLCt, v1,             GET=get, _EXTRA=extra
         END
         2 : TvLCt, v1, v2,         GET=get, _EXTRA=extra
         3 : TvLCt, v1, v2, v3,     GET=get, _EXTRA=extra
         4 : TvLCt, v1, v2, v3, v4, GET=get, _EXTRA=extra
         ELSE: Message, 'wrong number of arguments'
      ENDCASE

   ENDELSE
   
   
END
