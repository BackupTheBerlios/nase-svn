;+
; NAME: AbsoluteNZTicks
;
; AIM:
;  Suppress signs of plot labels (show absolute values). Also suppress
;  small values.
;
; PURPOSE: Support function that supresses signs and to small values
;          (<1E-10) for axis labelling. This is useful for polarplots 
;          and is indeed used for the polarplot routine.
;
; CATEGORY: GRAPHICS SUPPORT
;
; CALLING SEQUENCE: Plot, ... , XTICKFORMAT='AbsolueNZTicks', ...
;                   (also works with AXIS, CONTOUR, SHADE_SURF, SURFACE)  
;
; INPUTS: Axis  : number of axis (0 = X-, 1 = Y- und 2 = Z-axis)
;         Index : tickmark index (starting with 0)
;         Value : original value to be used as tickmark
;
; OUTPUTS: string used for labelling the current tickmark
;
; EXAMPLE: compare
;             Plot, (indgen(3)-1), ytickformat='AbsoluteTicks'
;          with
;             Plot, (indgen(3)-1)
;
; SEE ALSO: IDL Online Help: Graphics Keywords, continued - [XYZ]TICKFORMAT keyword 
;
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/10/01 14:51:44  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 2.2  2000/07/24 10:20:59  saam
;              removed MODHIST from documentation
;
;        Revision 2.1  2000/07/24 10:20:23  saam
;             stolen and translated from absoluteticks
;


FUNCTION AbsoluteNZTicks, axis, index, value

IF Abs(Value) LT 1E-10 THEN Return, '' ELSE Return, String(Abs(Value), Format='(G0.0)')

END
