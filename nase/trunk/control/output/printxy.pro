;+
; NAME: PrintXY
;
; AIM: Prints text at position (x,y)
;
; PURPOSE: Ausgabe von Text an einer bestimmten Fensterposition
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: PrintXY, Text [,x ,y]
;
; INPUTS: Text : Auszugebender Text
;
; OPTIONAL INPUTS: x, y: Position des ersten Zeichens, 0,0 definiert
;                        die linke obere Fensterecke. Werd nichts
;                        angegeben, so wird die gleiche Position wie
;                        beim letzen Aufruf verwendet.
;                        
; OUTPUTS: Der Text mit Print an der gewünschten Stelle
;
; COMMON BLOCKS: common_printxy, xpos, ypos        zum merken der Position
;
; SIDE EFFECTS: Die aktuelle Printposition ist nachdem Aufruf am
;               Anfang der nächsten Zeile
;
; PROCEDURE: Benutzung von Up(), Down() und Right()
;
; EXAMPLE: printxy, "X hier ist 10,10!", 10, 10
;
; SEE ALSO: <A HREF="#UP">Up()</A>, <A HREF="#DOWN">Down()</A>, <A HREF="#LEFT">Left()</A>, <A HREF="#RIGHT">Right()</A> 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/09/28 13:25:10  alshaikh
;              added AIM
;
;        Revision 2.2  1998/04/13 18:57:50  kupper
;               X/Y-Vertauschung umgetauscht...
;
;        Revision 2.1  1998/03/23 17:48:33  kupper
;               Aus der Hebe getauft!
;
;-

Pro PrintXY, text, X, Y
   
   common common_printxy, xpos, ypos

   Default, xpos, 0
   Default, ypos, 0
   
   If N_Params() gt 1 then begin
      xpos = X
      ypos = Y
   Endif
   
   print, Up(100)+Down(ypos)+Right(xpos)+text

End
