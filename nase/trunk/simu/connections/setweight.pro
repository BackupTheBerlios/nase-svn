;+
; NAME:
;
;
;
; PURPOSE:
;
;
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE:
;
;
; 
; INPUTS:
;
;
;
; OPTIONAL INPUTS:
;
;
;	
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPAMPLE:
;
;
;
; MODIFICATION HISTORY:
;
;       Mon Jul 28 16:48:52 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt.
;-

Pro SetWeigth, V_Matrix, Weight, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index
    
    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:
       default, t_index, LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HIEGHT=V_Matrix.target_h)
       V_Matrix.Weights(t_index, *) = Weight
    end

    if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:
       default, s_index, LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
       V_Matrix.Weights(*, s_index) = Weight
    end

    ; Nur einzelne Verbindung zurückliefern:
    default, s_index, LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
    default, t_index, LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HIEGHT=V_Matrix.target_h)

    V_Matrix.Weights(t_index, s_index) = Weight

end   






