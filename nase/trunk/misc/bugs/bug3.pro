;+
; AIM: demonstrates problems with random numbers 
;-
Pro Zufall, S
   zufallszahl = RandomU(S)
   print, zufallszahl
End

Pro Determinismus
   zufallszahl = RandomU(S)
   print, zufallszahl
End


PRO Bug3
   Print, 'Bug Nummer 3 handelt von Zufallszahlen:'
   Print 
   Print, 'Man sollte beachten, dass Zufallszahlen, die' 
   Print, 'innerhalb von Funktionen oder Prozeduren erzeugt'
   Print, 'werden, nur dann wirklich zufaellig sind, wenn'
   Print, 'man Seed mit an die Funktion/Prozedur uebergibt.'
   Print, 'Hier der Beweis:'
   Print, 'Zunaechst ohne Uebergabe von Seed:'
   Print
   Print, 'Pro Determinismus'
   Print, '   zufallszahl = RandomU(S)'
   Print, '   print, zufallszahl'
   Print, 'End'

   For i = 1,10 Do Begin
       Determinismus
   Endfor
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
   
   Print
   Print, 'Jetzt mit Uebergabe von Seed, das im Hauptprogramm'
   Print, 'nicht definiert sein muss:'
   Print
   Print, 'Pro Zufall, S'
   Print, '   zufallszahl = RandomU(S)'
   Print, '   print, zufallszahl'
   Print, 'End'
   
   For i = 1,10 Do Begin
       Zufall, Seed
   End

   Print
   Print, '...Also VORSICHT!'
END
