;+
; NAME:
;  journalize()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return a name for a new neuroscientific journal on a specific subject.
;
; PURPOSE:
;  Ever needed a name for the neuroscientific journal you're just
;  about to start? <C>journalize()</C> will invent one for you.
;
; CATEGORY:
;  Help
;  Strings
;
; CALLING SEQUENCE:
;*result = journalize( [subject] )
;
; OPTIONAL INPUTS:
;  subject:: The subject jour new journal will focus on. If you can't
;            think of any, just leave this empty. <C>journalize()</C>
;            will pick one for you.
;
; RESTRICTIONS:
;  With explicitly supplied subjects, the plural-"s" may sometimes be
;  used wrongly. Could easily be solved, but I don't care.<BR>
;  Meta-journalling (see examples) does not yet produce perfect
;  results. I don't care either.
;
; PROCEDURE:
;  Put together journal-pre- and suffixes, adjectives, and the subject,
;  and you've got it. It's that easy...
;
; EXAMPLE:
;*;; supply jour own subject:
;*print, journalize("Pasta Cooking")
;*>Philosophical Pasta Cooking Reviews
;*print, journalize("Paper Writing")
;*>Current Opinion on Psychological Paper Writing
;*;; let journalize() choose the subject:
;*for i=1,3 do print, journalize()
;*Experimental Neurocomputing Reviews
;*Biological Neurons
;*Proceedings of the Great Society for Behavioral Modelling
;*;; How about meta-journalling?
;*>for i=1,3 do print, journalize(journalize())
;*Physiological Chinese Transactions on Neural Vision Letters
;*Trends in Behavioral Computational Neurocomputing Reviews
;*Current Opinion on Behavioral Biological Brains
;-


function JZ__oneof, a
   Common Common_Random, seed
   return, a[fix(n_elements(a)*randomu(seed))]
end

function JZ__journaladjective
   a = ["", "European", "International", "American", "German", "Danish", $
        "Chinese", "Great", "Holy", "Incredible"]
   return, JZ__oneof(a)
End

function JZ__adjective
   a = ["", "Neural", "Biological", "Computational", "Experimental", $
        "Physiological", "Psychological", "Theoretical", $
        "Philosophical", "Behavioral"]
   return, JZ__oneof(a)
End

function JZ__subject, form
   ;; this form as in "Transactions on ..."
   s1 = ["Vision", "Recognition", "Science", "Neuroscience", $
         "Networks", "Neurocomputing", "Brains", $
         "Modelling", "Neurons", "Transmitters", "Synapses", $
         "Simulation", "Computation", "Cybernetics", "Journalization"]
   
   ;; this form as in "... letters"
   s2 = ["Vision", "Recognition", "Science", "Neuroscience", $
         "Network", "Neurocomputing", "Brain", $
         "Modelling", "Neuron", "Transmitter", "Synapse", $
         "Simulation", "Computation", "Cybernetic", "Journalization"]
   
   assert, (form eq 1) or (form eq 2)
   case form of
      1: return, JZ__oneof(s1)
      2: return, JZ__oneof(s2)
   endcase
end

function JZ__prefix
   Common Common_Random, seed
   jn = fix(5*randomu(seed))
   case jn of
      0: j = JZ__oneof(["", "The "])+JZ__journaladjective()+" Journal of"
      1: j = JZ__journaladjective()+" Transactions on"
      2: j = "Proceedings of the "+JZ__journaladjective()+" Society for"
      3: j = "Trends in "
      4: j = "Current Opinion on "
   endcase
   return, j
end

function JZ__suffix
   s = JZ__oneof(["Letters", "Reviews"])
   s = JZ__oneof(["", "Research "])+s
   return, s
End


function journalize, subject
   Common Common_Random, seed
   ps = fix(3*randomu(seed))
   ;; 0: no pre or suffix
   ;; 1: prefix
   ;; 2: suffix
   case ps of
      0: begin
         Default, subject, JZ__subject(1)
         j = JZ__oneof([JZ__adjective(), JZ__journaladjective()])+" "+subject
      end
      1: begin
         Default, subject, JZ__subject(1)
         j = JZ__prefix()+" "+JZ__adjective()+" "+subject
      end
      2: begin
         Default, subject, JZ__subject(2)
         j = JZ__adjective()+" "+subject+" "+JZ__suffix()
      end
   endcase

   ;; just remove duplicate and trailing/leading whitespace:
   return, strtrim(strcompress(j),2)
End
