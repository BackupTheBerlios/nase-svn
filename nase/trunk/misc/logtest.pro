;+
; NAME: DOG()
;
; PURPOSE: Liefert eine DOG-Maske ('Difference of Gaussians') zurück.
;
; CATEGORY: Simulation, Allgemein
;
; CALLING SEQUENCE: Array = DOG ( XLen, YLen,
;                                { (,OnSigma, OffSigma) | (,ONHWB, OFFHWB) }
;                                [ ,x0 ,y0 ]
;                                [ ,X0_ARR, Y0_ARR] )
; 
; INPUTS: XLen, YLen       : Ausmaße des gewünschten Arrays
;         OnSigma, OffSigma: Stdabweichungen der beiden Gaussmasken, die überlagert werden.
;                            Für OnSigma<OffSigma erhält man On-Center/Off-Surround - DOGs,
;                            für umgekehrt - umgekehrt (was sonst?)
;
; OPTIONAL INPUTS: x0, y0  : Position des Zentrums bzg. der Mitte des Arrays
;
; KEYWORD PARAMETERS: ONHWB, OFFHWB: wie On/OffSigma nur in Halbwertsbreiten
;                     X0_ARR, Y0_ARR: wie x0/y0 nur bezügl. der linken oberen Arrayecke
;
; OUTPUTS: Eine entsprechende DOG-Maske mit ABS(Maximum)=1.0
;
; PROCEDURE: Zwei Gäusse besorgen mit Gauss_2D, auf 1 normieren, subtrahieren, abs(max) aif 1 addieren.
;
; EXAMPLE: XOnCellRecept = DOG(21,21, 2,3)
;
; MODIFICATION HISTORY:
;
;       Fri Sep 12 12:52:50 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		$Log$
;		Revision 1.3  1997/09/12 10:52:34  kupper
;		Hallo!
;		Halli!
;		xxxxxxx
;
;
;       Fri Sep 12 12:50:50 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		$Log$
;		Revision 1.3  1997/09/12 10:52:34  kupper
;		Hallo!
;		Halli!
;		xxxxxxx
;
;		Revision 1.2  1997/09/12 10:50:40  kupper
;		Hallo!
;		Logtest!
;
;
;       Fri Sep 12 12:47:32 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		$Log$
;		Revision 1.3  1997/09/12 10:52:34  kupper
;		Hallo!
;		Halli!
;		xxxxxxx
;
;		Revision 1.2  1997/09/12 10:50:40  kupper
;		Hallo!
;		Logtest!
;
;		Revision 1.1  1997/09/12 10:48:29  kupper
;		Dies ist ein Log-Test
;		fürn Test-Log.
;
;
;       Thu Sep 11 17:17:33 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

