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

Function RFScan_Return, RFS

   TestInfo, RFS, "RFScan"

   If RFS.divide ne 0 then begin
      BoostWeight, RFS.RFs, 1.0/float(RFS.divide)
      RFS.divide = 0
      ;;------------------> VIUALIZE?
      If Keyword_Set(RFS.VISUALIZE) then begin
         ;;Draw Estimated RFs
         ShowWeights, RFS.RFs, WIN=RFS.WinRFs, /RECEPTIVE, ZOOM=RFS.VISUALIZE(2), GET_COLORMODE=ColorMode
         RFS.ColorMode = colormode
         WSet, RFS.WinMean      ;Draw Mean RF
         Shade_Surf, MiddleWeights(RFS.RFs, /RECEPTIVE, WRAP=RFS.wrap)        
      EndIf
      ;;--------------------------------
   EndIf

   return, RFS.RFs

End
