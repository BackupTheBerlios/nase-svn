/*
**
** $Version$
**
**
**
** MODIFICATION HISTORY:
**
**       $Log$
**       Revision 1.1  1999/02/24 19:39:32  saam
**       Initial revision
**
**
*/
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include "/vol/graphic/idl_5/external/export.h"


#define ERROR -1

typedef struct {
   unsigned short slen;
   short stype;
   char *s;
} STRING;



IDL_LONG mtime(int   argc  ,
	       void *argv[])
{
  char	        *cstr  ;	/* pointer to a C string  	*/
  STRING	*idlstr;   	/* Pointer to IDL STRING        */
  struct stat    mystat;
  int            error ;
  extern int     errno ;   
  
  if (argc != 1){
    fprintf(stderr, "fstat: expected 1 and got %i elements!", argc);
    return(ERROR);
  }


  /*
  ** convert IDL-String to C-String
  */
  idlstr = (STRING *) argv[0];
  if( (cstr=(char*)malloc((unsigned)sizeof(char)* (idlstr->slen)+1) ) == (char*)NULL ){
    //fprintf(stderr,"fstat: malloc error\r\n");
    return(ERROR);
  }
  cstr = strcpy(cstr, idlstr->s);



  error = stat(cstr, &mystat);
    
  if (error){
    //fprintf(stderr, "fstat: %s, %s\n", cstr, strerror(errno));
    return(ERROR);
  } 

  //printf("%i\n", mystat.st_mtime);
  return(mystat.st_mtime);
}   
