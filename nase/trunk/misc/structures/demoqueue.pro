; AIM: demonstrates usage of the <A>SpikeQueue</A> (no header!)
;
;          $Log$
;          Revision 1.3  2000/09/25 09:13:13  saam
;          * added AIM tag
;          * update header for some files
;          * fixed some hyperlinks
;
;          Revision 1.2  1997/09/17 10:25:45  saam
;          Listen&Listen in den Trunk gemerged
;
;          Revision 1.1.2.4  1997/09/12 10:42:38  saam
;          Einrueckungen
;              Einrueckungen
;




w = 200l
h = 100l
p = 0.05


In = BytArr(w*h,100)

Qu = InitSpikeQueue(INIT_DELAYS=FIX(Make_Array(w*h, VALUE=10.0)))





FOR i=0,99 DO BEGIN
   In(FIX((w*h-1)*RandomU(seed, w*h*p-1)), i) = 1
   Out = SpikeQueue(Qu, Norm2SSparse(In(*,i)))
   IF i GT 10 THEN BEGIN
      IF TOTAL(SSparse2Norm(out) NE IN(*,i - 10)) NE 0 THEN Print,'error', i
   END
END


END
