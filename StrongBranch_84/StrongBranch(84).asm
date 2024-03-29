%include "io.inc"

section .data

k dw 26
n dw 15
array dw 1 , 2 , 3 , 4 , 5 , 6 , 7 , 21 , 31 , 7 , 9 , 8 , 2 , 5 , 14
section .bss

maxValue resd 1

section .text
global main
main:
    mov ebp, esp; for correct debugging
     
    mov esi , array ; index = 0 
    mov eax , 0 
    mov [maxValue] , eax ; maxValue = 0 
    mov ax , [esi] ; array[0] = root
    CWDE 
    push eax ; eax -> parameter of StrongBranch(param1)
    mov ecx , 0 ; ecx = index 
    push ecx
    mov ebx , 0 ; ebx = currentSum = 0 
    ; node.sum -> sum of all nodes
    call StrongBranch ; StrongBranch(root)
    pop ecx
    pop eax
    jmp printResult
    
    StrongBranch:
        push ebp
        mov ebp , esp
        sub esp , 4 ; var sumValueL -> tree.left.sum
        
        mov eax , [ebp + 12] ; eax = node.value
        cmp eax , -1 
        je .end ; if node.value = -1 then return 0
        mov ax , [n]
        CWDE
        cmp ecx , eax ; if index >= n then return 0
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
   
        call StrongBranch ; StrongBranch(node.left)
       
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
 
        mov [ebp - 4] , ebx ; sumValueL = tree.left.sum 
        mov ebx , 0 
        call StrongBranch ; StrongBranch(node.right)
        pop ecx ; restore index
        pop eax ; clean stack
        
        mov eax , [ebp - 4] ; eax = sumValueL
        add eax , [ebp + 12] ; eax += node.value
        add eax , ebx ; eax += node.right.sum
        mov ebx , eax ; ebx = node.value + node.left.sum + node.right.sum
        mov ax , [k]
        CWDE 
        cmp ebx , eax
        jnae .selectNode 
        ; if node.sum < k
        ; then jump selectNode
        ; else return
        mov ebx , eax
        jmp .end ; return node.sum
            .selectNode:
                cmp ebx , [maxValue]
                ja .updateMaxValue
                ;if node.sum > maxValue & node.sum < k
                ;then maxValue = node.sum
                ;else return 
                jmp .end ; return node.sum
            .updateMaxValue:
                mov [maxValue] , ebx ; maxValue = node.sum
                jmp .end
            .end:
                mov esp , ebp
                pop ebp
                ret
    printResult:
        PRINT_DEC 4 , [maxValue]
    ret