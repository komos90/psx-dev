import math

N = 0x100
l = [int(math.sin(((2.0 * math.pi) / N) * i) * 0x1000) for i in range(0x0, N)]

for i in range(0x0, N, 0x1):
    print(".halfword 0x{0:04X} ; 0x{1:02X}".format(l[i], i))