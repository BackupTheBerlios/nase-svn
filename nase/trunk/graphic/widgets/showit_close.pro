;+
; NAME: ShowIt_Close
;
; PURPOSE: Schlie�en eines zuvor mit <A HREF="#SHOWIT_OPEN">ShowIt_Open</A> ge�ffneten Widgets.
;          Beim Schlie�en werden die Graphik-Systemvariablen auf die vor dem  
;          �ffnen gesicherten Werte zur�ckgesetzt. Au�erdem wird die gerade 
;          gesetzte Farbtabelle mit dem Widget zusammen gespeichert. Dies
;          kann allerdings auch unterbunden werden, um st�ndiges Hin- und
;          Herschalten der Farben zu verhindern. 
;
; CATEGORY: GRAPHIC / WIDGETS
;
; CALLING SEQUENCE: ShowIt_Close, widgetid[, /SAVE_COLORS]
;
; INPUTS: widget_id: Die Identifikationsnummer des zu schlie�enden Widgets. 
;                    Diese wird von <A HREF="#WIDGET_SHOWIT">Widget_ShowIt</A> geliefert.
;
; KEYWORD PARAMETERS: SAVE_COLORS: Ist dieses Schl�sselwort gesetzt, speichert
;                      ShowIt_Close die aktuelle Farbtabelle im UserValue des
;                      Widgets. Default: SAVE_COLORS=1
;
; PROCEDURE: 1. !P, !X, !Y und !Z zur�cksetzen.
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
   
   UWset, uservalue.oldwin

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
   ;get current palette and Save it in Draw-Widget's UVAL:
      UTVLCT, /GET, Red, Green, Blue
      uservalue.MyPalette.R = Red
      uservalue.MyPalette.G = Green
      uservalue.MyPalette.B = Blue
   ENDIF 

   Widget_Control, firstchild, SET_UVALUE=uservalue, /NO_COPY      


END
