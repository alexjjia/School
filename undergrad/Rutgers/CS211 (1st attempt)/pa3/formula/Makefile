CC = gcc
CFLAGS = -Wall
NAME = formula

build: formula.o nCr.o
	$(CC) $(CFLAGS) formula.o nCr.o -o $(NAME)

formula.o: formula.c
	$(CC) $(CFLAGS) -c formula.c

nCr.o: nCr.s
	$(CC) $(CFLAGS) -c nCr.c

nCr.s: nCr.c
	$(CC) nCr.c -S -o nCr.s

clean:
	rm -f formula.o nCr.o $(NAME)
