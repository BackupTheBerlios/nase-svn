FOR i=0,1000 DO BEGIN

   norm = RandomU(seed, FIX((1000*RandomU(seed, 1))(0))+1)
;  print, norm, sparse2norm(norm2sparse(norm))

   snorm = norm2sparse(norm)
   

   IF snorm(1,0) NE N_Elements(norm) THEN Message, 'Norm->Sparse: ungleiche Groesse'

   index = WHERE(norm NE 0.0, count)
   IF snorm(0,0) NE count THEN Message,'Norm->Sparse: unterschiedliche Zahl aktiver Elements'
   
   IF count NE 0 THEN BEGIN
      IF TOTAL( index NE snorm(0,1:snorm(0,0)) ) THEN Message, 'Norm->Sparse: unterschiedlich aktive Neurone'
      IF TOTAL( norm(index) NE snorm(1,1:snorm(0,0)) ) THEN Message, 'Norm->Sparse: unterschiedliche Aktivit"at'
   END
   
   nsnorm = sparse2norm(snorm)
   IF TOTAL(norm NE nsnorm) NE 0 THEN Message, 'Fehler in der Belegung'
   IF TOTAL(SIZE(norm) NE SIZE(nsnorm)) NE 0 THEN Message, 'Fehler in Groesse'

END

print, 'everything ok!'

END
