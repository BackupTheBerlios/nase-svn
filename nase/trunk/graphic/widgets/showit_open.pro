;+
; NAME: ShowIt_Open
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


   Widget_Control, widid, /REALIZE

   firstchild = Widget_Info(widid, /CHILD)
   Widget_Control, firstchild, GET_VALUE=winid, GET_UVALUE=uservalue, /NO_COPY
   UWSet, winid

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
                                ;we have to set the private color table:
      UTVLCT, uservalue.MyPalette.R, uservalue.MyPalette.G, uservalue.MyPalette.B 
   End

   Widget_Control, firstchild, SET_UVALUE=uservalue, /NO_COPY

END
