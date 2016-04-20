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

/*
 * Sample: String => String hashtable.
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "coucal.h"

int main(int argc, char **argv) {
  int i;
  coucal hashtable;
  struct_coucal_enum enumerator;
  coucal_item *item;

  if (argc == 1 || ( argc % 2 ) != 1 ) {
    printf("usage: %s [key value] ..\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  /* Create a new hashtable with default settings */
  hashtable = coucal_new(0);
  assert(hashtable != NULL);

  /* Fill hashtable */
  for(i = 1 ; i < argc ; i += 2) {
    coucal_write_pvoid(hashtable, argv[i], argv[i + 1]);
  }
  printf("stored %zu keys\n", coucal_nitems(hashtable));

  /* Check we have the items */
  printf("Checking keys:\n");
  for(i = 1 ; i < argc ; i += 2) {
    void *value = NULL;
    if (!coucal_read_pvoid(hashtable, argv[i], &value)) {
      assert(! "hashtable internal error!");
    }
    printf("%s=%s\n", argv[i], (const char*) value);
  }

  /* Enumerate */
  enumerator = coucal_enum_new(hashtable);
  printf("Enumerating keys:\n");
  while((item = coucal_enum_next(&enumerator)) != NULL) {
    printf("%s=%s\n", (const char*) item->name, (const char*) item->value.ptr);
  }

  /* Delete hashtable */
  coucal_delete(&hashtable);

  return EXIT_SUCCESS;
}

