;+
; NAME: GetWinID
;
; AIM:
;  Return the window ID associated with a window sheet.
;
; PURPOSE: Liefert die zu einem Window-Sheet gehörige WINID. Diese wird fuer 
;          "Device, /COPY"-Anweisungen benötigt.
;
; CATEGORY: GRAPHICS /SHEETS
;
; CALLING SEQUENCE: winid = GetWinID(Sh)
;
; INPUTS: 
;         Sh : ein mit DefineSheet initialisiertes Sheet
;
; OUTPUTS: 
;         winid: die WinID oder !NONE, falls keine vorhanden
;
; SIDE EFFECTS: Falls das Sheet ein Kind einer Widget-Applikation ist, wird die
;               gesamte Hierarchie, zu der das Sheet gehört, mit diesem Aufruf
;               realisiert, d.h. auf dem Bildschirm sichtbar.
;               Man beachte in diesem Zusammenhang, daß das Hinzufügen eines 
;               Sheets/ScrollIts zu einer bereits realisierten Widget-
;               Hierarchie in der aktuellen IDL-Version (5.0.2) unter KDE zu 
;               einem astreinen IDL-Absturz fuehrt!
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/10/01 14:51:35  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 1.4  2000/09/27 15:59:16  saam
;     service commit fixing several doc header violations
;
;     Revision 1.3  1999/09/06 13:33:34  thiel
;         Now works with Multi-sheets as well.
;
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

  IF (SH.Type)(0) EQ 'X' THEN BEGIN

      IF (sh.multi)(0) EQ 0 THEN BEGIN
         Widget_Control, SH.drawid, /REALIZE
         Widget_Control, SH.drawid, GET_VALUE=winid
         Return, winid
      ENDIF ELSE BEGIN
         winidarray = LonArr((sh.multi)(0))
         FOR i=0, (sh.multi)(0)-1 DO BEGIN
            Widget_Control, (SH.drawid)(i), /REALIZE
            Widget_Control, (SH.drawid)(i), GET_VALUE=winid
            winidarray(i) = winid
         ENDFOR
         Return, winidarray
      ENDELSE

   ENDIF ELSE Return, !NONE
            

END
