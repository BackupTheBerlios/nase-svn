print
print, "Vorsicht mit ALLEN VARIABLEN, die in Strukturen eingebunden sind!"
print
print, "s.a wird mit einem Byte belegt:"
s = {a: 23b}

print, "s.a =", s.a
print, "Jetzt bekommt s.a den Float 257.89 zugewiesen. Dadurch wird es KEIN Float, sondern bleibt ein Byte!"

s.a = 257.89

print, "s.a =", s.a


print, "Das passiert ohne jede Fehlermeldung."

print, "                          Rüdiger."
end


