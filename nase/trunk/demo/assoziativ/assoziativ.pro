;+
; NAME:                  assoziativ.pro 
;
;
; PURPOSE:               Im Programm ist ein einfacher Assoziativspeicher implementiert.
;                        Fest vorgegeben sind 3 gelernte Muster. 
;                        Man kann nun 7 unterschiedliche Muster praesentieren, und die
;                        verschiedenen Reaktionen des Assoziativspeichers beobachten :
;                        *Erkennung eines vollstaendig praesentierten gelernten Musters
;                        *Rekonstruktion eines gelernten Musters aus einem unvollstaendig vorgegebenen
;                        *Musterwettstreit zwischen 2 gelernten Mustern
;              
;                        Man kann alle wesentlichen Parameter der Neuronen, sowie der Verbindungen
;                        (Feeding- und Linking-Staerke) interaktiv variieren.
;                        Das Programm benutzt das Paket 'Faceit'!
;
;
; CATEGORY: MISCELLANEOUS
;
;
; CALLING SEQUENCE: .run assoziativ bzw. faceit,"asso
;
;
; 

; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:37:45  alshaikh
;           initial version
;
;
;-

faceit,"asso"
END