;+
; NAME: ShowIt_Close
;
; AIM:
;  Close a ShowIt draw widget after graphics output.
;
; PURPOSE: Schließen eines zuvor mit <A HREF="#SHOWIT_OPEN">ShowIt_Open</A> geöffneten Widgets.
;          Beim Schließen werden die Graphik-Systemvariablen auf die vor dem  
;          Öffnen gesicherten Werte zurückgesetzt. Außerdem wird die gerade 
;          gesetzte Farbtabelle mit dem Widget zusammen gespeichert. Dies
;          kann allerdings auch unterbunden werden, um ständiges Hin- und
;          Herschalten der Farben zu verhindern. 
;
; CATEGORY: GRAPHIC / WIDGETS
;
; CALLING SEQUENCE: ShowIt_Close, widgetid[, /SAVE_COLORS]
;
; INPUTS: widget_id: Die Identifikationsnummer des zu schließenden Widgets. 
;                    Diese wird von <A HREF="#WIDGET_SHOWIT">Widget_ShowIt</A> geliefert.
;
; KEYWORD PARAMETERS: SAVE_COLORS: Ist dieses Schlüsselwort gesetzt, speichert
;                      ShowIt_Close die aktuelle Farbtabelle im UserValue des
;                      Widgets. Default: SAVE_COLORS=1
;
; PROCEDURE: 1. !P, !X, !Y und !Z zurücksetzen.
;            2. Farbpalette speichern
;
; EXAMPLE: p=Widget_Base()
;          s=Widget_ShowIt(p, /PRIVATE_COLORS, XSIZE=500, YSIZE=200)
;          ShowIt_Open, s
;          Plot, RandomN(seed,50)
;          Showit_Close, s   
;
; SEE ALSO: <A HREF="#SCROLLIT">ScrollIt</A>, <A HREF="./SHEETS/#DEFINESHEET">DefineSheet</A>, <A HREF="./SHEETS/#OPENSHEET">OpenSheet</A>, <A HREF="./SHEETS/#CLOSESHEET">CloseSheet</A>, 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.7  2003/08/25 16:02:04  kupper
;        sorry, had debug messages left. removed.
;
;        Revision 1.6  2003/08/25 15:51:34  kupper
;        showits now also store the palette that was set when they were opened,
;        and restore it when being closed. So they do not interfere with the
;        "global" palette the user might use. Until now, they did.
;
;        Revision 1.5  2003/08/25 13:43:50  kupper
;        showits now count the number of closes / opens to protect against
;        nested calls.
;
;        Revision 1.4  2000/10/01 14:51:59  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.3  2000/03/16 15:31:29  kupper
;        Changed to restore old active window.
;
;        Revision 1.2  1999/09/06 14:04:56  thiel
;            Wrapped draw-widget inside base to provide free uservalue.
;
;        Revision 1.1  1999/09/01 16:43:53  thiel
;            Moved from other directory.
;
;        Revision 1.1  1999/08/30 09:20:34  thiel
;            DrawWidgets who rember their colortables. For use with FaceIt.
;
;-


PRO showit_close, widid, SAVE_COLORS=save_colors

   Default, save_colors, 1


   firstchild = Widget_Info(widid, /CHILD)

   Widget_Control, firstchild, GET_UVALUE=uservalue, /NO_COPY
   
   ;; decrease opencount
   uservalue.opencount = uservalue.opencount-1

   ;; opencount must always be 0 or positive:
   if (uservalue.opencount lt 0) then begin
      console, /Warning, "ShowIt widget closed more often than it was " + $
      "opened! This is a programming error!"
      uservalue.opencount = 0
   endif else begin
      ;; do only restore values, if opencount equals 0:
      If (uservalue.opencount eq 0) then begin
         UWset, uservalue.oldwin
         
         dmsg, "restoring win: "+str(uservalue.oldwin)
      
         new = !P
         !P =  uservalue.p
         uservalue.p = new
         new = !X
         !X =  uservalue.x
         uservalue.x = new
         new = !Y
         !Y =  uservalue.y 
         uservalue.y = new
         new = !Z
         !Z =  uservalue.z
         uservalue.z = new
         
         IF keyword_set(SAVE_COLORS) THEN BEGIN 
            ;;get current palette and Save it in Draw-Widget's UVAL:
            UTVLCT, /GET, Red, Green, Blue
            uservalue.MyPalette.R = Red
            uservalue.MyPalette.G = Green
            uservalue.MyPalette.B = Blue
         ENDIF
         If not(PseudoColor_Visual()) then begin
            ;; we've got a True-Color-Display, so
            ;; we have to
            ;; restore the old palette:
            UTVLCT, /OVER, uservalue.OldPalette.R, uservalue.OldPalette.G, uservalue.OldPalette.B
         endif
      endif
   endelse
   
   Widget_Control, firstchild, SET_UVALUE=uservalue, /NO_COPY      

END
