#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define __STRING_START_SIZE 1000
#define __ZERO              "0"
//#define __DEBUG  1


typedef struct vector
{
  uint64_t x;
  uint64_t y;
  uint64_t z;
} vec3;

/**
 * @brief Create a new instance of Vec3 and malloc it to 0
 * 
 * @param x 
 * @param y 
 * @param z 
 * @return vec3* 
 */
vec3 * vec3_new(uint64_t x, uint64_t y, uint64_t z)
{
  vec3 *v = calloc(1, sizeof(vec3));
  v->x = 0;
  v->y = 0;
  v->z = 0;
  return v;
}

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

int isNumber(char *query)
{
  if (atoll(query) || !strcmp(query, __ZERO))
    { return 1; }
  return 0;
}