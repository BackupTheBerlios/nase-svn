;+
; NAME: Swallow_Events
;
; AIM: A "NULL" widget event handler, swallowing all events.
;
; PURPOSE: In some cases, it may be desired that a widget does not
;          produce any event (such as a on/off button maintaining his
;          state, but not sending events).
;          To prevent a widget from sending events, it's EVENT_PRO or
;          EVENT_FUNC may be set to "swallow_events".
;
; CATEGORY: Widgets
;
; CALLING SEQUENCE: mywid = Any_Widget_Routine(..., EVENT_PRO="swallow_events")
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/09/05 18:38:50  kupper
;        new and simple. (very.)
;
;-

Pro Swallow_Events, Event
End

Function Swallow_Events, Event
   return, 0 ;;swallow event
End
