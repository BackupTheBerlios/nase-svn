;+
; NAME:
;  RankOrder()
;
; VERSION:
;  $Id$
;
; AIM:
;  computes rank-order of the first output-spikes for a given set of neurons
;
; PURPOSE:
; computes rank-order of the first output-spikes for a given set of neurons 
;  
;
; CATEGORY:
;  Layers
;  NASE
;  Signals
;  Simulation
;
; CALLING SEQUENCE:
;
; result = RankOrder(mydata)
;
; INPUTS:
;  mydata : array(nr_timesteps, nr_spiketrains) containing sua-data
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  result : result(pos)=rank of neuron pos.
;           
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;
; d = bytarr(5, 5)
; d(*, 0) = [0, 1, 0, 0, 0]
; d(*, 1) = [0, 0, 1, 0, 0]
; d(*, 2) = [1, 0, 0, 0, 0]
; d(*, 3) = [0, 0, 0, 1, 0]
; d(*, 4) = [0, 0, 0, 0, 1]
; print,RankOrder(d)
;
;
;*
;*>
;
; SEE ALSO:
;
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document



FUNCTION __extract_first_spikes, mylist
   trains = (size(mylist))(2)
   res = fltarr(trains)
   for i=0, trains-1 do res(i) = where(mylist(*, i) ne 0, c)
   return, res
end

FUNCTION rankorder, mylist
   slist = sort(__extract_first_spikes(mylist))
   lng =  n_elements(slist)
   res = lonarr(lng)
   res(slist) = indgen(lng)
   return, res
end

