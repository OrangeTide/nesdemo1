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
### game3
##############################################################################

GAME3_SRCS:=game3.s boot.s 
GAME3_OBJS:=$(patsubst %.s,%.o,$(GAME3_SRCS:%.c=%.o))
GAME3_EXEC:=game3.nes
GAME3_PRG:=game3.prg
GAME3_CHR:=game3.chr

CLEAN_LIST+=$(GAME3_OBJS) $(GAME3_EXEC) $(GAME3_PRG)

all :: $(GAME3_EXEC)

$(GAME3_PRG) : $(GAME3_OBJS)

$(GAME3_EXEC) : NESCOMBINE_FLAGS=-m 0
$(GAME3_EXEC) : $(GAME3_PRG) $(GAME3_CHR)
