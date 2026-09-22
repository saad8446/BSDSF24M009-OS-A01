#include "../include/myfilefunctions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int wordCount(FILE* file, int* lines, int* words, int* chars)
{
    int c;
    int in_word = 0;

    if (file == NULL || lines == NULL || words == NULL || chars == NULL)
    {
        return -1;
    }

    *lines = 0;
    *words = 0;
    *chars = 0;

    while ((c = fgetc(file)) != EOF)
    {
        (*chars)++;

        if (c == '\n')
        {
            (*lines)++;
        }

        if (isspace(c))
        {
            in_word = 0;
        }
        else if (!in_word)
        {
            (*words)++;
            in_word = 1;
        }
    }

    return 0;
}

int mygrep(FILE* fp, const char* search_str, char*** matches)
{
    char buffer[1024];
    int count = 0;
    char** result = NULL;

    if (fp == NULL || search_str == NULL || matches == NULL)
    {
        return -1;
    }

    while (fgets(buffer, sizeof(buffer), fp) != NULL)
    {
        if (strstr(buffer, search_str) != NULL)
        {
            char** temp;

            temp = realloc(result, (count + 1) * sizeof(char*));

            if (temp == NULL)
            {
                for (int i = 0; i < count; i++)
                {
                    free(result[i]);
                }

                free(result);
                return -1;
            }

            result = temp;

            result[count] = malloc(strlen(buffer) + 1);

            if (result[count] == NULL)
            {
                for (int i = 0; i < count; i++)
                {
                    free(result[i]);
                }

                free(result);
                return -1;
            }

            strcpy(result[count], buffer);
            count++;
        }
    }

    *matches = result;

    return count;
}