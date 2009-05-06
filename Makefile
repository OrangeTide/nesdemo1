##############################################################################
## Makefile
##############################################################################

all ::

clean ::
	$(RM) $(CLEAN_LIST)

.PHONY : all clean

##############################################################################
## Remove default rules
##############################################################################

%.o : %.c

%.o : %.s

##############################################################################
## RULES & CONFIG
##############################################################################
CC=cc65
AS=ca65
LD=ld65

CFLAGS=-T -t nes

%.nes : %.prg %.chr
	nescombine -o $@ $(NESCOMBINE_FLAGS) $^

%.nes : %.prg
	nescombine -o $@ $(NESCOMBINE_FLAGS) $^

%.prg : %.o
	$(LD) -o $@ -C nes.lds $^

%.chr : %.png
	pngtochr -o $@ $^

%.o : %.s
	$(AS) $(ASFLAGS) -o $@ $^

%.s : %.c
	$(CC) $(CFLAGS) -o $@ $^

%-pal.o : %.s
	$(AS) -o $@ -D PAL=1 $^

.PRECIOUS : %.s

##############################################################################
## Targets
##############################################################################

##############################################################################
### nesdemo1
##############################################################################

NESDEMO1_SRCS:=nesdemo1.s
NESDEMO1_OBJS:=$(patsubst %.s,%.o,$(NESDEMO1_SRCS:%.c=%.o))
NESDEMO1_EXEC:=nesdemo1.nes
NESDEMO1_PRG:=nesdemo1.prg

CLEAN_LIST+=$(NESDEMO1_OBJS) $(NESDEMO1_EXEC) $(NESDEMO1_PRG)

all :: $(NESDEMO1_EXEC)

$(NESDEMO1_PRG) : $(NESDEMO1_OBJS)

$(NESDEMO1_EXEC) : NESCOMBINE_FLAGS=-m 2
$(NESDEMO1_EXEC) : $(NESDEMO1_PRG)

##############################################################################
### nesdemo2
##############################################################################

NESDEMO2_SRCS:=nesdemo2.s
NESDEMO2_OBJS:=$(patsubst %.s,%.o,$(NESDEMO2_SRCS:%.c=%.o))
NESDEMO2_EXEC:=nesdemo2.nes
NESDEMO2_PRG:=nesdemo2.prg
NESDEMO2_CHR:=nesdemo2.chr

CLEAN_LIST+=$(NESDEMO2_OBJS) $(NESDEMO2_EXEC) $(NESDEMO2_PRG)

all :: $(NESDEMO2_EXEC)

$(NESDEMO2_PRG) : $(NESDEMO2_OBJS)

$(NESDEMO2_EXEC) : NESCOMBINE_FLAGS=-m 0
$(NESDEMO2_EXEC) : $(NESDEMO2_PRG) $(NESDEMO2_CHR)

##############################################################################
### nesdemo3
##############################################################################

NESDEMO3_SRCS:=nesdemo3.s boot.s rand.s
NESDEMO3_OBJS:=$(patsubst %.s,%.o,$(NESDEMO3_SRCS:%.c=%.o))
NESDEMO3_EXEC:=nesdemo3.nes
NESDEMO3_PRG:=nesdemo3.prg
NESDEMO3_CHR:=nesdemo3.chr

CLEAN_LIST+=$(NESDEMO3_OBJS) $(NESDEMO3_EXEC) $(NESDEMO3_PRG)

all :: $(NESDEMO3_EXEC)

$(NESDEMO3_PRG) : $(NESDEMO3_OBJS)

$(NESDEMO3_EXEC) : NESCOMBINE_FLAGS=-m 0
$(NESDEMO3_EXEC) : $(NESDEMO3_PRG) $(NESDEMO3_CHR)
