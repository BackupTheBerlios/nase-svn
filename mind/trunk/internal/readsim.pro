;+
; NAME:
;  ReadSim
;
; VERSION:
;  $Id$
;
; AIM:
;  Read various simulation data created by <A>Sim</A>. You probably
;  want to use the <A>ReadSimu</A>, instead.
;
; PURPOSE:            Reads SUA or membrane potentials saved via MIND
;                     allows specific neurons and times to be read.
;                     this routine doesn't care for oversampling.
;                     There is a high level routine called <A>ReadSimu</A>
;                     you probably want to use instead!
;
; CATEGORY:
;  DataStorage
;  Internal
;  MIND
;  Simulation
;
; CALLING SEQUENCE:   o = ReadSim(file [,/INPUT] [,/OUTPUT]
;                                 [,/MEMBRANE] [,/MUA] [,/LFP] 
;                                 [,/NONE]
;                                 [,TIME=time] [,SELECT=select] 
;                                 [,INFO=info]
;                                 [,UDS=uds]
;
;
; INPUTS:             file: path/file to be read (without suffices)
;
; KEYWORD PARAMETERS: IINPUT  : read input for layer
;                     OUTPUT  : read spike output of layer (this is default)
;                     MEMBRANE: read membrane potentials of layer
;                     LFP     : read local field potentials of layer
;                     MUA     : read multiple unit activity
;                     NONE    : read arbitrary data
;                     TIME    : reads the simulation from BIN start to BIN end specified
;                               as [start,end]. if end is negative,
;                               data is read to the (-end)-last
;                               element. Therefore end=-1 reads to
;                               the file's end. If end is omitted,
;                               data is read from 0 to start.
;                     SELECT  : an array of neuron indices to be read
;
; OPTIONAL OUTPUTS:   INFO    : returns the VIDEO informations
;
; OUTPUTS:            O: array (neuronindex,time) containing the data read
;
; EXAMPLE:            o = ReadSim('~/sim/local_assemblies/bar/gap/v1/_', $
;                                  /MEMBRANE, TIME=[0,1000], SELECT=[0,5,7,3,9])
;
; SEE ALSO:           <A>ReadSimu</A>
;        
;-
FUNCTION ReadSim, file, NONE=none, INPUT=input, OUTPUT=output, LFP=lfp, MEMBRANE=membrane, MUA=mua, RMUA=rmua, TIME=time, INFO=info, SELECT=select, UDS=uds

   On_Error, 2

   IF Set(TIME) THEN BEGIN
      IF N_Elements(TIME) EQ 1 THEN TIME = [0,TIME]
   END 

   IF N_Params() NE 1 THEN Message, 'filename expected'
   kc = Set(INPUT)+Keyword_Set(OUTPUT)+Keyword_Set(MEMBRANE)+Keyword_Set(MUA)+Keyword_Set(RMUA)+Keyword_Set(LFP)+Keyword_Set(NONE)
   IF kc EQ 0 THEN BEGIN
      OUTPUT = 1
      kc = 1
   END
   IF kc NE 1 THEN Console, 'can only read one type of data simultanously', /FATAL
   
   IF Set(NONE) THEN BEGIN
      filename = file 
      console, 'loading unknown data ...'
   END
   IF Set(INPUT) THEN BEGIN
      filename = file+'.'+STR(INPUT)+'.in.sim' 
      console, 'loading input spikes ('+STR(INPUT)+') ...'
   END
   IF Keyword_Set(OUTPUT)   THEN BEGIN
      filename = file+'.o.sim'
      console, 'loading output spikes...'
   END
   IF Keyword_Set(MEMBRANE) THEN BEGIN
      filename = file+'.m.sim'
      console, 'loading membrane potentials...'
   END
   IF Keyword_Set(MUA) THEN BEGIN
      filename = file+'.mua.sim'
      console, 'loading MUA...'
   END
   IF Keyword_Set(LFP) THEN BEGIN
      filename = file
      console, 'loading LFP...'
   END
   IF Keyword_Set(RMUA) THEN BEGIN
      filename = file+'.mua'
      console, 'loading RMUA...'
   END


   Video = LoadVideo( TITLE=filename, GET_SIZE=anz, GET_LENGTH=max_time, /SHUTUP, GET_STARRING=log1, GET_COMPANY=log2, ERROR=error, UDS=uds)
   IF Error THEN BEGIN
       console, 'data doesnt exist...'+filename, /WARN
       console, 'stopping', /FATAL
   END
   INFO = log1 + ', ' + log2
   IF Set(TIME) THEN BEGIN
       IF TIME(1) LT 0 THEN TIME(1)=max_time+TIME(1)
       IF max_time-1 LT TIME(1) THEN BEGIN
           TIME(1) = max_time-1
           console, 'requested time interval larger than actual recorded!!', /WARN
           console, '', /WARN
       END
   END ELSE TIME = [0,max_time-1]
   IF TIME(0) GT TIME(1) THEN Console, 'start time ('+STR(Time(0))+') is larger than stop time ('+STR(Time(1))+')', /FATAL

   anz = anz(1)
   IF Set(Select) THEN BEGIN
      IF (MAX(Select) GE anz) OR (MIN(Select) LT 0) THEN BEGIN
         console, 'illegal SELECT index', /FATAL
      END
      anz =  N_Elements(SELECT)
   END
   IF Keyword_Set(MEMBRANE) OR Keyword_Set(LFP) OR Keyword_Set(RMUA) OR KEYWORD_Set(NONE) THEN xt = DblArr(anz, TIME(1)-TIME(0)+1) ELSE xt = BytArr(anz, TIME(1)-TIME(0)+1)

   TIME = LONG(TIME)
   REWIND, Video, TIME(0), /SHUTUP
   IF Set(Select) THEN BEGIN
      FOR t=TIME(0), TIME(1) DO BEGIN
         tmp = Replay(Video)
         xt(*,t-TIME(0)) = tmp(Select)
         IF ((t-time(0)) MOD ((time(1)-time(0))/20)) EQ 0 THEN console, 'loading...'+STR((t-time(0))*100/(time(1)-time(0)))+' %',/UP
      END
   END ELSE BEGIN
      FOR t=TIME(0), TIME(1) DO BEGIN
         xt(*,t-TIME(0)) = Replay(Video)
         IF ((t-time(0)) MOD ((time(1)-time(0))/20)) EQ 0 THEN console, 'loading...'+STR((t-time(0))*100/(time(1)-time(0)))+' %', /UP
      END
   END
   Eject, Video, /SHUTUP


   IF Keyword_Set(INPUT)    THEN console, 'loading input spikes...done', /UP
   IF Keyword_Set(OUTPUT)   THEN console, 'loading output spikes...done', /UP
   IF Keyword_Set(MEMBRANE) THEN console, 'loading membrane potentials...done', /UP
   IF Keyword_Set(MUA)      THEN console, 'loading MUA...done', /UP
   IF Keyword_Set(RMUA)     THEN console, 'loading RMUA...done', /UP
   IF Keyword_Set(LFP)      THEN console, 'loading LFP...done', /UP

   RETURN, xt
END
