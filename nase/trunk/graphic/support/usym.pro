;+
; NAME:
;  USym()
;
; VERSION:
;  $Id$
;
; AIM:
;  Extends IDL's standard plot symbols by a circle. Several symbols
;  may also be filled and/or colored.
;
; PURPOSE:
;  Extends IDL's standard plot symbols by a circle. Several symbols
;  may also be filled and/or colored.
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE:
;*mysymid = USym(psym, [,/PLUS | ,/ASTERISK | ,/PERIOD | ,/DIAMOND |
;*                      ,/TRIANGLE | ,/SQUARE | ,/X | ,/CIRCLE]    
;*               [,/FILL] [,COLOR=...] [,THICK=...])
;
; INPUTS:
;  psym:: index of IDLs symbol number (see IDL help)
;
; INPUT KEYWORDS:
;  COLOR:: The color used to draw the symbols, or used to fill the
;          polygon. The default color is the same as the line color. 
;  FILL::  Set this keyword to fill the plot symbol. This only works
;          for extended symbols.
;  THICK:: The thickness of the lines used in drawing the symbol. The
;          default thickness is 1.0. 
;  SYMBOLNAME:: plots the specified symbol (same as <*>psym</*>) 
;
; OUTPUTS:
;  mysymid:: new symbol id that can be passed to the PSYM keywork for
;            following graphical commands
;
; EXAMPLE:
;*plot, indgen(10), psym=-usym(/TRIANGLE, /FILL, COLOR=rgb('green')), SYMSIZE=3
;plots data points as filled, green triangles. You may also plot circles:
;*plot, indgen(10), psym=-usym(/CIRCLE), SYMSIZE=2
;
; SEE ALSO:
;  <A>OrientSym</A> and  <C>UserSym</C>,<C>PSYM</C> in the IDL help
;-


FUNCTION USym, _psym, PLUS=plus, ASTERISK=asterisk, PERIOD=period, DIAMOND=diamond, TRIANGLE=triangle, $
               SQUARE=square, X=X, CIRCLE=circle, _EXTRA=e

ON_Error, 2



IF Keyword_Set(PLUS)     THEN psym= 1
IF Keyword_Set(ASTERISK) THEN psym= 2
IF Keyword_Set(PERIOD)   THEN psym= 3
IF Keyword_Set(DIAMOND)  THEN psym= 4
IF Keyword_Set(TRIANGLE) THEN psym= 5
IF Keyword_Set(SQUARE)   THEN psym= 6
IF Keyword_Set(X)        THEN psym= 7
IF Keyword_Set(CIRCLE)   THEN psym=20

IF (N_Params() EQ 1) THEN BEGIN
    IF Set(PSYM) THEN Console, 'specify plot symbol either by positional argument or by keyword', /FATAL $
                 ELSE psym=_psym
END
Default, psym, 0


CASE Psym OF 
    0: RETURN, 0                ; don't use any symbols
    1: BEGIN
        ;; plus sign
        X = [-1, 1,  0,  0,  0]
        Y = [ 0, 0,  0,  1, -1] 
    END
    2: BEGIN
        ;; asterisk
        X = [-1, 1, 0, -1,  1, 0, 0,  0, 0, 1, -1]
        Y = [-1, 1, 0,  1, -1, 0, 1, -1, 0, 0,  0] 
    END
    3: BEGIN
        ;; period
        X = [0,0]
        Y = [0,0] 
    END
    4: BEGIN
        ;; diamond
        X = [0, 1,  0, -1, 0]
        Y = [1, 0, -1,  0, 1] 
    END
    5: BEGIN
        ;; triangle
        X = [-1,  1, 0, -1]
        Y = [-1, -1, 1, -1] 
    END
    6: BEGIN
        ;; square
        X = [-1,  1, 1, -1, -1]
        Y = [-1, -1, 1,  1, -1] 
    END
    7: BEGIN
        ;; X sign
        X = [-1, 1,  0, -1,  1]
        Y = [-1, 1,  0,  1, -1] 
    END
    8:  RETURN, 8               ; user-defined symbol, do nothing
    10: RETURN, 10              ; IDLs histogram mode, leave that untouched
    20: BEGIN
        ;; circle
        A = FINDGEN(17) * (!PI*2/16.)
        X = COS(A)
        Y = SIN(A)
    END
    ELSE : Console, 'psym of '+str(psym)+' not supported, yet', /FATAL
END

IF Inset(Psym, [1,2,3,7]) AND ExtraSet(e, "FILL") THEN BEGIN
    IF e.fill EQ 1 THEN BEGIN
        Console, '/FILL not defined with PSYM='+STR(psym), /WARN
        e.fill = 0
    END
END

USERSYM, X, Y, _EXTRA=e


RETURN, 8
END
