Function titleize, forms; forms can be scalar or array
Common Common_Random, seed

   n_forms = 9

   default, forms, fix(n_forms*randomu(seed))

   form = forms[n_elements(forms)*randomu(seed)]

   case form of
      ;; note: negative form numbers are for internal use only!
      -1:return, "Why "+plural(noun())+" do need "+plural(noun())
      -2:return, "Why "+plural(noun())+" have "+plural(noun())
      -3:return, "On "+plural(noun())+" and "+plural(noun())

      0: return, titleize(-1)+"."
      1: return, titleize(-2)+"."
      2: return, "Do "+plural(noun())+" need "+plural(noun())+"?"
      3: return, "Do "+plural(noun())+" have "+plural(noun())+"?"
      4: return, "Why "+plural(noun())+"?"
      5: return, titleize(-3)+"."
      6: return, titleize(-3)+": "+titleize([0, 1, 2, 3, 4])
      7: return, titleize([-1, -2])+": "+titleize(5)
      8: return, titleize([2, 3])+" - "+titleize([0, 1, 5])
   endcase
End
