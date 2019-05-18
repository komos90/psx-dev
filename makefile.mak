# ----------------------------
# PlayStation 1 Psy-Q MAKEFILE
# ----------------------------
all:
	ccpsx -O0 -Xo$80010000 main.s -omain.cpe,main.sym,mem.map
	cpe2x /ca main.cpe

clean:
	del mem.map
	del main.sym
	del main.exe
	del main.cpe
	cls