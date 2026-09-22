#include <stdio.h>
#include <stdlib.h>

#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

int main()
{
    printf("--- Testing String Functions ---\n");

    char source[] = "Hello";
    char destination[100];

    printf("mystrlen(\"%s\") = %d\n",
           source, mystrlen(source));

    mystrcpy(destination, source);
    printf("mystrcpy = %s\n", destination);

    mystrncpy(destination, "Operating System", 10);
    destination[10] = '\0';
    printf("mystrncpy = %s\n", destination);

    mystrcpy(destination, "Hello ");
    mystrcat(destination, "World");
    printf("mystrcat = %s\n", destination);


    printf("\n--- Testing File Functions ---\n");

    FILE* file = fopen("test.txt", "r");

    if (file == NULL)
    {
        printf("Could not open test.txt\n");
        return 1;
    }

    int lines;
    int words;
    int chars;

    if (wordCount(file, &lines, &words, &chars) == 0)
    {
        printf("Lines: %d\n", lines);
        printf("Words: %d\n", words);
        printf("Characters: %d\n", chars);
    }

    fclose(file);


    file = fopen("test.txt", "r");

    if (file == NULL)
    {
        printf("Could not open test.txt\n");
        return 1;
    }

    char** matches = NULL;

    int count = mygrep(file, "OS", &matches);

    if (count >= 0)
    {
        printf("Lines containing \"OS\": %d\n", count);

        for (int i = 0; i < count; i++)
        {
            printf("%s", matches[i]);
            free(matches[i]);
        }

        free(matches);
    }

    fclose(file);

    return 0;
}