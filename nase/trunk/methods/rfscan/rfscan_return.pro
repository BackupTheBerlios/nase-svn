;+
; NAME: RFScan_Return()
;
; PURPOSE: Liefert das Ergebnis eines RF-Scans zurück.
;          siehe <A HREF="#RFSCAN_INIT">RFScan_Init()</A>
;
; CALLING SEQUENCE: Scanned_RFs = RFScan_Return( My_RFScan )
;
; INPUTS: My_RFScan: Eine mit <A HREF="#RFSCAN_INIT">RFScan_Init()</A> initialisierte
;                    RFScan-Struktur.
;
; OUTPUTS: Scanned_RFs: Eine DW-Struktur, die die geschätzten RFs
;                       enthält. ACHTUNG! Dies ist eine dynamische
;                       Datenstruktur, die nach Gebrauch vom BENUTZER
;                       mit <A
;                       HREF="../simu/connections/#FREEDW">FreeDW</A>
;                       freigegeben werden muß!
;                       Die Gewichte sind auf die Anzahl der
;                       beobachteten Outputs normiert. (D.h. im Falle
;                       von /OBSERVE_SPIKES liegen alle Gewichte
;                       zwischen Null und Eins.)
;
; RESTRICTIONS:ACHTUNG! Der Output  ist eine dynamische
;                       Datenstruktur, die nach Gebrauch vom BENUTZER
;                       mit <A HREF="../simu/connections/#FREEDW">FreeDW</A>
;                       freigegeben werden muß!
;                       
;                       Mit dem Aufruf von RFScan_Return() ist der
;                       Scanvorgang abgeschlossen! Ein weiterer Aufruf 
;                       von RFScan_Schaumal führt zwar zu keinem
;                       Fehler, liefert aber ungültige Ergebnisse!
;
; EXAMPLE: ShowWeights, RFScan_Return( My_RFScan ), /RECEPTIVE
;
; SEE ALSO: <A HREF="#RFSCAN_INIT">RFScan_Init()</A>, <A HREF="#RFSCAN_ZEIGMAL">RFScan_Zeigmal()</A>, <A HREF="#RFSCAN_SCHAUMAL">RFScan_Schaumal</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  1998/03/14 11:26:46  kupper
;               Inputkantentypen -1 und -2 implementiert.
;               Kosmetische Änderung an der Visualisierung (dreheung des Surface Plots).
;
;        Revision 1.5  1998/03/06 11:35:10  kupper
;               Bug korrigiert, der bei IDL-Versionen kleiner 5 auftrat,
;                wenn beim Aufruf kein Fenster geöffnet war.
;
;        Revision 1.4  1998/03/03 14:44:20  kupper
;               RFScan_Schaumal ist jetzt viel schneller, weil es
;                1. direkt auf den Weights-Tag der (Oldstyle)-DW-Struktur zugreift.
;                   Das ist zwar unelegant, aber schnell.
;                2. Beim Spikes-Observieren von den SSParse-Listenm Gebrauch
;                   macht und daher nur für die tatsächlich feuernden Neuronen
;                   Berechnungen durchführt.
;
;        Revision 1.3  1998/02/16 14:59:48  kupper
;               VISUALIZE ist jetzt implementiert. WRAP auch.
;
;        Revision 1.2  1998/01/30 17:02:50  kupper
;               Header geschrieben und kosmetische Veränderungen.
;                 VISULAIZE ist noch immer nicht implementiert.
;
;        Revision 1.1  1998/01/29 14:45:09  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Function RFScan_Return, RFS, FILENAME=filename

   TestInfo, RFS, "RFScan"


   If RFS.divide ne 0 then begin

      BoostWeight, RFS.RFs, 1.0/float(RFS.divide)
      If Keyword_Set(FILENAME) then begin
         Message, /INFORM, "Saving Estimated RFs in File '"+filename+".save'..."
         Message, /INFORM, "     Restore using 'Restore' and 'RestoreDW()'!"
         SaveRF = SaveDW(RFS.RFs)
         Save, SaveRF, FILENAME=filename+".save", /VERBOSE
         BoostWeight, RFS.RFs, float(RFS.divide) ;Soll ja noch weiter benutzt werden...   
      Endif Else begin
         RFS.divide = 0
      End

      ;;------------------> VISUALIZE?
      If Keyword_Set(RFS.VISUALIZE) then begin
         ActWin = !D.Window

         ;;Draw Estimated RFs
         ShowWeights, RFS.RFs, WIN=RFS.WinRFs, /RECEPTIVE, ZOOM=RFS.VISUALIZE(2), GET_COLORMODE=ColorMode
         RFS.ColorMode = colormode
         WSet, RFS.WinMean      ;Draw Mean RF
         ActP = !P
         !P.Multi = 0
         !P.Position = [0, 0, 0, 0]
         Shade_Surf, Rotate(MiddleWeights(RFS.RFs, /RECEPTIVE, WRAP=RFS.wrap), 3), color=RGB('orange', /NOALLOC)      
         !P = ActP

         If ActWin ne -1 then WSet, ActWin
      EndIf
      ;;--------------------------------
   EndIf

   return, RFS.RFs

End
