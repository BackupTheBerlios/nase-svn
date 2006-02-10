;+
; NAME:
;   class widget_image_container
;
; PURPOSE:
;   A widget object serving both as a display and a container for an image
;   array. The image is stored inside the object and displayed in a
;   <A>PlotTvScl</A>-Plot. Image data can be set and retrieved. Alternatively, the
;   image can be addressed through a pointer, allowing for online-monitoring of
;   array contents.<BR>
;   Auto-painting is inherited from <A>class Basic_Draw_Object</A>.
;<BR>
;   Upon mouse clicks, the following actions are
;   performed to further investigate the contents:<BR>
;<BR>
;    o left-click   : <A>PlotTvSclIt</A><BR>
;    o middle-click : <A>SurfIt</A><BR> 
;    o right-click  : <A>ExamineIt</A><BR>  
;<BR>
;   Setting of the color table via the <*>ct,n</*>
;   method is inherited from <A>class basic_draw_object</A>.
;   <I>Please note that the color table will be overwritten, if
;   <C>/NASE</C> is set (unless also <C>SETCOL=0</C> is passed).</I><BR>
;
; CATEGORY: 
;   Graphic, Widgets
;
; SUPERCLASSES:
;   <A>class Basic_Draw_Object</A>
;
; CONSTRUCTION: 
;
;*   o = Obj_New("widget_image_container"
;*               [,IMAGE=img_or_imgptr [,/NO_COPY]]
;*               [,XNORM=x]
;*               [,YNORM=y] 
;*               [-keywords inherited from <A>class basic_draw_object</A>, except /BUTTON_EVENTS-]
;*               [-all additional keywords are passed to <A>PlotTvScl</A>])
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;                                               
; INPUT KEYWORDS:
;
;  IMAGE:: This keyword can either be present, or the image can be supplied
;          using the image method.<BR>
;          It might either be<BR>
;            o a two-dimensional array containing the image data.
;              Array contents will be copied into the object, unless
;              the /NO_COPY keyword is set, see below.<BR>
;            o a pointer to an array containing the image data.
;              The pointer will be stored inside the object.
;              The pointer will not be freed, when the object dies.<BR>
;          Array contents are used to determine the plot dimensions and
;          initialize the color scaling. Both can be modified afterwards, using
;          the renew_[scaling|plot] methods described below.
;          If the widget is realized, and image data has nt yet been
;          initialized, the window will display "(empty)".
;
;  /NO_COPY:: If set, the contents of <*>IMAGE</*> will not be copied but
;             moved into the container. The <*>IMAGE</*> argument will be
;             undefined after the call.<BR>
;             This keyword has no effect if a pointer is passed in the
;             <*>IMAGE</*> argument.
;
;  XNORM, YNORM:: Lower left corner of the plot window inside the draw widget,
;               specified in normal coordinates.<BR>
;<BR>
;   XNORM and YNORM, as well as all additional keywords, will be passed
;   to <A>PlotTvScl</A>.
;
; SIDE EFFECTS: 
;  A widget is created.
;
; METHODS:
;
;  public: Public methods may be called from everywhere.
;   
;   image()                     :: returns image data. (Array)
;   image, img [,/NO_COPY]      :: sets image data to img. Display is updated,
;                                  unsing the last established color scaling
;                                  (see UPDATE_INFO keyword to <A>PlotTvScl</A> for details).
;                                  Data is copied into the object, unless
;                                  NO_COPY is set. In that case, img will be
;                                  undefined after the call.
;   imageptr()                  :: returns a pointer to the image array, such
;                                  that image data can be modified "outside the
;                                  object".
;   size([KEYWORDS_TO_SIZE])    :: returns the result of IDL's
;                                  <C>SIZE()</C> function applied to
;                                  the image data. Any Keywords are
;                                  passed on to <C>SIZE()</C>.
;   renew_scaling [,keywords=kw]:: requests the re-intialization of color
;                                  scaling when the display is next updated. All 
;                                  keywords will be passed to <A>PlotTvScl</A>, together
;                                  with the /INIT keywords set. (See there for details.)
;
;   replot                      :: requests the replotting of the whole
;                                  plot (including axes and
;                                  bitmap) when the display is next
;                                  updated. All keywords will be used
;                                  as originally specified.
;                                  Call this method e.g. if the window
;                                  contetns the window have bee
;                                  destroyed for some reason.
;   renew_plot [,XNORM=x]
;              [,YNORM=y]
;              [,keywords=kw]   :: requests the replotting with re-intialization of all plot
;                                  parameters when the display is next
;                                  updated. All keywords will be passed to <A>PlotTvScl</A>,
;                                  together with an unintialized
;                                  {PLOTTVSCL_INFO} struct. (See there
;                                  for details.)
;
;   surfit [,keywords=kw]       :: pass the contained image to
;                                  <A>SurfIt</A>. All keywords will be
;                                  passed through. The default for the
;                                  <*>NASE</*> keyword is taken from
;                                  the current plot parameters, but
;                                  can be overridden. (Note that this
;                                  default does not exist, if widget
;                                  was not yet realized.)
;
;   examineit [,keywords=kw]    :: pass the contained image to
;                                  <A>ExamineIt</A>. All keywords will be
;                                  passed through. The default for the
;                                  <*>NASE</*> keyword is taken from
;                                  the current plot parameters, but
;                                  can be overridden. (Note that this
;                                  default does not exist, if widget
;                                  was not yet realized.)
;
;  -plus those inherited from <A>class basic_draw_object</A> (see there for details)-
;   among which to note especially:
;
;   paint                       :: update the display.
;
;   paint_interval, secs        :: auto-update the display all secs seconds.
;                                  (Pass a negative value to disable auto-painting.)
;
;  as well as "realize" and "register" for creation of top level bases.
;
;
; PROCEDURE:
;  Combine features of <A>class Basic_Draw_Object</A> and <A>PlotTvScl</A>
;  while providing a transparent user-interface. No magic.
;
; EXAMPLE:
;;
;  1. simple usage:
;     o = Obj_New("widget_image_container", IMAGE=gauss_2d(32,32), /NASE)
;     o->register
;     o->realize
;     print, o->image()
;     o->image, 0.5*gauss_2d(32,32)
;     o->renew_scaling, range_in=[0,10]
;     o->image, randomu(23,32,32)
;     o->image, 10*randomu(23,32,32)
;     Obj_Destroy, o
;
;  2. monitor contents of a pre-existing array:
;     aptr = Ptr_New(gauss_2d(10,10))
;     o = Obj_New("widget_image_container", IMAGE=aptr, /NASE)
;     o->paint_interval, 0.5
;     o->register
;     o->realize
;     (*aptr)[*] = 0
;     (*aptr)[3,3] = 1
;     (*aptr)[*,*] = dist(10,10)/8.0
;     print, o->image() eq *aptr
;     print, o->imageptr() eq aptr
;     Obj_Destroy, o
;     print, Ptr_Valid(aptr); note that the pointer was -not- freed!
;     Ptr_Free, aptr
;
;  3. let the object create the array, then monitor it:
;     o = Obj_New("widget_image_container", IMAGE=gauss_2d(10,10), /NASE)
;     o->paint_interval, 0.5
;     o->register
;     o->realize
;     aptr = o->imageptr()
;     (*aptr)[*] = 0
;     (*aptr)[3,3] = 1
;     (*aptr)[*,*] = dist(10,10)/8.0
;     Obj_Destroy, o
;     print, Ptr_Valid(aptr); note that the pointer -was- freed!
;
; SEE ALSO:
;   <A>PlotTvScl</A>, <A>class Basic_Draw_Object</A>
;-


;; event handler
Pro widget_image_container_draw_event, event
   COMPILE_OPT HIDDEN
   
   ;; the widget of the basic_draw_object is event.HANDLER.
   ;; Its uvalue is the object reference:
   Widget_Control, event.HANDLER, GET_UVALUE=o
   
   EventType = Tag_Names(Event, /STRUCTURE_NAME)
   
   ;; only mousepress events from the draw widget may arrive here:
   assert, (EventType EQ  "WIDGET_DRAW"), "Only mousepress events from the draw widget may arriver here."
   
;   If Event.Type eq 1 then begin ;Mouse Button Release
;      If (Event.Release and 1) eq 1 then begin ;Left Button
;         print, "not yet"
;      endif
;   Endif                        ;Mouse Button Release
   
   If Event.Type eq 0 then begin ;Mouse Button Press
      ;;This might take a while, so display hourglass:
      ;;Widget_Control, /Hourglass
            
      If (Event.Press and 1) eq 1 then begin ;Left Mouse Button
         o->PlotTvSclIt, xsize=300, ysize=300, /JUST_REG
      endif                     ;Left Mouse Button
      
      If (Event.Press and 2) eq 2 then begin ;Middle Mouse Button
         o->Surfit, xsize=300, ysize=300, /JUST_REG
      Endif                     ;Middle Button
      
      If (Event.Press and 4) eq 4 then begin ;Right Mouse Button
         o->ExamineIt, /JUST_REG
      Endif                     ;Right Button
      
   EndIf
End



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_image_container::init, IMAGE=image, XNORM=xnorm, YNORM=ynorm, $
                                       NO_COPY=no_copy, _EXTRA=_extra
   DMsg, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "widget_image_container", $
                            /BUTTON_EVENTS, $
                            EVENT_PRO="widget_image_container_draw_event", $
                            _EXTRA=_extra) then return, 0

   ;; Try whatever initialization is needed for a widget_image_container object,
   ;; IN ADDITION to the initialization of the superclasses:

   self.extra = Ptr_New(_extra) ;temporary storage to get it into initial_paint_hook_

   if set(IMAGE) then self -> image, image
   
   Default, xnorm, 0.2
   Default, ynorm, 0.2
   self.xnorm = xnorm
   self.ynorm = ynorm

   self.update_info = Ptr_New({PLOTTVSCL_INFO})

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro widget_image_container::cleanup, _REF_EXTRA = _ref_extra
   DMsg, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
   Cleanup_Superclasses, self, "widget_image_container", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a widget_image_container object:
   If self.free_image_flag then Ptr_Free, self.contents
   Ptr_Free, self.update_info
   Ptr_Free, self.extra
End

;Pro widget_image_container::reset
   ;; Set all data members to defaults. You may want to use the member access
   ;; methods, in case they perform any side effects.
   ;; Remove this method if nothing is to reset on your object.
   ;;
   ;; insert code here
   ;;
;End


;; ------------ Public --------------------
;;
Function widget_image_container::imageptr
   return, self.contents
End
Function widget_image_container::image
   return, *self.contents
End
Pro widget_image_container::image, image, NO_COPY=no_copy
   If not self.image_initialized_flag then begin
      
      If Size(image, /TName) eq "POINTER" then begin
         self.contents=image
         self.free_image_flag = 0
      endif else begin
         self.contents=Ptr_New(image, NO_COPY=no_copy)
         self.free_image_flag = 1
      Endelse

      self.image_initialized_flag = 1
      
   endif else begin

      If Size(image, /TName) eq "POINTER" then begin
         ; we get a new pointer, so we perhaps have to free the old one:
         if self.free_image_flag then ptr_free, self.contents
         self.contents=image
         self.free_image_flag = 0
      endif else begin
         ; we get new image data to put into the poitned variable:
         If Keyword_Set(NO_COPY) then *self.contents = Temporary(image) $
         else *self.contents = image
      endelse
      
   endelse

   self->paint

End

Function widget_image_container::size, _extra = _extra
   return, size(*self.contents, _extra=_extra)
End

Pro widget_image_container::renew_scaling, _EXTRA=_extra
   self.renew_scaling_flag = 1
   Default, _extra, {dummy: 0}
   *self.extra = _extra         ;save any keywords to pass to PlotTvScl   
End

Pro widget_image_container::replot
   ;; we need to redraw the complete plot, with the stored parameters:
   self->renew_plot, _extra=*self.extra
End

Pro widget_image_container::renew_plot, XNORM=xnorm, YNORM=ynorm, _EXTRA=_extra
   *self.update_info = {PLOTTVSCL_INFO}
   If Set(xnorm) then self.xnorm = xnorm
   If Set(ynorm) then self.ynorm = ynorm
   Default, _extra, {dummy: 0}
   *self.extra = _extra         ;save any keywords to pass to PlotTvScl   
End

Pro widget_image_container::examineit, xpos=xpos, ypos=ypos, _EXTRA=_extra
   ;; get position of base:
   g = Widget_Info(self->widget(), /Geometry) ;von OBEN links
   default, xpos, g.XOFFSET + g.SCR_XSIZE + (2* g.MARGIN)
   default, ypos, g.YOFFSET; + g.SCR_YSIZE + (2* g.MARGIN)

   ;; we want examineit to inherit our widget's private color table, so
   ;; we open the showit beforehand:
   showit_open, self->showit()
   ;; The color table shall not be modified, so we pass SETCOL=0.
   ;; In addition, no rescaling of the array contents shall be done at
   ;; all, but examineit shall inherit "our" RANGE values. So we pass
   ;; the range in the RANGE_IN parameter. (That's why passing NSCALE
   ;; should have no effect, but we pass it to be complete, or it may
   ;; confuse me if I see it later :-))
   examineit, self->image(), $
              GROUP=self->widget(), $
              XPOS=xpos, YPOS=ypos, $
              NORDER = (*self.update_info).norder, $
              NSCALE = (*self.update_info).nscale, $
              SETCOL=0, $
              RANGE_IN=(*self.update_info).range_in, $
              _STRICT_EXTRA=_extra
   showit_close, self->showit()
End

Pro widget_image_container::surfit, xpos=xpos, ypos=ypos, _EXTRA=_extra
   ;; get position of base:
   g = Widget_Info(self->widget(), /Geometry) ;von OBEN links
   default, xpos, g.XOFFSET + g.SCR_XSIZE + (2* g.MARGIN)
   default, ypos, g.YOFFSET; + g.SCR_YSIZE + (2* g.MARGIN)

   surfit, self->image(), $
              GROUP=self->widget(), $
              XPOS=xpos, YPOS=ypos, $
              NORDER=(*self.update_info).norder, $
              _STRICT_EXTRA=_extra
End

Pro widget_image_container::plottvsclit, xpos=xpos, ypos=ypos, _EXTRA=_extra
   ;; get position of base:
   g = Widget_Info(self->widget(), /Geometry) ;von OBEN links
   default, xpos, g.XOFFSET + g.SCR_XSIZE + (2* g.MARGIN)
   default, ypos, g.YOFFSET; + g.SCR_YSIZE + (2* g.MARGIN)

   ;; we use our stored extra values as defaults, and add/overwrite
   ;; all extra values that have been passed here:
   e_out = *self.extra
   extra2structure, _extra, e_out, /CREATE

   ;; we want PlotTvSclIt to inherit our widget's private color table, so
   ;; we open the showit beforehand:
   showit_open, self->showit()
   ;; The color table shall not be modified, so we pass SETCOL=0.
   ;; In addition, no rescaling of the array contents shall be done at
   ;; all, but examineit shall inherit "our" RANGE values. So we pass
   ;; the range in the RANGE_IN parameter. (That's why passing NSCALE
   ;; should have no effect, but we pass it to be complete, or it may
   ;; confuse me if I see it later :-))
   PlotTvSclIt, self->imageptr(), $
              GROUP=self->widget(), $
              XPOS=xpos, YPOS=ypos, $
;              NORDER = (*self.update_info).norder, $
;              NSCALE = (*self.update_info).nscale, $
              SETCOL=0, $
              RANGE_IN=(*self.update_info).range_in, $
              _EXTRA=e_out
   showit_close, self->showit()
End

;; ------------ Protected ------------------

;; ------------ Private --------------------
Pro widget_image_container::paint_hook_
   if not self.image_initialized_flag then begin
      ;; indicates that image data is not yet
      ;; initialized
      xyouts, /normal, Alignment=0.5, 0.5, 0.5, "(empty)"
   endif else begin
      PlotTvScl, *self.contents, self.xnorm, self.ynorm, $
                 Update_Info=*self.update_info, INIT=self.renew_scaling_flag, $
                 _EXTRA=(*(self.extra))
      self.renew_scaling_flag = 0
   endelse
End

Pro widget_image_container::initial_paint_hook_
   self->paint_hook_
End

Pro widget_image_container::xct_callback_hook_
   if not self.image_initialized_flag then begin
      ;; indicates that image data is not yet
      ;; initialized
      xyouts, /normal, Alignment=0.5, 0.5, 0.5, "(empty)"
   endif else begin
      PlotTvScl, *self.contents, self.xnorm, self.ynorm, $
                 Update_Info=*self.update_info, /INIT, $
                 _EXTRA=(*(self.extra))
      self.renew_scaling_flag = 0
   endelse
End

Pro widget_image_container::resize_draw, x, y
   COMPILE_OPT IDL2
   ;; Resize the drawing area to the given values. This differs from
   ;; basic_widget_object::resize_hook_, which resizes the full area of the
   ;; widget (including the button row).
     
;   dmsg, " widget_image_container::resize_draw called with x:"+str(x)+", " + $
;         "y:"+str(y)

   ;; the draw widget is the first child of the showit widget.
   widget_control, widget_info(/child, self.w_showit), $
                   XSIZE=x, YSIZE=y

   ;; we need to redraw the complete plot:
   self->replot
   self->paint
   
End



;; ------------ Object definition ---------------------------
Pro widget_image_container__DEFINE
   dummy = {widget_image_container, $
            $
            inherits basic_draw_object, $
            $
            contents: Ptr_New(), $
            free_image_flag: 0b, $
            image_initialized_flag: 0b, $
            update_info: Ptr_New(), $ ;Will hold a {PLOTTVSCL_INFO} struct
            xnorm: 0.0, $
            ynorm: 0.0, $
            $
            extra: Ptr_New(), $ ;will temporarily hold the keywords passed to
            $                   ;::init
            renew_scaling_flag: 0b $            
           }
End
