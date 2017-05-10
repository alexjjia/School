CC = gcc
CFLAGS = -Wall
NAME = mystery

build: mystery.o
	$(CC) $(CFLAGS) mystery.o -o $(NAME)

mystery.o: mystery.c
	$(CC) $(CFLAGS) -c mystery.c

clean:
	rm -f mystery.o $(NAME)
