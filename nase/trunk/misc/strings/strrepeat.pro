;+
; NAME: StrRepeat()
;
; AIM: repeats a string (IDL provides this?!)
;
; PURPOSE: Liefert string, der aus lauter Verkettungen eines gegebenen 
;          Strings besteht.
;
; CATEGORY: Output, Text
;
; CALLING SEQUENCE: outstring = StrRepeat ( String, times )
;
; INPUTS: String: zu wiederholender String
;         times : Anzahl der Wiederholungen
;
; OUTPUTS: outstring: times mal String hintereinander
;
; PROCEDURE: Rekursives Verketten
;
; EXAMPLE: Print, StrRepeat ("Hallo!",3)
;
; SEE ALSO: <A HREF="#UP">Up()</A>, <A HREF="#DOWN">Down()</A>, <A HREF="#LEFT">Left()</A>, <A HREF="#RIGHT">Right()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/25 09:13:11  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 2.1  1998/03/23 17:45:59  kupper
;               Aus der Hebe getauft!
;
;-

Function StrRepeat, String, times

   If times le 0 then Return, ''
   
   Return, String+StrRepeat(String, times-1)

End
