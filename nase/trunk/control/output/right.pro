;+
; NAME: Right()
;
; PURPOSE: Liefert String aus lauter !KEY.RIGHTs
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: print, Right ( times )
;
; INPUTS: times : wieviele RIGHTs?
;
; OUTPUTS: String von times mal !KEY.RIGHT
;
; PROCEDURE: Aufruf von StrRepeat()
;
; EXAMPLE: print, Right(3)+"Hallo!"
; 
; SEE ALSO: <A HREF="#UP">Up()</A>, <A HREF="#DOWN">Down()</A>, <A HREF="#LEFT">Left()</A>, <A HREF="#RIGHT">Right()</A> 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/03/23 17:45:59  kupper
;               Aus der Hebe getauft!
;
;-

Function Right, times

   Return, StrRepeat(!KEY.RIGHT, times)

End
