Function noun;;;; not yet: , categories, exclude (prevent repetitions)
Common Common_Random, seed
   
   ;; categories:
   ;;
   ;; 0: neuro
   
   n_categories = 1
   
   nouns = ptrarr(n_categories, /Allocate_Heap)
   
   *(nouns[0]) = ["neuron", "spike", "nerve cell", "brain", "monkey", $
                  "barn owl", "human", "ferret", "cat", "ganglion cell", $
                  "simple cell", "complex cell", "synapse", "tea cup", "journal", $
                  "scientist", "wave", "inhibition", "context", "features", "invariance"]
   
   
   
   cat = 0;; will be chosen randomly later
   
   n = n_elements(*(nouns[cat]))
   i = n*randomu(seed)
   
   result = (*(nouns[cat]))[i]

   ptr_free, nouns

   return,  result

End
