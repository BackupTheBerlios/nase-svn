;+
; NAME: CW_FSLIDER2
;
; PURPOSE: Eine etwas huebschere Version des standard CW_FSLIDER.
;
; CATEGORY: widgets, graphic
;
; CALLING SEQUENCE: Widget_ID = CW_FSLIDER2( Parent
;                                           [,/DRAG]
;                                           [,FONT_TITLE = fontstring]
;                                           [,FONT_LABEL = fontstring]
;                                           [,FORMAT     = format_string]
;                                           [,FRAME      = frame_thickness]
;                                           [,SUBFRAME   = subframe_thickness]
;                                           [,/LABEL_{BOTTOM|LEFT|RIGHT|TOP}]
;                                           [,MAXIMUM    = maximum_value]
;                                           [,MINIMUM    = minimum_value]
;                                           [,/NO_COPY]
;                                           [,STEPWIDTH  = resolution]
;                                           [,TITLE      = title_string]
;                                           [,UVALUE     = user_value]
;                                           [,VALUE      = initial_value]
;                                           [,/VERTICAL]
;                                           [,XSIZE = width] [,YSIZE = height]
;
; INPUTS: Parent: Widget-ID des uebergeordneten Widgets.
;
; KEYWORD PARAMETERS: (Beschreibung teilweise aus der IDL-Online-Hilfe uebernommen)
;
;     DRAG         : Set this keyword to zero if events should only be
;                    generated when the mouse is released. If DRAG is non-zero,
;                    events will be generated continuously when the slider
;                    is adjusted. Note: On slow systems, /DRAG performance can
;                    be inadequate. The default is DRAG = 0.
;     FONT_TITLE/
;       FONT_LABEL : The font to use for the title (given in TITLE)
;                    and the label (given in FORMAT)
; 
;     FORMAT       : Provides the format in which the slider value is displayed.
;                    This should be a format as accepted by the STRING procedure.
;                    The default FORMAT is '(F6.2)'
;        
;     FRAME        : Set this keyword to have a frame drawn around the widget.
;                    The default is FRAME = 0.
;
;     SUBFRAME     : Set this keyword to have a frame drawn just around the slider
;                    and the label. The default is FRAME = 0.
;
;     LABEL_{BOTTOM|
;              LEFT|
;             RIGHT|
;               TOP}:Position of the label. Default is LABEL_BOTTOM
;
;     MAXIMUM      : The maximum value of the slider.
;                    The default is MAXIMUM = 100.
;
;     MINIMUM      : The minimum value of the slider.
;                    The default is MINIMUM = 0.
;
;     NO_COPY      : Usually, when setting or getting widget user values,
;                    either at widget creation or using the SET_UVALUE and
;                    GET_UVALUE keywords to WIDGET_CONTROL, IDL makes a second
;                    copy of the data being transferred. Although this
;                    technique is fine for small data, it can have a
;                    significant memory cost when the data being copied
;                    is large.
;                    If the NO_COPY keyword is set, IDL handles these
;                    operations differently. Rather than copy the source data,
;                    it takes the data away from the source and attaches it
;                    directly to the destination. This feature can be used by
;                    compound widgets to obtain state information from a
;                    UVALUE without all the memory copying that would otherwise
;                    occur. However, it has the side effect of causing the
;                    source variable to become undefined. On a "set" operation
;                    (using the UVALUE keyword to CW_FSLIDER2 or the SET_UVALUE
;                    keyword to WIDGET_CONTROL), the variable passed as value
;                    becomes undefined. On a "get" operation (GET_UVALUE keyword
;                    to WIDGET_CONTROL), the user value of the widget in question
;                    becomes undefined.
;
;     STEPWIDTH    : The maximum stepwidth in which the slider can be adjusted.
;                    This value is given in the units of the slider value. 
;                    If the widget is not large enough to provide this resolution,
;                    stepwidth adjusted to the amount corresponding to one pixel movement,
;                    if slider is manipulated by the mouse. However, the activated
;                    slider may always be controled by the cursor keys
;                    in steps given in STEPWIDTH.
;                    Default: 0.1
;
;     TITLE        : The title of the slider. 
;
;     UVALUE       : The "user value" to be assigned to the widget.
;
;     VALUE        : The initial value of the slider.
;
;     VERTICAL     : If set, the slider will be oriented vertically.
;                    The default is horizontal.
;
;     XSIZE        : For horizontal sliders, sets the length.
;
;     YSIZE        : For vertical sliders, sets the height.;
;
;
; OUTPUTS: Die Widget ID des neu erstellten Slider-Widgets.
;
; SIDE EFFECTS: Das neue Widget sendet Widget-Events folgender Art:
;                 Event = {CW_FSLIDER2,
;                          ID:0L, TOP:0L, HANDLER:0L,
;                          VALUE:0.0D, DRAG:0}
;               Value(double) ist der aktuelle Wert des Sliders.
;               Drag=1, falls /DRAG angegeben wurde, und der Slider
;               bei gedruecktem Mausknopf bewegt wurde, sonst 0.
;
;               Zum Auslesen und Setzen des aktuellen Slider-Values
;               kann wie gewohnt WIDGET_CONTROL mit den
;               Schluesselworten GET_VALUE und SET_VALUE verwendet werden.
;
; RESTRICTIONS:
;
; PROCEDURE: Dies ist ein "klassisches" Compound-Widget.
;
; EXAMPLE:
;          b=widget_base(/row)
;          s1=cw_fslider2(b, $
;                         TITLE="TITEL1", FONT_TITLE='-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1', $
;                         FORMAT='("Wert: ", F6.2, "%")', FONT_LABEL='-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1', $
;                         MINIMUM=-17, MAXIMUM=23)
;          s2=cw_fslider2(b, $
;                         TITLE="TITEL2", FONT_TITLE='-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1', $
;                         FORMAT='("Wert: ", F6.2, "%")', FONT_LABEL='-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1', $
;                         MINIMUM=-23, MAXIMUM=17, STEPWIDTH=0.01, /VERTICAL)
;          XMANAGER, "SliderTest", b, EVENT_HANDLER="DUMMY_EVENTHANDLER"
;          Widget_Control, b, /REALIZE
;
; SEE ALSO: CW_FSLIDER (Standard-IDL)
;           WIDGET_SLIDER (Standard-IDL)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/09/01 16:43:53  thiel
;            Moved from other directory.
;
;        Revision 2.6  1999/08/24 11:30:26  thiel
;            Negative minimum: Event_Func had to be changed also.
;
;        Revision 2.5  1999/08/24 10:03:36  thiel
;            Corrected value computation for negative minima.
;
;        Revision 2.4  1999/06/17 14:30:05  kupper
;        Extended Header.
;
;        Revision 2.3  1999/06/17 14:06:02  kupper
;        Modified Example to use Dummy_EventHandler.
;        Correct typing errors in Header.
;
;        Revision 2.2  1999/06/17 13:31:00  kupper
;        Added Label-Position Keywords.
;        Added Example.
;
;        Revision 2.1  1999/06/16 19:13:16  kupper
;        Initial version.
;        Provides functionality of CW_FSLIDER (standard IDL) but looks nicer
;        and is more compactly arranged.
;
;-

Function CW_FSLIDER2_event_func, event
   ;;only slider-events will arrive here.
   ;;event.HANDLER is the id of the outer Base.
   ;;all information is stored in the UVALUE of its first child
   FirstChild = Widget_Info(event.HANDLER, /CHILD)
   Widget_Control, FirstChild, GET_UVALUE=uval, /NO_COPY

   uval.value = event.value/double(uval.maxslider)*(uval.maximum-uval.minimum)+uval.minimum
   Widget_Control, uval.W_Label, SET_VALUE=string(uval.value, FORMAT=uval.format)
   
   If event.drag and not(uval.drag) then returnevent = 0 $ ; swallow event
   else returnevent = {CW_FSLIDER2, $
                       ID      : event.handler, $ ;The FSLIDER2-Base
                       TOP     : event.top, $ ;pass-through
                       HANDLER : 0L, $ ; We handled it!
                       VALUE   : uval.value, $
                       DRAG    : event.drag}

   Widget_Control, FirstChild, SET_UVALUE=uval, /NO_COPY
   return, returnevent
End

Function CW_FSLIDER2_func_get_value, id
   ;;id is the id of the outer Base.
   ;;all information is stored in the UVALUE of its first child
   FirstChild = Widget_Info(id, /CHILD)
   Widget_Control, FirstChild, GET_UVALUE=uval
   return, uval.value
End

Pro CW_FSLIDER2_pro_set_value, id, value
   ;;id is the id of the outer Base.
   ;;all information is stored in the UVALUE of its first child
   FirstChild = Widget_Info(id, /CHILD)
   Widget_Control, FirstChild, GET_UVALUE=uval, /NO_COPY

   uval.value = value
   Widget_Control, uval.W_Slider, SET_VALUE=(value-uval.minimum)/double(uval.maximum-uval.minimum)*uval.maxslider
   
   Widget_Control, uval.W_Label, SET_VALUE=string(value, FORMAT=uval.format)

   Widget_Control, FirstChild, SET_UVALUE=uval, /NO_COPY
End

Function CW_FSLIDER2, Parent $
           ,DRAG       = drag $
           ,FONT_TITLE = font_title $
           ,FONT_LABEL = font_label $
           ,FORMAT     = format $
           ,FRAME      = frame $
           ,SUBFRAME   = subframe $
           ,LABEL_BOTTOM= label_bottom $
           ,LABEL_LEFT = label_left $
           ,LABEL_RIGHT= label_right $
           ,LABEL_TOP  = label_top $
           ,MAXIMUM    = maximum $
           ,MINIMUM    = minimum $
           ,NO_COPY    = no_copy $
           ,STEPWIDTH  = stepwidth $
           ,TITLE      = title $
           ,UVALUE     = uvalue $
           ,VALUE      = value $
           ,VERTICAL   = vertical $
           ,XOFFSET = xoffset, YOFFSET = yoffset $
           ,XSIZE = xsize  ,YSIZE = ysize 
   
   Default, drag, 0
   Default, maximum, 100
   Default, minimum, 0
   Default, value, minimum
   Default, stepwidth, 0.1
   Default, format, '(F6.2)'
   Default, uvalue, 0

   ;Default Label position is bottom
   If not Keyword_Set(LABEL_TOP)    and $
    not   Keyword_Set(LABEL_BOTTOM) and $
    not   Keyword_Set(LABEL_LEFT)   and $
    not   Keyword_Set(LABEL_RIGHT)      $
    then LABEL_BOTTOM = 1

   
   W_Base = Widget_Base(Parent, $
                        /COLUMN, $
                        /BASE_ALIGN_CENTER, $
                        FRAME=frame, $
                        FUNC_GET_VALUE="CW_FSLIDER2_func_get_value", $
                        PRO_SET_VALUE="CW_FSLIDER2_pro_set_value", $
                        XOFFSET = xoffset, YOFFSET = yoffset, $
                        UVALUE=uvalue, NO_COPY=no_copy, $
                        EVENT_FUNC="CW_FSLIDER2_event_func")
   
   If keyword_set(LABEL_TOP) or keyword_set(LABEL_BOTTOM) then begin
      column = 1
      row = 0
   endif else begin
      column = 0
      row = 1
   endelse
   
   If Keyword_Set(TITLE) then W_Title = Widget_Label(W_Base, $
                                                     FONT=font_title, $
                                                     VALUE=title)
   
   W_InnerBase = Widget_Base(W_Base, $
                             COLUMN=column, ROW=row, $
                             /BASE_ALIGN_CENTER, FRAME=subframe)   

   ;if LABEL_TOP or LABEL_LEFT, create Label NOW:
   if Keyword_Set(LABEL_TOP) or Keyword_Set(LABEL_LEFT) then $
    W_Label = Widget_Label(W_InnerBase, $
                           $;/DYNAMIC_RESIZE, $
                           FONT=font_label, $
                           VALUE=string(value, FORMAT=format))

   maxslider = (maximum-minimum)/stepwidth
   W_Slider = Widget_Slider(W_InnerBase, $
      VALUE=(value-minimum)/double(maximum-minimum)*maxslider, $
      /DRAG, $
      MAXIMUM=maxslider, $
      /SUPPRESS_VALUE, $
      VERTICAL=vertical, $
      XSIZE=xsize, YSIZE=ysize)

   ;if LABEL_BOTTOM or LABEL_RIGHT, create Label NOW:
   if Keyword_Set(LABEL_BOTTOM) or Keyword_Set(LABEL_RIGHT) then $
   W_Label = Widget_Label(W_InnerBase, $
                          $;/DYNAMIC_RESIZE, $
                          FONT=font_label, $
                          VALUE=string(value, FORMAT=format))

   ;;UVALE of W_Base has to be left to the user (the compound widget
   ;;shall look like a normal one, with a free UVALUE.
   ;;We use the UVALE of the first child for our needs. (This can be used as a standard.)
   FirstChild = Widget_Info(W_Base, /CHILD)
   Widget_Control, FirstChild, SET_UVALUE={info         : "CW_FSLIDER2", $
                                           W_Slider     : W_SLider, $
                                           W_Label      : W_Label, $
                                           maximum      : maximum, $
                                           minimum      : minimum, $
                                           maxslider    : maxslider, $
                                           value        : double(value), $
                                           format       : format, $
                                           drag         : drag}


   
   Return, W_Base

End
