;+
; AIM: delete me, i'm no bug
;-
FUNCTION Test

   a = BytArr(1)
   print, 'In Funktion: '
   help, a
   return, a

END



a = Test()
print, 'nach Funktion: '
help, a

END
