;+
; NAME:
;  ZhangPrior()
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute the <I>a priori</I> distribution of stimuli. 
;
; PURPOSE:
;  <C>ZhangPrior()</C> has  formerly been a part of the
;  <A>Zhang()</A>-routine. However, as it may be used on its own, it
;  has been outsourced.  
;
; CATEGORY:
;  CombinationTheory
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* result = ZhangPrior(s, SNBINS=...[, PRIORDIST=...])
;
; INPUTS:
;  s:: Stimulus. A floating point array containing the stimulus as a
;      function of time. The stimulus may have multiple dimensions or
;      features, in this case, the first dimension of the array
;      <*>s</*> represents time, the second dimension contains the
;      stimulus features.
;
; INPUT KEYWORDS:
;  snbins:: Integer array specifying the number of bins to be used to
;           discretize the stimulus. The array needs to have as many
;           entries as there are stimulus features.
;  PRIRODIST:: Prior distribution
;
; OUTPUTS:
;  result:: Structure with information on stimulus distribution
;           containing the following tags: :<BR>
;              <*>result.ssize</*>: Size information of the stimulus
;                                   array <*>s</*>. See IDL's <C>Size()</C>
;                                   function for more info.<BR>
;              <*>result.sdim</*>: Number of stimulus dimensions.<BR>
;              <*>result.pr</*>: Prior distribution, i.e. the relative
;                            frequency of stimuli. The dimensions are
;                            corresponding to the setting of
;                            <*>snbins</*>.<BR>
;              <*>result.bv</*>: Data values corresponding to the
;                            histogram bins.<BR>
;              <*>result.ri</*>: List of reverse indices, see
;                            documentation of IDL's
;                            <C>Histogram()</C>. This is helpful to
;                            reconstruct at which times a certain
;                            stimulus occured.<BR>
;              <*>result.th</*>: Total number of prior histogram
;                                   entries. This may be used to
;                                   recompute the number of entries in
;                                   each stimulus histogram bin, to
;                                   check how often each stimulus
;                                   actually occurred.
;
;
; PROCEDURE:
;  Compute multidimensional histogram of the stimulus, then create the
;  structure containing all information.  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>Zhang()</A>, <A>HistMD()</A>.
;-

FUNCTION ZhangPrior, s, SNBINS=snbins, PRIORDIST=priordist $
 , SYMMETRIC=symmetric

   Default, symmetric, 0

   ssize = Size(s)
   sdur = ssize[1]

   IF ssize[0] EQ 1 $
    THEN sdim = 1 $
   ELSE sdim = ssize[2]

   IF sdim GT 1 THEN BEGIN
      IF Keyword_Set(symmetric) THEN BEGIN
         smax = IMax(Abs(s), 1)
         smin = -smax
      ENDIF ELSE BEGIN
         smin = IMin(s, 1)
         smax = IMax(s, 1)
      ENDELSE
   ENDIF ELSE BEGIN
      IF Keyword_Set(symmetric) THEN BEGIN
         smax = Max(Abs(s))
         smin = -smax
      ENDIF ELSE BEGIN
         smin = Min(s, MAX=smax)
      ENDELSE
   ENDELSE 

   IF NOT Set(snbins) THEN Console, /FATAL, 'SNBINS need to be specified.'

   sbinsize = (smax-smin)/(snbins-1)

   shist = HistMD(s, NBINS=snbins $
                  , MIN=smin-0.5*sbinsize, MAX=smax+0.5*sbinsize $
                  , GET_BINVALUES=binvalues $
                  , REVERSE_INDICES=revidx)

   priorstruct={ssize : ssize $
                , sdim : sdim $
                , bv : binvalues $
                , ri : revidx}

   ;; Set empty and therefore zero prior bins to 1 because
   ;; otherwise they cannot be evaluated when taking the logarithm
   ;; of the prior later. Empty bins to not appear in the reverse
   ;; indices.
   peq0 = Where(shist LE 0, count)
   IF count NE 0 THEN BEGIN
      Console, /WARN, Str(count)+' stimulus bins empty.'
      pne0 = DiffSet(LIndgen(N_Elements(shist)), peq0)  
      ;; Offset is 1 entry
      shist[peq0] = 1
   ENDIF 
         
   priorstruct=Create_Struct(priorstruct, 'th', Total(shist))

   IF Set(priordist) THEN BEGIN
      IF Keyword_Set(VERBOSE) THEN $
       Console, /MSG, 'User supplied prior distribution.'
      IF A_NE(Size(shist, /DIM), Size(priordist, /DIM)) THEN $
       Console, /FATAL $
                , 'Dimensions of prior distribution not suitable.'
      priorstruct=Create_Struct(priorstruct $
                                , 'pr', priordist/Total(priordist))
   ENDIF ELSE BEGIN
      priorstruct=Create_Struct(priorstruct $
                                , 'pr', shist/priorstruct.th)
   ENDELSE
   
   UnDef, shist

   Return, priorstruct

END
