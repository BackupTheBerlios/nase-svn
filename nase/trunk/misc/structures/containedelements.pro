;+
; NAME: 
;   ContainedElements()
;
; VERSION:
;   $Id$
;
; AIM:
;   Return the number of elements contained in a list, stack or
;   queue.
;   
; PURPOSE:
;   This Function returns the numer of elements that are stored in the
;   specified container (list, stack or queue). For a fixed queue,
;   either the fixed length of the queue, or the number of valid
;   elements (i.e. elements that have really be added by
;   <A>EnQueue</A>) can be returned.
;   
; CATEGORY:
;*  DataStructure
;
; CALLING SEQUENCE:
;   result = ContainedElements( container [,/VALID]) 
;
; INPUTS:
;   container:: The container to check. This may be a list,
;               initialized by <A>InitList()</A>, a stack, initialized
;               by <A>InitStack()</A>, a queue, initialized by
;               <A>InitQueue()</A>, or a fixed queue, initialized by
;               <A>InitFQueue()</A>.
;               Currently only fixed queues are supported!!
;  
; INPUT KEYWORDS:
;   VALID:: For a fixed queue, by default, the fixed length of the
;           queue is returned. Set this keyword if only the number of
;           valid elements should be returned (i.e. the number of
;           elements that were actually added using <A>EnQueue</A>.)
;
; OUTPUTS:
;   result:: Number of the contained (valid) elements. 
;
; RESTRICTIONS:
;   Currently only(!!) fixed queues are supported. Please extend this
;   function as soon as you need it for other containers.
;  
; PROCEDURE:
;   For a fixed queue, just return .length or .valid entry.
;  
; EXAMPLE:
;*  IDL> fq = InitFQueue(3)
;*  IDL> print, ContainedElements(fq) 
;*  IDL> print, ContainedElements(fq, /VALID) 
;*  IDL> Enqueue, fq, 23
;*  IDL> print, ContainedElements(fq) 
;*  IDL> print, ContainedElements(fq, /VALID)   
;-

;;; look in ../doc/header.pro for explanations and syntax,
;;; or view the NASE Standards Document


Function ContainedElements, c, VALID=VALID
   assert, contains(c.info, 'FIXED_QUEUE', /IGNORECASE), $
    "Currently only fixed queues are supported."
   
   If Keyword_Set(VALID) then return, c.valid else return, c.length
End
   
