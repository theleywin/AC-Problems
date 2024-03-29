%include "io.inc"

section .data

n dd 11
array dd 44 , 3 , 5 , 6 , 1 , 89 , 89, 3 , 1 , 10 , 1

section .text

global main

main:
    mov ebp, esp; for correct debugging
    
    
    mov eax , 0 ; eax = i = 0
  
    for1:
        inc eax ; i = i + 1
        cmp eax , [n] ; 
        je printArray ; if i + 1 == n then jump printArray else jump for2
        dec eax ; i = i + 1 - 1 = i
        mov ecx , [n] ; ecx = n - i - 1
        sub ecx , eax ; |
        dec ecx       ; |
        inc eax       ; i++
        mov esi , array ; esi = j = 0
        ;jmp for2 
        for2:
            mov ebx , [esi + 4] ; ebx = array[j+1]
            mov edx , [esi] ; edx = array[j]
            cmp edx , ebx 
            jnl next ; if !(array[j] < array[j+1]) then jump next else sort
            mov [esi] , ebx ; array[j] = ebx = array[j+1]
            mov [esi + 4] , edx ; array[j+1] = edx = array[j*]
            ;jmp next
                next:
                add esi , 4 ; j++
                loop for2 ; if j < n - i - 1 then jump for2 else jump for1
                jmp for1 ; jump for1
    printArray:    
        ; print(array)
        mov ecx , [n] ; ecx = n
        mov esi , array ; esi = index = 0 
        PRINT_STRING "[ "
        while:
            PRINT_DEC 4 , [esi] ; print(array[index])
            PRINT_STRING " "
            add esi , 4 ; index++
            dec ecx ; 
            cmp ecx , 0
            jne while ; if index < n then jump while else end
        PRINT_STRING "]"   
    xor eax, eax
    ret