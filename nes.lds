MEMORY {
	ZP: start = $0, size = $100, type = rw;
	RAM: start = $0200, size = $0600, type = rw;
	ROM: start = $c000, size = $8000, type = ro, file = %O;
}

SEGMENTS {
	ZEROPAGE: load = ZP, type = zp;
	DATA: load = ROM, run = RAM, type = rw, define = yes, align = $100;
	BSS: load = RAM, type = bss, define = yes, align = $100;
	CODE: load = ROM, type = ro, align = $100;
	RODATA: load = ROM, type = ro, align = $100;
	VECTORS: load = ROM, type = ro, start = $fffa;
}

FILES {
	%O: format = bin;
}
