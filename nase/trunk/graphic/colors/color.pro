;+
; NAME:
;  Color
;
; VERSION:
;  $Id$
;
; AIM:
;  sets a color in the color table by specifying color name
;
; PURPOSE:
;  Sets a color in the color table by specifying color name.
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;  Since this is a low level routine, you probably want to use <A>RGB</A>,
;  instead. 
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE:
;* Color, name, [,index] [,r, g, b] [,FILE=...] [,/LEARN] [,/LIST]
;*         [,MAXNUMBER=...] [,NUMBER=...] [NAME=...]
;*         [,TEXT=...] [,RED=..., GREEN=..., BLUE=...] 
;*         [,/EXIT]
;
; INPUTS:
;   name    :: color name (like red, green, ...). Name may be modified by
;              the words dark, pale, very dark, very pale.
;              Only one very is handled.  Default color is white.
;
; OPTIONAL INPUTS:
;   index   :: color table index for new color (default: last)
;   r, g, b :: components of color table to modify
;
;
; INPUT KEYWORDS:
;   FILE      :: color file to use instead of the default.
;                Must be saved using save2,/xdr.
;   LEARN     :: prompts for r,g,b values of an unknown color
;   LIST      :: lists all available colors
;   MAXNUMBER :: Return number of colors known.
;   NUMBER    :: select color by color number (0 to MAXNUMBER-1).
;                Index # 255 is set by default.  To set a different index
;                a dummy color name must also be given.  It is ignored.
;                <*> color,'dum',50,number=7 </*> sets index 50 to color 7.
;                If no args are given default color and index used.
;   name*:: Return name of selected color. Useful with NUMBER keyword.
;           (*lowercase because of parser)
;   TEXT      :: Returns 0 or 255, whichever best with color.
;   RED       :: Return red value for specified color
;   GREEN     :: Return green value for specified color
;   BLUE      :: Return blue value for specified color
;   EXIT      :: exit without modifying screen color table
;
; OPTIONAL OUTPUTS:
;   r, g, b :: components of color table to modify
;
; COMMON BLOCKS:
;   COLOR_COM
;
; SEE ALSO:
;  <A>RGB()</A>.
;
;-

FUNCTION WORDPOS, REF, S, help=hlp
 
   L = 0
   LOOP:	W = GETWORD(REF, L)
   IF W EQ '' THEN RETURN, -1
   IF S EQ W THEN RETURN, L
   L = L + 1
   GOTO, LOOP
END
 

PRO Color, name0, index, rct, gct, bct, learn=lrn, $
           list=lst, number=num, name=nam, maxnumber=mx, text=txt, $
           exit=ext, red=rc, green=gc, blue=bc, file=file

   COMMON color_com, flag, cc, rr, gg, bb
 
 
   if n_elements(file) eq 0 then begin
      file = GetEnv('NASEPATH')+'/graphic/colors/clrs_xdr.save2'
   endif
  
                                ;------- initialize  -------
   if n_elements(flag) eq 0 then begin
      restore2,file,cc,rr,gg,bb,/xdr ; Get known colors.
      flag = 1
   endif
   last = !d.n_colors - 1       ; Last color table value.
  
                                ;------  set defaults  ---------
   if n_params(0) lt 1 then name0='white' ; No name, use white.
   if n_params(0) lt 2 then index = last ; No index, use last.
                                ;-------  Catch undefined args  ---------
   if n_elements(name0) eq 0 then begin
      print,' Error in color: color name argument is undefined.'
      return
   endif
   if n_elements(index) eq 0 then begin
      print,' Error in color: color index argument is undefined.'
      return
   endif
  
   if (index lt 0) or (index gt last) then begin
      print,' Error in color: color index out of range.'
      print,' index, last = ', index, last
      return
   endif
  
                                ;--------  MAXNUMBER  --------------
   mx = n_elements(rr)
  
                                ;--------  NUMBER  --------------
   if n_elements(num) then begin
      name0 = cc(num)
   endif
  
                                ;------  NAME  -----------
   nam = name0
  
  
                                ;-----  /LIST  -----------------
   if keyword_set(lst) then begin
      ii = strtrim(indgen(mx),2)
      print,' Available colors:'
      print,ii+': '+cc+','
      return
   endif
  
                                ;-------  process name  -----------------
   name = strlowcase(name0)     ; Force lower case.
   lo = 0                       ; Name starts at word 0.
   vflag = 0                    ; No verys.
   sfact = 1.                   ; Saturation factor.
   vfact = 1.                   ; Value factor.
   vpos = wordpos(name,'very')  ; Look for very.
   if vpos ge 0 then lo = lo + 1 ;  Ignore very in color name.
   if vpos lt 0 then vpos = 99
   dkpos = wordpos(name,'dark') ; Look for dark.
   if dkpos ge 0 then begin     ; Process dark.
      lo = lo + 1               ; Ignore dark in color name.
      vfact = .7                ; Value factor for dark.
      if vpos eq (dkpos-1) then vfact=.3 ; Value factor for very dark.
   endif
   dlpos = wordpos(name,'pale') ; Look for dull.
   if dlpos ge 0 then begin     ; Process dull.
      lo = lo + 1               ; Ignore dull in color name.
      sfact = .5                ; Saturation factor for dull.
      if vpos eq (dlpos-1) then sfact=.3 ; Sat. fact. for very dull.
   endif
   name = getword(name,lo,9)    ; Ignore modifiers.
   
   w = where(name eq cc, count) ; Look up desired color.
   lflag = 0                    ; Learn flag, put new at end.
   
   if count gt 0 then begin     ; Found it.
      if keyword_set(lrn) then begin ; If /LEARN then change color.
         lflag = 1              ;   Existing color.
         ix = w(0)              ;   Index of color.
         print,' Change existing color.'
         print,' R, G, B = ',$  ;   Show old color values.
          rr(ix),gg(ix),bb(ix)
         goto, ln
      endif
      tvlct, r, g, b, /get      ;   Get current color table.
      rc = rr(w(0))
      gc = gg(w(0))
      bc = bb(w(0))
      rgb_to_hsv, rc,gc,bc,h,s,v ; Convert to H,S,V
      s = s*sfact               ; Handle dark and dull.
      v = v*vfact
      hsv_to_rgb, h, s, v, rc, gc, bc ; Convert back to R,G,B.
      rc=rc(0) & gc=gc(0) & bc=bc(0)
      if keyword_set(ext) then return
      r(index) = rc             ; Put color back into table.
      g(index) = gc
      b(index) = bc
      if n_params(0) ge 5 then begin ; If r,g,b given modify it.
         rct(index) = rc
          gct(index) = gc
          bct(index) = bc
       endif else begin
          tvlct, r, g, b        ;   Load modified color table.
       endelse
      txt = last                ; Last color table value.
      if (rc+gc+bc)/3. gt 128 then txt = 0
      return
   endif
   
   print,' Error in color: unknown color name = ' + name
   if not keyword_set(lrn) then return
   
                                ;------ /LEARN  --------------
   print,' Learn new color.'
   ln:	tmpi = index + 1        ; Find a color table index to use.
   if tmpi gt last then tmpi = 1
   tvlct, r, g, b, /get		; Get existing color table.
   rs = r(tmpi)			; Save color table color.
   gs = g(tmpi)
   bs = b(tmpi)
   save = tvrd(50,350,100,100)	; Save image under color patch.
   tv,bytarr(100,100)+tmpi,50,350 ; Put color patch there.
   txt = ''
   print,' Enter estimated r,g,b for color = '+name+' (like 50,100,150)'
   read, rw, gw, bw
   print,' Use the following commands:'
   print,'        0  decrease  increase  last'
   print,'   red   w      e         r      t'
   print,' green   d      f         g      h'
   print,'  blue   c      v         b      n'   
   print,'         p lists color values.'
   print,'         RETURN when color is ok.'
   print,'         q to quit with no change.'
   print,' '
   cr = string(10b)
   goto, disply
   loop:	k = getkey()
   k = strlowcase(k)
   if k eq 'q' then begin
      print,' No change to known colors.'
      goto, done2
   endif
   if k eq 'w' then rw = 0
   if k eq 'e' then rw = (rw-1)>0
   if k eq 'r' then rw = (rw+1)<last
   if k eq 't' then rw = last
   if k eq 'd' then gw = 0
   if k eq 'f' then gw = (gw-1)>0
   if k eq 'g' then gw = (gw+1)<last
   if k eq 'h' then gw = last
   if k eq 'c' then bw = 0
   if k eq 'v' then bw = (bw-1)>0
   if k eq 'b' then bw = (bw+1)<last
   if k eq 'n' then bw = last
   if k eq 'p' then print,'r, g, b = ', rw, gw, bw
   if k eq 'enter' then goto, done
   disply:	r(tmpi) = rw    ; Put them at display index.
   g(tmpi) = gw
   b(tmpi) = bw
   tvlct, r, g, b               ; Show new color.
   goto, loop
 
   done:	if lflag eq 0 then begin
      cc = [cc,name]		; Add new color name.
      rr = [rr,rw]              ; Add new color r,g,b.
      gg = [gg,gw]
      bb = [bb,bw]
   endif else begin
      rr(ix) = rw               ; Add color, have name already. 
      gg(ix) = gw
      bb(ix) = bw
   endelse
   save2,file,cc,rr,gg,bb, /xdr ; Save new color list.
   print,' New color saved.'
   r(index) = rw                ; Put new color at desired table index.
   g(index) = gw
   b(index) = bw
   done2:	tv, save, 50, 350 ; Restore image under patch.
   r(tmpi) = rs			; Restore color table.
   g(tmpi) = gs
   b(tmpi) = bs
   if n_params(0) ge 5 then begin
      rct(index) = rw
      gct(index) = gw
      bct(index) = bw
   endif else begin
      tvlct, r, g, b
   endelse
 
   return
end
