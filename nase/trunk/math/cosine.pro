;+
; NAME:
;  Cosine()
;
; VERSION:
;  $Id$
;
; AIM:
;  Generates a cosine waveform with a specified frequency, phase, sample rate and length.
;
; PURPOSE:
;  This function returns a one-dimensional cosine waveform whose <*>frequency</*>, <*>phase</*>, sample rate
;  <*>fSample</*> and <*>length</*> are specified as positional arguments. There is nothing exceptional about this
;  routine; it just serves the purpose to avoid the annoying juggling with sample rates, data points, <*>FIndGen</*>
;  and 2*!pi.
;
; CATEGORY:
;  Algebra
;  Math
;  Signals
;
; CALLING SEQUENCE:
;  out = Cosine(frequency, phase, fsample, length [, /RADIANTS | /DEGREES] [, SAMPLES/ | /SECONDS])
;
; INPUTS:
;  frequency:: A float, integer or complex scalar giving the frequency of the cosine waveform (in Hz).
;  phase::     A float, integer or complex variable giving the phase of the cosine waveform. If <*>phase</*> is a scalar,
;              a constant phase is assumed for the whole length of the waveform. <*>Phase</*> may also be an array of
;              the same length as the desired result, providing a separate phase value for each of the sample points
;              (phase modulation). By default, <*>phase</*> is assumed to be given in radiants (setting the keyword
;              <*>RADIANTS</*> has the same effect). If you want <*>phase</*> to be interpreted as degrees, you have
;              to set the keyword <*>DEGREES</*>.
;  fSample::   A float, integer or complex scalar giving the sample rate (in Hz).
;  length::    A float, integer or complex scalar giving the desired length of the waveform. By default, <*>length</*>
;              is assumed to be given as the number of samples (setting the keyword <*>SAMPLES</*> has the same effect).
;              If you want <*>length</*> to be interpreted as seconds, you have to set the keyword <*>SECONDS</*>.
;
; INPUT KEYWORDS:
;  RADIANTS:: Set this keyword if you want <*>phase</*> to be interpreted as radiants (this is the default).
;  DEGREES::  Set this keyword if you want <*>phase</*> to be interpreted as degrees; setting this keyword overrides the
;             <*>RADIANTS</*> keyword.
;  SAMPLES::  Set this keyword if you want <*>length</*> to be interpreted as the number of sample points (this is the
;             default).
;  SECONDS::  Set this keyword if you want <*>length</*> to be interpreted as the number of seconds; setting this keyword
;             overrides the <*>SAMPLES</*> keyword.
;
; OUTPUTS:
;  out:: The result is a one-dimensional float array containing the specified cosine waveform.
;
; RESTRICTIONS:
;  All positional arguments have to be interpretable as float values (i.e., of integer, float, complex or possibly
;  string type). If they are not, the routine will not work correctly.<BR>
;  If <*>frequency</*>, <*>fSample</*> or <*>length</*> are arrays containing more than one element, only the first entry
;  is used.<BR>
;  If <*>phase</*> is neither a scalar nor an array of the same length as the desired output, this causes a fatal console
;  message.
;
; EXAMPLE:
;  Generate and display a 3.4-Hz sine waveform of length 1.2 s with a sample rate of 500 Hz:
;
;* Sinewave = Cosine(3.4, -90, 500, 1.2, /DEG, /SEC)
;* Plot, FIndGen(500*1.2)/500, Sinewave
;
;-


FUNCTION  Cosine,   Frequency, Phase, fSample, Length,  $
                    radiants = radiants, degrees = degrees, samples = samples, seconds = seconds


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  N_Params() LT 4  THEN  Console, '  Wrong number of arguments.', /fatal
   NPhase = N_Elements(Phase)

   f  = Float(frequency(0))
   fS = Float(fSample(0))
   IF  Keyword_Set(seconds)  THEN  N   = Round(Float(Length(0)) * fS)  $
                             ELSE  N   = Round(Float(Length(0)))
   IF  (NPhase NE 1) AND (NPhase NE N)  THEN  Console, '  Phase argument contains wrong number of elements.', /fatal
   IF  Keyword_Set(degrees)  THEN  phi = Float(Phase) * !DtoR  $
                             ELSE  phi = Float(Phase)

   Return, cos(2*!pi * f*FIndGen(N)/fS + phi)


END
