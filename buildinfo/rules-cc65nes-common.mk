AS.target=ca65
LD.target=ld65

%.nes : $(TARGET_DIR)/%.prg %.chr
	nescombine -o $@ $(NESCOMBINE_FLAGS) $^

%.nes : $(TARGET_DIR)/%.prg
	nescombine -o $@ $(NESCOMBINE_FLAGS) $^

%.prg : %.o
	$(LD.target) -o $@ -C nes.lds $^

%.chr : %.png
	pngtochr -o $@ $^

$(TARGET_DIR)/%.o : %.s
	@mkdir -p $(TARGET_DIR)
	$(AS.target) -o $@ $^

$(TARGET_DIR)/%-pal.o : %.s
	@mkdir -p $(TARGET_DIR)
	$(AS.target) -o $@ -D PAL=1 $^
