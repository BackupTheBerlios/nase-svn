;+
; NAME:
;  ProceedLayer_4
;
; AIM:
;  Compute output of Oversampling Neurons in current timestep.
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_4 uebergeben
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_4, Layer
;
; INPUTS:               Layer         : ein durch InitLayer_4 initialisierter Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para2         = InitPara_4(tauf=10.0, vs=1.0, oversampling=10, refperiod=1)
;                       MyLayer    = InitLayer_4(5,5, para2)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, MyLayer.w*MyLayer.h))
;                       InputLayer_4, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_4, MyLayer
;                       Print, 'Output: ', Out2Vector(MyLayer.O)
;
;
;-
;
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 2.7  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 2.6  2000/09/27 15:59:41  saam
;      service commit fixing several doc header violations
;
;      Revision 2.5  1998/11/08 17:27:24  saam
;            the layer-structure is now a handle
;
;      Revision 2.4  1998/08/23 12:36:28  saam
;            new Keyword FADE
;
;      Revision 2.3  1998/06/01 15:10:48  saam
;            spontanous activity with keyword spikenoise implemented
;
;      Revision 2.2  1998/02/11 14:57:36  saam
;            Spike hat nun wieder normale Hoehe
;
;      Revision 2.1  1998/02/05 13:47:34  saam
;            Cool
;
;
;
PRO ProceedLayer_4, _Layer, _EXTRA=e
common common_random, seed

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.R = Layer.R * Layer.para.dr
      Layer.S = Layer.S * Layer.para.ds
   END

   firedLast = WHERE(Layer.AR EQ 1, count); neurons with abs refractory period gone
   IF count NE 0 THEN BEGIN
      Layer.R(firedLast) = Layer.R(firedLast) + Layer.para.vr
      Layer.S(firedLast) = Layer.S(firedLast) + Layer.para.vs
      Layer.AR(firedLast) = 0
   END


   Layer.M = Layer.F*(1.+Layer.L)-Layer.I
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w*Layer.h)
   
   ; do some spike noise by temporarily incresing membrane potential
   spikenoise = WHERE(RandomU(seed, Layer.w*Layer.h) LT Layer.para.sn, c)
   IF c NE 0 THEN Layer.M(spikenoise) = Layer.M(spikenoise)+Layer.Para.th0*1.05
   

   ; absolute refractory period if needed
   refN = WHERE(Layer.AR GT 0, count)
   IF count NE 0 THEN BEGIN
;      Layer.M(refN) = 0
      Layer.AR(refN) = Layer.AR(refN)-1
   END


   result  = WHERE(Layer.M GE (Layer.R + Layer.S + Layer.Para.th0 + 100d*Layer.AR), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN BEGIN
      newOut = [newOut, result]
      Layer.AR(result) = Layer.para.rp ; mark neurons as refractory
   END
   Handle_Value, Layer.O, newOut, /SET
   
   Layer.decr = 1

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
END
