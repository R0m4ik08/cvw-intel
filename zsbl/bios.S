#include "system.h"

.section .init
.global _start
.type _start, @function
	
_start:
	
	li x1, 0
	li x2, 0
	li x4, 0
	li x5, 0
	li x6, 0
	li x7, 0
	li x8, 0
	li x9, 0
	li x10, 0
	li x11, 0
	li x12, 0
	li x13, 0
	li x14, 0
	li x15, 0

	jal x0, _zsbl_main

end_of_bios:	

	


