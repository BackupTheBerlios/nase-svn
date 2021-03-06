;+
; NAME:
;  TestInfo
;
; AIM: Does info tag of a given structure match a teststring? 
;
; PURPOSE: Testet den Info-Tag einer Struktur auf einen bestimmten
;          Inhalt. (D.h. es kann schnell getestet werden, ob einer
;          Prozedur die "richtige" Art von Struktur übergeben wurde.)
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE: TestInfo, Structure, Name
;
; INPUTS: Structure: Die betreffende Struktur
;                     oder ein Handle darauf (wie z.B. bei DW-Strukturen)
;         Name     : Ein String (Gross/Kleinschreibung egal), der den
;                    Namen enthält, auf den getestet werden soll.
;
; OUTPUTS: Enthält der info-Tag der übergebenen Struktur den
;          entsprechenden Namen, so kehrt TestInfo ohne weitere
;          Reaktion zurück zur Aufrufenden Prozedur.
;          Besitzt die übergebene Struktur keinen info-Tag, oder
;          enthält dieser nicht den gewünschten Namen, so wird eine
;          Message ausgegeben, TestInfo kehrt zurück zur
;          aufrufenden Prozedur und an dieser Stelle bricht die
;          Programmausführung ab.
;
; SIDE EFFECTS: Bei Nichtübereinstimmung bricht die Programmausführung 
;               in der aufrufenden Prozedur ab.
;
; PROCEDURE: TestInfo benutzt <A HREF="../misc/array/#CONTAINS">Contains</A>
;            mit der /IGNORECASE-Option zum Testen.
;
; EXAMPLE: Pro My_LayerProc, LayerStruct
;              TestInfo, LayerStruct, "Layer"
;            ...
;          End
;
;          -> Ist Layerstruct tatsächlich eine Layer-Struktur, so
;          passiert nichts, ist es nicht, so wird die Message
;          "%TESTINFO: This is not a 'Layer'-Structure" ausgegeben und 
;          die Programmausführung in My_LayerProc abgebrochen.
;
; SEE ALSO: <A HREF="#INFO">Info</A>, <A HREF="../misc/array/#CONTAINS">Contains</A>
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/25 13:58:57  thiel
;            Added AIMS in header.
;
;        Revision 1.1  1998/01/28 14:25:39  kupper
;               Dieses File wurde aus dem misc-Verzeichnis hierhin verschoben.
;
;        Revision 2.2  1998/01/28 13:51:05  kupper
;               Nur Hyperlink korrigiert.
;
;        Revision 2.1  1998/01/28 13:44:08  kupper
;               Mal schnell geschrieben, um nicht immer wieder den typischen
;        	"If-Contains-Message"-Teil am Prozeduranfang tippen zu müssen...
;


Pro TestInfo, Struct, String

   ON_ERROR, 2

   If not Contains(Info(Struct), String, /IGNORECASE) then message, "This is not a '"+String+"'-Structure!"

   ON_ERROR, 0
End
