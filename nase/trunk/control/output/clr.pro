;+
; NAME: CLR
;
; AIM: clears the (text-)screen
;
; PURPOSE: Loescht den Textbildschirm
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: CLR
;
; SIDE EFFECTS: Bildschirm ist nach dem AUfruf leer (oho!)
;
; PROCEDURE: StrRepeat (!KEY.ENTER, 100)
;
; EXAMPLE: CLR
;
; SEE ALSO: <A HREF="#STRREPEAT">StrRepeat()</A>,
;           <A HREF="#UP">Up()</A>, <A HREF="#DOWN">Down()</A>, <A HREF="#LEFT">Left()</A>, <A HREF="#RIGHT">Right()</A> 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/28 13:25:09  alshaikh
;              added AIM
;
;        Revision 2.1  1998/03/23 17:45:58  kupper
;               Aus der Hebe getauft!
;
;-

Pro CLR

   print, StrRepeat(!KEY.ENTER, 100)

End
