;+
; NAME: TestInfo
;
; PURPOSE: Testet den Info-Tag einer Struktur auf einen bestimmten
;          Inhalt. (D.h. es kann schnell getestet werden, ob einer
;          Prozedur die "richtige" Art von Struktur übergeben wurde.)
;
; CATEGORY: Simulation, Miscellaneous
;
; CALLING SEQUENCE: TestInfo, Structure, Name
;
; INPUTS: Structure: Die betreffende Struktur
;         Name     : Ein String (Gross/Kleinschreibung egal), der den
;                    Namen enthält, auf den getestet werden soll.
;
; OUTPUTS: Enthält der info-Tag der übergebenen Struktur den
;          entsprechenden Namen, so kehrt TestInfo ohne weitere
;          Reaktion zurück zur AUfrufenden Prozedur.
;          Besitzt die übergebene Struktur keinen info-Tag, oder
;          enthält dieser nicht den gewünschten Namen, so wird eine
;          Message ausgegeben, TestInfo kehrt zurück zur
;          aufrufenden Prozedur und an dieser Stelle bricht die
;          Programmausführung ab.
;
; SIDE EFFECTS: Bei Nichtübereinstimmung bricht die Programmausführung 
;               in der aufrufenden Prozedur ab.
;
; PROCEDURE: TestInfo benutzt <A HREF="array/#CONTAINS">Contains</A>
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
; SEE ALSO: <A HREF="array/#CONTAINS">Contains</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  1998/01/28 13:51:05  kupper
;               Nur Hyperlink korrigiert.
;
;        Revision 2.1  1998/01/28 13:44:08  kupper
;               Mal schnell geschrieben, um nicht immer wieder den typischen
;        	"If-Contains-Message"-Teil am Prozeduranfang tippen zu müssen...
;
;-

Pro TestInfo, Struct, String

   ON_ERROR, 2

   If not ExtraSet(Struct, "info") then message, "This Structure does not contain an 'info'-Tag!"

   If not Contains(Struct.info, String, /IGNORECASE) then message, "This is not a '"+String+"'-Structure!"

   ON_ERROR, 0
End
