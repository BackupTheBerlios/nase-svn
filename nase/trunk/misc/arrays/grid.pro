;+
; NAME:
;   Grid()
;
; VERSION:
;   $Id$
;  
; AIM:
;   generates indices addressing a subgrid of a two dimensional array 
;
; PURPOSE:
;   Extracts indices for positions placed
;   on a two-dimensional evenly spaced grid.
;   In the current version the grid is centered
;   in the array (if possible).
;  
; CATEGORY:
;  Array
;  Graphic
;  
; CALLING SEQUENCE:
;* idx = Grid {,dims | ,SIZE=...} [,STEP=...] [,COUNT=...]
;             [,CSHIFT=...] [,/UNIFORM] [,/SHOW]
;  
; OPTIONAL INPUTS:
;   dims :: array of dimensions of the underlying array
;           or speciy SIZE instead
;  
; INPUT KEYWORDS:
;   SIZE ::  array determining the array's size as
;            returned by IDLs size
;            function. Alternatively, you can use the
;            dims input
;   COUNT :: array containing the number of grid
;            points in each direction. If !NONE is
;            specified for a dimension, it is filled
;            to the arrays edges.
;   STEP ::  array containing the step width for each
;            dimension (default: 1)
;   CSHIFT :: array containing the shift of the grid
;            relative to the array's center for each
;            dimension (default: 0)
;   UNIFORM :: step is automatically set to dims/count, which means
;              uniform distribution of the count points on the grid.
;   SHOW :: displays chosen positions in the current plot device
;           
;  
; OUTPUTS:
;   idx ::  array containing the one-dimensional
;           indices of the grid
;  
; EXAMPLE:
;* a = FltArr(21,11)
;* idx = Grid(SIZE=SIZE(a), STEP=[4,2], COUNT=[!NONE,2])
;* a(idx) = 1
;* plottvscl, a
;  
;-
FUNCTION GRID, _dims, STEP=step, COUNT=count, SIZE=_size, CSHIFT=cshift, UNIFORM=uniform, SHOW=show

; check dimensions
IF Set(_dims)+Set(_size) NE 1 THEN Console, 'either dims or size must be set', /FATAL
IF Set(_dims) THEN dims=_dims
IF Set(_size) THEN dims=_size(1:_size(0))
ndim=N_Elements(dims)
IF ndim NE 2 THEN Console, 'sorry, just works for two dimensions', /FATAL

Default, count , REPLICATE(!NONE, ndim)
Default, step  , REPLICATE(1    , ndim)
Default, cshift, REPLICATE(0    , ndim)


if Set(uniform) then step = fix(dims/count)


;check grid method
FOR d=ndim-1,0,-1 DO BEGIN
    IF count(d) EQ !NONE THEN ccount = (dims(d))/step(d) ELSE ccount = MAX([1,count(d)])
    t = REVERSE((LindGen(ccount)*step(d)))
    t=t - (MAX(t)-MIN(t)+1)/2 - cshift(d)
    pos = (dims(d))/2 - t - even(ccount)*even(dims(d))
    print,t
    print, pos
    ok = WHERE((pos GE 0) AND (pos LT dims(d)),c) 
    IF (c NE ccount) THEN BEGIN
        Console, "Grid doesn't fit into the array...", /WARN
        Console, "cutting "+STR(ccount-c)+" values in dimension "+STR(d), /WARN
        pos = pos(ok)
    END

    IF NOT Set(idx) THEN idx=pos ELSE BEGIN
        lidx =  TRANSPOSE(REBIN(idx*dims(d), N_Elements(idx), N_Elements(pos), /SAMPLE))
        sidx =  REBIN(pos, N_Elements(pos), N_Elements(idx), /SAMPLE)
        idx = lidx + sidx        
    END
END

IF Keyword_Set(SHOW) THEN BEGIN
    a=Make_Array(SIZE=[N_Elements(dims),dims,1,PRODUCT(dims)])
    a(idx)=1
    plottvscl, a, XRANGE=[0,dims(0)-1], XTITLE='first dimension', YRANGE=[0,dims(1)-1], YTITLE='second dimension', TITLE='grid'
    
    IF Odd(dims(0)) THEN plots, [(dims(0)-1)/2, (dims(0)-1)/2], [0, dims(1)-1], LINESTYLE=1 $
                    ELSE plots, [(dims(0)-1)/2+0.5, (dims(0)-1)/2+0.5], [0, dims(1)-1], LINESTYLE=1
    IF Odd(dims(1)) THEN plots, [0, dims(0)-1], [(dims(1)-1)/2, (dims(1)-1)/2], LINESTYLE=1 $
                    ELSE plots, [0, dims(0)-1], [(dims(1)-1)/2+0.5, (dims(1)-1)/2+0.5], LINESTYLE=1
END



RETURN, REFORM(idx, N_Elements(idx))
END
