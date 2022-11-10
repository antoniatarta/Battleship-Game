.386
.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Vaporase",0
area_width EQU 640  
area_height EQU 580  
area DD 0

counter DD 0 

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc

start_x EQU 70
start_y EQU 145
size_width EQU 500
size_height EQU 400

x db 0
y db 0
coltx dd 0
colty dd 0
ratari dd 0
succes dd 0
parti dd 25
over db 0
win db 0
variabila1 db 0
format DB "%d ", 0
culoare dd 0000CCh

m db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
  db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  
.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb: ;nu alb 
	mov dword ptr [edi],  0808080h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

line_horizontal macro x, y, len, color 
local linie
	mov EAX, y
	mov EBX, area_width
	mul EBX
	add EAX, x
	mov EBX, 4 
	mul EBX		;shl EAX,2
	add EAX, area
	mov ECX, len
	linie:
		mov dword ptr[EAX], color
		add EAX, 4
		loop linie
endm

line_vertical macro x, y, len, color 
local linie
	mov EAX, y
	mov EBX, area_width
	mul EBX
	add EAX, x
	mov EBX, 4 
	mul EBX		;shl EAX,2
	add EAX, area
	mov ECX, len
	linie:
		mov dword ptr[EAX], color
		add EAX, 4*area_width
		loop linie
endm

albastru proc 
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
		line_vertical coltx,colty,50,0000CCh
		add coltx,1
	ret 0
albastru endp

rosu4 proc 
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
		line_vertical coltx,colty,50,0FF3333h
		add coltx,1
	ret 0
rosu4 endp

rosu2 proc 
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
		line_vertical coltx,colty,50,990000h
		add coltx,1
	ret 0
rosu2 endp

rosu3 proc 
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
		line_vertical coltx,colty,50,330000h
		add coltx,1
	ret 0
rosu3 endp


rosu5 proc 
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
		line_vertical coltx,colty,50,0FF0000h
		add coltx,1
	ret 0
rosu5 endp


; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 128
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	xor EBX,EBX
	xor ECX,ECX
	mov EBX, [EBP+arg2] ;pt x
	mov ECX, [EBP+arg3] ;pt y
	cmp EBX,start_x
	jl cont
	cmp EBX,size_width+start_x
	jg cont
	cmp ECX,start_y
	jl cont
	cmp ECX,size_height+start_y
	jg cont
	
	sub EBX, start_x
	xor EAX,EAX
	xor EDX,EDX
	mov EAX,EBX
	xor ECX,ECX
	mov ECX,50
	div ECX
	mov EBX,EAX
	inc EBX
	mov x, BL
	
	xor EBX,EBX
	mov EBX, [EBP+arg3]
	sub EBX, start_y
	xor EAX,EAX
	xor EDX,EDX
	mov EAX,EBX
	xor ECX,ECX
	mov ECX,50
	div ECX
	mov EBX,EAX
	inc EBX
	mov y, BL
	
	xor EAX,EAX
	mov AL,y
	xor EBX, EBX
	mov BL,12
	mul BL
	add AL, x
	
    mov EDX,EAX	
   
	xor EAX,EAX
	xor EBX,EBX
	dec x
	mov AL,x
	mov BL,50
	mul BL
	xor EBX,EBX
	mov BL,start_x
	add EAX, EBX
	xor EBX,EBX
	mov BL,1
	add EAX, EBX
		
	xor ECX,ECX
	mov ECX,EAX
		
	xor EAX,EAX
	xor EBX,EBX
	dec y
	mov AL,y
	mov BL,50
	mul BL
	xor EBX,EBX
	mov BL,start_y
	add EAX, EBX
	xor EBX,EBX
	mov BL,1
	add EAX, EBX
	mov coltx,ECX
	mov colty,EAX
	
	cmp win,0
	jne afisare_litere
	
	cmp over,0
	jne afisare_litere
	
	cmp m[EDX],1
	je cont  
	
	cmp m[EDX],2
	je doi
	
	cmp m[EDX],3
	je trei
	
	cmp m[EDX],4
	je patru
	
	cmp m[EDX],5
	je cinci
	
	ratare:
		inc ratari
		mov m[EDX],1
		call albastru
		jmp cont
	doi:
		inc succes
		dec parti
		mov m[EDX],1
		call rosu2
		jmp cont
	trei:
		inc succes
		dec parti
		mov m[EDX],1
		call rosu3
		jmp cont
	patru:
		inc succes
		dec parti
		mov m[EDX],1
		call rosu4
		jmp cont
	cinci:
		inc succes
		dec parti
		mov m[EDX],1
		call rosu5
		jmp cont	

	cont:
	
evt_timer:
	inc counter
	
afisare_litere:
	make_text_macro 'V', area, 260, 30
	make_text_macro 'A', area, 270, 30
	make_text_macro 'P', area, 280, 30
	make_text_macro 'O', area, 290, 30
	make_text_macro 'R', area, 300, 30
	make_text_macro 'A', area, 310, 30
	make_text_macro 'S', area, 320, 30
	make_text_macro 'E', area, 330, 30
	
	make_text_macro 'A', area, 600, 550
	make_text_macro 'T', area, 610, 550
	
	cmp ratari,55
	jne g_win
	cmp win,0
	jne g_win
	inc over
	make_text_macro 'G', area, 300, 80
	make_text_macro 'A', area, 310, 80
	make_text_macro 'M', area, 320, 80
	make_text_macro 'E', area, 330, 80
	make_text_macro 'O', area, 350, 80
	make_text_macro 'V', area, 360, 80
	make_text_macro 'E', area, 370, 80
	make_text_macro 'R', area, 380, 80
	make_text_macro 'G', area, 310, 100
	make_text_macro 'A', area, 320, 100
	make_text_macro 'M', area, 330, 100
	make_text_macro 'E', area, 340, 100
	make_text_macro 'O', area, 360, 100
	make_text_macro 'V', area, 370, 100
	make_text_macro 'E', area, 380, 100
	make_text_macro 'R', area, 390, 100
	make_text_macro 'G', area, 320, 120
	make_text_macro 'A', area, 330, 120
	make_text_macro 'M', area, 340, 120
	make_text_macro 'E', area, 350, 120
	make_text_macro 'O', area, 370, 120
	make_text_macro 'V', area, 380, 120
	make_text_macro 'E', area, 390, 120
	make_text_macro 'R', area, 400, 120
	
	g_win:
	cmp succes,25
	jne play
	cmp over,0
	jne play
	inc win
	make_text_macro 'W', area, 300, 80
	make_text_macro 'I', area, 310, 80
	make_text_macro 'N', area, 320, 80
	make_text_macro 'W', area, 350, 80
	make_text_macro 'I', area, 360, 80
	make_text_macro 'N', area, 370, 80
	make_text_macro 'W', area, 400, 80
	make_text_macro 'I', area, 410, 80
	make_text_macro 'N', area, 420, 80
	make_text_macro 'W', area, 330, 100
	make_text_macro 'I', area, 340, 100
	make_text_macro 'N', area, 350, 100
	make_text_macro 'W', area, 380, 100
	make_text_macro 'I', area, 390, 100
	make_text_macro 'N', area, 400, 100
	make_text_macro 'W', area, 300, 120
	make_text_macro 'I', area, 310, 120
	make_text_macro 'N', area, 320, 120
	make_text_macro 'W', area, 350, 120
	make_text_macro 'I', area, 360, 120
	make_text_macro 'N', area, 370, 120
	make_text_macro 'W', area, 400, 120
	make_text_macro 'I', area, 410, 120
	make_text_macro 'N', area, 420, 120
	 
	play:
	mov ebx, 10
	mov eax, parti
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 200, 120
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 190, 120
	 
	mov ebx, 10
	mov eax, ratari
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 150, 100
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 140, 100
	 
	mov ebx, 10
	mov eax, succes
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 160, 80
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 150, 80
	
	make_text_macro 'P', area, 70, 120
	make_text_macro 'A', area, 80, 120
	make_text_macro 'R', area, 90, 120
	make_text_macro 'T', area, 100, 120
	make_text_macro 'I', area, 110, 120
	
	make_text_macro 'V', area, 130, 120
	make_text_macro 'A', area, 140, 120
	make_text_macro 'P', area, 150, 120
	make_text_macro 'O', area, 160, 120
	make_text_macro 'R', area, 170, 120

	make_text_macro 'R', area, 70, 100
	make_text_macro 'A', area, 80, 100
	make_text_macro 'T', area, 90, 100
	make_text_macro 'A', area, 100, 100
	make_text_macro 'R', area, 110, 100
	make_text_macro 'I', area, 120, 100
	
	make_text_macro 'S', area, 70, 80
	make_text_macro 'U', area, 80, 80
	make_text_macro 'C', area, 90, 80
	make_text_macro 'C', area, 100, 80
	make_text_macro 'E', area, 110, 80
	make_text_macro 'S', area, 120, 80

	final:
	line_horizontal start_x, start_y, size_width, 000066h
	line_vertical start_x, start_y, size_height, 000066h
	line_horizontal start_x, start_y+size_height, size_width, 000066h
	line_vertical start_x+size_width, start_y, size_height, 000066h

	line_vertical start_x+50, start_y, size_height, 000066h
	line_vertical start_x+100, start_y, size_height, 000066h
	line_vertical start_x+150, start_y, size_height, 000066h
	line_vertical start_x+200, start_y, size_height, 000066h
	line_vertical start_x+250, start_y, size_height, 000066h
	line_vertical start_x+300, start_y, size_height, 000066h
	line_vertical start_x+350, start_y, size_height, 000066h
	line_vertical start_x+400, start_y, size_height, 000066h
	line_vertical start_x+450, start_y, size_height, 000066h
	
	line_horizontal start_x, start_y+50, size_width, 000066h
	line_horizontal start_x, start_y+100, size_width, 000066h
	line_horizontal start_x, start_y+150, size_width, 000066h
	line_horizontal start_x, start_y+200, size_width, 000066h
	line_horizontal start_x, start_y+250, size_width, 000066h
	line_horizontal start_x, start_y+300, size_width, 000066h
	line_horizontal start_x, start_y+350, size_width, 000066h
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

random proc
	push EAX
	rdtsc
	mov EBX,107
	xor EDX, EDX
	div EBX
	pop EAX
	ret 0
random endp

; reset proc ;punem gardul de 1
	; push 80
	; push 0
	; push offset m
	; call memset
	; add ESP,12
	; ret 0
; reset endp

show macro n
LOCAL s1
	xor EAX, EAX
	mov AL, n
	push EAX
	push offset format
	call printf
	add ESP,8
endm

vapor5 proc 
	stv5:
	call random
	mov EAX,EDX
	mov ECX,5
	et_verif_v5:
	cmp m[EAX],0
	jne stv5
	add EAX,12
	loop et_verif_v5
	mov ECX,5
	et_v5:
	mov m[EDX],5
	add EDX,12
	loop et_v5
	ret 0
vapor5 endp

vapor4 proc 
	stv4:
	call random 
	mov EAX,EDX
	mov ECX,4
	et_verif_v4:
	cmp m[EAX],0
	jne stv4
	inc EAX
	loop et_verif_v4
	mov ECX, 4
	et_v4:
	mov m[EDX],4
	inc EDX
	loop et_v4
	ret 0
vapor4 endp

vapor3 proc 
	stv3:
	call random
	mov EAX,EDX
	mov ECX,3
	et_verif_v3:
	cmp m[EAX],0
	jne stv3
	add EAX,12
	loop et_verif_v3
	mov ECX,3
	et_v3:
	mov m[EDX],3
	add EDX,12
	loop et_v3
	ret 0
vapor3 endp

vapor2 proc 
	stv2:
	call random 
	mov EAX,EDX
	mov ECX,2
	et_verif_v2:
	cmp m[EAX],0
	jne stv2
	inc EAX
	loop et_verif_v2
	mov ECX, 2
	et_v2:
	mov m[EDX],2
	inc EDX
	loop et_v2
	ret 0
vapor2 endp
	
vaporase proc
	call vapor5
	call vapor4
	call vapor4
	call vapor5
	call vapor3
	call vapor2 
	call vapor2
	ret 0
vaporase endp

start:

	call vaporase

	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
 	 
	;call reset
	
	;terminarea programului
	push 0
	call exit
end start
