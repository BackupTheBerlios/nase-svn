Function titleize, forms; forms can be scalar or array
Common Common_Random, seed

   n_forms = 7

   default, forms, fix(n_forms*randomu(seed))

   form = forms[n_elements(forms)*randomu(seed)]

   case form of

      0: return, "Why "+plural(noun())+" do need "+plural(noun())+"."
      1: return, "Why "+plural(noun())+" have "+plural(noun())+"."
      2: return, "Do "+plural(noun())+" need "+plural(noun())+"?"
      3: return, "Do "+plural(noun())+" have "+plural(noun())+"?"
      4: return, "Why "+plural(noun())+"?"
      5: return, "On "+plural(noun())+" and "+plural(noun())+"."
      6: return, "On "+plural(noun())+" and "+plural(noun())+": " $
                 +titleize([0, 1, 2, 3, 4])
   endcase
End
