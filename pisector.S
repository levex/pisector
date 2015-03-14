; Author: Levente Kurusa <levex@fedoraproject.org>
;                        <levex@linux.com>
; Have a wonderful Pi-Day! 3/14/15 9:26:53am/pm

[org 0x7C00]

main:
	; bootstrap the code
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov esp, 0x9000 ; setup the stack

	; start by setting up the FPU
	mov edx, cr0
	and edx, ~(0x0000000C)
	mov cr0, edx
	fninit
	fnstsw [fpu_status]
	cmp WORD [fpu_status], 0x0000
	je nofpu
	; okay, we have the FPU ready!


inf_loop:
	jmp inf_loop

nofpu:
	mov si, nofpu_str
	call print_str
	jmp inf_loop

print_str:
	lodsb
	or al, al
	jz _print_str_done
	mov ah, 0Eh
	int 10h
	jmp print_str
	_print_str_done:
		ret


current_value: db 0x00 ; the digit we will print
current_it: dd 0x00000000 ; the number of the digit we will calculate

fpu_status: dw 0x0000

nofpu_str: db "No FPU found!", 0x0D, 0x0A, 0x00
number: db "0123456789ABCDEF"

times 510-($-$$) db 0
dw 0xAA55
