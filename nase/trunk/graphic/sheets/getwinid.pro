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
; SIDE EFFECTS:        Falls das Sheet ein Kind einer
;                      Widget-Applikation ist, wird die gesamte
;                      Hierarchie, zu der das Sheet gehoert, mit
;                      diesem Aufruf realisiert, d.h. auf dem
;                      Bildschirm sichtbar.
;                      Man beachte in diesem Zusammenhang, dass das
;                      Hinzufuegen eines Sheets/ScrollIts zu einer
;                      bereits realisierten Widget-Hierarchie in der
;                      aktuellen IDL-Version (5.0.2) unter KDE zu einem
;                      astreinen IDL-Absturz fuehrt!
;
; SEE ALSO:            <A HREF="http://neuro.physik.uni-marburg.de/nase/graphic/sheets">andere Sheet-Routinen</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1999/06/15 17:36:39  kupper
;     Umfangreiche Aenderungen an ScrollIt und den Sheets. Ziel: ScrollIts
;     und Sheets koennen nun als Kind-Widgets in beliebige Widget-Applikationen
;     eingebaut werden. Die Modifikationen machten es notwendig, den
;     WinID-Eintrag aus der Sheetstruktur zu streichen, da diese erst nach der
;     Realisierung der Widget-Hierarchie bestimmt werden kann.
;     Die GetWinId-Funktion fragt nun die Fensternummer direkt ueber
;     WIDGET_CONTROL ab.
;     Ebenso wurde die __sheetkilled-Prozedur aus OpenSheet entfernt, da
;     ueber einen WIDGET_INFO-Aufruf einfacher abgefragt werden kann, ob ein
;     Widget noch valide ist. Der Code von OpenSheet und DefineSheet wurde
;     entsprechend angepasst.
;     Dennoch sind eventuelle Unstimmigkeiten mit dem frueheren Verhalten
;     nicht voellig auszuschliessen.
;
;     Revision 1.1  1999/02/12 15:22:08  saam
;           tributed to A. Gabriel
;
;
;-
FUNCTION GetWinID, _SH

   Handle_Value, _SH, SH

   IF SH.Type EQ 'X' THEN begin
      If not Widget_Info( SH.drawid, /REALIZED) then Widget_Control, SH.drawid, /REALIZE
      Widget_Control, SH.drawid, GET_VALUE=winid
      Return, winid
   Endif ELSE Return, !NONE
            

END
