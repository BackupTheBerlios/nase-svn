;+
; NAME: Dummy_EventHandler
;
; PURPOSE: Ein supersimpler Widget-Event-Handler zu Testzwecken.
;          Gibt einfach jedes Event mittels HELP auf dem Bildschirm aus.
;
; CATEGORY: Widgets
;
; CALLING SEQUENCE: XMANAGER, "MyWidget", MyWidget, EVENT_HANDLER="Dummy_EventHandler"
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/06/17 14:11:00  kupper
;        Initial revision.
;
;-

Pro Dummy_EventHandler, Event
   print, "Widget sent event:"
   help, Event, /STRUCTURE
End
