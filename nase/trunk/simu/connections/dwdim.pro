;+
; NAME:
;  DWDim()
;
; AIM: Determine dimensions of target- and sourcelayer of given DW structure.
;
; PURPOSE:            Ermittelt die Dimension der Target- und Source-Cluster
;                     einer DW-Struktur. Ein direkter Zugriff auf die Tags der
;                     DW-Struktur ist bloed, da
;                       1) Handles verbogen werden muessen und dabei
;                            leicht Fehler auftreten
;                       2) Die Implementation der Datenstruktur nicht
;                            angepasst werden kann, ohne dass diverse
;                            andere Routinen gleich mitveraendert werden
;                            muessen.
;
; CATEGORY: Simulation / Connections
;
; CALLING SEQUENCE:   dim = DWDim( DW {,/SW | ,/SH | ,/TW | ,/TH}+ )
;
; INPUTS:             DW: eine mit InitDW initialisierte DW-Struktur
;
; KEYWORD PARAMETERS: SW/SH/TW/TH : Gibt an, welche Layerdimensionen
;                                   in dim zurueckgegeben werden sollen.
;                                   Die Keywords koennen kombiniert werden,
;                                   es wird dann ein Array zurueckgegeben.
;                                   ACHTUNG: Die Reihenfolge der Keywords
;                                   spielt keine Rolle!!
;
; OUTPUTS:            dim: ein Array mit den gewueschten Layerdimensionen,
;                          die Reihenfolge lautet:
;                          [source_width, source_height, target_width, target_height]
;
; EXAMPLE:            print, DWDim(DW, /SH)
;                     print, DWDim(DW, /SH, /SW, /TW, /TH)
;                     % ist identisch mit
;                     print, DWDim(DW, /TH, /TW, /SH, /SW)
;
; SEE ALSO:           <A HREF="#INITDW">InitDw</A>,<A HREF="#WEIGHTS">Weights</A>,<A HREF="#DELAYS">Delays</A> 
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/09/25 16:49:13  thiel
;         AIMS added.
;
;     Revision 2.2  1998/01/05 16:55:42  saam
;           verbessertes Fehlerhandling; benutzt nun info
;
;     Revision 2.1  1998/01/05 14:39:57  saam
;           ein Stern erblickt das Licht der Welt
;
;

FUNCTION DWDim, _DW, SW=sw, SH=sh, TW=tw, TH=th, ALL=all

   On_Error, 2

   IF N_Params() NE 1 THEN Message, 'incorrect number of arguments'
   IF Keyword_Set(ALL) THEN BEGIN
      sw = 1
      sh = 1
      tw = 1
      th = 1
   END
   IF NOT (Keyword_Set(SW) OR Keyword_Set(SH) OR Keyword_Set(TW) OR Keyword_Set(TH)) THEN Message, 'at least one keyword expected'
   IF Set(_DW) THEN BEGIN
      infoTag = Info(_DW) ;check if _DW is valid nase-structure
      IF NOT Contains(infoTag, 'weight', /IGNORECASE) THEN Message,'no DW-Structure but a '+infoTag+' passed!'
   END ELSE Message, 'argument undefined'

   Handle_Value, _DW, DW, /NO_COPY

   IF Keyword_Set(SW) THEN dim = DW.source_w
   IF Keyword_Set(SH) THEN IF NOT Set(dim) THEN dim = DW.source_h ELSE dim = [dim, DW.source_h]
   IF Keyword_Set(TW) THEN IF NOT Set(dim) THEN dim = DW.target_w ELSE dim = [dim, DW.target_w]
   IF Keyword_Set(TH) THEN IF NOT Set(dim) THEN dim = DW.target_h ELSE dim = [dim, DW.target_h]
   
   Handle_Value, _DW, DW, /NO_COPY, /SET
   RETURN, dim

END
