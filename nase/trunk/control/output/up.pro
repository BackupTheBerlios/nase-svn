;+
; NAME: Up()
;
; AIM: Returns a String of !KEY.UPs
;
; PURPOSE: Liefert String aus lauter !KEY.UPs
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: print, Up( times )
;
; INPUTS: times : wieviele Ups?
;
; OUTPUTS: String von times mal !KEY.UP
;
; PROCEDURE: Aufruf von StrRepeat()
;
; EXAMPLE: print, up(3)+"Hallo!"
; 
; SEE ALSO: <A HREF="#UP">Up()</A>, <A HREF="#DOWN">Down()</A>, <A HREF="#LEFT">Left()</A>, <A HREF="#RIGHT">Right()</A> 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/28 13:25:10  alshaikh
;              added AIM
;
;        Revision 2.1  1998/03/23 17:45:59  kupper
;               Aus der Hebe getauft!
;
;-

Function Up, times

   Return, StrRepeat(!KEY.UP, times)

End
