CC = gcc
CFLAGS = -Wall -Wextra -Iinclude

TARGET = bin/client

SRC = src/main.c src/mystrfunctions.c src/myfilefunctions.c

OBJ = obj/main.o obj/mystrfunctions.o obj/myfilefunctions.o


all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(TARGET)

obj/main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

obj/mystrfunctions.o: src/mystrfunctions.c
	$(CC) $(CFLAGS) -c src/mystrfunctions.c -o obj/mystrfunctions.o

obj/myfilefunctions.o: src/myfilefunctions.c
	$(CC) $(CFLAGS) -c src/myfilefunctions.c -o obj/myfilefunctions.o

clean:
	rm -f $(OBJ) $(TARGET)