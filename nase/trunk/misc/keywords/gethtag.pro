;+
; NAME:                 SetHTag
;  
; PURPOSE:              This Routine provides a rather comfortable
;                       scheme to get structure tags in a linked list
;                       of handles.structures. This occurs quite
;                       often in the MIND environment. Please see the
;                       example.
;  
; CATEGORY:             NASE STRUCTURES 
;  
; CALLING SEQUENCE:     GetHTag, struc, htag, value
;  
; INPUTS:
;                       struc: structure that is the root of the
;                              linked handle list
;                       htag : string, that describes how to de-
;                              reference the list. It is separated
;                              by slashes, where each slash stands
;                              for dereferencing a handle.
;                              "TARGET_TAG/TAG_IN_Z/.../TAG_IN_A"
;                       value: the value, to be assigned to TARGET_TAG
;  
; EXAMPLE:
;                       Assume the following construct:
;                         _a = {HI: -1}
;                         _b = Handle_Create(!MH, VALUE={a:_a})
;                         _c = Handle_Create(!MH, VALUE={b:_b})
;                         _d = Handle_Create(!MH, VALUE={c:_c})
;                          e = {d:_d}
;                       If you to change HI simply call:
;                         SetHTag, e, "HI/a/b/c/d", 1
;                       and retrieve HI in value by:
;                         GetHTag, e, "HI/a/b/c/d", value
;
; SEE ALSO:             <A HREF="#SETHTAG">SetHTag</A>, <A HREF="#SETTAG">SetTag</A>
;
;-  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/04/04 12:50:53  saam
;              it finally works
;
;
;
PRO GetHTag, struc, htag, val

IF N_Params() NE 3 THEN Console, 'wrong argument count', /FATAL
IF TypeOF(struc) NE 'STRUCT' THEN Console, '1st arg ist no structure', /FATAL
IF TypeOF(htag)  NE 'STRING' THEN Console, '2nd arg ist no string', /FATAL


deref = Str_Sep(htag, '/')
ntag = N_Elements(deref)

_s = struc
FOR pos = ntag-1, 1, -1 DO BEGIN
    command = "_h = _s."+STR(deref(pos))
    IF NOT Execute(command) THEN Console, 'Excution failed: '+command, /FATAL
    Handle_Value, _h, _s
END

command = "val = _s."+STR(deref(0))                   
IF NOT Execute(command) THEN Console, 'Excution failed: '+command, /FATAL

END