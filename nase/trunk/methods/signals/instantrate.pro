;+
; NAME: InstantRate
;
; PURPOSE: Berechnung der momentanen Feuerrate aus einem Spiketrain. Dazu wird
;          ein Rechteckfenster einer vorgegebenen Breite über den Spiketrain 
;          geschoben. Die Zahl der im Fenster enthaltenen Spikes geteilt durch
;          die Fensterbreite liefert dann die Feuerrate an der Position des 
;          Fensters.
;
; CATEGORY: METHODS / SIGNALS
;
; CALLING SEQUENCE: rate = Instantrate( spikes 
;                                      [,SAMPLEPERIOD=sampleperiod]  
;                                      [,SSIZE=ssize] [,SSHIFT=sshift]
;                                      [,TVALUES=tvalues] [,AVARAGED=avaraged])
;
;
; INPUTS: spikes: Ein zweidimensionales Array, erster Index: Neuronen- oder
;                 Trialnummer. zweiter Index: Zeit
;
; OPTIONAL INPUTS: sampleperiod: Länge eines Bins in Sekunden, Default: 0.001s
;                  ssize: Breite des Fensters, das zur Ermittlung der Feuerrate
;                         benutzt wird. Default: 128 BIN
;                  sshift: Versatz der Positionen, an denen die Feuerrate 
;                          ermittelt werden soll. Default: ssize/2
;                  Alle diese Parameter wurden von der Routine <A HREF="../#SLICES">Slices</A> übernommen.
;
; OUTPUTS: rate: Ein zweidimensionales Array, das die ermittelten Feuerraten
;                zu den gewünschten Zeitpunkten enthält. 1.Index: Neuronen- 
;                oder Trialnummer. 2.Index: Zeit. Je nach gewähltem sshift
;                ist das Resultat entsprechend kürzer als das Original.
;
; OPTIONAL OUTPUTS: tvalues: Ein Array, das die Anfangspositionen der zum 
;                            Mitteln verwendeten Fenster enthält.
;                            (Siehe auch <A HREF="../#SLICES">Slices</A>.)
;                   avaraged: Ein Array, das die über alle Neuronen/Trials
;                             gemittelte instantane Feurrate enthält.
;
; PROCEDURE: Durch Verwendung der Routine Slices ist das alles ganz einfach.
;            Man summiert mit Total über die Scheiben, und falls gewünscht
;            gibt man noch den Mittelwert zurück.
;
; EXAMPLE: a=fltarr(10,1000)
;          a(*,0:499)=Randomu(s,10,500) le 0.01    ; 10 Hz 
;          a(*,500:999)=Randomu(s,10,500) le 0.05  ; 50 Hz
;          r=instantrate(a, ssize=100, sshift=10, tvalues=axis, avaraged=av)
;          !p.multi=[0,1,3,0,0] 
;          trainspotting, a 
;          plot, axis+50, r(0,*) ; axis enthält die Startzeiten der Fenster.
;                                  Interpretiert man die ermittelten Werte als
;                                  die Feuerraten zum Zeitpunkt in der Mitte
;                                  des Fensters, dann korrigiert axis+ssize/2
;                                  die Darstellung. 
;          plot, axis+50, av
;
; SEE ALSO: <A HREF="../#SLICES">Slices</A>, <A HREF="../#ISI">ISI</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/12/06 15:37:12  thiel
;            Neu.
;
;-

FUNCTION InstantRate, nt, SAMPLEPERIOD=sampleperiod, $
                      SSIZE=ssize, SSHIFT=sshift, $
                      TVALUES=tvalues, TINDICES=tindices, $
                      AVARAGED=avaraged


   Default, sampleperiod, 0.001
   Default, ssize, 128*1000.*sampleperiod
   Default, sshift, ssize/2

   sli = Slices(nt, SSIZE=ssize, SSHIFT=sshift, TVALUES=tvalues, $
                TINDICES=tindices)

   result = Transpose(Float(Total(sli,3))/ssize/sampleperiod)

   avaraged = Total(result,1)/(Size(result))(1)

   Return, result


END
