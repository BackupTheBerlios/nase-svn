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
;                       mit <A HREF="../simu/connections/#FREEDW">FreeDW</A> freigegeben werden muß!
;
; RESTRICTIONS:ACHTUNG! Der Output  ist eine dynamische
;                       Datenstruktur, die nach Gebrauch vom BENUTZER
;                       mit <A HREF="../simu/connections/#FREEDW">FreeDW</A> freigegeben werden muß!
;
; EXAMPLE: ShowWeights, RFScan_Return( My_RFScan ), /RECEPTIVE
;
; SEE ALSO: <A HREF="#RFSCAN_INIT">RFScan_Init()</A>, <A HREF="#RFSCAN_ZEIGMAL">RFScan_Zeigmal()</A>, <A HREF="#RFSCAN_SCHAUMAL">RFScan_Schaumal</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
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
   EndIf

   return, RFS.RFs

End
