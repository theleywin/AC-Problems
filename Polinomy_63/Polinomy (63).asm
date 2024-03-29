%include "io.inc"

section .data
x db 2
n dd 3
array db 1 , 2 , 4
section .text
global main
main:
    mov ebp, esp; for correct debugging

    mov esi , array ; esi = index = 0
    mov al , [esi] 
    cwde
    mov ebx , eax ; result += array[0]
    mov al , [x] ; eax = x = pow
    cwde 
    mov ecx , 1 ; [ecx] = index = pow
    inc esi ; index++ 
    cmp dword [n] , 1
    je end
    ; Evaluate array[index]
    Eval:
        push ebx ; Save actual sum
        push eax ; Save actual pow
        mov al , [esi]
        cwde
        mov ebx , eax ; Get coefficient
        pop eax ; restore pow
        push eax ; save pow
        mul dword ebx  ; array[index] * pow(x , index)
        mov edx , eax  ; edx =  array[index] * pow(x , index)
        pop eax ; restore pow
        pop ebx ; restore current sum
        add ebx , edx ; sum = sum + array[index] * pow(x , index)
        push ebx ; save actual sum
        mov ebx , eax 
        mov al , [x]
        cwde
        mul dword ebx ; eax = pow = pow * x
        pop ebx ; restore sum
        inc esi ; index++
        inc ecx ; 
        cmp ecx , [n] ; if index < n then jump Eval else jump end
        je end       
        jmp Eval              
    end:
    PRINT_DEC 4 , ebx ; Print result
    xor eax, eax
    ret