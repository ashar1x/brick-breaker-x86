.386
.data

; ── Colors ───────────────────────────────────────────────────────────────────
HI_CLR_BG     EQU (black * 16)
HI_CLR_TITLE  EQU (yellow       + HI_CLR_BG)
HI_CLR_BORDER EQU (lightGray    + HI_CLR_BG)
HI_CLR_HDR    EQU (lightMagenta + HI_CLR_BG)
HI_CLR_COL    EQU (lightCyan    + HI_CLR_BG)
HI_CLR_R1     EQU (yellow       + HI_CLR_BG)
HI_CLR_R2     EQU (lightGreen   + HI_CLR_BG)
HI_CLR_R3     EQU (lightCyan    + HI_CLR_BG)
HI_CLR_R4     EQU (lightMagenta + HI_CLR_BG)
HI_CLR_R5     EQU (white        + HI_CLR_BG)
HI_CLR_FOOTER EQU (lightRed     + HI_CLR_BG)
HI_CLR_ART1   EQU (lightRed     + HI_CLR_BG)
HI_CLR_ART2   EQU (lightGreen   + HI_CLR_BG)
HI_CLR_ART3   EQU (yellow       + HI_CLR_BG)
HI_CLR_ART4   EQU (white        + HI_CLR_BG)
HI_CLR_ART5   EQU (lightMagenta + HI_CLR_BG)

; ── Borders ──────────────────────────────────────────────────────────────────
hi_borderTop BYTE 0C9h, 78 DUP(0CDh), 0BBh, 0
hi_borderBot BYTE 0C8h, 78 DUP(0CDh), 0BCh, 0
hi_borderMid BYTE 0BAh, 78 DUP(020h), 0BAh, 0
hi_borderSep BYTE 0CCh, 78 DUP(0CDh), 0B9h, 0

; ── ASCII art title: HIGH SCORES (Standard figlet font, ~55 chars) ───────────
hi_art1 BYTE "      _   _ ___ ____ _   _   ____   ____ ___  ____  _____ ____       ", 0
hi_art2 BYTE "     | | | |_ _/ ___| | | | / ___| / ___/ _ \|  _ \| ____/ ___|      ", 0
hi_art3 BYTE "     | |_| || | |  _| |_| | \___ \| |  | | | | |_) |  _| \___ \      ", 0
hi_art4 BYTE "     |  _  || | |_| |  _  |  ___) | |__| |_| |  _ <| |___ ___) |     ", 0
hi_art5 BYTE "     |_| |_|___\____|_| |_| |____/ \____\___/|_| \_\_____|____/      ", 0

; ── Subtitle ─────────────────────────────────────────────────────────────────
hi_sub    BYTE "=== TOP 5 PLAYERS OF ALL TIME ===", 0

; ── Table header ─────────────────────────────────────────────────────────────
hi_colHdr BYTE "   RANK        NAME                   SCORE         LEVEL    ", 0
hi_divRow BYTE "   ----   --------------------     ----------     -------    ", 0

; (Dynamic scores are now loaded from GameData memory)

; ── Footer ───────────────────────────────────────────────────────────────────
hi_footer BYTE ">>> Press any key to return to Main Menu <<<", 0

; ── Background fill ──────────────────────────────────────────────────────────
hi_bgLine BYTE 80 DUP(' '), 0

.code

HighScoreScreen PROC
    pushad

    ; ── Fill screen with black background ────────────────────
    mov eax, lightGray + HI_CLR_BG
    call SetTextColor
    call Clrscr
    mov ecx, 25
    mov dh, 0
hi_fillBG:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_bgLine
    call WriteString
    inc dh
    loop hi_fillBG

    ; ── Top border row 0 ─────────────────────────────────────
    mov eax, HI_CLR_BORDER
    call SetTextColor
    mov dh, 0
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderTop
    call WriteString

    ; ── Empty row 1 ──────────────────────────────────────────
    mov dh, 1
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderMid
    call WriteString

    ; ── ASCII art title rows 2-6 (rainbow colors) ────────────
    mov eax, HI_CLR_ART1
    call SetTextColor
    mov dh, 2
    mov dl, 4
    call Gotoxy
    mov edx, OFFSET hi_art1
    call WriteString

    mov eax, HI_CLR_ART2
    call SetTextColor
    mov dh, 3
    mov dl, 4
    call Gotoxy
    mov edx, OFFSET hi_art2
    call WriteString

    mov eax, HI_CLR_ART3
    call SetTextColor
    mov dh, 4
    mov dl, 4
    call Gotoxy
    mov edx, OFFSET hi_art3
    call WriteString

    mov eax, HI_CLR_ART4
    call SetTextColor
    mov dh, 5
    mov dl, 4
    call Gotoxy
    mov edx, OFFSET hi_art4
    call WriteString

    mov eax, HI_CLR_ART5
    call SetTextColor
    mov dh, 6
    mov dl, 4
    call Gotoxy
    mov edx, OFFSET hi_art5
    call WriteString

    ; ── Empty row 7 ──────────────────────────────────────────
    mov eax, HI_CLR_BORDER
    call SetTextColor
    mov dh, 7
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderMid
    call WriteString

    ; ── Sub-title row 8 (centered) ───────────────────────────
    mov eax, HI_CLR_COL
    call SetTextColor
    mov dh, 8
    mov dl, 23
    call Gotoxy
    mov edx, OFFSET hi_sub
    call WriteString

    ; ── Separator row 9 ──────────────────────────────────────
    mov eax, HI_CLR_BORDER
    call SetTextColor
    mov dh, 9
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderSep
    call WriteString

    ; ── Column header row 10 ─────────────────────────────────
    mov eax, HI_CLR_HDR
    call SetTextColor
    mov dh, 10
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET hi_colHdr
    call WriteString

    ; ── Divider row 11 ───────────────────────────────────────
    mov eax, HI_CLR_BORDER
    call SetTextColor
    mov dh, 11
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET hi_divRow
    call WriteString

    ; ── Dynamic Score Table ──────────────────────────────────
    mov ecx, 5
    mov esi, 0          ; current index
    mov bl, 13          ; start row (using BL to store row safely)
hi_drawScores:
    push ecx
    push esi
    
    ; Set row color based on rank
    mov eax, HI_CLR_R1
    cmp esi, 0
    je hi_setRowCol
    mov eax, HI_CLR_R2
    cmp esi, 1
    je hi_setRowCol
    mov eax, HI_CLR_R3
    cmp esi, 2
    je hi_setRowCol
    mov eax, HI_CLR_R4
    cmp esi, 3
    je hi_setRowCol
    mov eax, HI_CLR_R5
    
hi_setRowCol:
    call SetTextColor
    
    ; 1. Draw Rank (col 12)
    mov dh, bl
    mov dl, 12
    call Gotoxy
    mov eax, esi
    inc eax
    call WriteDec
    
    ; 2. Draw Name (col 23)
    mov dh, bl
    mov dl, 23
    call Gotoxy
    mov edx, OFFSET HighScoreNames
    mov eax, esi
    imul eax, 16
    add edx, eax
    call WriteString
    
    ; 3. Draw Score (col 49)
    mov dh, bl
    mov dl, 49
    call Gotoxy
    mov eax, HighScores[esi * 4]
    call WriteDec
    
    ; 4. Draw Level (col 65)
    mov dh, bl
    mov dl, 65
    call Gotoxy
    mov eax, HighScoreLevels[esi * 4]
    cmp eax, 0
    jne hi_showLevel
    mov eax, 1               ; default to 1 if not set
hi_showLevel:
    call WriteDec
    
    inc bl              ; next row
    pop esi
    inc esi
    pop ecx
    dec ecx
    jnz hi_drawScores

    ; ── Separator row 19 ─────────────────────────────────────
    mov eax, HI_CLR_BORDER
    call SetTextColor
    mov dh, 19
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderSep
    call WriteString

    ; ── Empty row 20 ─────────────────────────────────────────
    mov dh, 20
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderMid
    call WriteString

    ; ── Bottom border row 21 ─────────────────────────────────
    mov dh, 21
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET hi_borderBot
    call WriteString

    ; ── Footer row 23 ────────────────────────────────────────
    mov eax, HI_CLR_FOOTER
    call SetTextColor
    mov dh, 23
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET hi_footer
    call WriteString

    ; ── Hide cursor ──────────────────────────────────────────
    mov dh, 24
    mov dl, 79
    call Gotoxy

    ; ── Wait for any key ─────────────────────────────────────
hi_waitKey:
    mov eax, 50
    call Delay
    call ReadKey
    jz hi_waitKey

    ; ── Clear and return ─────────────────────────────────────
    mov eax, lightGray + HI_CLR_BG
    call SetTextColor
    call Clrscr

    popad
    ret
HighScoreScreen ENDP
