;+
; NAME:                  assoziativ.pro 
;
; AIM:  Associative Memory Demonstration  in <A>faceit</A>-Style
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
;- 
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.4  2000/09/28 11:49:40  alshaikh
;           AIM bugfixes
;
;     Revision 1.3  2000/09/27 12:16:06  alshaikh
;           changed aim
;
;     Revision 1.2  2000/09/27 12:14:08  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:45  alshaikh
;           initial version
;
;
;

faceit,"asso"
END
