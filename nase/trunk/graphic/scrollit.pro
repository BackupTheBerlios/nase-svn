;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;	
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-

Pro ScrollIt_Event, Event
; Die einzigen Events, die ankommen, sind Size-Events

   Draw = WIDGET_INFO(Event.Top, /CHILD) ;das ist unser Draw-Widget!

   If fix(!VERSION.Release) ge 4 then WIDGET_CONTROL, Draw, $
    SCR_XSIZE=Event.X, SCR_YSIZE=Event.Y

End

Function ScrollIt, XPOS=xpos, YPOS=ypos, XSIZE=xsize, YSIZE=ysize, $
                   X_SCROLL_SIZE=x_scroll_size, Y_SCROLL_SIZE=y_scroll_size, $
                   GROUP=group

   Default,  xsize, 500
   Default,  ysize, 500
   Default,  xpos,  200
   Default,  ypos,  200
   Default,  x_scroll_size, 300
   Default,  y_scroll_size, 300
   Default,  group, 0
 
   Base = Widget_Base(GROUP_LEADER=group, TITLE='Scroll It!', $
                     XOFFSET=xpos, YOFFSET=ypos, $
                     /TLB_SIZE_EVENTS)
   Draw = Widget_Draw(Base, $
                      XSIZE=xsize, YSIZE=ysize, $
                      X_SCROLL_SIZE=x_scroll_size, Y_SCROLL_SIZE=y_scroll_size)

   Widget_Control, /REALIZE, Base
   Widget_Control, GET_VALUE=Window_ID, Draw

   XMANAGER, 'ScrollIt', Base, /JUST_REG


   V = WIDGET_INFO(Base, /VERSION)
   

   return, Window_ID
end

