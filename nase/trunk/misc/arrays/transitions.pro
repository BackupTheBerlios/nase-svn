;+
; NAME:
;  Transitions()
;
; VERSION:
;  $Id$
;
; AIM:
;  Generate random sequence of switches between array indices.
;
; PURPOSE:
;  <C>Transitions</C> returns a sequence of array indices
;  that can be used to generate a random series of state switches.
;  The series contains all the desired transitions between those
;  states. This may be needed to create stimulus sequences that switch 
;  between a number of possible stimuli and one wants to be sure that
;  all these stimuli are applied and that at the same time all
;  transitions from one of these stimuli to another one are also
;  contained. Since there may be more than one solution to this
;  problem, <C>Transitions</C> generates one possible random
;  solution. If one needs longer sequences, different of those random
;  transition sequences may be concatenated.
;
; CATEGORY:
;  Array
;  CombinationTheory
;  Input
;  Signals
;
; CALLING SEQUENCE:
;* result = Transitions(array, [,MAXITER=...])
;
; INPUTS:
;  array:: This may take to different forms.<BR>
;           Either, a onedimensional
;          array of integer or longword type that is interpreted as
;          all the array 
;          indices that should be visited by the sequence. The result
;          will contain all possible transitions between those
;          indices, including those that switch from one index to
;          itself.<BR>
;          The second possibility is to pass a twodimensional array of
;          byte type, its nonzero entries meaning that a transition
;          between the row index of the entry and its column index is
;          desired. In this way, certain transitions can be excluded
;          conveniently.
;
; INPUT KEYWORDS:
;  MAXITER:: The maximum number of iterations allowed to find a
;            solution. Since finding a sequence of transitions may
;            sometimes take quite some time for long index arrays,
;            setting this keyword prevents the routine from searching
;            too long. If no solution was found, the result returned
;            in <*>!NONE</*>. It may yield faster results if the
;            routine is started anew if it hasn't terminated after
;            a certain number of steps. Setting <*>MAXITER=0</*> disables the
;            stopping function and <C>Transitions</C> will continue to
;            explore the transition space until it finds a
;            solution. Default: <*>MAXITER=10000</*>.
;
; OUTPUTS:
;  result:: Onedimensional array containing a sequence of
;           indices. <*>result[0]=Last(result)</*>, ie the
;           sequence always starts and ends with the same index. The
;           number of elements in <*>result</*> is 
;           <*>n^2+1</*> with <*>n</*> being the number of entries
;           in <*>array</*>, if <*>array</*> was onedimensional, and
;           <*>m+1</*>, 
;           with <*>m</*> being the number of nonzero elements of
;           <*>array</*>, if it was twodimensional.
;
; COMMON BLOCKS:
;  random
;
; PROCEDURE:
;  A kind of sorting a twodimensional array that contains the possible
;  states in the form of
;* [...[state i],[state n]...]
;* [...[state j],[state m]...]
; that tries to arrange them such that 
;* [...[state i],[state j],[state k]...]
;* [...[state j],[state k],[state l]...]
; The routine keeps former possibilities in a stack and returns to
; them if it gets stuck.
;
; EXAMPLE:
;* array=['a','b','c']
;* print, array[Transitions(IndGen(3))]
;*> a b c b a c a
;* print, array[Transitions(IndGen(3))]
;*> a c a b c b a
;* allow=BytArr(3,3)
;* allow[*,0]=1
;* allow[0,*]=1
;* print, array[Transitions(allow)]
;*> a c a b a a
;
; SEE ALSO:
;  <A>FracRandom()</A>
;-


;; This is the old version that was not random enough, but found a
;; solution much faster:
;FUNCTION Transitions, array

;   COMMON random, seed

;   length = N_Elements(array)
;   final = length-1

;   ;; basic transition for array with 2 elements
;   t = [0, 1, 0]

;   ;; successively add more transitions
;   FOR next=2, final DO BEGIN
;      ;; next contains new state 
;      FOR i=0, next-1 DO BEGIN
;         ;; find first place where new state would fit
;;         idx = (Where(t EQ i))[0]
;         ;; find all places where new state would fit and choose one randomly
;         allidx = Where(t EQ i, count)
;         idx = allidx[count*RandomU(seed)]
;         ;; add new state
;         t = [t[0:idx], next, t[idx:*]]
;      ENDFOR
;   ENDFOR 
   
;   ;; interpret sequence of transitions as array indices 
;   Return, array[t]

;END


FUNCTION Transitions, i, MAXITER = maxiter

   Default, maxiter, 10000l

   si = Size(i)

   ;; decide whether input is possible indices or a transition
   ;; matrix. make diff array that contains all allowed transitions in
   ;; the form [...[state i],[state n]...]
   ;;          [...[state j],[state m]...]
   CASE si[0] OF
      1: BEGIN
         DMsg, 'Index input, all transitions allowed.'
         diff = LonArr(si[1]^2, 2)
         diff[*, 0] = Reform(Rebin(i, si[1], si[1], /SAMP), si[1]^2)
         FOR n = 0, si[1]-1 DO BEGIN
            diff[n*si[1], 1] = Shift(i, n)
         ENDFOR
         cnz = si[1]^2
      END
      2: BEGIN
         DMsg, 'Transition matrix input.'
         strans = Size(i)
         nonzero = Where(i, cnz)
         diff = LonArr(cnz, 2)
         FOR n = 0, cnz-1 DO BEGIN
            diff[n, *] = Subscript(nonzero[n], SIZE=strans)
         ENDFOR
      END
      ELSE: Console, /FATAL, 'Pass either 1- or 2dim arrays.'
   ENDCASE

   ;; Scramble the diff array to generate random solutions
   ra = FracRandom(cnz, cnz)
   diff = Temporary(diff[ra, *])

   ;; Init some state variables
   count = 0 ;; position inside the diff array that is processed
   c = 1 ;; number of possible next diff entries that may be inserted
   niter = 0 ;; overall number of iterations
   stopsearch = 0 ;; flag to mark whether max iterations have been reached
   st = InitStack()

   REPEAT BEGIN

      count = count+1

      ;; if no more diff entries are left to
      ;; be inserted, pop the previous state off the stack
      IF c EQ 0 THEN BEGIN
         REPEAT BEGIN
            p = Pop(st)
            count = count-1
         ENDREP UNTIL (Size(p))[1] GT 1
         next = p[1:*, *]
         c = (Size(next))[1]
         Push, st, next
      ENDIF ELSE BEGIN
         nextidx = Where(diff[count:*, 0] EQ diff[count-1, 1], c)
         next = diff[nextidx+count, *]
         Push, st, next
      ENDELSE ;; c eq 0

      ;; insert a fitting diff entry at the present position
      IF c NE 0 THEN BEGIN
         nextidx = Where((diff[*, 0] EQ next[0, 0]) AND $
                         (diff[*, 1] EQ next[0, 1]))
         add = diff[nextidx, *]
         diff[nextidx, *] = diff[count, *]
         diff[count, *] = add
      ENDIF

      niter = niter+1

      IF (maxiter GT 0) THEN BEGIN
         IF niter GE maxiter THEN BEGIN
            Console, /WARN, 'Failed to find transition sequence.'
            stopsearch = 1
         ENDIF
      ENDIF


   ENDREP UNTIL ((count GE cnz-1) AND (c NE 0)) OR (stopsearch)

   FreeStack, st

   IF stopsearch THEN Return, !NONE ELSE $
    Return, [diff[*, 0], diff[cnz-1, 1]]
   
END
