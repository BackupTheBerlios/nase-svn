;+
; NAME: TestInfo
;
; PURPOSE: Testet den Info-Tag einer Struktur auf einen bestimmten
;          Inhalt. (D.h. es kann schnell getestet werden, ob einer
;          Prozedur die "richtige" Art von Struktur �bergeben wurde.)
;
; CATEGORY: Simulation, Miscellaneous
;
; CALLING SEQUENCE: TestInfo, Structure, Name
;
; INPUTS: Structure: Die betreffende Struktur
;         Name     : Ein String (Gross/Kleinschreibung egal), der den
;                    Namen enth�lt, auf den getestet werden soll.
;
; OUTPUTS: Enth�lt der info-Tag der �bergebenen Struktur den
;          entsprechenden Namen, so kehrt TestInfo ohne weitere
;          Reaktion zur�ck zur AUfrufenden Prozedur.
;          Besitzt die �bergebene Struktur keinen info-Tag, oder
;          enth�lt dieser nicht den gew�nschten Namen, so wird eine
;          Message ausgegeben, TestInfo kehrt zur�ck zur
;          aufrufenden Prozedur und an dieser Stelle bricht die
;          Programmausf�hrung ab.
;
; SIDE EFFECTS: Bei Nicht�bereinstimmung bricht die Programmausf�hrung 
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
;          -> Ist Layerstruct tats�chlich eine Layer-Struktur, so
;          passiert nichts, ist es nicht, so wird die Message
;          "%TESTINFO: This is not a 'Layer'-Structure" ausgegeben und 
;          die Programmausf�hrung in My_LayerProc abgebrochen.
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
;        	"If-Contains-Message"-Teil am Prozeduranfang tippen zu m�ssen...
;
;-

Pro TestInfo, Struct, String

   ON_ERROR, 2

   If not ExtraSet(Struct, "info") then message, "This Structure does not contain an 'info'-Tag!"

   If not Contains(Struct.info, String, /IGNORECASE) then message, "This is not a '"+String+"'-Structure!"

   ON_ERROR, 0
End
