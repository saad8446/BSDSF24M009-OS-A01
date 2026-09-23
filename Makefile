CC = gcc
CFLAGS = -Wall -Wextra -Iinclude

LIB = lib/libmyutils.a
TARGET = bin/client_static

OBJ = obj/main.o obj/mystrfunctions.o obj/myfilefunctions.o

all: $(TARGET)

$(LIB): obj/mystrfunctions.o obj/myfilefunctions.o
	ar rcs $(LIB) obj/mystrfunctions.o obj/myfilefunctions.o

$(TARGET): obj/main.o $(LIB)
	$(CC) $(CFLAGS) obj/main.o $(LIB) -o $(TARGET)

obj/main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

obj/mystrfunctions.o: src/mystrfunctions.c
	$(CC) $(CFLAGS) -c src/mystrfunctions.c -o obj/mystrfunctions.o

obj/myfilefunctions.o: src/myfilefunctions.c
	$(CC) $(CFLAGS) -c src/myfilefunctions.c -o obj/myfilefunctions.o

clean:
	rm -f $(OBJ) $(LIB) $(TARGET)