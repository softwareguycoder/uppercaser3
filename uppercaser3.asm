;   Executable name         : uppercaser3
;   Version                 : 1.0
;   Created date            : 28 Dec 2018
;   Last update             : 28 Dec 2018
;   Author                  : Brian Hart
;   Description             : A simple program in assembly for Linux, using NASM,
;                             demonstrating the logic to take the text in a static buffer
;                             (which has been set in the .data section) and turn all its letters
;                             into uppercase, where applicable
;
;   Run it this way:
;       ./uppercaser3
;
;   Build using these commands:
;       nasm -f elf64 -g -F stabs uppercaser3.asm
;       ld -o uppercaser3 uppercaser3.o
;
SECTION     .bss                        ; Section contaning uninitialized data
      
SECTION     .data                       ; Section containing initialized data
        WelcomeMsg: db "*** Welcome to UPPERCASER3! ***",0xA,"Where we will take an internal static buffer and convert it to uppercase.",0xA,0xA
        WelcomeLen: equ $-WelcomeMsg
        
        BufferIsMsg: db "Buffer contents are: "
        BufferIsLen: equ $-BufferIsMsg

        Buff: db "Hello, world!",0xA    ; Text buffer itself
        BUFFLEN: equ $-Buff             ; Length of the buffer
        
        NewLine: db 0xA                 ; New line char to make an empty line on the screen
        NewLineLen: equ $-NewLine       ; Length of the new line char (1 byte)
        
        ; Print a message to the screen letting the user know we are working
        OperatingMsg: db "Converting the internal buffer to UPPERCASE...",0xA,0xA
        OperatingMsgLen: equ $-OperatingMsg

SECTION     .text                       ; Section containing code

global      _start

_start:
        nop                         ; This no-op keeps gdb happy...
        
; Print the Welcome message to the screen
PrintWelcome:
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Output
        mov ecx, WelcomeMsg         ; Pass address of the WelcomeMsg
        mov edx, WelcomeLen         ; Length of the WelcomeMsg
        int 80h                     ; Make sys_write kernel call
        
; Print out the contents of the buffer before we operate
PrintBuffer1:
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Output
        mov ecx, BufferIsMsg        ; Pass address of the BufferIsMsg prompt
        mov edx, BufferIsLen        ; Length of the BufferIsMsg prompt
        int 80h                     ; Make sys_write kernel call
        
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Output
        mov ecx, Buff               ; Pass address of the Buff
        mov edx, BUFFLEN            ; Length of the Buff
        int 80h                     ; Make sys_write kernel call

; Print an extra new line char to the screen to give us some breathing room      
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Output
        mov ecx, NewLine            ; Pass address of the NewLine buffer
        mov edx, NewLineLen         ; Length of the NewLine buffer
        int 80h                     ; Make sys_write kernel call

; Print out a message telling the user we are processing the program:
PrintOperatingMsg:
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Input
        mov ecx, OperatingMsg       ; Pass address of the OperatingMsg buffer
        mov edx, OperatingMsgLen    ; Length of the OperatingMsgLen buffer
        int 80h                     ; Make sys_write kernel call

SetUp:        
; Set up registers to scan the Buff
        mov esi, BUFFLEN            ; Save the length of the buffer into ESI for safekeeping
        mov ecx, esi                ; Place the number of bytes in the buffer into ECX
        mov ebp, Buff               ; Place the address of the buffer into EBP
        dec ebp                     ; Adjust count to offset
        
; Go through the buffer and convert lowercase to uppercase characters:
Scan:
        cmp byte [ebp+ecx], 61h     ; Test input char against lowercase 'a'
        jb Next                     ; If below 'a' in ASCII chart, not lowercase
        cmp byte [ebp+ecx], 7Ah     ; Test input char against lowercase 'z'
        ja Next                     ; If above 'z' in ASCII chart, not lowercase
                                    ; At this point, we have a lowercase char
        sub byte [ebp+ecx], 20h     ; Subtract 20h to give uppercase...
Next:
        dec ecx                     ; Decrement counter
        jnz Scan                    ; If characters remain, loop back
        
; Write the buffer full of processed text to STDOUT:
Write:    
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Input
        mov ecx, BufferIsMsg        ; Pass address of the BufferIsMsg prompt
        mov edx, BufferIsLen        ; Length of the BufferIsMsg prompt
        int 80h                     ; Make sys_write kernel call
        
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Input
        mov ecx, Buff               ; Pass address of the Buff
        mov edx, BUFFLEN            ; Length of the Buff
        int 80h                     ; Make sys_write kernel call

        ; Print an extra new line char to the screen to give us some breathing room      
        mov eax, 4                  ; Specify sys_write call
        mov ebx, 1                  ; Specify File Descriptor 1: Standard Input
        mov ecx, NewLine            ; Pass address of the NewLine buffer
        mov edx, NewLineLen         ; Length of the NewLine buffer
        int 80h                     ; Make sys_write kernel call
        
; All done! Let's end this party...
Done:
        mov eax, 1                  ; Code for Exit Syscall
        mov ebx, 0                  ; Return a code of zero
        int 80h                     ; Make sys_exit kernel call
        
              
      