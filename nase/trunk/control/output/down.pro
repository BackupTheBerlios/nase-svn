;+
; NAME: Up()
;
; PURPOSE: Liefert String aus lauter !KEY.DOWNs
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: print, Down ( times )
;
; INPUTS: times : wieviele DOWNs?
;
; OUTPUTS: String von times mal !KEY.DOWN
;
; PROCEDURE: Aufruf von StrRepeat()
;
; EXAMPLE: print, Down(3)+"Hallo!"
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

Function Down, times

   Return, StrRepeat(!KEY.DOWN, times)

End
