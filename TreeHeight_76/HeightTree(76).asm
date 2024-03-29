%include "io.inc"

section .data
n dd 17
array dw 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , -1 , 9 , 10 , -1 , -1 , -1 , 11 , 12 , 13

section .text
global main
main:
    mov ebp, esp; for correct debugging
   
    mov esi , array ; index = 0 
    mov ax , [esi] ; array[0] = root
    CWDE 
    push eax ; eax -> parameter of height(param1)
    mov ecx , 0 ; ecx = index 
    push ecx
    mov ebx , 0 ; ebx = h = 0 
    call height ; height(root)
    pop ecx
    pop eax
    jmp printHeight
    
    height:
        push ebp
        mov ebp , esp
        sub esp , 4 ; var hL -> tree.left.height
        
        mov eax , [ebp + 12] ; eax = node.value
        cmp eax , -1 
        je .end ; if node.value = -1 then return 0
        cmp ecx , [n] ; if index >= n then return 0
        jae .end
        
        mov eax , 4
        mul dword ecx
        add eax  , 2 
        ;eax = 4i + 2 -> index of node.left (dw)
        
        mov ax , [esi + eax] 
        CWDE
        ;eax = array[4i+2]
        push eax  ; eax = paramater = node.left.value
        
        mov eax , 2
        mul dword ecx
        add eax , 1
        ;eax = 2i + 1 -> index of node.left (db)
        push ecx ; Save current index
        mov ecx , eax ; index = 2i + 1
   
        call height ; height(node.left)
       
        pop ecx ; restore index
        pop eax ; clean stack
        
        mov eax , 4
        mul dword ecx
        add eax  , 4
        ;eax = 4i + 4 -> index of node.right (dw)
        
        mov ax , [esi + eax] 
        CWDE 
        ;eax = array[4i+4]
        push eax ; eax = parameter = node.right.value
        
        mov eax , 2
        mul dword ecx
        add eax , 2   
        ;eax = 2i + 2 -> index of node.right (db)          
        push ecx ; Save current index
        mov ecx , eax ; index = 2i + 2
 
        mov [ebp - 4] , ebx ; hL = tree.left.height
        mov ebx , 0 
        call height ; height(node.right)
        pop ecx ; restore index
        pop eax ; clean stack
        
        mov eax , [ebp - 4] ; eax = hL
        cmp eax , ebx
        jae .selectLeftNode 
        ; if node.left.height >= node.right.height 
        ; then jump selectLeftNodeHeight
        ; else selectRightNodeHeight
        add ebx , 1
        jmp .end ; return node.right.height + 1
            .selectLeftNode:
                inc eax 
                mov ebx , eax
                jmp .end ; return node.left.height + 1
            .end:
                mov esp , ebp
                pop ebp
                ret
    printHeight:
        PRINT_DEC 4 , ebx
    xor eax, eax
    ret