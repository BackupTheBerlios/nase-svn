print
print, "Vorsicht mit Arrays, die in Strukturen eingebunden sind!"
print
print, "s.a wird mit indgen(3,4) belegt:"
s = {a: indgen(3,4)}

print, s.a
print, "Jetzt bekommt s.a ein 2x2-Array mit Nullen zugewiesen. Dadurch wird es KEIN 2x2-Array, sondern behält sein Format!"

s.a = intarr(2,2)

print, s.a
print, "Das alles passiert ohne jede Fehlermeldung. Gemosert wird nur, falls das zugewiesene Array zu groß ist..."

print
print, "So. nochmal: s.a=indgen(3,4)"
s.a = indgen(3, 4)
print, s.a
print, "und jetzt ein Zuckerstückchen: s.a = TRANSPOSE(s.a):"
s.a =  TRANSPOSE(s.a)
print, s.a
print, "Sieht witzig aus, was? Tja, da machen wirs doch einfach rückgängig: Nochmal: s.a = TRANSPOSE(s.a):"
s.a =  TRANSPOSE(s.a)
print, s.a
print, "---UPS !!"
print, "                               Rüdiger."
end
