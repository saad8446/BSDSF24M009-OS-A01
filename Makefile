CC = gcc
CFLAGS = -Wall -Wextra -Iinclude
PICFLAGS = -fPIC

LIB = lib/libmyutils.so
TARGET = bin/client_dynamic

PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
MANDIR = $(PREFIX)/share/man/man3

OBJ = obj/main.o obj/mystrfunctions.o obj/myfilefunctions.o

all: $(TARGET)

$(LIB): obj/mystrfunctions.o obj/myfilefunctions.o
	$(CC) -shared obj/mystrfunctions.o obj/myfilefunctions.o -o $(LIB)

$(TARGET): obj/main.o $(LIB)
	$(CC) $(CFLAGS) obj/main.o -Llib -lmyutils -o $(TARGET)

obj/main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

obj/mystrfunctions.o: src/mystrfunctions.c
	$(CC) $(CFLAGS) $(PICFLAGS) -c src/mystrfunctions.c -o obj/mystrfunctions.o

obj/myfilefunctions.o: src/myfilefunctions.c
	$(CC) $(CFLAGS) $(PICFLAGS) -c src/myfilefunctions.c -o obj/myfilefunctions.o

install: $(TARGET)
	install -d $(BINDIR)
	install -d $(LIBDIR)
	install -d $(MANDIR)
	install -m 755 $(TARGET) $(BINDIR)/client
	install -m 755 $(LIB) $(LIBDIR)/libmyutils.so
	install -m 644 man/man3/*.3 $(MANDIR)/
	ldconfig

clean:
	rm -f $(OBJ) $(LIB) $(TARGET)