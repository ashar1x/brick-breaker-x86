; =============================================================================
; MainMenuScreen.asm  -  Main Menu Screen
; =============================================================================
.386
.data

; ── Colors (Original Colors on Black Background) ─────────────────────────────
MM_CLR_BG    EQU (black * 16)
MM_CLR_TTL   EQU (yellow       + MM_CLR_BG)
MM_CLR_HDR   EQU (lightGreen   + MM_CLR_BG)
MM_CLR_TXT   EQU (lightCyan    + MM_CLR_BG)
MM_CLR_UNSEL EQU (lightCyan    + MM_CLR_BG)
MM_CLR_SEL   EQU (black        + (lightMagenta * 16)) ; Highlighted selected
MM_CLR_INP   EQU (yellow       + MM_CLR_BG)
MM_CLR_FTR   EQU (lightRed     + MM_CLR_BG)

; Clean ASCII Art: MAIN MENU
mm_a1 BYTE "            __  __    _    ___ _   _    __  __ _____ _   _   _   _            ", 0
mm_a2 BYTE "           |  \/  |  / \  |_ _| \ | |  |  \/  | ____| \ | | | | | |          ", 0
mm_a3 BYTE "           | |\/| | / _ \  | ||  \| |  | |\/| |  _| |  \| | | | | |          ", 0
mm_a4 BYTE "           | |  | |/ ___ \ | || |\  |  | |  | | |___| |\  | | |_| |          ", 0
mm_a5 BYTE "           |_|  |_/_/   \_\___|_| \_|  |_|  |_|_____|_| \_|_\____/          ", 0

mm_menuHdr  BYTE ">>> SELECT AN OPTION <<<", 0

mm_opt1     BYTE "   Start Game     ", 0
mm_opt2     BYTE "   Instructions   ", 0
mm_opt3     BYTE "   High Scores    ", 0
mm_opt4     BYTE "   Exit           ", 0

mm_footer   BYTE "Use UP and DOWN arrows to navigate, ENTER to select.", 0
mm_bgLine   BYTE 80 DUP(' '), 0

mm_choice   DWORD 1

.code

MainMenuScreen PROC
    push ebx
    push ecx
    push edx
    push esi

    ; Reset screen to black background
    mov eax, lightGray + MM_CLR_BG
    call SetTextColor
    call Clrscr

    ; Fill entire screen with black background
    mov eax, lightGray + MM_CLR_BG
    call SetTextColor
    mov ecx, 25
    mov dh, 0
mm_fillBG:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET mm_bgLine
    call WriteString
    inc dh
    loop mm_fillBG

    ; Initialize choice to 1
    mov mm_choice, 1

    ; Draw ASCII art (Multi-colored like original)
    mov dh, 4
    mov dl, 1
    call Gotoxy
    mov eax, (lightRed + MM_CLR_BG)
    call SetTextColor
    mov edx, OFFSET mm_a1
    call WriteString

    mov dh, 5
    mov dl, 1
    call Gotoxy
    mov eax, (lightGreen + MM_CLR_BG)
    call SetTextColor
    mov edx, OFFSET mm_a2
    call WriteString

    mov dh, 6
    mov dl, 1
    call Gotoxy
    mov eax, (yellow + MM_CLR_BG)
    call SetTextColor
    mov edx, OFFSET mm_a3
    call WriteString

    mov dh, 7
    mov dl, 1
    call Gotoxy
    mov eax, (white + MM_CLR_BG)
    call SetTextColor
    mov edx, OFFSET mm_a4
    call WriteString

    mov dh, 8
    mov dl, 1
    call Gotoxy
    mov eax, (lightMagenta + MM_CLR_BG)
    call SetTextColor
    mov edx, OFFSET mm_a5
    call WriteString

    ; Menu header
    mov eax, MM_CLR_HDR
    call SetTextColor
    mov dh, 11
    mov dl, 27
    call Gotoxy
    mov edx, OFFSET mm_menuHdr
    call WriteString

    ; Draw footer
    mov eax, MM_CLR_FTR
    call SetTextColor
    mov dh, 22
    mov dl, 14
    call Gotoxy
    mov edx, OFFSET mm_footer
    call WriteString

draw_menu:
    ; --- Draw Option 1 ---
    cmp mm_choice, 1
    je highlight_1
    mov eax, MM_CLR_UNSEL
    jmp draw_1
highlight_1:
    mov eax, MM_CLR_SEL
draw_1:
    call SetTextColor
    mov dh, 13
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET mm_opt1
    call WriteString

    ; --- Draw Option 2 ---
    cmp mm_choice, 2
    je highlight_2
    mov eax, MM_CLR_UNSEL
    jmp draw_2
highlight_2:
    mov eax, MM_CLR_SEL
draw_2:
    call SetTextColor
    mov dh, 14
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET mm_opt2
    call WriteString

    ; --- Draw Option 3 ---
    cmp mm_choice, 3
    je highlight_3
    mov eax, MM_CLR_UNSEL
    jmp draw_3
highlight_3:
    mov eax, MM_CLR_SEL
draw_3:
    call SetTextColor
    mov dh, 15
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET mm_opt3
    call WriteString

    ; --- Draw Option 4 ---
    cmp mm_choice, 4
    je highlight_4
    mov eax, MM_CLR_UNSEL
    jmp draw_4
highlight_4:
    mov eax, MM_CLR_SEL
draw_4:
    call SetTextColor
    mov dh, 16
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET mm_opt4
    call WriteString

wait_key:
    ; Move cursor out of view to stop blinking
    mov dh, 24
    mov dl, 79
    call Gotoxy

    mov eax, 50
    call Delay
    call ReadKey
    jz wait_key

    ; Check if extended key (al=0)
    cmp al, 0
    je ext_key

    ; Check if Enter (0Dh)
    cmp al, 0Dh
    je mm_done

    jmp draw_menu

ext_key:
    ; Up arrow is 48h
    cmp ah, 48h
    je move_up
    
    ; Down arrow is 50h
    cmp ah, 50h
    je move_down

    jmp draw_menu

move_up:
    dec mm_choice
    cmp mm_choice, 1
    jge ok_up
    mov mm_choice, 4
ok_up:
    jmp draw_menu

move_down:
    inc mm_choice
    cmp mm_choice, 4
    jle ok_down
    mov mm_choice, 1
ok_down:
    jmp draw_menu

mm_done:
    ; Reset colors before returning
    mov eax, lightGray + MM_CLR_BG
    call SetTextColor
    call Clrscr

    mov eax, mm_choice

    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
MainMenuScreen ENDP
