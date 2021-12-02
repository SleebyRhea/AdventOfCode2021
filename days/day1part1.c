#include "../adventofcode.h"

#define __INPUT_FILE  "input/day1_depths.input"
#define __ZERO        "0"

long long castAway(char *word, long long depth, long long *count);

/**
 * @brief Get the count of times the next depth was greater than the last
 *  Pretty bad implementation overall. Only works with ASCII code points,
 *  bare C, etc etc
 * 
 * @return int 
 */
int main()
{
  if ( !(access(__INPUT_FILE, F_OK) == 0) )
    { fprintf(stderr, "failed to open file %s\n",__INPUT_FILE); exit(1); }

  long long count = -1;
  long long depth = 0;

  char c;
  char *word = NULL;
  char points = 0;

  FILE *file;
  file = fopen( __INPUT_FILE, "r");

  printf("Starting ...\n");
  while ( !feof(file) )
  { c = fgetc(file);

    if (word == NULL)
      { word = calloc(0, __STRING_START_SIZE); }

    if (c == '\n' || c == ' ' || c == '\t')
    {
      depth  = castAway(word, depth, &count);
      points = 0;
      free(word);
        word = NULL;
      continue;
    }
    
    if ( points+1 > strlen(word) )
      { word = realloc(word, strlen(word) * 2); }

    word[points] = c;
    points++;
  }

  fprintf(stdout, "%llu\n", count);
}

/**
 * @brief Cast word into the depths
 * 
 * @param word 
 * @param depth 
 * @param count 
 * 
 * @return long long 
 */
long long castAway(char *word, long long depth, long long *count)
{
#ifdef __DEBUG
  fprintf(stderr, "castAway(_,_,_): casting the word %s into a long long\n", word);
#endif

  long long willItNumber;
  long long newCount = 0;
  willItNumber = atoll(word);

  // It did indeed long long
  if (willItNumber > 0 || strcmp(word,__ZERO))
  {
#ifdef __DEBUG
    fprintf(stderr, "castAway(_,_,_): it made a long long (%llu) :)\n", willItNumber);
    fprintf(stderr, "castAway(_,_,_): testing the depths of (%llu) :)\n", depth);
    fprintf(stderr, "castAway(_,_,_): testing the count of (%llu) :)\n", *count);
#endif
    if ( willItNumber > depth )
    { 
#ifdef __DEBUG
      fprintf(stderr, "castAway(_,_,_): Its bigger than the last depth!\n");
#endif
      newCount = *count + 1; *count = newCount;
    }
    return willItNumber;
  }

  return depth;
}
