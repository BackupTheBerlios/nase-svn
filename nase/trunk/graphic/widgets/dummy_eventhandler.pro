;+
; NAME: Dummy_EventHandler
;
; AIM:
;  A universal event handler that displays events using the HELP
;  routine.
;
; PURPOSE: Ein supersimpler Widget-Event-Handler zu Testzwecken.
;          Gibt einfach jedes Event mittels HELP auf dem Bildschirm
;          aus.
;          May be used as a procedure or a function. The function will
;          swallow all events.
;
; CATEGORY: Widgets
;
; CALLING SEQUENCE: XMANAGER, "MyWidget", MyWidget, EVENT_HANDLER="Dummy_EventHandler"
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/10/01 14:51:58  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.2  2000/08/30 18:36:31  kupper
;        Added function type event handler.
;
;        Revision 1.1  1999/06/17 14:11:00  kupper
;        Initial revision.
;
;-

Pro Dummy_EventHandler, Event
   print, "Widget sent event:"
   help, Event, /STRUCTURE
End

Function Dummy_EventHandler, Event
   print, "Widget sent event:"
   help, Event, /STRUCTURE

   return, 0 ;;swallow event
End
