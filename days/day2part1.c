#include "../adventofcode.h"

#define __INPUT_FILE  "input/day1_depths.input"
#define __UP            "up"
#define __DOWN          "down"
#define __FORWARD       "forward"

typedef struct movement
{
  uint64_t magnitude;
  char     *direction;
} movement;

int processWord(char *word, vec3 *loc, movement *move);

int main()
{
  if ( !(access(__INPUT_FILE, F_OK) == 0) )
    { fprintf(stderr, "failed to open file %s\n",__INPUT_FILE); exit(1); }

  char c;
  char *word;
  vec3 *loc;
  movement *track;
  uint64_t points;

  FILE *file;
  file = fopen(__INPUT_FILE, "r");


  while (!feof(file))
  { c = fgetc(file);
    
    if (word == NULL)
      { word = calloc(0, __STRING_START_SIZE); }

    if (c == ' ' || c == '\t' || c == '\n' )
    {
      word[points] = '\0';
      processWord(word, &loc, &track);
      points = 0;
      free(word);
      continue;
    }

    if ( points+1 > strlen(word) )
      { word = realloc(word, strlen(word) * 2); }
    
    word[points] = c;
    points++;
  }

  // Emit X * Y to stdout
  fprintf(stdout, "%llu\n", (loc->x * loc->y));
}


/**
 * @brief 
 * 
 * @param word 
 * @param loc 
 * @param move 
 * 
 * @return int  If 1, time to process direction. If 0, else.
 */
int processWord(char *word, vec3 *loc, movement *move)
{
  if ( isNumber(word) )
    { move->magnitude = atoll(word); return 1; }

  int found = 0;
  switch (0)
  {
    case strcmp(word, __UP):
      { found++; break; }
    case strcmp(word, __DOWN):
      { found++; break; }
    case strcmp(word, __FORWARD):
      { found++; break; }
    default:
  }

  if (!found) { return 0; }
  
  move->direction = calloc(1, sizeof(word));
  strcpy(&move->magnitude, word);
  return 0;
}
