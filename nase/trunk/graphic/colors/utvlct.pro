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
;  <*>!TOPCOLOR+1</*> entries.
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
;              GET::    see IDL Help for tvlct
;              HLS::    see IDL Help for tvlct
;              HSV::    see IDL Help for tvlct
;
; SEE ALSO:            <A>ULoadCt</A>, <A>UTvScl</A>
;
;-

PRO UTvLCt, v1, v2, v3, v4, SCLCT=SCLCT, OVER=over, _EXTRA=extra
   default, sclct, 0
   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      if not extraset(extra,'get') then begin
       
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
             1 : TvLCt, _v,     _EXTRA=extra
             2 : TvLCt, _v, v2, _EXTRA=extra
             3 : TvLCt, _v,     _EXTRA=extra
             4 : TvLCt, _v, v4, _EXTRA=extra
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
