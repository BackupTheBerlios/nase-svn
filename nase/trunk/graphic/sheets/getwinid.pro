;+
; NAME:                GetWinID
;
; PURPOSE:             Liefert die zu einem Window-Sheet gehoerige WINID. Diese
;                      wird fuer "Device, /COPY"-Anweisungen benoetigt.
;
; CATEGORY:            SHEET GRAPHIC
;
; CALLING SEQUENCE:    winid = GetWinID(Sh)
;
; INPUTS:              Sh : ein mit DefineSheet initialisiertes Sheet
;
; OUTPUTS:             winid: die WinID oder !NONE, falls keine vorhanden
;
; SEE ALSO:            <A HREF="http://neuro.physik.uni-marburg.de/nase/graphic/sheets">andere Sheet-Routinen</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/02/12 15:22:08  saam
;           tributed to A. Gabriel
;
;
;-
FUNCTION GetWinID, _SH

   Handle_Value, _SH, SH

   IF SH.Type EQ 'X' THEN Return, SH.winid ELSE Return, !NONE
            

END
