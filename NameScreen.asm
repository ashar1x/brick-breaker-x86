; NameScreen.asm  -  Player Name Input Screen
.386
.data

; ── Colors (Original Text Colors on Black Background) ────────────────────────
NS_CLR_BG    EQU (black * 16)
NS_CLR_TTL   EQU (yellow       + NS_CLR_BG)
NS_CLR_HDR   EQU (lightGreen   + NS_CLR_BG)
NS_CLR_TXT   EQU (lightCyan    + NS_CLR_BG)
NS_CLR_INP   EQU (yellow       + NS_CLR_BG)
NS_CLR_FTR   EQU (lightRed     + NS_CLR_BG)
NS_CLR_BOX   EQU (white        + (blue * 16))

; Clean ASCII Art (Corrected: BRICK BREAKER)
; Clean ASCII Art (Corrected: BRICK BREAKER)
ns_a1 BYTE "  ____   _        _ __   __ _____ ____    _   _    _    __  __  _____  ", 0
ns_a2 BYTE " |  _ \ | |      / \\ \ / /| ____|  _ \  | \ | |  / \  |  \/  || ____| ", 0
ns_a3 BYTE " | |_) || |     / _ \\ V / |  _| | |_) | |  \| | / _ \ | |\/| ||  _|   ", 0
ns_a4 BYTE " |  __/ | |___ / ___ \| |  | |___|  _ <  | |\  |/ ___ \| |  | || |___  ", 0
ns_a5 BYTE " |_|    |_____/_/   \_\_|  |_____|_| \_\ |_| \_/_/   \_\_|  |_||_____| ", 0

; Input box border pieces
ns_bTop  BYTE 0C9h, 40 DUP(0CDh), 0BBh, 0
ns_bMid  BYTE 0BAh, 40 DUP(020h), 0BAh, 0
ns_bBot  BYTE 0C8h, 40 DUP(0CDh), 0BCh, 0

ns_askMsg   BYTE "Enter your name: ", 0
ns_errMsg   BYTE "Name cannot be empty!", 0
ns_bgLine    BYTE 80 DUP(' '), 0
ns_cursorCol BYTE 38  ; 19 (box) + 1 (border) + 17 (prompt) + 1 = 38

.code

NameScreen PROC
    pushad
    
    ; Reset screen to black background
    mov eax, lightGray + NS_CLR_BG
    call SetTextColor
    call Clrscr

    ; Fill entire screen with black background
    mov eax, lightGray + NS_CLR_BG
    call SetTextColor
    mov ecx, 25
    mov dh, 0
ns_fillBG:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET ns_bgLine
    call WriteString
    inc dh
    loop ns_fillBG

    ; Draw ASCII Art
    mov dh, 4
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET ns_a1
    mov eax, (lightRed + NS_CLR_BG)
    call SetTextColor
    call WriteString

    mov dh, 5
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET ns_a2
    mov eax, (lightGreen + NS_CLR_BG)
    call SetTextColor
    call WriteString

    mov dh, 6
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET ns_a3
    mov eax, (yellow + NS_CLR_BG)
    call SetTextColor
    call WriteString

    mov dh, 7
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET ns_a4
    mov eax, (white + NS_CLR_BG)
    call SetTextColor
    call WriteString

    mov dh, 8
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET ns_a5
    mov eax, (lightMagenta + NS_CLR_BG)
    call SetTextColor
    call WriteString

    ; Draw Input Box (at row 12, col 19)
    mov eax, NS_CLR_BOX
    call SetTextColor

    mov dh, 12
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET ns_bTop
    call WriteString

    mov dh, 13
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET ns_bMid
    call WriteString

    mov dh, 14
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET ns_bBot
    call WriteString

    ; (Second Input Box removed)

ns_inputLoop:
    ; Clear input field area inside the box
    mov eax, NS_CLR_BOX
    call SetTextColor
    mov dh, 13
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET ns_bMid
    call WriteString

    ; Write prompt inside box
    mov dh, 13
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET ns_askMsg
    call WriteString

    ; Initialize length and reset name buffer
    mov PlayerNameLen, 0
    mov BYTE PTR [PlayerName], 0

ns_readLoop:
    mov eax, 50
    call Delay
    call ReadKey
    jz ns_readLoop

    ; Check Enter (0Dh)
    cmp al, 0Dh
    je ns_enterKey

    ; Check Backspace (08h)
    cmp al, 08h
    je ns_backspaceKey

    ; Check if printable (>= 32 and <= 126)
    cmp al, 32
    jl ns_readLoop
    cmp al, 126
    jg ns_readLoop

    ; Check length limit (max 14)
    mov ebx, PlayerNameLen
    cmp ebx, 14
    jge ns_readLoop

    ; Store character
    mov [PlayerName + ebx], al
    inc PlayerNameLen

    ; Echo character at correct position
    mov ebx, PlayerNameLen
    dec ebx
    movzx edx, bl
    add dl, 37
    mov dh, 13
    call Gotoxy
    mov al, [PlayerName + ebx]
    call WriteChar
    jmp ns_readLoop

ns_backspaceKey:
    mov ebx, PlayerNameLen
    cmp ebx, 0
    je ns_readLoop

    ; Decrement length
    dec PlayerNameLen
    mov ebx, PlayerNameLen
    mov BYTE PTR [PlayerName + ebx], 0

    ; Position cursor to the deleted char column, erase it, then reposition
    movzx edx, bl
    add dl, 37
    mov dh, 13
    call Gotoxy
    mov al, ' '
    call WriteChar
    ; reposition cursor back
    movzx edx, bl
    add dl, 37
    mov dh, 13
    call Gotoxy

    jmp ns_readLoop

ns_enterKey:
    ; Null terminate
    mov ebx, PlayerNameLen
    mov BYTE PTR [PlayerName + ebx], 0

    cmp PlayerNameLen, 0
    jne ns_done

    ; Show error
    mov eax, NS_CLR_FTR
    call SetTextColor
    mov dh, 15
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET ns_errMsg
    call WriteString
    mov eax, 1000
    call Delay
    jmp ns_inputLoop

    ; After name is entered, move to Bricks input
    jmp ns_done

ns_done:
    ; Reset colors before returning
    mov eax, lightGray + NS_CLR_BG
    call SetTextColor
    call Clrscr

    popad
    ret
NameScreen ENDP