# ----------------------------
# PlayStation 1 Psy-Q MAKEFILE
# ----------------------------
all:
	#del mem.map
	#del main.sym
	#del main.exe
	#del main.cpe
	#cls

	ccpsx -O0 -Xo$80010000 main.s -omain.cpe,main.sym,mem.map
	#ccpsx -O0 -Xo$80010000 main.c -S
	#asmpsx
	cpe2x /ca main.cpe
