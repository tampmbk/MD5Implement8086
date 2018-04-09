#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#define LEFTROTATE(x, c) (((x) << (c)) | ((x) >> (32 - (c))))

int main(){
	uint32_t a = 0xa11c3bf7;
	uint32_t r = 17;
	printf("rotateLeft(%x  , %d) = %x\n", a, r,LEFTROTATE((a), r));

}
