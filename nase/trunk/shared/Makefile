#   
#   Modification History:
#
#         $Log$
#         Revision 1.6  2000/08/31 08:56:29  saam
#               OSF needs c++ and not cc as c++ compiler
#
#         Revision 1.5  2000/08/04 15:13:02  kupper
#         Added system variable !NASEDIR.
#
#         NASE C lib is now located in each users nase directory (no system wide
#         install).
#         The library is checked at startup and compiled if it doesn't exist.
#
#         Revision 1.4  1999/03/04 16:36:21  kupper
#
#         Erster Commit.
#         Wrapper-Routinen in IDL folgen demnächst...
#
#         Revision 1.3  1999/02/25 20:50:06  saam
#               + nasec.c now split up in several .o files
#               + only mtime at the moment
#
#         Revision 1.2  1999/02/24 20:41:50  saam
#               working install option
#
#         Revision 1.1.1.1  1999/02/24 19:39:32  saam
#               NEXT GENERATION: NASE uses C
#
#

SHELL=/bin/sh
CFLAGS=
FFLAGS=

OBJECTS=mtime.o IDL_IO_support.o

SHL_EXT=so
SHL_LIBS=nasec.$(SHL_EXT)
LIB_VER=0.0.1
# INSTALL_DIR=/vol/lib/nase



all : 
	@echo "OS type detected: "`uname`
	@case `uname` in \
	   "OSF1" )  make libs \
			"CC=cc" \
			"CXX=c++" \
			"C_LD=ld" \
			"CFLAGS=-DOSF1" \
			"C_LD_FLAGS=-S -shared" ;; \
	   "Linux" ) make libs \
			"CC=cc" \
			"CXX=cc" \
			"C_LD=ld" \
			"CFLAGS=-fPIC -shared" \
			"C_LD_FLAGS=-shared" ;; \
	   *) echo "This system is not supported" ;; \
       esac


libs : $(SHL_LIBS)



nasec.$(SHL_EXT) : $(OBJECTS)
	$(C_LD) $(C_LD_FLAGS) -o nasec.$(SHL_EXT) $(OBJECTS) $(C_LD_POST)


# install: nasec.$(SHL_EXT)
# 	  @case `uname` in \
# 		  "OSF1" )  make _install "INSTALL=/usr/bin/installbsd" ;; \
# 		  "Linux" ) make _install "INSTALL=/usr/bin/install" ;;\
# 		  *) echo "This system is not supported" ;; \
# 	  esac
# 
# _install:
# 	  $(INSTALL)  -m 0777 nasec.$(SHL_EXT) $(INSTALL_DIR)/nasec.$(SHL_EXT).$(LIB_VER)
# 	  ln -sf $(INSTALL_DIR)/nasec.$(SHL_EXT).$(LIB_VER) $(INSTALL_DIR)/nasec.$(SHL_EXT)
 

tidy :
	rm -f *.o

clean :
	rm -f *.o *.so *.sl *.a so_locations


#  Rules for building the object files.

.SUFFIXES: .c .o .cc

.c.o :
	$(CC) $(CFLAGS) -c $*.c

.cc.o :
	$(CXX) $(CFLAGS) -c $*.cc
