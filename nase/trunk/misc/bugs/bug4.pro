PRO Bug4
   Print, 'Bug Nummer 4 handelt von ScrollIts/Sheets,'
   Print, 'die Kinder in einer Widget-Hierarchie sind:'
   Print 
   Print, 'Unter der aktuellen IDL-Version (5.0.2) und KDE' 
   Print, 'ist es nicht möglich, einer bereits realisierten'
   Print, 'Widget-Hierarchie ein ScrollIt/Sheet hinzuzufügen.'
   Print, ''

   Print, 'Weiter?'
   Taste = Get_KBRD(1)

   Print, 'Wir machen uns ein Base-Widget:'
   Print
   Print, '  b=Widget_Base(/ROW)'
            b=Widget_Base(/ROW)
   Print
   Print, 'Noch ist es nicht realisiert, also unsichtbar.'
   Print, 'Wir fügen ein Sheet hinzu:'
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

   Print, 'Wir fügen ein normales Draw-Widget hinzu:'
   Print
   Print, '  d=WIDGET_DRAW(b)'

   Print
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
            d=WIDGET_DRAW(b)

   Print, 'Offenbar kein Problem.'
   Print, 'Nun werden wir ein Sheet hinzufügen.'
   Print, 'Dies ist nichts anderes als ein Draw-Widget,'
   Print, 'das eventuell Scrollbalken haben kann.'
   Print, 'Auf Tastendruck wird ausgeführt:'
   Print, '  s2=definesheet(b)'

   Print
   Print, 'Weiter?'
   Taste = Get_KBRD(1)
   
   s2 = definesheet(b)

   Print, 'Wenn Du dies hier noch lesen kannst,'
   Print, 'dann tritt der Fehler bei Deiner IDL-Version'
   Print, 'NICHT auf. Glückwunsch!'

END
