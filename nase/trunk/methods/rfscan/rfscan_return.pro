;+
; NAME:
;  RFScan_Return()
;
; VERSION:
;  $Id$
;
; AIM:
;  Get the (simplified) RF-Cinematogramm of simulated neurons.
;
; PURPOSE:
;  Liefert das Ergebnis eines RF-Scans zurück
;          (siehe <A>RFScan_Init</A>).
;
; CATEGORY:
;  NASE
;  Statistics
;  Signals
;  Simulation
;
; CALLING SEQUENCE:
;*Scanned_RFs = RFScan_Return(My_RFScan)
;
; INPUTS:
;  My_RFScan:: Eine mit <A HREF="#RFSCAN_INIT">RFScan_Init()</A> initialisierte
;              RFScan-Struktur.
;  
; OUTPUTS:
;  Scanned_RFs:: Eine DW-Struktur, die die geschätzten RFs
;                enthält.<BR>
;                <B>ACHTUNG! Dies ist eine dynamische
;                Datenstruktur, die nach Gebrauch vom BENUTZER
;                mit <A>FreeDW</A>
;                freigegeben werden muß!</B><BR>
;                Die Gewichte sind auf die Anzahl der
;                beobachteten Outputs normiert. (D.h. im Falle
;                von <*>/OBSERVE_SPIKES</*> liegen alle Gewichte
;                zwischen Null und Eins.)
;  
;
; RESTRICTIONS:
;  <B>ACHTUNG! Der Output  ist eine dynamische
;     Datenstruktur, die nach Gebrauch vom BENUTZER
;     mit <A HREF="../simu/connections/#FREEDW">FreeDW</A>
;     freigegeben werden muß!</B><BR>
;
;     Mit dem Aufruf von RFScan_Return() ist der
;     Scanvorgang abgeschlossen! Ein weiterer Aufruf 
;     von RFScan_Schaumal führt zwar zu keinem
;     Fehler, liefert aber ungültige Ergebnisse!
;
; EXAMPLE:
;*ShowWeights, RFScan_Return( My_RFScan ), /RECEPTIVE
;
; SEE ALSO: <A>RFScan_Init</A>, <A>RFScan_Zeigmal</A>, <A>RFScan_Schaumal</A>
;-


Function RFScan_Return, RFS, FILENAME=filename

   TestInfo, RFS, "RFScan"


   If RFS.divide ne 0 then begin

      BoostWeight, RFS.RFs, 1.0/float(RFS.divide)
      If Keyword_Set(FILENAME) then begin
         console, /msg , "Saving Estimated RFs in File '"+filename+".save'..."
         console, /msg , "     Restore using 'Restore' and 'RestoreDW()'!"
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
