;+
; NAME: DOG()
;
; PURPOSE: Liefert eine DOG-Maske ('Difference of Gaussians') zur�ck.
;
; CATEGORY: Simulation, Allgemein
;
; CALLING SEQUENCE: Array = DOG ( XLen, YLen,
;                                { (,OnSigma, OffSigma) | (,ONHWB, OFFHWB) }
;                                [ ,x0 ,y0 ]
;                                [ ,X0_ARR, Y0_ARR] )
; 
; INPUTS: XLen, YLen       : Ausma�e des gew�nschten Arrays
;         OnSigma, OffSigma: Stdabweichungen der beiden Gaussmasken, die �berlagert werden.
;                            F�r OnSigma<OffSigma erh�lt man On-Center/Off-Surround - DOGs,
;                            f�r umgekehrt - umgekehrt (was sonst?)
;
; OPTIONAL INPUTS: x0, y0  : Position des Zentrums bzg. der Mitte des Arrays
;
; KEYWORD PARAMETERS: ONHWB, OFFHWB: wie On/OffSigma nur in Halbwertsbreiten
;                     X0_ARR, Y0_ARR: wie x0/y0 nur bez�gl. der linken oberen Arrayecke
;
; OUTPUTS: Eine entsprechende DOG-Maske mit ABS(Maximum)=1.0
;
; PROCEDURE: Zwei G�usse besorgen mit Gauss_2D, auf 1 normieren, subtrahieren, abs(max) aif 1 addieren.
;
; EXAMPLE: XOnCellRecept = DOG(21,21, 2,3)
;
; MODIFICATION HISTORY:
;
;    $Log$
;    Revision 1.6  1997/09/12 11:01:44  kupper
;    Commit1
;
;


