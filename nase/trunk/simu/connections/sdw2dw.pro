;+
; NAME:
;  SDW2DW()
;
; AIM: Transform a SDW connection struct into a DW connection matrix.
;
; PURPOSE: Transform an SDW[_DELAY]_WEIGHT struct into a
;          DW[_DELAY]_WEIGHT struct (respectively, handles to those).
;          This procedure is intended for INTERNAL ORGANIZATION of
;          connection matrices and should ONLY BE USED IF YOU ARE
;          AWARE OF WHAT YOU'RE DOING! 
;
; CATEGORY:
;  Simulation / Connections (Internal!)
;
; CALLING SEQUENCE:   DW = SDW2DW(SDW [,/KEEP_ARGUMENT])
;
; INPUTS: SDW: a handle to a SDW[_DELAY]_WEIGHT struct, as
;         created by InitDW or by DW2SDW.
;         
; KEYWORD PARAMETERS: KEEP_ARGUMENT: SDW is undefined after the call
;                     by default. If this keyword is set, the original
;                     argument stays defined.
;
; OUTPUTS: DW: a handle to an equivalent DW[_DELAY]_WEIGHT struct.
;
; SIDE EFFECTS: SDW may be changed.
;               learning potentials and queued spikes will not be
;               contained in the resulting DW.
;
; SEE ALSO: <A HREF='#DW2SDW>DW2SDW</A>, <A HREF='#INITDW>InitDW</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.10  2000/09/25 16:49:13  thiel
;         AIMS added.
;
;     Revision 2.9  2000/08/04 09:43:38  thiel
;         Changed position of Handle_Value, _SDW, SDW, /NO_COPY to enable
;         correct work of DWDim.
;
;     Revision 2.8  2000/07/18 16:38:46  kupper
;     Implemented Poggio&Riesenhuber-like MAX conjuction operation.
;
;     Fixed bug in SDW2DW that currupted synaptic depression data.
;
;     Englishified headers (Sorry, InitDW still mostly german, it's just too
;     long...)
;
;     Revision 2.7  1999/11/05 13:09:57  alshaikh
;           1)jede synapse hat jetzt ihr eigenes U_se
;           2)keyword REALSCALE
;
;     Revision 2.6  1999/10/25 08:14:18  alshaikh
;           Fehler korrigiert
;
;     Revision 2.5  1999/10/12 14:36:50  alshaikh
;           neues keyword '/depress'... synapsen mit kurzzeitdepression
;
;     Revision 2.4  1998/04/06 15:40:53  thiel
;            Kontroll-Ausgabe wieder entfernt.
;
;     Revision 2.3  1998/04/06 15:35:54  thiel
;            Tippfehler korrigiert.
;
;     Revision 2.2  1998/04/05 13:51:53  saam
;           now conversion is less memory intensive
;
;     Revision 2.1  1998/02/05 11:36:18  saam
;           Cool
;
;

FUNCTION SDW2DW, _SDW, KEEP_ARGUMENT=keep_argument


   IF (Info(_SDW) NE 'SDW_DELAY_WEIGHT') AND (Info(_SDW) NE 'SDW_WEIGHT') THEN Message, 'SDW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_SDW))+' !'

   dims = DWDim(_SDW, /ALL)

   IF Info(_SDW) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN            
      DW = {  info    : 'DW_DELAY_WEIGHT',$
              source_w: dims(0) ,$
              source_h: dims(1) ,$
              target_w: dims(2) ,$
              target_h: dims(3) ,$
              Weights : Weights(_SDW),$
              Delays  : Delays(_SDW)  }
   END ELSE IF Info(_SDW) EQ 'SDW_WEIGHT' THEN BEGIN
      DW = {  info    : 'DW_WEIGHT'  ,$
              source_w: dims(0) ,$
              source_h: dims(1) ,$
              target_w: dims(2) ,$
              target_h: dims(3) ,$
              Weights : Weights(_SDW) }
      
   END ELSE Message, 'this must not happen!!'


   ;; We need this again, because there are no(t yet) functions for
   ;; accessing the depression-parameters and conjunction-method from
   ;; a SDW-handle (like for Weights and Delays!):
   Handle_Value, _SDW, SDW, /NO_COPY


; kompatibilitaetsabfrage zu alten sdw-strukturen
   IF NOT ExtraSet(SDW,'depress') THEN depress = 0 else depress =  SDW.depress
      
; depressions-parameter  
   IF depress EQ 1 THEN begin  
      settag,dw, 'U_se_const',SDW.U_se_const
      settag,dw, 'tau_rec', SDW.tau_rec
      settag,dw, 'realscale', SDW.realscale
   END 
   settag,dw, 'depress', SDW.depress
   
; kompatibilitaetsabfrage zu alten sdw-strukturen
   IF NOT ExtraSet(SDW,'conjunction_method') THEN conjunction_method=1 else depress=SDW.conjunction_method
   ;; method 1 is "SUM".
      

   ;; We need this again, because there are no(t yet) functions for
   ;; accessing the depression-parameters and conjunction-method from
   ;; a SDW-handle (like for Weights and Delays!):
   Handle_Value, _SDW, SDW, /NO_COPY, /SET

  
   IF NOT Keyword_Set(KEEP_ARGUMENT) THEN FreeDW, _SDW
   
   RETURN, Handle_Create(!MH, VALUE=DW, /NO_COPY)
END
