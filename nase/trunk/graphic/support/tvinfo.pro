;+
; NAME:
;  TvInfo()
;
; VERSION:
;  $Id$
;
; AIM:
;  checks validity of an array to be drawn with TV and provides some
;  information about it
;
; PURPOSE:
;  Checks validity of an array to be drawn with <A>UTv</A>,
;  <A>UTvScl</A>, <A>PTvS</A>, <C>TV</C> ... and provides image dimensions
;  depending on the image type (indexed or true color, with different
;  types of <*>INTERLACE</*>, and alpha channels.
;
; CATEGORY:
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;*bool = TVInfo(image [,TRUE=...] [,ALPHA=...] [,WIDTH=...] [,HEIGHT=...])
;
; INPUTS:
;  image :: the image to be checked and analyzed
;
; INPUT KEYWORDS:
;  TRUE :: defines type of INTERLACE for true color images or zero for
;          indexed images. See <C>TV</C> help for more information.
;
; OUTPUTS:
;  bool :: boolean showing if the passed array is a valid argument for
;          <A>UTV</A> and its partners.
;
; OPTIONAL OUTPUTS:
;  ALPHA :: if set to a named variable, will return TRUE if
;           <*>image</*> has an alpha channel
;  HEIGHT/WIDTH:: if set to a named variable, will contain the image's width/height,
;           but only if <*>bool</*> is TRUE.
;
; EXAMPLE:
; A valid true-color, 300x200 pixel image with an alpha channel
;*print, TVInfo(randomu(seed,4,300,200), ALPHA=a, WIDTH=w, HEIGHT=h)
;*; 1
;*print, a, w, h
;*; 1 300 200
;
;-

FUNCTION TVInfo, i, TRUE=true, ALPHA=alpha, WIDTH=w, HEIGHT=h

si = SIZE(i)
CASE si(0) OF
    2: BEGIN
        alpha = 0
        w = si(1)
        h = si(2)
        IF Set(TRUE) THEN BEGIN
            IF TRUE GT 0 THEN RETURN, (1 EQ 0) ELSE RETURN, (1 EQ 1)
        END ELSE RETURN, (1 EQ 1)
    END
    3: BEGIN
        Default, TRUE, 1
        alpha = 0

        ; check true color dimension and alpha channel
        IF (TRUE LE 0) THEN RETURN, (1 EQ 0)
        IF (TRUE GT 3) THEN Console, 'invalid value for TRUE', /FATAL
        IF NOT Inset(si(TRUE), [3,4]) THEN RETURN, (1 EQ 0) $
                                      ELSE ALPHA = si(TRUE)-3
        
        
        CASE TRUE OF 
            1: BEGIN
                w=si(2) 
                h=si(3)
            END
            2: BEGIN
                w=si(1)
                h=si(3)
            END
            3: BEGIN
                w=si(1)
                h=si(2)
            END
        END
        RETURN, (1 EQ 1)
    END
    ELSE: RETURN, (1 EQ 0)
END

END

