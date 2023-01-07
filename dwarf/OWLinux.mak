
proj_name = dwarfw

!ifndef WATCOM
WATCOM=\watcom
!endif

!ifndef DEBUG
DEBUG=0
!endif

!if $(DEBUG)
outd_suffix=D
!else
outd_suffix=R
!endif

OUTD=../build/osi386L$(outd_suffix)


!ifndef dwarfw_autodepends
dwarfw_autodepends = .AUTODEPEND
!endif

objs = $(OUTD)/dwlngen.obj $(OUTD)/dwutils.obj

watcom_dir=../watcom

.c : c

inc_dirs = -Ih -I$(watcom_dir)/h -I$(WATCOM)/h

cflags = -ox -s -DNDEBUG

extra_c_flags =

.c{$(OUTD)}.obj: $($(proj_name)_autodepends)
	$(WATCOM)/binl/wcc386 -q -zc -bc -bt=linux $(cflags) $(extra_c_flags_$[&) $(inc_dirs) -fo$@ $[@

ALL: $(OUTD) $(OUTD)/dw.lib

$(OUTD):
	@if not exist $(OUTD) mkdir $(OUTD)

$(OUTD)/dw.lib : $(objs)
        @%create tmp.lbc
        @for %i in ($(objs)) do @%append tmp.lbc +%i
        jwlib -n $(OUTD)/dw.lib @tmp.lbc

