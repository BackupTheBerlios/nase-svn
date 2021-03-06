#======================================================================
# This is a generic makefile that has to be used together with the
# 'cs-config' utility that can be generated by Crystal Space.
#
# To use this you first have to generate a config file by doing:
#       make csconfig
# in the Crystal Space directory. Then copy the generated cs-config
# script (which will be in the CS root initially) to your project
# directory.
#
# You also have to edit this makefile so it is suitable for your project.
# You probably want to change at least:
#       EXECUTABLE for the name of the executable
#       OBJSRC for the location of the sources
#       LINKFLAGS for all the libraries that your application needs
#
# If you want to compile plugins as well, edit:
#       PLUGIN for the name of the plugin
#       PLUGIN.OBJSRC for the location of the plugin sources
#       PLUGIN.LINKFLAGS for the libraries that the plugin needs
#
# If you installed Crystal Space (usually /usr/local/crystal) then
# this makefile should already work. If not you need to set the CRYSTAL
# environment variable to point to the Crystal Space directory.
#
# This makefile supports the following targets: all, clean, depend.
#======================================================================

#------
# Name of program and plugin
#------
EXECUTABLE=simple$(EXE)

DOCU=doc/howto_install/howto_install.html
DOCSRC=doc/howto_install.tex

#------
# Location of sources and object files
#------
#OBJSRC=$(wildcard src/*.cpp)
HEADERS=$(wildcard src/*.h)
OBJSRC=$(wildcard src/*.cpp)
OBJS=$(addsuffix .o, $(basename $(OBJSRC)))

#OBJSRC= src/simple.cpp 
#OBJS=$(addsuffix .o, $(basename $(OBJSRC)))

#------
# Tools to use
#------
CCC=g++ 
LINK=g++
RM=rm

#------
# Flags for compiler and linker.
# Make sure to update the required libraries for your own project
#------
CSCONFIG.MAK=csconfig.mak
-include $(CSCONFIG.MAK)
ifeq ($(LINK.PLUGIN),)
  LINK.PLUGIN=$(LINK)
endif
CFLAGS := $(shell ./cs-config --cflags)
CXXFLAGS := $(shell ./cs-config --cxxflags)
LINKFLAGS := $(shell ./cs-config --libs cstool csutil cssys csgfx csgeom)

#------
# Rules
#------
.PHONY: all depend clean doc
.SUFFIXES: .cpp
DO.SHARED.PLUGIN.CORE=$(LINK.PLUGIN) $(LFLAGS.DLL) -o $@ $^ $(PLUGIN.POSTFLAGS)
DO.PLUGIN = $(DO.SHARED.PLUGIN.PREAMBLE) $(DO.SHARED.PLUGIN.CORE) \
  $(DO.SHARED.PLUGIN.POSTAMBLE)
DO.EXEC = $(LINK) -o $@ $^ $(LFLAGS.EXE) $(LIBS.EXE.PLATFORM)

#.cpp.o: $< 
%.o: %.cpp %.h
	$(CCC) $(CXXFLAGS) -o $@ -c $<

all: $(CSCONFIG.MAK) $(EXECUTABLE)

$(EXECUTABLE): $(OBJS) 
	$(DO.EXEC) $(LINKFLAGS)

clean:
	$(RM) $(OBJS) 

#-----
# Translate HTML-Documentation
#-----

doc: $(DOCU)

$(DOCU): $(DOCSRC)
	latex2html $(DOCSRC)

#------
# Create dependencies
#------
depend: $(CSCONFIG.MAK)
	gcc -MM $(CXXFLAGS) $(OBJSRC) > makefile.dep

#------
# Re-create the config flags include file
#------
$(CSCONFIG.MAK): ./cs-config
	./cs-config --makevars > $(CSCONFIG.MAK)

#------
# Include dependencies
#------
-include makefile.dep

