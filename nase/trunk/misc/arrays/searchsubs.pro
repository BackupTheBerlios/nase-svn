;+
; NAME:
;  SearchSubs
;
; VERSION:
;  $Id$
;
; AIM:
;  search an onedimensional array for specified subarray
;
; PURPOSE:
;  Look, if a subarray can be found in an onedimensional array and return the position(s).
;  To make the routine run faster, one can decide to skip the search, if the subarray is found for the first time, immediately.
;  In a special but very common case, the subarray to be found can consist of N equal elements (e.g. amplifier hangs at upper
;  threshold,...). Now, one can choose a keyword to avoid returning every posibble position in a large block of equal values, that
;  are equal to the subarray.
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;  out = SearchSubs(array, subarray [,/only_first] [,/all_positions])
;
;
; INPUTS:
;  array:: array in which subarray shall be found
;  subarray:: the array to be found
;
; INPUT KEYWORDS:
;  only_first:: skip the search at the first appearance of subarray in array
;  all_positions:: find every possible position, don't skip positions within positions
;
; OUTPUTS:
;  outputs the routine requires to pass to the caller,
;  including the function result (here: out0, out1). They
;  are noted by lower case.
;  out0:: array of positions where subarray is found in array, -1 if subarray is not found
;
; SIDE EFFECTS:
; Take as example: array=[1,2,3,4,4,4,4,4,3,1,2,1,4,4,4,4,4,4]
;                   subarray=[4,4]
; Then...
;  searchsubs(array, subarray) = [3,12]
;  searchsubs(array, subarray, /only_first) = [3]
;  searchsubs(array, subarray, /all_positions) = [3,4,5,6,12,13,14,15,16]
;
;  The keywords have to be set, when you really are interested in every position!!!
;
;
; RESTRICTIONS:
;  Does your routine check passed arguments? Can it
;  handle all data types? If not, mention this here
;  (or better write your routine, that you can skip
;  this :) )
;
; PROCEDURE:
;  How does the routine achieve its goal? Is it
;  straightforward? Is it brute force? You can
;  also mention references for more information
;  on the implementation here.
;
; EXAMPLE:
;  array=[1,2,3,4,4,4,4,4,3,1,2,1,4,4,4,4,4,4]
;  subarray=[4,4]
;
;  searchsubs(array, subarray) = [3,12]
;  searchsubs(array, subarray, /only_first) = [3]
;  searchsubs(array, subarray, /all_positions) = [3,4,5,6,12,13,14,15,16]
;
;  array=[1,2,3,4,4,4,4,4,3,1,2,1,4,4,4,4,4,4]
;  subarray=[0,1]
;
;  searchsubs(array, subarray) = -1
;
;-
FUNCTION searchsubs, array, subarray, only_first=only_first, all_positions=all_positions

     n_sub = n_elements(subarray)

     positions = -1
     potpos   = WHERE(array(0:n_elements(array)-n_sub) EQ subarray(0))

     ;; das erste Element aus subarray kommt nicht vor -> kein Treffer
     IF potpos(0) EQ -1 THEN BEGIN
       RETURN, -1
     ENDIF ELSE BEGIN

       ;; Evtl. folgt ein Check, ob der Subarray aus gleichen Elementen besteht.
       ;; Ab ca. 10 Elementen lohnt es, die moeglichen Treffer einzuschraenken.
       IF not(keyword_set(all_positions)) THEN BEGIN
         sub_is_equal = (where(subarray-shift(subarray,1)))(0)   ; -1 means the subarray is equal !!!
         IF (sub_is_equal EQ -1) AND (n_elements(potpos) GT 2) THEN $
           IF (where((potpos-shift(potpos,1)) EQ 1))(0) NE -1 THEN BEGIN
             potpos(where((potpos-shift(potpos,1)) EQ 1)) = 0
             potpos = potpos(where(potpos)>0)
         ENDIF
       ENDIF

       ;; untersuche alle moeglichen Trefferstellen, die beiden Fälle only_first / nicht only_first sind
       ;; aus Geschwindigkeitsgründen etwas umständlich getrennt worden.
       IF keyword_set(only_first) THEN $
         FOR potposnr = 0,n_elements(potpos)-1 DO BEGIN
           feldpos    = potpos(potposnr)
           ausschnitt = array(feldpos:feldpos+n_sub-1)
           treffer    = (where(ausschnitt-subarray))(0) EQ -1
           IF treffer THEN return, feldpos
         ENDFOR $
       ELSE $
         FOR potposnr = 0,n_elements(potpos)-1 DO BEGIN
           feldpos    = potpos(potposnr)
           ausschnitt = array(feldpos:feldpos+n_sub-1)
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
