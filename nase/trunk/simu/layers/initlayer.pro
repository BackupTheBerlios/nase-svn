;+
; NAME:
;  InitLayer()
;
; VERSION:
;  $Id$
;
; AIM:
;  Initialize neuron layer of arbitrary type.
;
; PURPOSE:
;  Initialize a neuron layer of arbitrary type "i". The desired type
;  is determined by the parameter structure obtained from the
;  corresponding <A NREF=INITPARA_1>InitPara_i</A>-function.<BR>
;  <C>InitLayer</C> is just a wrapper function calling the appropriate
;  <A NREF=INITLAYER_1>InitLayer_i</A>-function automatically.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;  Structures
;
; CALLING SEQUENCE:
;* layer = InitLayer( WIDTH=..., HEIGHT=..., TYPE=... )
;
; INPUTS:
;  WIDTH, HEIGHT:: Number of neurons in the rows and columns of the
;                  neuron layer.
;  TYPE:: Structure containing neuron specific parameters, must be
;         previously defined by <A NREF=INITPARA_1>InitPara_i</A>.
;
; OUTPUTS:
;  layer:: Structure containing layer information. Tags inside the
;          structure may differ depending on the neuron type, but
;          normally look something like
;*          layer = { info   : 'LAYER'
;*                    type   : 'i'    
;*                    w      : width
;*                    h      : height
;*                    para   : type
;*                    F      : DblArr(width*height) 
;*                    L      : DblArr(width*height) 
;*                    I      : DblArr(width*height)
;*                    O      : handle}
;
; PROCEDURE:
;  <C>InitLayer</C> uses the type string contained in the parameter
;  structure the determine the desired neuron type. Then it calls the
;  specific <C>InitLayer_i</C>-function using <C>CALL_FUNCTION</C>. 
;
; EXAMPLE:
;* para1 = InitPara_1(tauf=10.0, vs=1.0)
;* mylayer = InitLayer(WIDTH=5, HEIGHT=5, TYPE=para1)
;
; SEE ALSO:
;  <A>InputLayer</A>, <A>ProceedLayer</A>, <A NREF=INITLAYER_1>InitLayer_i</A>,
;  <A NREF=INITPARA_1>InitPara_i</A>.
; 
;-
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.5  2001/02/22 14:40:44  thiel
;       Translated header.
;
;       Revision 2.4  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 2.3  1998/11/06 14:28:38  thiel
;              Hyperlinks.
;
;       Revision 2.2  1998/11/06 14:14:30  thiel
;              Hyperlink-Fehler
;
;       Revision 2.1  1998/11/04 16:32:54  thiel
;              Rahmen fuer InitLayer_i-Funktionen.
;

FUNCTION InitLayer, WIDTH=width, HEIGHT=height, TYPE=type

	Layer = Call_Function('InitLayer_'+type.type $
                              , WIDTH=width, HEIGHT=height, TYPE=type)

	RETURN, Layer

END 
