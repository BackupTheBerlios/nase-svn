;+
; NAME:               ReadMaple 
;
; PURPOSE:            Liest eine mit Maples SAVE-Funktion abgespeicherte
;                     Variable ein. Darf nur eine Variable gespeichert 
;                     worden sein. Dei Anzahl der einzulesenden Elemente
;                     muss bekannt sein.
;
; CATEGORY:           MISC MAPLE
;
; CALLING SEQUENCE:   var = ReadMaple(file, nel)
;
; INPUTS:             file: Filename des SAVE-Maple-Files
;                     nel : Zahl der einzulesenden Elemente
;
; OUTPUTS:            var : das Ergebnis der Leseaktion
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/10/18 19:51:04  saam
;           new, a little bit experimental, needs some proof
;           ...and generality if needed...
;
;
;-
FUNCTION ReadMaple, file, nel

   Default, nel, 1
   tmpsuff = '.tmp'

   ; eliminate maple syntax like "y := "
   IF FileExists(file) THEN BEGIN
      command = "/usr/bin/perl -e 's/[A-DF-Za-df-z:=\[\]\n,;]//gi' -p < "+file+" > "+file+tmpsuff
      spawn, command, result
   END ELSE Message, "file doesn't exist"
   
   val = DblArr(nel)
   lun = UOpenR(file+tmpsuff)
   ReadF, lun, val
   UClose, lun
   
   RETURN, val
END
