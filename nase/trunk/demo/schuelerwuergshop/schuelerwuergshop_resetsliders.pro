;+
; NAME: schuelerwuergshop_RESETSLIDERS
;
; AIM: Module of <A>schuelerwuergshop</A>  (see also  <A>faceit</A>)
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="#FACEIT">FaceIt</A>.
;          schuelerwuergshop_RESETSLIDERS ist eine Routine, die der Übersichtlichkeit 
;          halber aus <A HREF="#FACEIT">schuelerwuergshop_RESET</A> ausgelagert wurde. Sie ist also zum 
;          Funktionieren einer eigenen Simulation nicht unbedingt erforderlich.
;          Hier werden nach einem Reset die Slider auf ihre aktuellen Werte 
;          gesetzt.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: schuelerwuergshop_RESETSLIDERS, dataptr, displayptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enthält.
;         diplayptr: Ein Zeiger auf die Struktur, die die WidgetIDs der 
;                    graphischen Elemente und andere wichtige graphische
;                    Daten enthält (zB Handles auf NASE-Plotcilloscopes oä).
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; PROCEDURE: Nach der Neuinitialisierung der Parameter in <A HREF="#schuelerwuergshop_RESET">schuelerwuergshop_Reset</A> werden
;            in dieser Routine mit Hilfe des IDL-Befehls Widget_Control
;            die Schieberegler auf die geänderten Parameterwerte gesetzt, um
;            Bildschirmdarstellung und tatsächliche Werte konsistent zu
;            halten. 
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#schuelerwuergshop_RESET">schuelerwuergshop_Reset</A>.
;           Außerdem IDL-Online-Hilfe zu 'Widget_Control'.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/28 12:29:38  alshaikh
;              added AIM
;
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:02:27  kupper
;        Initial revision
;
;-



PRO schuelerwuergshop_RESETSLIDERS, dataptr, displayptr

;   Widget_Control, (*displayptr).w_nparvs, SET_VALUE=(*dataptr).prepara.vs
;   Widget_Control, (*displayptr).w_npartaus, SET_VALUE=(*dataptr).prepara.taus
;   Widget_Control, (*displayptr).w_extinpampl, SET_VALUE=(*dataptr).extinpampl
;   Widget_Control, (*displayptr).w_extinpperiod, SET_VALUE=(*dataptr).extinpperiod
;   Widget_Control, (*displayptr).w_couplampl, SET_VALUE=(*dataptr).couplampl
    
END
