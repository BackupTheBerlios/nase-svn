;+
; NAME:               ReadSim
;
; PURPOSE:            Reads SUA or membrane potentials saved via MIND
;                     allows specific neurons and times to be read.
;                     this routine doesn't care for oversampling.
;                     There is a high level routine called ReadSimu
;                     you probably want to use instead!
;
; CATEGORY:           MIND INTERNAL
;
; CALLING SEQUENCE:   o = ReadSim(file [,/INPUT] [,/OUTPUT] [,/MEMBRANE] [,TIME=time] [,SELECT=select])
;
; INPUTS:             file: path/file to be read (without suffices)
;
; KEYWORD PARAMETERS: IINPUT  : read input for layer
;                     OUTPUT  : read spike output of layer (this is default)
;                     MEMBRANE: read membrane potentials of layer
;                     TIME    : reads the simulation from BIN start to BIN end specified
;                               as [start,end]
;                     SELECT  : an array of neuron indices to be read
;
; OUTPUTS:            O: array (neuronindex,time) containing the data read
;
; EXAMPLE:            o = ReadSim('~/sim/local_assemblies/bar/gap/v1/_', $
;                                  /MEMBRANE, TIME=[0,1000], SELECT=[0,5,7,3,9])
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#READSIMU>readsimu</A>
;        
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 1.1  1999/12/21 09:02:52  saam
;            moved to internal, but it can be used by
;            the user anyway
;
;
;
FUNCTION ReadSim, file, INPUT=input, OUTPUT=output, MEMBRANE=membrane, MUA=mua, TIME=time, SELECT=select, _EXTRA=e

   IF Set(TIME) THEN BEGIN
      IF N_Elements(TIME) EQ 1 THEN TIME = [0,TIME]
   END 

   IF N_Params() NE 1 THEN Message, 'filename expected'
   kc = Set(INPUT)+Keyword_Set(OUTPUT)+Keyword_Set(MEMBRANE)+Keyword_Set(MUA)
   IF kc EQ 0 THEN BEGIN
      OUTPUT = 1
      kc = 1
   END
   IF kc NE 1 THEN Message, 'can only read one type of data simultanously'
   
   IF Set(INPUT) THEN BEGIN
      filename = file+'.'+STR(INPUT)+'.in.sim' 
      print, 'READSIM: loading input spikes ('+STR(INPUT)+') ...'
   END
   IF Keyword_Set(OUTPUT)   THEN BEGIN
      filename = file+'.o.sim'
      print, 'READSIM: loading output spikes...'
   END
   IF Keyword_Set(MEMBRANE) THEN BEGIN
      filename = file+'.m.sim'
      print, 'READSIM: loading membrane potentials...'
   END
   IF Keyword_Set(MUA) THEN BEGIN
      filename = file+'.mua.sim'
      print, 'READSIM: loading MUA...'
   END


   Video = LoadVideo( TITLE=filename, GET_SIZE=anz, GET_LENGTH=max_time, /SHUTUP, ERROR=error)
   IF Error THEN BEGIN
      print, 'READSIM: data doesnt exist...'+filename
      print, 'READSIM: stopping'
      stop
   END
   IF Set(TIME) THEN BEGIN
      IF max_time-1 LT TIME(1) THEN BEGIN
         TIME(1) = max_time-1
         print, 'READSIM: requested time interval larger than actual recorded!!'
         print, ''
      END
   END ELSE TIME = [0,max_time-1]


   anz = anz(1)
   IF Set(Select) THEN BEGIN
      IF (MAX(Select) GE anz) OR (MIN(Select) LT 0) THEN BEGIN
         print, 'READSIM: illegal SELECT index'
         stop
      END
      anz =  N_Elements(SELECT)
   END
   IF Keyword_Set(MEMBRANE) THEN xt = DblArr(anz, TIME(1)-TIME(0)+1) ELSE xt = BytArr(anz, TIME(1)-TIME(0)+1)

   print, ''
   TIME = LONG(TIME)
   REWIND, Video, TIME(0)
   IF Set(Select) THEN BEGIN
      FOR t=TIME(0), TIME(1) DO BEGIN
         tmp = Replay(Video)
         xt(*,t-TIME(0)) = tmp(Select)
         IF ((t-time(0)) MOD ((time(1)-time(0))/20)) EQ 0 THEN print, !Key.UP, 'READSIM: ', (t-time(0))*100/(time(1)-time(0)), ' %' 
      END
   END ELSE BEGIN
      FOR t=TIME(0), TIME(1) DO BEGIN
         xt(*,t-TIME(0)) = Replay(Video)
         IF ((t-time(0)) MOD ((time(1)-time(0))/20)) EQ 0 THEN print, !Key.UP, 'READSIM: ', (t-time(0))*100/(time(1)-time(0)), ' %' 
      END
   END
   Eject, Video, /SHUTUP


   IF Keyword_Set(INPUT)    THEN print, 'READSIM: loading input spikes...done'
   IF Keyword_Set(OUTPUT)   THEN print, 'READSIM: loading output spikes...done'
   IF Keyword_Set(MEMBRANE) THEN print, 'READSIM: loading membrane potentials...done'
   IF Keyword_Set(MUA)      THEN print, 'READSIM: loading MUA...done'

   RETURN, xt
END
