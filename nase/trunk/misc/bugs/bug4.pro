PRO Bug4
   Print, 'Bug Nummer 4 handelt von ScrollIts/Sheets,'
   Print, 'die Kinder in einer Widget-Hierarchie sind:'
   Print 
   Print, 'Unter der aktuellen IDL-Version (5.0.2) und KDE' 
   Print, 'ist es nicht m�glich, einer bereits realisierten'
   Print, 'Widget-Hierarchie ein ScrollIt/Sheet hinzuzuf�gen.'
   Print, ''

   Print, 'Weiter?'
   Taste = Get_KBRD(1)

   Print, 'Wir machen uns ein Base-Widget:'
   Print
   Print, '  b=Widget_Base(/ROW)'
            b=Widget_Base(/ROW)
   Print
   Print, 'Noch ist es nicht realisiert, also unsichtbar.'
   Print, 'Wir f�gen ein Sheet hinzu:'
   Print
   Print, '  s1=definesheet(b)'

   Print
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
            s1=definesheet(b)

   Print
   Print, 'Wir realisieren die Widget-Hierarchie:'
   Print, '   Widget_Control, b, /REALIZE'

   Print
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
             Widget_Control, b, /REALIZE

   Print, 'Wir f�gen ein normales Draw-Widget hinzu:'
   Print
   Print, '  d=WIDGET_DRAW(b)'

   Print
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
            d=WIDGET_DRAW(b)

   Print, 'Offenbar kein Problem.'
   Print, 'Nun werden wir ein Sheet hinzuf�gen.'
   Print, 'Dies ist nichts anderes als ein Draw-Widget,'
   Print, 'das eventuell Scrollbalken haben kann.'
   Print, 'Auf Tastendruck wird ausgef�hrt:'
   Print, '  s2=definesheet(b)'

   Print
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
   
   s2 = definesheet(b)

   Print, 'Wenn Du dies hier noch lesen kannst,'
   Print, 'dann tritt der Fehler bei Deiner IDL-Version'
   Print, 'NICHT auf. Gl�ckwunsch!'

END
