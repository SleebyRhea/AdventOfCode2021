#include "../adventofcode.h"

#define __INPUT_FILE  "input/day1_depths.input"

typedef struct slidingdoor
{
  long long a;
  long long b;
  long long c;
} slidingdoor;

void castAway(char *word, slidingdoor *door, long long *count);

slidingdoor* slidingdoor_init();
        void slidingdoor_push(slidingdoor *door, long long value);
   long long slidingdoor_sum(slidingdoor *door);


int main()
{
  if ( !(access(__INPUT_FILE, F_OK) == 0) )
    { fprintf(stderr, "failed to open file %s\n",__INPUT_FILE); exit(1); }

  long long count   = 0; 
  slidingdoor *door = slidingdoor_init();

  char c;
  char *word = NULL;
  char points = 0;

  FILE *file;
  file = fopen( __INPUT_FILE, "r");

  while ( !feof(file) )
  { c = fgetc(file);

    if (word == NULL)
      { word = calloc(0, __STRING_START_SIZE); }

    if (c == '\n' || c == ' ' || c == '\t')
    {
      castAway(word, door, &count);
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
 * @brief Creates a new sliding door and initializes all members to -1
 * 
 * @param door 
 * @return slidingdoor* 
 */
slidingdoor* slidingdoor_init()
{
  slidingdoor *d = calloc(1, sizeof(slidingdoor));
  
  d->a = 0;
  d->b = 0;
  d->c = 0;

  return d;
}


/**
 * @brief Push a value onto the slidingdoor stack
 * 
 * @param door 
 * @param value 
 */
void slidingdoor_push(slidingdoor *door, long long value)
{
  door->c = door->b;
  door->b = door->a;
  door->a = value;
}


/**
 * @brief Return the sum of all members of a slidingdoor
 * 
 * @param door 
 * @return long long 
 */
long long slidingdoor_sum(slidingdoor *door)
{
  if ( !door->a || !door->b || !door->c )
    { return 0; }
  return door->a + door->b + door->c; 
}


/**
 * @brief Push a value onto the slidingdoor stack
 * 
 * @param word  String to atoll()
 * @param slidingdoor The stack we're working with
 * @param count Pointer to Current count
 * 
 * @return long long  New depth
 */
void castAway(char *word, slidingdoor *door, long long *count)
{
  long long willItNumber, previousSum, newSum;
  long long newCount = 0;
  willItNumber = atoll(word);

  // It did indeed long long
  if (willItNumber > 0 || strcmp(word,__ZERO))
  {
    previousSum = slidingdoor_sum(door);
    slidingdoor_push(door, willItNumber);
    newSum = slidingdoor_sum(door);

    if ( newSum && previousSum && (newSum > previousSum) )
      { newCount = *count + 1; *count = newCount; }
  }
}