;+
; NAME: Left()
;
; AIM: Returns a String of !KEY.LEFTs
;
; PURPOSE: Liefert String aus lauter !KEY.LEFTs
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: print, Left ( times )
;
; INPUTS: times : wieviele Lefts?
;
; OUTPUTS: String von times mal !KEY.LEFT
;
; PROCEDURE: Aufruf von StrRepeat()
;
; EXAMPLE: print, Left(3)+"Hallo!"
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

Function Left, times

   Return, StrRepeat(!KEY.LEFT, times)

End
