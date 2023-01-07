#pmake/50: build os_osi os_nt os_os2 os_dos os_linux cpu_386

host_os  = osi
host_cpu = 386

!ifndef WATCOM
WATCOM= \watcom
!endif

watcom_dir=../watcom

proj_name       = orl
orl_autodepends = .autodepend

!ifndef DEBUG
DEBUG=0
!endif

!if $(DEBUG)
cflags = -od -d2 -w3 -D_INT_DEBUG
OUTD= ../build/osi386LD
!else
cflags = -ox -s -DNDEBUG
OUTD= ../build/osi386LR
!endif

#
#  List of orl library object files
#

omf_objs =  $(OUTD)/omfload.obj &
            $(OUTD)/omfmunge.obj &
            $(OUTD)/omfentr.obj &
            $(OUTD)/omfflhn.obj &
            $(OUTD)/omfdrctv.obj

elf_objs  = $(OUTD)/elfentr.obj &
            $(OUTD)/elflwlv.obj &
            $(OUTD)/elfflhn.obj &
            $(OUTD)/elfload.obj

coff_objs = $(OUTD)/coffentr.obj &
            $(OUTD)/cofflwlv.obj &
            $(OUTD)/coffflhn.obj &
            $(OUTD)/coffload.obj &
            $(OUTD)/coffimpl.obj

orl_objs  = $(OUTD)/orlentry.obj &
            $(OUTD)/orlflhnd.obj &
            $(OUTD)/orlhash.obj &
            $(omf_objs) &
            $(elf_objs) &
            $(coff_objs)

.c{$(OUTD)}.obj: $($(proj_name)_autodepends)
	$(WATCOM)/binl/wcc386 -q -zc -bc -bt=linux $(cflags) $(inc_dirs) -fo$@ $[@

.c: ./c;./elf/c;./coff/c;./omf/c
.h: ./h;./elf/h;./coff/h;./omf/h

inc_dirs = -Ih -Ielf/h -Icoff/h -Iomf/h -I../h -I$(watcom_dir)/h -I$(WATCOM)/h

ALL : $(OUTD) $(OUTD)/orl.lib

$(OUTD):
	@if not exist $(OUTD) mkdir $(OUTD)

$(OUTD)/orl.lib : $(orl_objs)
	@%create $^&.lbc
	@for %i in ($(orl_objs)) do @%append $^&.lbc +%i
	jwlib -n $(OUTD)/orl.lib $(libflags) @$^&.lbc
