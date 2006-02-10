;+
; NAME:
;  TLB_size_handler
;
; VERSION:
;  $Id$
;
; AIM:
;  A generic mouse-resize-handler for top level base widgets.
;
; PURPOSE:
;  This routine does a minimal handling of top-level-base resize
;  events. It resizes the top-level-base widget to the values that are
;  passed by the event. This should be enough to make a simple widget
;  respond adequately to mouse resizing.<BR>
;
;  FLAME: If you are extraordinary lucky, and IDL's widget auto-layout
;  works on your platform (which, according to the IDL manual, OF
;  COURSE works for ALL platforms), this routine will also be enough
;  for a complex widget hierarchy. However, the chance for this is
;  close to zero. Or, if I come to think about it, it might be
;  negative. So you may need to adjust this routine to fit the
;  specific needs of a more complex widget. And pleaso do not expect,
;  that the values reported by the event are correct. You will have to
;  go with a few pixels off here and there, depending on what window
;  manager happens to be used on your system. Of course, the IDL
;  manual does not mention any problem in regard to this. All is
;  platform-independent. Naturally. Please write ten thousand
;  support mails to RSI, and blame them.<BR>
;
;  You can either register this routine as the event handler for your
;  widget in <C>XMANAGER</C>, if no other events arrive at the top
;  level, or you can call it from your own event handler. Any other
;  events apart from top level base size events will be passed to
;  <A>dummy_eventhandler</A>.
;
; CATEGORY:
;  Widgets
;
; CALLING SEQUENCE:
;*TLB_size_handler, event
;
; INPUTS:
;  event:: an event produced by the widget hierarchy.
;
; SIDE EFFECTS:
;  resizes the top-level-base widget.
;
; RESTRICTIONS:
;  Do not expect IDL's widget management to be platform-independent,
;  whatever they tell you.<BR>
;
;  Do not forget that your widget hierarchy does only produce size
;  events, if you set /TLB_SIZE_EVENTS in your call to <C>WIDGET_BASE()</C>.
;
; PROCEDURE:
;  Straightforward, and pray that it works.
;
; EXAMPLE:
;*
;*> Xmanager, my_widget, EVENT_HANDLER="TLB_size_handler"
;
; SEE ALSO:
;  <A>dummy_eventhandler</A>
;-

Pro TLB_size_handler, e

   case tag_names(e, /structure_name) of
      'WIDGET_BASE': begin ;; a top-level-base-resize-event
         widget_control, e.top, update=0
         widget_control, e.top, xsize=e.x, ysize=e.y
         widget_control, e.top, update=1
      end
      else: dummy_eventhandler, e
   endcase
   
End
