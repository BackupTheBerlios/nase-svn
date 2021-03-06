;+
; NAME: ShowIt_Open
;
; AIM:
;  Open a ShowIt draw widget for graphics output.
;
; PURPOSE: �ffnen eines zuvor mit <A HREF="#WIDGET_SHOWIT">Widget_ShowIt</A> vorbereiteten Widgets.
;          Beim �ffnen werden die Graphik-Systemvariablen auf die zu diesem 
;          Widget geh�renden Werte gesetzt. Au�erdem wird die mit dem Widget
;          assoziierte Window-ID ermittelt und das entsprechende Fenster
;          per UWSet ge�ffnet, soda� nachfolgende Graphikausgabe dort ankommt.
;          Falls das Widget vor dem ShowIt_Open-Aufruf noch nicht realisiert 
;          war, f�hrt ShowIt_Open die Realisierung durch. (Dies wirkt im
;          �brigen auf die gesamte Widget-Hierarchie, der das ShowIt angeh�rt.)
;
; CATEGORY: GRAPHIC / WIDGETS
;
; CALLING SEQUENCE: ShowIt_Open, widgetid
;
; INPUTS: widget_id: Die Identifikationsnummer des zu �ffnenden Widgets. Diese
;                    wird von <A HREF="#WIDGET_SHOWIT">Widget_ShowIt</A> geliefert.
; PROCEDURE: 1. Realisieren.
;            2. UWSet auf das Fenster mit der zugeh�rigen WinID.
;            3. !P, !X, !Y und !Z setzen.
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
;        Revision 1.9  2003/08/25 16:02:04  kupper
;        sorry, had debug messages left. removed.
;
;        Revision 1.8  2003/08/25 15:51:34  kupper
;        showits now also store the palette that was set when they were opened,
;        and restore it when being closed. So they do not interfere with the
;        "global" palette the user might use. Until now, they did.
;
;        Revision 1.7  2003/08/25 13:43:50  kupper
;        showits now count the number of closes / opens to protect against
;        nested calls.
;
;        Revision 1.6  2000/10/01 14:51:59  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.5  2000/03/16 15:31:54  kupper
;        Changed to store old active window.
;
;        Revision 1.4  1999/11/23 14:03:27  kupper
;        corrected copy-and-paste-error.
;
;        Revision 1.3  1999/11/16 17:05:13  kupper
;        Incorporated changes previously made to the sheet/scrollit routines:
;        Will not produce tracking events for TrueColor or DirectColor
;        visuals, but will set colortable upon opening in that case.
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


PRO ShowIt_Open, widid

   dmsg, "--- called. ---"

   ;; determine currently open window:
   active_window = !D.window
   dmsg, "active win: "+str(active_window)

   dmsg, "realizing widget..."
   Widget_Control, widid, /REALIZE
   dmsg, "...done realizing widget"

   ;; get uservalue:
   firstchild = Widget_Info(widid, /CHILD)
   Widget_Control, firstchild, GET_VALUE=winid, GET_UVALUE=uservalue, /NO_COPY

   ;; increase opencount
   uservalue.opencount = uservalue.opencount+1
   dmsg, "new opencount: "+str(uservalue.opencount)

   ;; do only store values, if opencount equals 1:
   If (uservalue.opencount eq 1) then begin
      uservalue.oldwin = active_window
      UWSet, winid

      dmsg, "stored old win id: "+str(uservalue.oldwin)
      dmsg, "stored new win id: "+str(winid)
      
      old = !P
      !P = uservalue.p
      uservalue.p = old
      old = !X
      !X = uservalue.x
      uservalue.x = old
      old = !Y 
      !Y = uservalue.y
      uservalue.y = old
      old = !Z
      !Z = uservalue.z
      uservalue.z = old
      
      If not(PseudoColor_Visual()) then begin
                                ;we've got a True-Color-Display, so
                                ;we have to set the private color
                                ;table:
         ;; store old palette:
         UTVLCT, /GET, Red, Green, Blue
         uservalue.OldPalette.R = Red
         uservalue.OldPalette.G = Green
         uservalue.OldPalette.B = Blue
         ;; set my palette:
         UTVLCT, /OVER, uservalue.MyPalette.R, uservalue.MyPalette.G, uservalue.MyPalette.B 
      endif
   Endif
   
   Widget_Control, firstchild, SET_UVALUE=uservalue, /NO_COPY

   dmsg, "--- ready. ---"
END
