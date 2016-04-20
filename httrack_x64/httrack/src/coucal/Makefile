###############################################################################
#
# "Cuckoo Hashtables"
#
###############################################################################

CFILES = coucal.c

all: gcc tests sample runtests

clean:
	rm -f *.o *.obj *.so* *.dll *.exe *.pdb *.exp *.lib sample tests

tar:
	rm -f coucal.tgz
	tar cvfz coucal.tgz coucal.txt coucal.c coucal.h Makefile LICENSE README.md

gcc:
	gcc -c -fPIC -O3 -g3 -pthread \
		-W -Wall -Wextra -Werror -Wno-unused-function \
		-D_REENTRANT -D_GNU_SOURCE \
		-DHTS_INTHASH_USES_MURMUR \
		$(CFILES)
	gcc -shared -fPIC -O3 -Wl,-O1 -Wl,--no-undefined \
		-rdynamic -shared -Wl,-soname=libcoucal.so \
		coucal.o -o libcoucal.so \
		-ldl -lpthread

tests:
	gcc -c -fPIC -O3 -g3 \
		-W -Wall -Wextra -Werror -Wno-unused-function \
		-D_REENTRANT \
		tests.c -o tests.o
	gcc -fPIC -O3 -Wl,-O1 \
		-lcoucal -L. \
		tests.o -o tests 

sample:
	gcc -c -fPIC -O3 -g3 \
		-W -Wall -Wextra -Werror -Wno-unused-function \
		-D_REENTRANT \
		sample.c -o sample.o
	gcc -fPIC -O3 -Wl,-O1 \
		-lcoucal -L. \
		sample.o -o sample

runtests:
	LD_LIBRARY_PATH=. ./tests 100000
