FOR i=0,1000 DO BEGIN

   norm = FltArr( FIX((1000*RandomU(seed, 1))(0))+1 )
   norm( N_Elements(norm) * RandomU(seed, FIX(0.1*N_Elements(norm))+1)) = 1.0
;  print, norm, sparse2norm(norm2sparse(norm))

   snorm = norm2ssparse(norm)
   

   IF snorm(1) NE N_Elements(norm) THEN Message, 'Norm->SSparse: ungleiche Groesse'

   index = WHERE(norm NE 0.0, count)
   IF snorm(0) NE count THEN Message,'Norm->SSparse: unterschiedliche Zahl aktiver Elements'
   
   IF count NE 0 THEN BEGIN
      IF TOTAL( index NE snorm(2:snorm(0,0)+1) ) THEN Message, 'Norm->Sparse: unterschiedlich aktive Neurone'
   END
   
   nsnorm = ssparse2norm(snorm)
   IF TOTAL(norm NE nsnorm) NE 0 THEN Message, 'Fehler in der Belegung'
   IF TOTAL(SIZE(norm) NE SIZE(nsnorm)) NE 0 THEN Message, 'Fehler in Groesse'

END

print, 'everything ok!'

END
