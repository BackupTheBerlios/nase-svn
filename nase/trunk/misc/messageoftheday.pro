;+
; NAME:
;  MessageOfTheDay
;
; VERSION:
;  $Id$
;
; AIM:
;  In interactive sessions, display message of the day.
;
; PURPOSE:
;  Display message of the day, as text or as dialog. If Session is
;  non-interactive, nothing is done at all. Message can be displayed
;  in a modal dialog.
;
; CATEGORY:
;  Help
;  Startup
;
; CALLING SEQUENCE:
;*MessageOfTheDay( [/WIN] )
;
; INPUT KEYWORDS:
;  WIN:: Display a graphical dialog, if X connections are allowed in
;        the current session. If not, text is displayed.
;
; RESTRICTIONS:
;  Graphical dialogs are modal (using DIALOG_MESSAGE()). This is a bit
;  disturbing, that's why they are disanled by default. Someone to
;  implement non-modal dialogs`?
;
; SEE ALSO:
;  <A>Interactive</A>, <A>XAllowed</A>
;-



Pro MessageOfTheDay, WIN=WIN
   
   If not Interactive() then return

   message = "Had your look in '"+journalize()+"' today?"

   If Keyword_Set(WIN) and XAllowed() then begin
      dummy = dialog_message(/INFORMATION, message, $
                             TITLE="Message of the Day")
   endif else begin
      console, strrepeat("-", strlen(message))
      console, message
      console, strrepeat("-", strlen(message))
   endelse
      
End
