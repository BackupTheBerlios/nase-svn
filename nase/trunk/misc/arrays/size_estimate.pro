;+
; NAME:
;  Size_Estimate()
;  
; AIM:
;  Estimate size of a visual object in an image array.
;
; PURPOSE:
;  Estimate the size of a single object contained in an image array.
;  Several estimation algorithms can be selected.
;  
; CATEGORY:
;  Array
;  Image
;  Simulation
;  
; CALLING SEQUENCE:
;* result = Size_Estimate( array,
;*                         { /INERTIA, |
;*                           ENCLOSE=procentage }
;*                       )
;  
; INPUTS:
;  array:: The image array containing the object.
;  
; OUTPUTS:
;  result:: A float, indicating the estimated size of the contained object, in
;           relataion to the array size. (For non-square arrays: in relation to
;           the smaller dimension.)
;           A value of 0.0 means that the supplied array is empty, a value of
;           1.0 means that the contained object roughly "fills" the array.
;  
; KEYWORD PARAMETERS:
;  INERTIA:: Set this keyword to return a size estimation by the normalized
;            inertia. The value returned is the square root of the arrays inertia
;            (second moment), normalized to the array dimensions.
;  ENCLOSE:: Set this keyword to a value in the range of 0..100.
;            The value returned is the size of the smallest square still
;            enclosing the given percentage of the supplied image's area,
;            normalized to the array dimensions.
;            Example: If ENCLOSE=90, and the value returned is 0.5, 90% of the
;                     image area are contained inside a box of half the array
;                     size.
;  
; RESTRICTIONS:
;  Exactly one keyword must be specified.
;  The supplied array is expected to contain only positive values. Results will
;  be unreliable for an arry containing negative values.
;  The contained object is expected to be localized and centered inside the
;  array.
;  
; PROCEDURE:
;  INERTIA: Basically, call <A HREF="#INERTIA">Inertia()</A>.
;  ENCLOSE: Compute area of subarrays using <A HREF="#GETSUBARRAY()">GetSubarray()</A>,
;           and execute loop over size until found.
;  Note:
;   This routine is intended to be extended :-)
;   Please add any new algorithms for size estimation as they come along.
;   The only restrictions are: 
;     1. the return value is normalized to the array dimensions, i.e. return
;        values can be expected to be roughly inside the range of 0.0 .. 1.0.
;     2. the measure is linear to size changes, i.e.
;        for a given array g of dimensions (d x d):
;          g2=inssubarray(fltarr(d,d),/center,congrid(g,d/x,d/x))
;          print, Size_Estimate(g,/your_keyword)/size_estimate(g2,/your_keyword)
;        should approximately yield the value x.
;
;   Examples for possible new algorithms include
;     o size estimation by frequency analysis
;     o size estimation in Meierfrankenfeld-style (Mexwalls). See diploma theses, 
;       Götz Meierfrankenfeld, Marburg, 1997
;     o size estimation using IDL's SEARCH2D function
;
;
; EXAMPLE:
;* f=Obj_New("widget_image_factory",WIDTH=100,HEIGHT=100)
;* f->register
;* f->realize
;* print, Size_Estimate(f->image(), /INERTIA)
;* print, Size_Estimate(f->image(), ENCLOSE=96)
; 
;  Now modify image and repeat the last two commands.
;
; SEE ALSO:
;  <A>Inertia()</A>, <A>GetSubarray()</A>
;-

Function Size_Estimate, a, INERTIA=inertia, ENCLOSE=enclose

   ;; The following statement is needed for IDL not to confuse the variable
   ;; INERTA and the function inertia():
   Forward_Function inertia

   ;; One, and only one Keyword makes sense:
   Total_Keywords = $
    Keyword_Set(INERTIA) $
    + Keyword_Set(ENCLOSE)
;;; ------------------------------------------------
;;; ------------> please add any new keywords above!
;;; ------------------------------------------------
   If (Total_Keywords ne 1) then begin
      On_Error, 2 ;; return to caller
      Message, "Please specify exactly one keyword."
   endif

   ;; compute image aerea:
   area = total(a)
   ;; return 0 for an empty image:
   if area eq 0 then return, 0.0

   ;; look up array dimensions:
   dims = Size(a, /Dimensions)
   h = dims[0] ;; NASE convention: first dimension is height
   w = dims[1] ;; but that doesn`t really matter here.
   mindim = min(dims)
   maxdim = max(Temporary(dims))
   
   ;; --------------------- INERTIA -----------------------------------
   If Keyword_Set(INERTIA) then begin
      est_size = inertia(a, [h/2.0, w/2.0])
      ;;   normalize to a size value:
      est_size = sqrt(est_size) / (mindim/2.0)
   EndIf
   ;; --------------------- End: INERTIA -----------------------------------
   
   ;; --------------------- ENCLOSE -----------------------------------
   If Keyword_Set(ENCLOSE) then begin
      s = maxdim
      while s gt 0 do begin
         If Total(getsubarray(a, s<h, s<w, /Center))/area lt $
          ENCLOSE/100.0 then return, (s+1.0)/mindim
         s = s-1
      endwhile
      return, 1.0/mindim
   EndIf
   ;; --------------------- End: ENCLOSE -----------------------------------


   return, est_size
End
