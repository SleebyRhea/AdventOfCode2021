#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define __STRING_START_SIZE 1000
#define __DEBUG 1


/**
 * @brief Debugging print function
 * 
 * @param string 
 */
void debug(char *string)
{
#ifdef __DEBUG
  printf("%s\n", string);
#endif
}

/**
 * @brief Quickly get the size of a file
 * 
 * @param f The file handle we are getting the size of
 * @return long 
 */
long howBigIsThis(FILE *f)
{
  fpos_t *pos = malloc(sizeof(fpos_t));
  long long size;

  fgetpos(f, pos);
  fseek(f, 0, SEEK_END);
  size = ftell(f);
  fsetpos(f, pos);
  free(pos);

  return size;
}