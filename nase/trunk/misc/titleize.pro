Function titleize, form
Common Common_Random, seed

   n_forms = 4

   default, form, fix(n_forms*randomu(seed))

   case form of

      0: return, "Why "+plural(noun())+" do need "+plural(noun())+"."
      1: return, "Why "+plural(noun())+" have "+plural(noun())+"."
      2: return, "Do "+plural(noun())+" need "+plural(noun())+"?
      3: return, "Do "+plural(noun())+" have "+plural(noun())+"?"
   endcase
End
