;+
; NAME: GetKey()
;
; PURPOSE: Ersetzt die Get_Kbrd(1)-Funktion (Standard-IDL) mit
;          zusätzlicher Steuercode-Verarbeitung.
;
;          Diese Routine ist ein (hoffentlich adäquater) Ersatz für
;          die GetKey()-Funktion, die offensichtlich im Archiv der
;          importierten NASE-Routinen fehlt.
;
; CATEGORY: Misc
;
; CALLING SEQUENCE: K = GetKey()
;
; OUTPUTS: K: String, bei druckbaren Zeichen eben diese (Länge 1), bei 
;             nichtdruckbaren Zeichen (den meisten, weitere können
;             leicht implementiert werden) eine textuelle
;             Beschreibung.
;             Bisher gibts:
;
;             UP,DOWN,RIGHT,LEFT,INS,DEL,PGUP,PGDOWN,POS1,END,
;             F1,..,F12,BACK,ENTER,TAB,ESC,BEL
;
; PROCEDURE: Vergleich mit der neuen Sytemvariable !KEY.
;
; EXAMPLE: while 1 do print, GetKey()
;
; SEE ALSO: Get_Kbrd() (Standard-IDL)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/02/23 15:17:06  kupper
;               Schöpfung.
;               Die Funktion dieser Routine wurde aus ihren diversen Aufrufen
;               in Routinen des alien-Verzeichnisses rekonstruiert, da sie
;               offenbar im importierten Archiv fehlt.
;               Aber keine Garantie, daß sie mit allen Routinen läuft...
;
;-

Function GetKey

   k = Get_KBRD(1)
   Repeat begin
      g = Get_KBRD(0)
      k = k+g
   EndRep Until (g eq '')

   Case k of
      !KEY.UP     : k = 'UP'
      !KEY.DOWN   : k = 'DOWN'
      !KEY.RIGHT  : k = 'RIGHT'
      !KEY.LEFT   : k = 'LEFT'
      !KEY.INS    : k = 'INS'
      !KEY.DEL    : k = 'DEL'
      !KEY.PGUP   : k = 'PGUP'
      !KEY.PGDOWN : k = 'PGDOWN'
      !KEY.POS1   : k = 'POS1'
      !KEY._END   : k = 'END'
      !KEY.F1     : k = 'F1'
      !KEY.F2     : k = 'F2'
      !KEY.F3     : k = 'F3'
      !KEY.F4     : k = 'F4'
      !KEY.F5     : k = 'F5'
      !KEY.F6     : k = 'F6'
      !KEY.F7     : k = 'F7'
      !KEY.F8     : k = 'F8'
      !KEY.F9     : k = 'F9'
      !KEY.F10    : k = 'F10'
      !KEY.F11    : k = 'F11'
      !KEY.F12    : k = 'F12'
      !KEY.BACK   : k = 'BACK'
      !KEY.ENTER  : k = 'ENTER'
      !KEY.TAB    : k = 'TAB'
      !KEY.ESC    : k = 'ESC'
      !KEY.BEL    : k = 'BEL'
      Else        :
   Endcase

   Return, k

End
