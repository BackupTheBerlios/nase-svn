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
;    o left-click-and-hold: magnify<BR>
;    o middle-click       : <A>SurfIt</A><BR> 
;    o right-click        : <A>ExamineIt</A><BR>  
;<BR>
;   Setting of the color table via the <*>ct,n</*> and <*>ct()</*>
;   methods is inherited from <A>class basic_draw_object</A>.
;   The color table is initialized to <*>0</*> (linear grey ramp) upon
;   creation of the object.<BR>
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
;*   o = Obj_New("widget_image_container",
;*               IMAGE=img_or_imgptr [,/NO_COPY]
;*               [,XPOS=x]
;*               [,YPOS=y] 
;*               [-keywords inherited from <A>class basic_draw_object</A>, except /BUTTON_EVENTS-]
;*               [-all additional keywords are passed to <A>PlotTvScl</A>])
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;                                               
; INPUT KEYWORDS:
;
;  IMAGE:: This keyword must either be present, or the image must be supplied
;          using the image method, before the widget is realized!<BR>
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
;
;  /NO_COPY:: If set, the contents of <*>IMAGE</*> will not be copied but
;             moved into the container. The <*>IMAGE</*> argument will be
;             undefined after the call.<BR>
;             This keyword has no effect if a pointer is passed in the
;             <*>IMAGE</*> argument.
;
;  XPOS, YPOS:: Lower left corner of the plot window inside the draw widget,
;               specified in normal coordinates.<BR>
;<BR>
;   XPOS and YPOS, as well as all additional keywords, will be passed
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
;   renew_plot [,XPOS=x]
;              [,YPOS=y]
;              [,keywords=kw]   :: requests the re-intialization of all plot
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
Pro widget_image_container_event, event
   COMPILE_OPT HIDDEN
   
   ;; the widget of the basic_draw_object is event.HANDLER.
   ;; Its value is the object reference:
   Widget_Control, event.HANDLER, GET_VALUE=o
   
   EventType = Tag_Names(Event, /STRUCTURE_NAME)
   
   ;; only mousepress events from the draw widget may arrive here:
   assert, (EventType EQ  "WIDGET_DRAW"), "Only mousepress events from the draw widget may arriver here."
   
   If Event.Type eq 1 then begin ;Mouse Button Release
      If (Event.Release and 1) eq 1 then begin ;Left Button
;         mag = Widget_Info(Event.ID, /SIBLING)
;         If mag ne 0 then Widget_Control, mag, /DESTROY 
         print, "not yet"
      endif
   Endif                        ;Mouse Button Release
   
   If Event.Type eq 0 then begin ;Mouse Button Press
      ;;This might take a while, so display hourglass:
      ;;Widget_Control, /Hourglass
            
      If (Event.Press and 1) eq 1 then begin ;Left Mouse Button
         print, "not yet"
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
Function widget_image_container::init, IMAGE=image, XPOS=xpos, YPOS=ypos, $
                                       NO_COPY=no_copy, _EXTRA=_extra
   DMsg, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "widget_image_container", $
                            /BUTTON_EVENTS, $
                            EVENT_PRO="widget_image_container_event", $
                            _EXTRA=_extra) then return, 0

   ;; Try whatever initialization is needed for a widget_image_container object,
   ;; IN ADDITION to the initialization of the superclasses:

   self.extra = Ptr_New(_extra) ;temporary storage to get it into initial_paint_hook_

   If Size(image, /TName) eq "POINTER" then begin
      self.contents=image
   endif else begin
      self.contents=Ptr_New(image, NO_COPY=no_copy)
      self.free_image_flag = 1
   Endelse
   
   Default, xpos, 0.2
   Default, ypos, 0.2
   self.xpos = xpos
   self.ypos = ypos

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
   If Keyword_Set(NO_COPY) then *self.contents = Temporary(image) $
   else *self.contents = image
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

Pro widget_image_container::renew_plot, XPOS=xpos, YPOS=ypos, _EXTRA=_extra
   *self.update_info = {PLOTTVSCL_INFO}
   If Set(xpos) then self.xpos = xpos
   If Set(ypos) then self.ypos = ypos
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
              NASE=(*self.update_info).nase, $
              NORDER = (*self.update_info).norder, $
              NSCALE = (*self.update_info).nscale, $
              SETCOL=0, $
              RANGE_IN=(*self.update_info).range_in, $
              _EXTRA=_extra
   showit_close, self->showit()
End

Pro widget_image_container::surfit, _EXTRA=_extra
   ;; get position of base:
   g = Widget_Info(self->widget(), /Geometry) ;von OBEN links
   default, xpos, g.XOFFSET + g.SCR_XSIZE + (2* g.MARGIN)
   default, ypos, g.YOFFSET; + g.SCR_YSIZE + (2* g.MARGIN)

   surfit, self->image(), $
              GROUP=self->widget(), $
              XPOS=xpos, YPOS=ypos, $
              NASE=(*self.update_info).nase, $
              NORDER=(*self.update_info).norder, $
              _EXTRA=_extra
End

;; ------------ Protected ------------------

;; ------------ Private --------------------
Pro widget_image_container::paint_hook_
   PlotTvScl, *self.contents, self.xpos, self.ypos, $
    Update_Info=*self.update_info, INIT=self.renew_scaling_flag, $
   _EXTRA=(*(self.extra))
   self.renew_scaling_flag = 0
End

Pro widget_image_container::initial_paint_hook_
   self->paint_hook_
End




;; ------------ Object definition ---------------------------
Pro widget_image_container__DEFINE
   dummy = {widget_image_container, $
            $
            inherits basic_draw_object, $
            $
            contents: Ptr_New(), $
            free_image_flag: 0b, $
            update_info: Ptr_New(), $ ;Will hold a {PLOTTVSCL_INFO} struct
            xpos: 0.0, $
            ypos: 0.0, $
            $
            extra: Ptr_New(), $ ;will temporarily hold the keywords passed to
            $                   ;::init
            renew_scaling_flag: 0b $            
           }
End
