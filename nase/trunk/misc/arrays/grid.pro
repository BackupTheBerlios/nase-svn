;+
; NAME:
;   Grid
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
;   In the current version the grid is center
;   in the array (if possible).
;  
; CATEGORY:
;  Array
;  
; CALLING SEQUENCE:
;* idx = Grid {,dims | ,SIZE=...} [,STEP=...] [,COUNT=...] [,CSHIFT=...] 
;  
; OPTIONAL INPUTS:
;   dims :: array of dimensions of the underlying array
;           or speciy SIZE instead
;  
; INPUT KEYWORDS:
;   SIZE::   array determining the array's size as
;            returned by IDLs size
;            function. Alternatively, you can use the
;            dims input
;   COUNT::  array containing the number of grid
;            points in each direction. If !NONE is
;            specified for a dimension, it is filled
;            to the arrays edges.
;   STEP::   array containing the step width for each
;            dimension (default: 1)
;   CSHIFT:: array containing the shift of the grid
;            relative to the array's center for each
;            dimension (default: 0)
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
FUNCTION GRID, _dims, STEP=step, COUNT=count, SIZE=_size, CSHIFT=cshift

; check dimensions
IF Set(_dims)+Set(_size) NE 1 THEN Console, 'either dims or size must be set', /FATAL
IF Set(_dims) THEN dims=_dims
IF Set(_size) THEN dims=_size(1:_size(0))
ndim=N_Elements(dims)
IF ndim NE 2 THEN Console, 'sorry, just works for two dimensions', /FATAL

Default, count , REPLICATE(!NONE, ndim)
Default, step  , REPLICATE(1    , ndim)
Default, cshift, REPLICATE(0    , ndim)


;check grid method
FOR d=ndim-1,0,-1 DO BEGIN
    IF count(d) EQ !NONE THEN ccount = (dims(d)+1)/step(d) ELSE ccount = MAX([1,count(d)])

    t = REVERSE((LindGen(ccount)*step(d)))
    t=t - (MAX(t)-MIN(t))/2 + cshift(d)
    pos = (dims(d)-1)/2 - t 
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

RETURN, REFORM(idx, N_Elements(idx))
END
