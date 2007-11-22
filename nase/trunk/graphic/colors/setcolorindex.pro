;+
; NAME:
;  SetColorIndex
;
; VERSION:
;  $Id$
;
; AIM:
;  sets one entry in the current color table (better use <A>RGB</A>).
;
; PURPOSE:
;  Set one entry in the current color table (this also works for
;  TrueColor displays). To be compliant with the NASE color
;  management you better use <A>RGB</A> to define a specific
;  color. <B>Never</B> use color indices > <*>!TOPCOLOR</*>, because
;  this will cause color problems. <BR>
;  <C>SetColorIndex</C> does not break if it is
;  called on the NULL device. The call is simply skipped. <BR>
;  The call is skipped also, if the current device is the X device,
;  and connecting to the X server is not allowed during this session
;  (see <A>XAllowed()</A> for details).
;;
; CATEGORY:
;  Color
;
; CALLING SEQUENCE:
;  SetColorIndex, idx, {R,G,B | name} 
;
; INPUTS:
;  idx   :: The index in the color table to be modified. 
;           <*>idx > !TOPCOLOR</*> will break NASE color management and
;           is only intended for internal use.
;  R,G,B :: red, green and blue values for the required color ranging
;           from 0 to 255 
;  name  :: a known color string as specified by <A>COLOR</A>
;
; SIDE EFFECTS: 
;   entry <*>idx</*> in the color map will be changed
;
; EXAMPLE: 
;* SetColorIndex, 100, 255,0,0     ; sets color index 100 to red
;* SetColorIndex, 1, 'dark green'  ; sets color index   1 to a dark green
;
; SEE ALSO:
;  <A>RGB</A>, <A>Color</A>
;
;-

Pro SetColorIndex, Nr, R, G, B
   
   ;; ----------------------------
   ;; Do absolutely nothing in the following cases, as code will break
   ;; otherwise:
   ;;
   ;; Device is the NULL device:
   If Contains(!D.Name, 'NULL', /IGNORECASE) then begin
      printf, -2, "% WARN: (SetColorIndex) "+ $
        "Skipping call on 'NULL' device."
      flush, -2
      return
   endif
   ;; Device is the X device, but connecting to the X-Server is forbidden:
   If (!D.Name eq 'X') and not XAllowed() then begin
      printf, -2, "% WARN: (SetColorIndex) "+ $
        "Connecting to X server is forbidden. Skipping call on 'X' device."
      flush, -2
      return
   endif
   ;; ----------------------------


   if Nr gt !D.Table_Size-1 THEN BEGIN
       Console, "color index out of range", /WARN
       RETURN
   END
   If (Size(R))(1) eq 7 then Color, R, /EXIT, RED=R, GREEN=G, BLUE=B

   My_Color_Map = intarr(!D.Table_Size,3) ;IDL 3.6
    ;My_Color_Map = [0]                   ;IDL 4
 
   UTvLCT, My_Color_Map, /GET   ;Das /GET-Keyword belegt in IDL 3.6 nur
                                ;die schon bestehende Variable My_Color_Map,
                                ;deshalb muss sie mit der richtigen Groesse
                                ;initialisiert werden

    My_Color_Map (Nr,*) = [R,G,B]
    UTvLCT,  My_Color_Map, /OVER

End
