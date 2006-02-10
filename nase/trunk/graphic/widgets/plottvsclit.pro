;+
; NAME:
;  PlotTvSclIt
;
; VERSION:
;  $Id$
;
; AIM:
;  An interactive PlotTvScl widget.
;
; PURPOSE:
;  This routine uses an object of <A>class widget_imagecontainer</A>
;  in order to realize an interactive version of the well-known
;  <A>PlotTvScl</A> routine. Try to use it whereever you used
;  <A>PlotTvScl</A> for invetigating an array. Just like
;  <A>class widget_imagecontainer</A>, it supports mouse-resizing, and
;  duplication, <A>Surfit</A>, <A>ExamineIt</A>, via the mouse buttons, as well as
;  interactive palette selection. Have fun!
;
; CATEGORY:
;  Graphic
;  Image
;  Objects
;  Widgets
;
; CALLING SEQUENCE:
;*PlotTvSclIt, array, [--all parameters and switches passed to <A>class widget_imagecontainer</A>--]
;
; INPUTS:
;  array:: The array to be plotted. This must be an array with two
;         dimensions (one dimension should work, but don't take it for
;         granted). This argument ist passed as <*>IMAGE=...</*> to
;         <A>class widget_imagecontainer</A>.
;
; (others):: Any other arguments are passed to
;            <A>class widget_imagecontainer</A>, especially those that are
;            then passed to <A>PlotTvScl</A>. 
;   
; SIDE EFFECTS:
;  Realizes and registeres the widget.
;
; PROCEDURE:
;  Wrapper to <A>widget_image_container</A>.
;
; EXAMPLE:
;*
;*> PlotTvSclIt, xsize=300, ysize=300, alison()
;   Then try resizing and clicking into the window and on the button.
;
; SEE ALSO:
;  <A>PlotTvScl</A>, <A>class widget_imagecontainer</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

Pro PlotTvSclIt, a, XPOS=xpos, YPOS=ypos, _ref_extra=e
   o = obj_new("widget_image_container", IMAGE=a, XOFFSET=xpos, $
               YOFFSET=ypos, _strict_extra=e)
   o -> register
   o -> realize
End
