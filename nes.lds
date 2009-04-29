MEMORY {
	ZP: start = $10, size = $f0, type = rw;
	HEADER: start = $7f00, size = $10, type = ro, file = %O;
	RAM: start = $0300, size = $0400, type = rw;
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
