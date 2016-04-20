/* ------------------------------------------------------------ */
/*
Coucal, Cuckoo hashing-based hashtable with stash area.
Copyright (C) 2013-2014 Xavier Roche and other contributors
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "coucal.h"

static size_t fsize(const char *s) {
  struct stat st;

  if (stat(s, &st) == 0 && S_ISREG(st.st_mode)) {
    return st.st_size;
  } else {
    return (size_t) -1;
  }
}

static int coucal_test(const char *snum) {
  unsigned long count = 0;
  const char *const names[] = {
    "", "add", "delete", "dry-add", "dry-del",
    "test-exists", "test-not-exist"
  };
  const struct {
    enum {
      DO_END,
      DO_ADD,
      DO_DEL,
      DO_DRY_ADD,
      DO_DRY_DEL,
      TEST_ADD,
      TEST_DEL
    } type;
    size_t modulus;
    size_t offset;
  } bench[] = {
    { DO_ADD, 4, 0 },     /* add 4/0 */
    { TEST_ADD, 4, 0 },   /* check 4/0 */
    { TEST_DEL, 4, 1 },   /* check 4/1 */
    { TEST_DEL, 4, 2 },   /* check 4/2 */
    { TEST_DEL, 4, 3 },   /* check 4/3 */
    { DO_DRY_DEL, 4, 1 }, /* del 4/1 */
    { DO_DRY_DEL, 4, 2 }, /* del 4/2 */
    { DO_DRY_DEL, 4, 3 }, /* del 4/3 */
    { DO_ADD, 4, 1 },     /* add 4/1 */
    { DO_DRY_ADD, 4, 1 }, /* add 4/1 */
    { TEST_ADD, 4, 0 },   /* check 4/0 */
    { TEST_ADD, 4, 1 },   /* check 4/1 */
    { TEST_DEL, 4, 2 },   /* check 4/2 */
    { TEST_DEL, 4, 3 },   /* check 4/3 */
    { DO_ADD, 4, 2 },     /* add 4/2 */
    { DO_DRY_DEL, 4, 3 }, /* del 4/3 */
    { DO_ADD, 4, 3 },     /* add 4/3 */
    { DO_DEL, 4, 3 },     /* del 4/3 */
    { TEST_ADD, 4, 0 },   /* check 4/0 */
    { TEST_ADD, 4, 1 },   /* check 4/1 */
    { TEST_ADD, 4, 2 },   /* check 4/2 */
    { TEST_DEL, 4, 3 },   /* check 4/3 */
    { DO_DEL, 4, 0 },     /* del 4/0 */
    { DO_DEL, 4, 1 },     /* del 4/1 */
    { DO_DEL, 4, 2 },     /* del 4/2 */
    /* empty here */
    { TEST_DEL, 1, 0 },   /* check */
    { DO_ADD, 4, 0 },     /* add 4/0 */
    { DO_ADD, 4, 1 },     /* add 4/1 */
    { DO_ADD, 4, 2 },     /* add 4/2 */
    { DO_DEL, 42, 0 },    /* add 42/0 */
    { TEST_DEL, 42, 0 },  /* check 42/0 */
    { TEST_ADD, 42, 2 },  /* check 42/2 */
    { DO_END }
  };
  char *buff = NULL;
  const char **strings = NULL;

  /* produce random patterns, or read from a file */
  if (sscanf(snum, "%lu", &count) != 1) {
    const size_t size = fsize(snum);
    FILE *fp = fopen(snum, "rb");
    if (fp != NULL) {
      buff = malloc(size);
      if (buff != NULL && fread(buff, 1, size, fp) == size) {
        size_t capa = 0;
        size_t i, last;
        for(i = 0, last = 0, count = 0 ; i < size ; i++) {
          if (buff[i] == 10 || buff[i] == 0) {
            buff[i] = '\0';
            if (capa == count) {
              if (capa == 0) {
                capa = 16;
              } else {
                capa <<= 1;
              }
              strings = (const char **) realloc((void*) strings, capa*sizeof(char*));
            }
            strings[count++] = &buff[last];
            last = i + 1;
          }
        }
      }
      fclose(fp);
    }
  }

  /* successfully read */
  if (count > 0) {
    coucal hashtable = coucal_new(0);
    size_t loop;
    for(loop = 0 ; bench[loop].type != DO_END ; loop++) {
      size_t i;
      for(i = bench[loop].offset ; i < (size_t) count
          ; i += bench[loop].modulus) {
        int result;
        char buffer[256];
        const char *name;
        const long expected = (long) i * 1664525 + 1013904223;
        if (strings == NULL) {
          snprintf(buffer, sizeof(buffer),
            "http://www.example.com/website/sample/for/hashtable/"
            "%ld/index.html?foo=%ld&bar",
            (long) i, (long) (expected));
          name = buffer;
        } else {
          name = strings[i];
        }
        if (bench[loop].type == DO_ADD
            || bench[loop].type == DO_DRY_ADD) {
          size_t k;
          result = coucal_write(hashtable, name, (uintptr_t) expected);
          for(k = 0 ; k < /* stash_size*2 */ 32 ; k++) {
            (void) coucal_write(hashtable, name, (uintptr_t) expected);
          }
          /* revert logic */
          if (bench[loop].type == DO_DRY_ADD) {
            result = result ? 0 : 1;
          }
        }
        else if (bench[loop].type == DO_DEL
            || bench[loop].type == DO_DRY_DEL) {
          size_t k;
          result = coucal_remove(hashtable, name);
          for(k = 0 ; k < /* stash_size*2 */ 32 ; k++) {
            (void) coucal_remove(hashtable, name);
          }
          /* revert logic */
          if (bench[loop].type == DO_DRY_DEL) {
            result = result ? 0 : 1;
          }
        }
        else if (bench[loop].type == TEST_ADD
            || bench[loop].type == TEST_DEL) {
          intptr_t value = -1;
          result = coucal_readptr(hashtable, name, &value);
          if (bench[loop].type == TEST_ADD && result
              && value != expected) {
            fprintf(stderr, "value failed for %s (expected %ld, got %ld)\n",
                    name, (long) expected, (long) value);
            return EXIT_FAILURE;
          }
          /* revert logic */
          if (bench[loop].type == TEST_DEL) {
            result = result ? 0 : 1;
          }
        }
        if (!result) {
          fprintf(stderr, "failed %s{%d/+%d} test on loop %ld"
                  " at offset %ld for %s\n",
                  names[bench[loop].type],
                  (int) bench[loop].modulus,
                  (int) bench[loop].offset,
                  (long) loop, (long) i, name);
          return EXIT_FAILURE;
        }
      }
    }
    coucal_delete(&hashtable);
    fprintf(stderr, "all hashtable tests were successful!\n");
    return EXIT_SUCCESS;
  } else {
    fprintf(stderr, "Malformed number\n");
    return EXIT_FAILURE;
  }
}

int main(int argc, char **argv) {
  if (argc == 2) {
    return coucal_test(argv[1]);
  } else {
    fprintf(stderr, "usage: %s [number-of-tests | keys-filename]\n", argv[0]);
    return EXIT_FAILURE;
  }
}
