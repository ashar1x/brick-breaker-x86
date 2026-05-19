.386
.data

; ── Colors ───────────────────────────────────────────────────────────────────
HS_CLR_BG     EQU (black * 16)
HS_CLR_R1     EQU (lightRed      + HS_CLR_BG)
HS_CLR_R2     EQU (lightGreen    + HS_CLR_BG)
HS_CLR_R3     EQU (yellow        + HS_CLR_BG)
HS_CLR_R4     EQU (white         + HS_CLR_BG)
HS_CLR_R5     EQU (lightMagenta  + HS_CLR_BG)
HS_CLR_SUB    EQU (lightCyan     + HS_CLR_BG)
HS_CLR_BORDER EQU (lightGray     + HS_CLR_BG)
HS_CLR_LOAD   EQU (lightGreen    + HS_CLR_BG)
HS_CLR_DONE   EQU (yellow        + HS_CLR_BG)
HS_CLR_PRESS  EQU (lightRed      + HS_CLR_BG)

; ── ASCII-art title: BRICK BREAKER ──────────────────────────────────────────
; Uses same Standard figlet font as MainMenuScreen and NameScreen
; "BRICK" centered (~34 chars content, padded to 78)
hs_a1 BYTE "            ____  ____  ___ ____ _  __    ____  ____  _____    _    _  _______ ____              ", 0
hs_a2 BYTE "           | __ )|  _ \|_ _/ ___| |/ /   | __ )|  _ \| ____|  / \  | |/ / ____|  _ \             ", 0
hs_a3 BYTE "           |  _ \| |_) || | |   | ' /    |  _ \| |_) |  _|   / _ \ | ' /|  _| | |_) |           ", 0
hs_a4 BYTE "           | |_) |  _ < | | |___| . \    | |_) |  _ <| |___ / ___ \| . \| |___|  _ <            ", 0
hs_a5 BYTE "           |____/|_| \_\___\____|_|\_\   |____/|_| \_\_____/_/   \_\_|\_\_____|_| \_\           ", 0


; ── Tagline & decoration ─────────────────────────────────────────────────────
hs_stars  BYTE "               *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *       ", 0
hs_tag    BYTE "                    - SMASH THE BRICKS. BEAT THE CLOCK. -                ", 0

; ── Loading bar frames (extra wide - 60 chars) ────────────────────────────────
hs_lb0 BYTE "     [                                                            ]   Initializing...                   ", 0
hs_lb1 BYTE "     [#############                                               ]   Loading assets...                 ", 0
hs_lb2 BYTE "     [###########################                                 ]   Loading graphics...               ", 0
hs_lb3 BYTE "     [###########################################                 ]   Loading levels...                 ", 0
hs_lb4 BYTE "     [#########################################################   ]   Almost ready...                   ", 0
hs_lb5 BYTE "     [###########################################################]   Ready!                            ", 0

hs_lbPtrs DWORD OFFSET hs_lb0, OFFSET hs_lb1, OFFSET hs_lb2,
                OFFSET hs_lb3, OFFSET hs_lb4, OFFSET hs_lb5

; ── Press key prompt ─────────────────────────────────────────────────────────
hs_pressKey BYTE "                >>> Press ANY KEY to Continue <<<              ", 0

; ── Background fill ──────────────────────────────────────────────────────────
hs_bgLine BYTE 80 DUP(' '), 0

.code

HomeScreen PROC
    pushad

    ; ── Fill screen with black background ────────────────────
    mov eax, lightGray + HS_CLR_BG
    call SetTextColor
    call Clrscr
    mov ecx, 25
    mov dh, 0
hs_fillBG:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hs_bgLine
    call WriteString
    inc dh
    loop hs_fillBG

    ; ── ASCII art "BRICK" rows 2-6 ──────────────────────────
    mov dh, 2
    mov dl, 1
    call Gotoxy
    mov eax, HS_CLR_R1
    call SetTextColor
    mov edx, OFFSET hs_a1
    call WriteString

    mov dh, 3
    mov dl, 1
    call Gotoxy
    mov eax, HS_CLR_R2
    call SetTextColor
    mov edx, OFFSET hs_a2
    call WriteString

    mov dh, 4
    mov dl, 1
    call Gotoxy
    mov eax, HS_CLR_R3
    call SetTextColor
    mov edx, OFFSET hs_a3
    call WriteString

    mov dh, 5
    mov dl, 1
    call Gotoxy
    mov eax, HS_CLR_R4
    call SetTextColor
    mov edx, OFFSET hs_a4
    call WriteString

    mov dh, 6
    mov dl, 1
    call Gotoxy
    mov eax, HS_CLR_R5
    call SetTextColor
    mov edx, OFFSET hs_a5
    call WriteString

    ; ── Decorative stars row 14 ──────────────────────────────
    mov eax, HS_CLR_R3
    call SetTextColor
    mov dh, 12
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET hs_stars
    call WriteString

    ; ── Tagline row 15 ───────────────────────────────────────
    mov eax, HS_CLR_SUB
    call SetTextColor
    mov dh, 13
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET hs_tag
    call WriteString

    ; ── Decorative stars row 16 ──────────────────────────────
    mov eax, HS_CLR_R3
    call SetTextColor
    mov dh, 14
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET hs_stars
    call WriteString

    ; ── Animated loading bar at row 19 ───────────────────────
    mov esi, 0
hs_loadLoop:
    cmp esi, 6
    jge hs_loadDone

    cmp esi, 5
    je hs_lastFrame
    mov eax, HS_CLR_LOAD
    jmp hs_drawFrame
hs_lastFrame:
    mov eax, HS_CLR_DONE
hs_drawFrame:
    call SetTextColor

    mov dh, 19
    mov dl, 8
    call Gotoxy

    mov ebx, esi
    shl ebx, 2
    mov edx, hs_lbPtrs[ebx]
    call WriteString

    mov eax, 600
    call Delay

    inc esi
    jmp hs_loadLoop

hs_loadDone:

    ; ── Press any key prompt at row 23 ───────────────────────
    mov eax, HS_CLR_PRESS
    call SetTextColor
    mov dh, 24
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET hs_pressKey
    call WriteString

    ; ── Hide cursor ──────────────────────────────────────────
    mov dh, 24
    mov dl, 79
    call Gotoxy

    ; ── Wait for any key ─────────────────────────────────────
hs_waitKey:
    mov eax, 50
    call Delay
    call ReadKey
    jz hs_waitKey

    ; ── Clear before returning ───────────────────────────────
    mov eax, lightGray + HS_CLR_BG
    call SetTextColor
    call Clrscr

    popad
    ret
HomeScreen ENDP
