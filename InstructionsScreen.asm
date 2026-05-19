; InstructionScreen.asm
.386
.data

COLOR_BORDER    EQU (lightGray + (black * 16))    ; 7
COLOR_TITLE     EQU (white + (black * 16))        ; 15
COLOR_HEADER    EQU (yellow + (black * 16))       ; 14
COLOR_TEXT      EQU (lightGray + (black * 16))    ; 7
COLOR_BONUS     EQU (lightCyan + (black * 16))    ; 11
COLOR_FOOTER    EQU (lightRed + (black * 16))     ; 12

borderTop    BYTE 0C9h, 78 DUP(0CDh), 0BBh, 0
borderMid    BYTE 0BAh, 78 DUP(020h), 0BAh, 0
borderSep    BYTE 0CCh, 78 DUP(0CDh), 0B9h, 0
borderBot    BYTE 0C8h, 78 DUP(0CDh), 0BCh, 0

strTitle     BYTE "BRICK BREAKER - INSTRUCTIONS", 0

strCtrlHdr   BYTE ">>> CONTROLS <<<", 0
strCtrl1     BYTE "LEFT ARROW or  [A] ...  Move Paddle Left", 0
strCtrl2     BYTE "RIGHT ARROW or [D] ...  Move Paddle Right", 0

strObjHdr    BYTE ">>> OBJECTIVE <<<", 0
strObj1      BYTE "Break all bricks to advance to the next level", 0

strLivesHdr  BYTE ">>> LIVES <<<", 0
strLives1    BYTE "You start with 3 lives", 0
strLives2    BYTE "Losing the ball below the paddle costs 1 life", 0
strLives3    BYTE "Game Over when all lives are lost", 0

strBonusHdr  BYTE "> > > BONUSES & FEATURES < < <", 0
strBonus1    BYTE "[P] PAUSE GAME  - Press P to pause/resume the game", 0
strBonus2    BYTE "[M] MOUSE       - Move your mouse to control the paddle", 0
strBonus3    BYTE "[S] SOUNDS      - Audio feedback on all game events", 0
strBonus4    BYTE "[F] FILE SAVE   - High scores are saved and loaded", 0
strBonus5    BYTE "[*] BALL TRAIL  - Watch the glowing trail behind the ball", 0

strFooter    BYTE "Press any key to return to Main Menu...", 0

.code

InstructionsScreen PROC

 pushad

    call Clrscr


    mov eax, COLOR_BORDER
    call SetTextColor

    ; Row 0 : Top border
    mov dh, 0
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderTop
    call WriteString

    ; Row 1 : Empty
    mov dh, 1
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderMid
    call WriteString

    ; Row 2 : Title (centered, col 26)
    mov eax, COLOR_TITLE
    call SetTextColor
    mov dh, 2
    mov dl, 26
    call Gotoxy
    mov edx, OFFSET strTitle
    call WriteString

    ; Row 3 : Empty
    mov eax, COLOR_BORDER
    call SetTextColor
    mov dh, 3
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderMid
    call WriteString

    ; Row 4 : Separator
    mov dh, 4
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderSep
    call WriteString

    ; Row 5 : Controls Header
    mov eax, COLOR_HEADER
    call SetTextColor
    mov dh, 5
    mov dl, 3
    call Gotoxy
    mov edx, OFFSET strCtrlHdr
    call WriteString

    ; Row 6 : Control 1
    mov eax, COLOR_TEXT
    call SetTextColor
    mov dh, 6
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strCtrl1
    call WriteString

    ; Row 7 : Control 2
    mov dh, 7
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strCtrl2
    call WriteString

    ; Row 8 : Separator
    mov eax, COLOR_BORDER
    call SetTextColor
    mov dh, 8
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderSep
    call WriteString

    ; Row 9 : Objective Header
    mov eax, COLOR_HEADER
    call SetTextColor
    mov dh, 9
    mov dl, 3
    call Gotoxy
    mov edx, OFFSET strObjHdr
    call WriteString

    ; Row 10 : Objective text
    mov eax, COLOR_TEXT
    call SetTextColor
    mov dh, 10
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strObj1
    call WriteString

    ; Row 11 : Separator
    mov eax, COLOR_BORDER
    call SetTextColor
    mov dh, 11
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderSep
    call WriteString

    ; Row 12 : Lives Header
    mov eax, COLOR_HEADER
    call SetTextColor
    mov dh, 12
    mov dl, 3
    call Gotoxy
    mov edx, OFFSET strLivesHdr
    call WriteString

    ; Row 13 : Lives 1
    mov eax, COLOR_TEXT
    call SetTextColor
    mov dh, 13
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strLives1
    call WriteString

    ; Row 14 : Lives 2
    mov dh, 14
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strLives2
    call WriteString

    ; Row 15 : Lives 3
    mov dh, 15
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strLives3
    call WriteString
    ; Row 16 : Separator
    mov eax, COLOR_BORDER
    call SetTextColor
    mov dh, 16
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderSep
    call WriteString

    ; Row 17 : Bonuses Header
    mov eax, COLOR_HEADER
    call SetTextColor
    mov dh, 17
    mov dl, 3
    call Gotoxy
    mov edx, OFFSET strBonusHdr
    call WriteString

    ; Row 18 : Bonus 1
    mov eax, COLOR_BONUS
    call SetTextColor
    mov dh, 18
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strBonus1
    call WriteString

    ; Row 19 : Bonus 2
    mov dh, 19
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strBonus2
    call WriteString

    ; Row 20 : Bonus 3
    mov dh, 20
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strBonus3
    call WriteString

    ; Row 21 : Bonus 4
    mov dh, 21
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strBonus4
    call WriteString

    ; Row 22 : Bonus 5
    mov dh, 22
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET strBonus5
    call WriteString

    ; Row 21 : Separator
    mov eax, COLOR_BORDER
    call SetTextColor
    mov dh, 21
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderSep
    call WriteString

    ; Row 22 : Empty
    mov dh, 22
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderMid
    call WriteString

    ; Row 23 : Footer (centered, col 20)
    mov eax, COLOR_FOOTER
    call SetTextColor
    mov dh, 23
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strFooter
    call WriteString

    ; Row 24 : Bottom border
    mov eax, COLOR_BORDER
    call SetTextColor
    mov dh, 24
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET borderBot
    call WriteString

    ; Wait for key then clean up
    ; Wait for any key
inst_waitKey:
    mov eax, 50
    call Delay
    call ReadKey
    jz inst_waitKey
    mov eax, lightGray + (black * 16)
    call SetTextColor
   
    call Clrscr

    popad
    ret
InstructionsScreen ENDP