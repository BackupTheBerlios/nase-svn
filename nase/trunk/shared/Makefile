#   
#   Modification History:
#
#         $Log$
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

SHL_EXT=so
SHL_LIBS=nasec.$(SHL_EXT) 
LIB_VER=0.0.1
INSTALL_DIR=/vol/lib/nase



all : 
	@echo "OS type detected: "`uname`
	@case `uname` in \
	   "OSF1" )  make libs \
			"CC=cc" \
			"C_LD=ld" \
			"CFLAGS=-DOSF1" \
			"C_LD_FLAGS=-S -shared" ;; \
	   "Linux" ) make libs \
			"CC=cc" \
			"C_LD=ld" \
			"CFLAGS=-fPIC -shared" \
			"C_LD_FLAGS=-shared" ;; \
	   *) echo "This system is not supported" ;; \
       esac


libs : $(SHL_LIBS)



nasec.$(SHL_EXT) : nasec.o
	$(C_LD) $(C_LD_FLAGS) -o nasec.$(SHL_EXT) nasec.o $(SIMPLE_EXPORT) \
		$(C_LD_POST)


install: nasec.$(SHL_EXT)
	@case `uname` in \
		"OSF1" )  make _install "INSTALL=/usr/bin/installbsd" ;; \
		"Linux" ) make _install "INSTALL=/usr/bin/install" ;;\
		*) echo "This system is not supported" ;; \
	esac

_install:
	$(INSTALL)  -m 0777 nasec.$(SHL_EXT) $(INSTALL_DIR)/nasec.$(SHL_EXT).$(LIB_VER)
	ln -sf $(INSTALL_DIR)/nasec.$(SHL_EXT).$(LIB_VER) $(INSTALL_DIR)/nasec.$(SHL_EXT)


tidy :
	rm -f *.o

clean :
	rm -f *.o *.so *.sl *.a so_locations


#  Rules for building the object files.

.SUFFIXES: .c .o

.c.o :
	$(CC) $(CFLAGS) -c $*.c

