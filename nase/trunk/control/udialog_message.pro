;+
; NAME: UDialog_Message
;
; PURPOSE: Graphischer User-Dialog im Stil von "Dialog_Message"(IDL5)
;          bzw. "Widget_Message"(IDL4) für alle IDL-Versionen (ab 3 aufwärts).
;
; CATEGORY: Allgemein, miscellaneous
;
; CALLING SEQUENCE: kompatibel zu Dialog_Message bzw. Widget_Message.
;                   s. Hilfe von IDL4 oder IDL5.
;
; COMMON BLOCKS: Common_UDialog_Message, buttonname
;
; RESTRICTIONS: Für IDL3 haben nicht alle Schlüsselwörter einen Effekt.
;
; PROCEDURE: Je nach Version entweder alles an Dialog/Widget_Message
;            weitergeben oder (IDL3) das Widget selbst bauen.
;
; EXAMPLE: Print, UDialog_Message(/QUESTION, ["Jetzt mußt Du Dich entscheiden:","Ja oder Nein?"])
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  1998/06/04 14:30:17  kupper
;               Jetzt hoffentlich wirklich.
;
;        Revision 2.2  1998/05/21 10:31:52  kupper
;               Message-Box jetzt in IDL3 ungefähr auf Bildschirmmitte.
;
;        Revision 2.1  1998/05/20 14:58:20  kupper
;               Schöpfung.
;
;-

Function Dialog_Message
   ;dummy
End
Function Widget_Message
   ;dummy
End

Function UDialog_Message, Text, CANCEL=cancel, ERROR=error, INFORMATION=information, QUESTION=question, $
           TITLE=title, DISPLAY_NAME=display_name, DIALOG_PARENT=dialog_parent, DEFAULT_CANCEL=default_cancel, DEFAULT_NO=default_no, _EXTRA=_extra

   Common common_udialog_message, buttonname

   IDLversion = fix(!version.release)
   Default, dialog_parent, 0
   Default, cancel, 0
   default, error, 0
   default, information, 0
   default, question, 0
   default, default_cancel, 0
   default, default_no, 0
   If Keyword_Set(ERROR) then default, title, "Error"
   If Keyword_Set(INFORMATION) then default, title, "Information"
   If Keyword_Set(QUESTION) then default, title, "Question"
   default, title, "Warning"

   If IDLversion ge 5 then begin
      Return, Dialog_Message(Text, CANCEL=cancel, ERROR=error, INFORMATION=information, $
                         QUESTION=question, TITLE=title, DISPLAY_NAME=display_name, $
                         DIALOG_PARENT=dialog_parent, DEFAULT_CANCEL=default_cancel,$
                         DEFAULT_NO=default_no, _EXTRA=_extra)
   End
   If IDLversion eq 4 then Return, Widget_Message(Text, CANCEL=cancel, ERROR=error, INFORMATION=information, QUESTION=question, $
           TITLE=title, DIALOG_PARENT=dialog_parent, DEFAULT_CANCEL=default_cancel, DEFAULT_NO=default_no, _EXTRA=_extra)
   
   ;IDL 3 - Do it yourself...

   Device, GET_SCREEN_SIZE=screensize

   Base = Widget_Base(/COLUMN, XOFFSET=(screensize(0)-100)/2, YOFFSET=(screensize(1)-100)/2, TITLE=title, SPACE=0, XPAD=0, YPAD=0)
   SubBase = Widget_Base(Base, /COLUMN, FRAME=1, SPACE=0, XPAD=0, YPAD=0)
   For i=1, n_elements(Text) do TextWid = Widget_Label(SubBase, FRAME=0, VALUE=Text(i-1))

   If Keyword_Set(QUESTION) then names = ["Yes", "No"] else names = ["OK"]
   If keyword_Set(CANCEL)   then names = [names, "Cancel"]

   Buttons = CW_BGROUP(Base, FRAME=0, names, /ROW, /RETURN_NAME)

   WIDGET_CONTROL, Base, /REALIZE

   Event = Widget_Event(Base)
   buttonname = Event.Value     ;Return Button Name in common block.
   Widget_Control, Base, /DESTROY ;Kill Base

   Return, buttonname
End
