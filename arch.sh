#!/bin/bash -e

cd "$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Obj"

cat <<EOF >arch.make
.SUFFIXES:
.SUFFIXES: .f .F .o .c .a .f90 .F90

SIESTA_ARCH = x86_64_MPI

CC = mpicc
FPP = \$(FC) -E -P -x c
FC = mpif90
FC_SERIAL = gfortran

# MPI setup
MPI_INTERFACE = libmpi_f90.a
MPI_INCLUDE = .

FFLAGS = -O3 -fPIC -ftree-vectorize -march=native

AR = ar
RANLIB = ranlib

SYS = nag

SP_KIND = 4
DP_KIND = 8
KINDS = \$(SP_KIND) \$(DP_KIND)

LDFLAGS =
INCFLAGS=
COMP_LIBS =
LIBS =

FPPFLAGS = \$(DEFS_PREFIX)-DFC_HAVE_ABORT

# MPI requirement:
FPPFLAGS += -DMPI

# flook
INCFLAGS += -I$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/flook/$FLOOK_VERSION/include
LDFLAGS += -L$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/flook/$FLOOK_VERSION/lib -Wl,-rpath=$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/flook/$FLOOK_VERSION/lib
LIBS += -lflookall -ldl
COMP_LIBS += libfdict.a
FPPFLAGS += -DSIESTA__FLOOK

# netcdf
INCFLAGS += -I$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/netcdf/$NC_VERSION/include
LDFLAGS += -L$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/zlib/$ZLIB_VERSION/lib -Wl,-rpath=$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/zlib/$ZLIB_VERSION/lib
LDFLAGS += -L$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/hdf5/$HDF_FULL_VERSION/lib -Wl,-rpath=$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/hdf5/$HDF_FULL_VERSION/lib
LDFLAGS += -L$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/netcdf/$NC_VERSION/lib -Wl,-rpath=$SIESTA_DIR/siesta-$SIESTA_FULL_VERSION/Docs/build/netcdf/$NC_VERSION/lib
LIBS += -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz
COMP_LIBS += libncdf.a libfdict.a
FPPFLAGS += -DCDF -DNCDF -DNCDF_4

# openblas
LDFLAGS += -L$OPENBLAS_DIR/lib -Wl,-rpath=$OPENBLAS_DIR/lib
LIBS += -lopenblas_nonthreaded

# ScaLAPACK (required only for MPI build)
LDFLAGS += -L$SCALAPACK_DIR/lib -Wl,-rpath=$SCALAPACK_DIR/lib
LIBS += -lscalapack

# Dependency rules ---------

FFLAGS_DEBUG = -g -O1

# The atom.f code is very vulnerable. Particularly the Intel compiler
# will make an erroneous compilation of atom.f with high optimization
# levels.
atom.o: atom.F
	\$(FC) -c \$(FFLAGS_DEBUG) \$(INCFLAGS) \$(FPPFLAGS) \$(FPPFLAGS_fixed_F) $<
.c.o:
	\$(CC) -c \$(CFLAGS) \$(INCFLAGS) \$(CPPFLAGS) $<
.F.o:
	\$(FC) -c \$(FFLAGS) \$(INCFLAGS) \$(FPPFLAGS) \$(FPPFLAGS_fixed_F) $<
.F90.o:
	\$(FC) -c \$(FFLAGS) \$(INCFLAGS) \$(FPPFLAGS) \$(FPPFLAGS_free_F90) $<
.f.o:
	\$(FC) -c \$(FFLAGS) \$(INCFLAGS) \$(FCFLAGS_fixed_f) $<
.f90.o:
	\$(FC) -c \$(FFLAGS) \$(INCFLAGS) \$(FCFLAGS_free_f90) $<
EOF
