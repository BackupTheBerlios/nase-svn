;+
; NAME:
;  NoTicks
;
; VERSION:
;  $Id$
; 
; AIM:
;  suppresses axis labelling in plots
;
; PURPOSE:
;  This functions suppresses the labeling of an arbitrary axis,
;  without having to omit the tickmarks.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE: 
;  This routine is usually not called directly. Instead you can pass
;  this routine's name as string to the <*>[XYZ]TICKFORMAT</*> keywords,
;  used by several graphic routines like <C>Plot</C>, <C>Contour</C>,... :
;*  Plot, ... , XTICKFORMAT='NOTICKS', ...
;
; INPUTS:
;  Since IDL calls this function directly, all arguments must have a
;  defined syntax: 
;  axis  :: number of the axis (0 = x-, 1 = y- und 2 = z-axis)
;  index :: tickmark index starting with 0
;  value :: tickmark value that would be used for labeling, if this
;           routine wouldn't be called.
;
; OUTPUTS:
;  always the empty string
;
; EXAMPLE:
;  the standard tickformat produces 3-6 labels:
;*  Plot, indgen(10)
;  while
;*  Plot, indgen(10), XTICKFORMAT="NOTICKS"
;  completely suppresses labeling of the x-axis 
;
; SEE ALSO:
;  [XYZ]TICKFORMAT in the IDL help 
;               
;-


FUNCTION NoTicks, axis, index, value
   Return, ""
END
