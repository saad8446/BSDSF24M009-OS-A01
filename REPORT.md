# Operating Systems Programming Assignment – 01

## libmyutils: C Utility Library

**Student Name:** Muhammad Saad
**Email:** [msaaad8484@gmail.com](mailto:msaaad8484@gmail.com)
**Repository:** BSDSF24M009-OS-A01

---

# Feature 1: Project Scaffolding and Version Control

## Overview

In Feature 1, I created the basic structure of the project and placed the project under Git version control.

The project contains the following main directories:

```text
src/
include/
lib/
bin/
obj/
```

The purpose of these directories is:

* `src/` – contains C source files.
* `include/` – contains header files.
* `lib/` – contains compiled libraries.
* `bin/` – contains executable programs.
* `obj/` – contains object files created during compilation.

Git and GitHub were used to track the project and its development.

---

# Feature 2: Multi-file Project Using Make Utility

## Question 1: Explain the linking rule `$(TARGET): $(OBJECTS)`. How does it differ from a Makefile rule that links against a library?

The rule:

```makefile
$(TARGET): $(OBJECTS)
```

means that the final executable depends on all the object files.

For example:

```text
main.o
mystrfunctions.o
myfilefunctions.o
        ↓
     linked together
        ↓
      client
```

The linker takes the object files and combines them to create the final executable.

In our Feature 2 Makefile, the object files were directly linked together.

When linking against a library, the Makefile uses a library such as:

```text
libmyutils.a
```

or:

```text
libmyutils.so
```

Instead of directly linking every utility object file, the main program is linked against the library.

For example:

```makefile
$(TARGET): obj/main.o $(LIB)
```

So the main difference is that Feature 2 directly links the individual object files, while the library versions link the main object file with a pre-built library.

---

## Question 2: What is a Git tag and why is it useful? What is the difference between a simple tag and an annotated tag?

A Git tag is a name given to a specific commit.

For example:

```text
v0.1.1-multifile
v0.2.1-static
v0.3.1-dynamic
v0.4.1-final
```

Tags are useful because they mark important versions of a project. This makes it easy to identify and return to a particular stable version.

There are two common types of tags:

### Simple/Lightweight Tag

A lightweight tag is basically a name pointing to a commit.

It contains very little additional information.

### Annotated Tag

An annotated tag contains additional information such as:

* tag name
* tag message
* tagger information
* date

We used annotated tags in this assignment, for example:

```bash
git tag -a v0.4.1-final -m "Feature 5: Final documentation and installation"
```

---

## Question 3: What is the purpose of creating a Release on GitHub? What is the significance of attaching binaries?

A GitHub Release provides a clear published version of the project based on a Git tag.

For example, a release can represent:

```text
Version 0.3.1
```

Users can download the files associated with that version.

Attaching binaries means providing already-compiled files such as:

```text
bin/client
bin/client_static
bin/client_dynamic
lib/libmyutils.a
lib/libmyutils.so
```

This is useful because users do not have to compile the source code themselves before using the provided binary.

---

# Feature 3: Creating and Using a Static Library

## Question 1: Compare the Makefile from Part 2 and Part 3. What are the key differences that enable creation of a static library?

In Feature 2, the Makefile directly linked the object files:

```text
main.o
mystrfunctions.o
myfilefunctions.o
```

to create the executable.

In Feature 3, the utility object files were first placed inside a static library:

```text
lib/libmyutils.a
```

The important rule was:

```makefile
$(LIB): obj/mystrfunctions.o obj/myfilefunctions.o
	ar rcs $(LIB) obj/mystrfunctions.o obj/myfilefunctions.o
```

Then the main program was linked with the library:

```makefile
$(TARGET): obj/main.o $(LIB)
	$(CC) $(CFLAGS) obj/main.o $(LIB) -o $(TARGET)
```

Therefore, Feature 3 introduced an additional library-building step before linking the final executable.

---

## Question 2: What is the purpose of the `ar` command? Why is `ranlib` often used after it?

The `ar` command is used to create and manage archive files.

In our project, we used it to create:

```text
lib/libmyutils.a
```

For example:

```bash
ar rcs lib/libmyutils.a obj/mystrfunctions.o obj/myfilefunctions.o
```

The `.a` file is a static library containing object files.

`ranlib` is traditionally used to create or update the archive's symbol index. Modern versions of `ar` with the `s` option usually create the index automatically.

Therefore, `ranlib` may be used separately when the symbol index needs to be generated or updated.

---

## Question 3: When you run `nm` on `client_static`, are symbols such as `mystrlen` present? What does this tell you about static linking?

Yes, functions such as:

```text
mystrlen
mystrcpy
mystrncpy
mystrcat
```

can appear in the symbol information of the static executable.

This happens because the required code from the static library is copied into the final executable during linking.

Therefore, the executable contains the required library code itself.

This demonstrates an important property of static linking:

```text
Static library
      ↓
code copied into executable
      ↓
client_static
```

---

# Feature 4: Creating and Using a Dynamic Library

## Question 1: What is Position-Independent Code (`-fPIC`) and why is it required for shared libraries?

`-fPIC` means **Position-Independent Code**.

It tells the compiler to create machine code that can work correctly regardless of where the shared library is loaded into memory.

A shared library may be loaded at different memory addresses by different programs.

Therefore, the library code should not depend on one fixed memory location.

In our Makefile we used:

```makefile
PICFLAGS = -fPIC
```

and compiled the library source files using:

```makefile
$(CC) $(CFLAGS) $(PICFLAGS) -c src/mystrfunctions.c -o obj/mystrfunctions.o
```

and similarly for `myfilefunctions.c`.

Then the object files were used to create:

```text
lib/libmyutils.so
```

---

## Question 2: Explain the difference in file size between the static and dynamic clients. Why does this difference exist?

The static client contains the required library code inside the executable.

The dynamic client does not contain the complete library code. Instead, it contains information telling the operating system to load the shared library:

```text
libmyutils.so
```

Therefore, the dynamic executable can be smaller because the library code remains in the separate `.so` file.

The basic difference is:

```text
Static:

client_static
    ↓
contains library code


Dynamic:

client_dynamic
    ↓
uses separate
libmyutils.so
```

The exact size difference depends on the compiler, linker, and contents of the program.

---

## Question 3: What is `LD_LIBRARY_PATH`? Why was it necessary and what does this tell us about the dynamic loader?

`LD_LIBRARY_PATH` is an environment variable that tells the Linux dynamic loader where it should search for shared libraries.

Our library was located inside our project:

```text
./lib/libmyutils.so
```

When we first tried to run:

```bash
./bin/client_dynamic
```

the operating system did not automatically know where our custom shared library was located.

We could therefore run:

```bash
LD_LIBRARY_PATH=./lib ./bin/client_dynamic
```

This temporarily told the loader to also search the project's `lib` directory.

We also used:

```bash
ldd bin/client_dynamic
```

to check the shared-library dependencies.

This demonstrates that dynamic linking requires the operating system's dynamic loader to locate the required `.so` file when the program starts.

---

# Feature 5: Man Pages and Installation

## Implementation

For Feature 5, I created manual pages for all six functions:

```text
mystrlen
mystrcpy
mystrncpy
mystrcat
wordCount
mygrep
```

The pages are stored in:

```text
man/man3/
```

Each page contains the required sections:

* `.TH`
* `.SH NAME`
* `.SH SYNOPSIS`
* `.SH DESCRIPTION`
* `.SH AUTHOR`

I also added an `install` target to the Makefile.

The installation places:

```text
client
```

in:

```text
/usr/local/bin/
```

the shared library in:

```text
/usr/local/lib/
```

and the man pages in:

```text
/usr/local/share/man/man3/
```

After installation, I was able to run:

```bash
client
```

directly from the terminal.

I also tested the manual pages using commands such as:

```bash
man mystrlen
man mygrep
```

This confirmed that the program and its documentation were installed successfully.

---

# Git Workflow and Versions

During the project, separate branches were used for the different features:

```text
main
multifile-build
static-build
dynamic-build
man-pages
```

The project was developed feature by feature and the completed branches were merged into the main branch.

The important version tags were:

```text
v0.1.1-multifile
v0.2.1-static
v0.3.1-dynamic
v0.4.1-final
```

GitHub Releases were also created for the different versions according to the assignment requirements.

---

# Conclusion

This assignment helped me understand how a C project is developed from multiple source files into executable programs and libraries.

I learned the difference between:

```text
Object files
Static libraries
Dynamic libraries
```

I also learned how Makefiles automate compilation and linking.

The project demonstrated the difference between static and dynamic linking using:

```text
libmyutils.a
libmyutils.so
```

I also practiced Git branches, commits, tags, and GitHub Releases.

Finally, I created Linux man pages and an installation target so that the program could be installed and executed using:

```bash
client
```

and its documentation could be accessed using:

```bash
man mystrlen
```

This completed the complete development, build, documentation, and version-control workflow for the project.
