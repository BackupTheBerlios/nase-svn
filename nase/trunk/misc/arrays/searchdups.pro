;+
; NAME: searchdups
;
; AIM: searches an array for subsequences (wrong naming) 
;
; PURPOSE: Such in einem Array (eindimensional) eine beliebige Elementfolge und gibt die Stellen zurueck,
;          an denen diese im Array auftaucht.
;
; CATEGORY: misc/arrays
;
;
; CALLING SEQUENCE: pos = search_subarray(array, subarray)
;
; 
; INPUTS: array : das zu durchsuchende Array
;         subarray : die zu suchende Folge von Elementen
;
;
;
; OUTPUTS: Ein Indexfeld mit den Positionen, an denen subarray in array auftaucht, bzw. -1 falls keine
;          Vorkommen entdeckt wird.
;
;          Achtung : Wenn in einem array a=[2, 4, 1, 1, 1, 1, 1, 3, 6, 1, 9]
;                    das Vorkommen von s=[1,1,1] gesucht wird, so liefert die Funktion
;                    nur eine 2 zurueck und nicht 2,3,4.
;
;                    Wenn man also n gleiche Elemente sucht, und diese m (m>n) mal hintereinander auftauchen,
;                    wird nur die erste Stelle zurueckgeliefert.
;                     
;
;
; SIDE EFFECTS: noch keine bekannt ;-)
;
;
; RESTRICTIONS: Bei der Suche in einem Floatingpoint-Array ist unbedingt die Genauigkeit zu beachten!!!
;               Eventuell wird eine Suchfolge nicht erkannt, weil eine Abweichung in der 6. Nachkomma-
;               stelle auftritt.
;
; PROCEDURE:
;
;
; EXAMPLE: Ist unten angefuegt.
;
;
; MODIFICATION HISTORY:
;
;     Die Grundfunktion stammt von Alex!
;
;     13.11.98 fuer NASE dokumentiert und um Optimierung fuer Suchmasken aus n identischen Elementen
;              erweitert.          Hans Joerg
;
;     $Log$
;     Revision 1.2  2000/09/25 09:12:55  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.1  1998/11/16 13:04:28  brinks
;     *** empty log message ***
;
;
;-

;-------------------------------------------------------------------------------------------------       
;-------------------------------------------------------------------------------------------------           
 

FUNCTION searchdups, array, subarray

     positions = -1    
     potpos   = WHERE(array(0:n_elements(array)-n_elements(subarray)) EQ subarray(0))  
    
     ;; das erste Element aus subarray kommt nicht vor -> kein Treffer   
     IF potpos(0) EQ -1 THEN BEGIN    
       RETURN, -1              
     ENDIF ELSE BEGIN 


       ;; Es folgt ein Check, ob der Subarray aus gleichen Elementen besteht.
       ;; Ab ca. 10 Elementen lohnt es, die moeglichen Treffer einzuschraenken.       
       sub_is_equal = 1
       FOR i=0,n_elements(subarray)-1 DO IF subarray(i) NE subarray(0) THEN sub_is_equal = 0

       IF (sub_is_equal EQ 1) AND (n_elements(potpos) GT 2) THEN $
        IF (where(potpos-shift(potpos,1) EQ 1))(0) NE -1 THEN BEGIN  
         potpos(where(potpos-shift(potpos,1) EQ 1)) = 0
         potpos = potpos(where(potpos))
       ENDIF
       ;; Evtl. Optimierung beendet.


       
       ;; untersuche alle moeglichen Trefferstellen
       FOR potposnr = 0,n_elements(potpos)-1 DO BEGIN    
         feldpos    = potpos(potposnr)    
         ausschnitt = array(feldpos:feldpos+n_elements(subarray)-1)    
         treffer    = (where(ausschnitt-subarray))(0) EQ -1    
         IF treffer THEN positions = [positions,feldpos]
       ENDFOR    
     IF n_elements(positions) GT 1 THEN positions = positions(1:*) ;; die -1 wegschneiden, falls etwas gefunden wurde
    ENDELSE    
 
   RETURN, positions
END 





;PRO test_search_array
;
;  datafield_length = 5000      ;; Groesse des zu durchsuchenden Arrays
;  sequence_length = 70         ;; Groesse der Suchsequenzen
;  testrun = 1000               ;; Anzahl der Testdurchlaeufe
;
;  datafield = fltarr(datafield_length)
;
;  sequence1 = fltarr(sequence_length)                             ;; Sequenz1 ist eine zufaellige Zahlenfolge
;  FOR i=0,sequence_length-1 DO  sequence1(i) = randomu(seed)*10-5
;
;  sequence2 = fltarr(sequence_length)                             ;; Sequenz2 ist eine konstante Folge
;  FOR i=0,sequence_length-1 DO sequence2(i) = 4.99567 
;
;
;  ;; Im Datenfeld werden die jeweils ersten Werte der beiden Sequenzen gleichmaessig eingebettet
;  ;; als moegliche Positionen, an denen die Suche erfolgreich sein koennte (aber nicht ist ;-)
;  
;  FOR i=0,datafield_length-1 DO datafield(i) = randomu(seed)*10-5.
;
;  FOR i=0,datafield_length/21 DO BEGIN 
;    datafield(i*20) = sequence1(0) 
;    datafield(i*20+5) = sequence2(0)
;  ENDFOR
;
;
;  ;; Jede Sequenz wird dreimal im Datenfeld eingebettet
;
;  datafield(1000:1000+sequence_length-1) = sequence1
;  datafield(2000:2000+sequence_length-1) = sequence1
;  datafield(3000:3000+sequence_length-1) = sequence1
;
;  datafield(500:500+sequence_length-1) = sequence2
;  datafield(1500:1500+sequence_length-1) = sequence2
;  datafield(2500:2500+sequence_length-1) = sequence2
;
;
;  ;; An zwei Stellen wird jede Sequenz versetzt uebereinander geschrieben.
;  ;; Das ist nur fuer den Fall der Sequenz2 interessant.
;
;  FOR i=0,5 DO BEGIN 
;    datafield((4000+(i*sequence_length/2)):(4000+(i*sequence_length/2)+sequence_length-1)) = sequence1
;    datafield((4500+(i*sequence_length/2)):(4500+(i*sequence_length/2)+sequence_length-1)) = sequence2
;  ENDFOR 
;
;
;
;  print,'optimale Sequenz...'
;  print, systime(0)
;   FOR j=1,testrun DO pos = searchdups(datafield,sequence2)
;  print, systime(0)
;  print, pos
;
;  print, 'zufaellige Sequenz'
;  print, systime(0)
;   FOR j=1,testrun DO pos = searchdups(datafield,sequence1)
;  print, systime(0)
;  print, pos
;
;END 
