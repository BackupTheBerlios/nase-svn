;+
; NAME:               lrprochebblp2.pro
;
; PURPOSE:            Die Prozedur erhaelt als Input die 
;                     (verzoegerten oder unverzoegerten) praesynaptischen 
;                     Aktionspotentiale (VORSICHT: das passiert
;                     bereits in DelayWeigh!) und aktualisiert alle 
;                     Lernpotentiale, die in der mit <A HREF="#INITRECALL">InitRecall</A>
;                     erzeugten Struktur enthalten sind. Wird kein 
;                     In-Handle uebergeben, so werden die Potentiale 
;                     nur abgeklungen.
;
; CATEGORY:           SIMULATION / PLASTICITY
;
; CALLING SEQUENCE:   lrprochebblp2, LP , DW
;
; INPUTS:             LP: Eine mit InitRecall erzeugte Struktur
;                     DW: die zugehoerige DW-Struktur
;
; SIDE EFFECTS:       LP wird beim Aufruf veraendert
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/01/26 10:40:28  alshaikh
;           +initial version
;           +doesn't work with delays
;           +no fancy header
;
;
;-




PRO lrprochebblp2,win=win,con=con,target_l=target_l

TotalRecall,win,con

END
