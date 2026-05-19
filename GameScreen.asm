.data

; ------------------------------------------------------------------------------
; Layout Constants
; ------------------------------------------------------------------------------
HUD_ROW          EQU 0
PLAYFIELD_TOP    EQU 1
PLAYFIELD_BOTTOM EQU 24
BRICK_START_ROW  EQU 3
PADDLE_ROW       EQU 22
BRICK_WIDTH      EQU 9
BRICK_START_COL  EQU 2
BRICK_ROWS       EQU 5
BRICK_COLS       EQU 8
PADDLE_WIDTH     EQU 12
LEFT_WALL        EQU 1
RIGHT_WALL       EQU 78

; ------------------------------------------------------------------------------
; Game State Variables
; ------------------------------------------------------------------------------
Score       DWORD 0
Lives       DWORD 3
Level       DWORD 1
GameOver    DWORD 0
WonGame     DWORD 0

; Ball state
BallX       SDWORD 40
BallY       SDWORD 15
BallDX      SDWORD 1
BallDY      SDWORD -1
OldBallX    SDWORD 0
OldBallY    SDWORD 0

; HUD change tracking (stops blinking)
LastScore   DWORD 99999
LastLives   DWORD 99999
LastBricks  DWORD 99999
LastLevel   DWORD 99999

; Paddle
PaddleX     DWORD 34

; Brick grid: 5 rows x 8 cols
BrickArray  BYTE BRICK_ROWS * BRICK_COLS DUP(1)

; Colors per brick row
BrickColors BYTE 12, 14, 10, 11, 13

; Speed per level (delay in ms): Level1=120, Level2=85, Level3=55
LevelDelays DWORD 120, 85, 55

; ------------------------------------------------------------------------------
; Level brick layouts
; Each layout is BRICK_ROWS * BRICK_COLS bytes (40 bytes)
; 1 = brick alive, 0 = empty gap
; ------------------------------------------------------------------------------

; Level 1: Full solid grid (classic)
Level1Bricks BYTE \
    1,1,1,1,1,1,1,1, \
    1,1,1,1,1,1,1,1, \
    1,1,1,1,1,1,1,1, \
    1,1,1,1,1,1,1,1, \
    1,1,1,1,1,1,1,1

; Level 2: Checkerboard pattern (gaps make ball harder to predict)
Level2Bricks BYTE \
    1,0,1,0,1,0,1,0, \
    0,1,0,1,0,1,0,1, \
    1,0,1,0,1,0,1,0, \
    0,1,0,1,0,1,0,1, \
    1,0,1,0,1,0,1,0

; Level 3: Diamond/fortress pattern (dense center, gaps on sides)
Level3Bricks BYTE \
    0,0,1,1,1,1,0,0, \
    0,1,1,1,1,1,1,0, \
    1,1,1,1,1,1,1,1, \
    0,1,1,1,1,1,1,0, \
    0,0,1,1,1,1,0,0

LevelBrickPtrs DWORD OFFSET Level1Bricks, OFFSET Level2Bricks, OFFSET Level3Bricks

; ------------------------------------------------------------------------------
; Strings
; ------------------------------------------------------------------------------
paddleStr    BYTE "<===========>" , 0
blankPaddle  BYTE "              ", 0
blankBall    BYTE " ", 0

; Level 1: Solid brick style
l1Row0 BYTE "|######|", 0
l1Row1 BYTE "|######|", 0
l1Row2 BYTE "|######|", 0
l1Row3 BYTE "|######|", 0
l1Row4 BYTE "|######|", 0
Level1BrickStrs DWORD OFFSET l1Row0, OFFSET l1Row1, OFFSET l1Row2, OFFSET l1Row3, OFFSET l1Row4

; Level 2: Dashed/open brick style
l2Row0 BYTE "[------]", 0
l2Row1 BYTE "[------]", 0
l2Row2 BYTE "[------]", 0
l2Row3 BYTE "[------]", 0
l2Row4 BYTE "[------]", 0
Level2BrickStrs DWORD OFFSET l2Row0, OFFSET l2Row1, OFFSET l2Row2, OFFSET l2Row3, OFFSET l2Row4

; Level 3: Armored brick style
l3Row0 BYTE  "[@@@@@@]", 0
l3Row1 BYTE  "[||||||]", 0
l3Row2 BYTE  "[@@@@@@]", 0
l3Row3 BYTE  "[||||||]", 0
l3Row4 BYTE  "[@@@@@@]", 0
Level3BrickStrs DWORD OFFSET l3Row0, OFFSET l3Row1, OFFSET l3Row2, OFFSET l3Row3, OFFSET l3Row4

; Pointers to each level's brick visual styles
LevelBrickVisualPtrs DWORD OFFSET Level1BrickStrs, OFFSET Level2BrickStrs, OFFSET Level3BrickStrs

blankBrick BYTE "        ", 0

; HUD
hudPlayer   BYTE " PLAYER: ", 0
hudLevel    BYTE "  LEVEL: ", 0
hudScore    BYTE "  SCORE: ", 0
hudLives    BYTE "  LIVES: ", 0
hudBricks   BYTE "  BRICKS: ", 0

; Playfield border
pfTop  BYTE 0DAh, 78 DUP(0C4h), 0BFh, 0
pfSide BYTE 0B3h, 0
pfBot  BYTE 0C0h, 78 DUP(0C4h), 0D9h, 0

; Level transition screen strings
ltLine1  BYTE "  _      _____  _    _  _____  _           _____  _      _____   ___   ____  ", 0
ltLine2  BYTE " | |    | ____|| |  | || ____|| |         / ____|| |    | ____| / _ \ |  _ \ ", 0
ltLine3  BYTE " | |    | |__  | |  | || |__  | |        | |     | |    | |__  | |_| || |_) |", 0
ltLine4  BYTE " | |    |  __| | |  | ||  __| | |        | |     | |    |  __| |  _  ||  _  / ", 0
ltLine5  BYTE " | |___ | |___ |  \/  || |___ | |____    | |____ | |___ | |___ | | | || | \ \ ", 0
ltLine6  BYTE " |_____||_____| \____/ |_____||______|    \_____||_____||_____||_| |_||_|  \_\", 0
ltNext   BYTE "              GET READY FOR LEVEL  ", 0
ltMsg    BYTE "          >>> Press any key to start <<<         ", 0
ltBgLine BYTE 80 DUP(' '), 0

; Game Over strings
goLine1   BYTE "  _____    ___   __  __  _____     ___   _      _  _____  ____  ", 0
goLine2   BYTE " / ____|  / _ \ |  \/  || ____|   / _ \ | |    | || ____||  _ \ ", 0
goLine3   BYTE "| |  __  | |_| || \  / || |__    | | | || |    | || |__  | |_) |", 0
goLine4   BYTE "| | |_ | |  _  || |\/| ||  __|   | | | | \ \  / / |  __| |  _ < ", 0
goLine5   BYTE "| |__| | | | | || |  | || |____  | |_| |  \ \/ /  | |____| | \ \", 0
goLine6   BYTE " \_____| |_| |_||_|  |_||______|  \___/    \__/   |______|_|  \_\", 0
goScoreLbl BYTE "           YOUR FINAL SCORE:  ", 0
goRetMsg   BYTE "     >>> Press any key to return to Main Menu <<<", 0
bgLine     BYTE 80 DUP(' '), 0

; Win screen strings
winLine1   BYTE " __     __  ____   _    _      __          __  _____  _   _  _ ", 0
winLine2   BYTE " \ \   / / / __ \ | |  | |     \ \        / / |_   _|| \ | || |", 0
winLine3   BYTE "  \ \_/ / | |  | || |  | |      \ \  /\  / /    | |  |  \| || |", 0
winLine4   BYTE "   \   /  | |  | || |  | |       \ \/  \/ /     | |  | |\  || |", 0
winLine5   BYTE "    | |   | |__| || |__| |        \  /\  /     _| |_ | | \ ||_|", 0
winLine6   BYTE "    |_|    \____/  \____/          \/  \/     |_____||_|  \_(_)", 0
winAllDone BYTE "All levels completed!", 0

; ------------------------------------------------------------------------------
; BONUS: File Handling 
; ------------------------------------------------------------------------------
scoreFileName   BYTE "scores.dat", 0
fileHandle      DWORD ?
bytesWritten    DWORD ?
bytesRead       DWORD ?

; ------------------------------------------------------------------------------
; BONUS: Pause System  
; ------------------------------------------------------------------------------
Paused          DWORD 0
pauseMsg1       BYTE "  ____     _     _   _   ____  ______  ____  ", 0
pauseMsg2       BYTE " |  _ \   / \   | | | | / ___||  ____||  _ \ ", 0
pauseMsg3       BYTE " | |_) | / _ \  | | | | \___ \|  |_   | | | |", 0
pauseMsg4       BYTE " |  __/ / ___ \ | |_| |  ___) |  |___ | |_| |", 0
pauseMsg5       BYTE " |_|   /_/   \_\ \___/  |____/|______||____/ ", 0
pauseResume     BYTE "          Press P to Resume          ", 0
pauseBlank      BYTE "                                            ", 0

; ------------------------------------------------------------------------------
; BONUS: Mouse Support  
; ------------------------------------------------------------------------------
ConsoleInHandle DWORD 0
MouseInputRec   INPUT_RECORD <>
MouseEventsRead DWORD 0
MouseEventCount DWORD 0
ConsoleMode     DWORD 0

; ------------------------------------------------------------------------------
; BONUS: Visual Effects - Ball Trail  
; ------------------------------------------------------------------------------
TRAIL_LEN       EQU 3
TrailX          SDWORD TRAIL_LEN DUP(-1)
TrailY          SDWORD TRAIL_LEN DUP(-1)
TrailIdx        DWORD 0
TrailColors     DWORD (gray + black*16), (brown + black*16), (yellow + black*16)

; ------------------------------------------------------------------------------
; Cursor visibility (reduces flicker)
; ------------------------------------------------------------------------------
ConsoleOutHandle DWORD 0
CursorInfoHide   DWORD 25, 0        ; dwSize=25, bVisible=FALSE
CursorInfoShow   DWORD 25, 1        ; dwSize=25, bVisible=TRUE

.code

; ==============================================================================
; GameScreen  -  Main entry point called from Main.asm
; ==============================================================================
GameScreen PROC
    pushad

    call InitGame
    call HideCursor
    call DrawStaticScreen
    call GameLoop

    call ShowCursor
    mov eax, lightGray + (black * 16)
    call SetTextColor
    call Clrscr

    popad
    ret
GameScreen ENDP

; ==============================================================================
; InitGame  -  Full reset (called once at game start)
; ==============================================================================
InitGame PROC
    pushad

    ; Seed the random number generator (system time) so power-ups vary each game
    call Randomize

    ; BONUS: Initialize mouse support
    call InitMouse

    mov Score, 0
    mov Lives, 3
    mov Level, 1
    mov GameOver, 0
    mov WonGame, 0
    mov BricksBroken, 0
    mov Paused, 0
    mov LastBricks, 99999
    mov LastScore, 99999
    mov LastLives, 99999
    mov LastLevel, 99999

    mov BallX, 40
    mov BallY, 15
    mov BallDX, 1
    mov BallDY, -1
    mov OldBallX, 40
    mov OldBallY, 15

    mov PaddleX, 34

    ; BONUS: Reset trail buffer
    call ResetTrail

    call LoadLevelBricks
    call PU_Reset

    popad
    ret
InitGame ENDP

; ==============================================================================
; InitLevel  -  Reset only what changes between levels (keeps score + lives)
; ==============================================================================
InitLevel PROC
    pushad

    mov WonGame, 0
    mov BricksBroken, 0
    mov LastBricks, 99999

    ; Reset ball to center
    mov BallX, 40
    mov BallY, 15
    mov BallDX, 1
    mov BallDY, -1
    mov OldBallX, 40
    mov OldBallY, 15

    ; Reset paddle to center
    mov PaddleX, 34

    call LoadLevelBricks
    call PU_Reset

    popad
    ret
InitLevel ENDP

; ==============================================================================
; LoadLevelBricks  -  Copy the current level's brick layout into BrickArray
; ==============================================================================
LoadLevelBricks PROC
    pushad

    ; Get pointer to the correct layout: LevelBrickPtrs[Level-1]
    mov eax, Level
    dec eax                         ; 0-based index
    shl eax, 2                      ; * 4 for DWORD ptr
    mov esi, LevelBrickPtrs[eax]    ; esi = source layout

    mov edi, OFFSET BrickArray
    mov ecx, BRICK_ROWS * BRICK_COLS
llb_copy:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    loop llb_copy

    popad
    ret
LoadLevelBricks ENDP

; ==============================================================================
; DrawStaticScreen  -  Draw full screen once (HUD + border + bricks + paddle + ball)
; ==============================================================================
DrawStaticScreen PROC
    pushad

    mov eax, lightGray + (black * 16)
    call SetTextColor
    call Clrscr

    call DrawHUD
    call DrawPlayFieldBorder
    call DrawBricks
    call DrawPaddle
    call DrawBall

    popad
    ret
DrawStaticScreen ENDP

; ==============================================================================
; GameLoop  -  Main game loop
; ==============================================================================
GameLoop PROC
    pushad

gl_frame:
    call ReadInput

    mov eax, BallX
    mov OldBallX, eax
    mov eax, BallY
    mov OldBallY, eax

    call MoveBall
    call CheckWallCollision
    call CheckPaddleCollision
    call CheckBrickCollision

    ; --- RENDER PHASE (minimized flicker) ---
    ; 1. Erase trail dots
    call EraseTrail
    ; 2. Update trail buffer
    call UpdateTrail

    ; 3. Erase old ball + Draw new ball back-to-back (reduces flicker)
    mov eax, OldBallX
    cmp eax, BallX
    jne gl_doErase
    mov eax, OldBallY
    cmp eax, BallY
    je gl_skipErase
gl_doErase:
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    mov eax, OldBallY
    mov dh, al
    mov eax, OldBallX
    mov dl, al
    call Gotoxy
    mov al, ' '
    call WriteChar
    popad
gl_skipErase:
    call DrawBall

    ; 4. Draw trail after ball (trail skips ball position)
    call DrawTrail

    ; Update power-up (move, check collection, tick effects)
    call PU_Update

    call CheckBallLost
    call UpdateHUDNumbers
    call ApplyDelay

    ; Check win condition
    cmp WonGame, 1
    je gl_win

    ; Check game over
    cmp GameOver, 1
    je gl_end

    jmp gl_frame

gl_win:
    ; BONUS: Level cleared sound (ascending beeps)
    INVOKE Beep, 800, 80
    INVOKE Beep, 1000, 80
    INVOKE Beep, 1200, 120

    ; Check if there are more levels
    mov eax, Level
    cmp eax, 3
    je gl_finalWin

    ; --- Level cleared, not the last one ---
    inc Level                   ; advance to next level
    call ShowLevelTransition    ; show "LEVEL X" screen
    call InitLevel              ; reset bricks/ball/paddle
    call ResetTrail             ; BONUS: reset trail for new level
    call DrawStaticScreen       ; redraw full screen
    jmp gl_frame                ; continue game loop

gl_finalWin:
    ; --- All 3 levels cleared ---
    call UpdateHighScores
    call SaveHighScores         ; BONUS: persist to file
    call ShowWinScreen
    jmp gl_exit

gl_end:
    ; BONUS: Game over sound (low tone)
    INVOKE Beep, 150, 500

    call UpdateHighScores
    call SaveHighScores         ; BONUS: persist to file
    call ShowGameOver

gl_exit:
    popad
    ret
GameLoop ENDP

; ==============================================================================
; ShowLevelTransition  -  Brief screen shown between levels
; ==============================================================================
ShowLevelTransition PROC
    pushad

    ; Black background
    mov eax, lightGray + (black * 16)
    call SetTextColor
    call Clrscr
    mov ecx, 25
    mov dh, 0
slt_bgLoop:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET ltBgLine
    call WriteString
    inc dh
    loop slt_bgLoop

    ; "LEVEL" ASCII art (rows 4-9, yellow)
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 4
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET ltLine1
    call WriteString

    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dh, 5
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET ltLine2
    call WriteString

    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 6
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET ltLine3
    call WriteString

    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov dh, 7
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET ltLine4
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 8
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET ltLine5
    call WriteString

    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 9
    mov dl, 18
    call Gotoxy
    mov edx, OFFSET ltLine6
    call WriteString

    ; "GET READY FOR LEVEL X" (row 13)
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 13
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET ltNext
    call WriteString
    ; Print the level number
    mov eax, Level
    call WriteDec

    ; Press any key (row 17)
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 17
    mov dl, 12
    call Gotoxy
    mov edx, OFFSET ltMsg
    call WriteString

    ; Hide cursor
    mov dh, 24
    mov dl, 79
    call Gotoxy

    ; Wait for key
slt_wait:
    mov eax, 50
    call Delay
    call ReadKey
    jz slt_wait

    popad
    ret
ShowLevelTransition ENDP

; ==============================================================================
; ReadInput  -  Non-blocking keyboard + mouse, moves paddle, handles pause
; ==============================================================================
ReadInput PROC
    pushad

    ; BONUS: Check for mouse events first
    call ReadMouseInput

    call ReadKey
    jz ri_done

    cmp al, 0
    je ri_extended

    ; BONUS: Check for pause key 'P' / 'p'
    cmp al, 70h         ; 'p'
    je ri_pause
    cmp al, 50h         ; 'P'
    je ri_pause

    cmp al, 61h         ; 'a'
    je ri_moveLeft
    cmp al, 41h         ; 'A'
    je ri_moveLeft
    cmp al, 64h         ; 'd'
    je ri_moveRight
    cmp al, 44h         ; 'D'
    je ri_moveRight
    jmp ri_done

ri_extended:
    cmp ah, 4Bh         ; left arrow
    je ri_moveLeft
    cmp ah, 4Dh         ; right arrow
    je ri_moveRight
    jmp ri_done

ri_pause:
    ; ── BONUS: Pause System ──────────────────────────────────────
    INVOKE Beep, 600, 50      ; pause sound

    ; Draw "PAUSED" overlay in center of screen
    pushad
    mov eax, white + (lightRed * 16)
    call SetTextColor

    mov dh, 9
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET pauseMsg1
    call WriteString

    mov dh, 10
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET pauseMsg2
    call WriteString

    mov dh, 11
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET pauseMsg3
    call WriteString

    mov dh, 12
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET pauseMsg4
    call WriteString

    mov dh, 13
    mov dl, 19
    call Gotoxy
    mov edx, OFFSET pauseMsg5
    call WriteString

    mov eax, yellow + (lightRed * 16)
    call SetTextColor
    mov dh, 15
    mov dl, 22
    call Gotoxy
    mov edx, OFFSET pauseResume
    call WriteString

    ; Hide cursor
    mov dh, 24
    mov dl, 79
    call Gotoxy
    popad

    ; Wait loop until P is pressed again
ri_pauseWait:
    mov eax, 50
    call Delay
    call ReadKey
    jz ri_pauseWait
    cmp al, 70h         ; 'p'
    je ri_unpause
    cmp al, 50h         ; 'P'
    je ri_unpause
    jmp ri_pauseWait

ri_unpause:
    INVOKE Beep, 800, 50      ; unpause sound
    ; Redraw the play area to clear the pause overlay
    call DrawStaticScreen
    jmp ri_done

ri_moveLeft:
    call ErasePaddle
    mov eax, PaddleX
    sub eax, 2
    cmp eax, LEFT_WALL
    jge ri_setLeft
    mov eax, LEFT_WALL
ri_setLeft:
    mov PaddleX, eax
    call DrawPaddle
    jmp ri_done

ri_moveRight:
    call ErasePaddle
    mov eax, PaddleX
    add eax, 2
    ; Calculate max X based on current paddle width
    mov ebx, RIGHT_WALL - PADDLE_WIDTH
    cmp PU_WasWidened, 1
    jne ri_setRight
    mov ebx, RIGHT_WALL - 18          ; wide paddle is 18 chars
ri_setRight:
    cmp eax, ebx
    jle ri_applyRight
    mov eax, ebx
ri_applyRight:
    mov PaddleX, eax
    call DrawPaddle

ri_done:
    popad
    ret
ReadInput ENDP

; ==============================================================================
; ErasePaddle  -  Erases current paddle (uses wide blank if widened)
; ==============================================================================
ErasePaddle PROC
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, PADDLE_ROW
    mov eax, PaddleX
    mov dl, al
    call Gotoxy
    ; Use wider blank if paddle is currently widened
    cmp PU_WasWidened, 1
    je ep_wide
    mov edx, OFFSET blankPaddle
    jmp ep_draw
ep_wide:
    mov edx, OFFSET blankWidePaddle
ep_draw:
    call WriteString
    popad
    ret
ErasePaddle ENDP

; ==============================================================================
; DrawPaddle  -  Draws paddle (uses wide paddle if widened)
; ==============================================================================
DrawPaddle PROC
    pushad
    ; Check if wide paddle is active
    cmp PU_WasWidened, 1
    je dp_wide
    ; Normal paddle
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, PADDLE_ROW
    mov eax, PaddleX
    mov dl, al
    call Gotoxy
    mov edx, OFFSET paddleStr
    call WriteString
    jmp dp_done
dp_wide:
    ; Wide paddle
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dh, PADDLE_ROW
    mov eax, PaddleX
    mov dl, al
    call Gotoxy
    mov edx, OFFSET widePaddleStr
    call WriteString
dp_done:
    popad
    ret
DrawPaddle ENDP

; ==============================================================================
; DrawBall
; ==============================================================================
DrawBall PROC
    pushad
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov eax, BallY
    mov dh, al
    mov eax, BallX
    mov dl, al
    call Gotoxy
    mov al, '*'
    call WriteChar
    popad
    ret
DrawBall ENDP

; ==============================================================================
; MoveBall
; ==============================================================================
MoveBall PROC
    pushad
    mov eax, BallX
    add eax, BallDX
    mov BallX, eax
    mov eax, BallY
    add eax, BallDY
    mov BallY, eax
    popad
    ret
MoveBall ENDP

; ==============================================================================
; CheckWallCollision
; ==============================================================================
CheckWallCollision PROC
    pushad

    mov eax, BallX
    cmp eax, LEFT_WALL
    jg cwc_checkRight
    mov BallDX, 1
    mov BallX, LEFT_WALL + 1
    INVOKE Beep, 300, 5            ; BONUS: wall bounce sound

cwc_checkRight:
    mov eax, BallX
    cmp eax, RIGHT_WALL
    jl cwc_checkTop
    mov BallDX, -1
    mov BallX, RIGHT_WALL - 1
    INVOKE Beep, 300, 5            ; BONUS: wall bounce sound

cwc_checkTop:
    mov eax, BallY
    cmp eax, PLAYFIELD_TOP + 1
    jg cwc_done
    mov BallDY, 1
    mov BallY, PLAYFIELD_TOP + 2
    INVOKE Beep, 300, 5            ; BONUS: wall bounce sound

cwc_done:
    popad
    ret
CheckWallCollision ENDP

; ==============================================================================
; CheckPaddleCollision  -  Angled bounce based on hit position
; ==============================================================================
CheckPaddleCollision PROC
    pushad

    mov eax, BallY
    cmp eax, PADDLE_ROW
    jne cpc_done

    mov eax, BallX
    mov ebx, PaddleX
    cmp eax, ebx
    jl cpc_done

    ; Determine current paddle width (normal=12, wide=18)
    mov ecx, PADDLE_WIDTH
    cmp PU_WasWidened, 1
    jne cpc_normalW
    mov ecx, 18                     ; wide paddle width
cpc_normalW:
    add ebx, ecx
    cmp eax, ebx
    jge cpc_done

    ; Angle based on offset from center of current paddle width
    mov ebx, eax
    sub ebx, PaddleX
    ; ecx still holds current width
    shr ecx, 1                      ; ecx = half width
    sub ebx, ecx
    mov BallDX, ebx
    cmp BallDX, -2
    jge cpc_checkMax
    mov BallDX, -2
cpc_checkMax:
    cmp BallDX, 2
    jle cpc_setDY
    mov BallDX, 2

cpc_setDY:
    mov BallDY, -1
    mov eax, BallY
    dec eax
    mov BallY, eax
    INVOKE Beep, 400, 5            ; BONUS: paddle hit sound

cpc_done:
    popad
    ret
CheckPaddleCollision ENDP

; ==============================================================================
; CheckBrickCollision
; ==============================================================================
CheckBrickCollision PROC
    pushad

    mov eax, BallY
    sub eax, BRICK_START_ROW
    cmp eax, 0
    jl cbc_done
    cmp eax, BRICK_ROWS
    jge cbc_done
    mov esi, eax

    mov eax, BallX
    sub eax, BRICK_START_COL
    cmp eax, 0
    jl cbc_done
    mov ebx, BRICK_WIDTH
    cdq
    idiv ebx
    cmp eax, 0
    jl cbc_done
    cmp eax, BRICK_COLS
    jge cbc_done
    mov edi, eax

    mov eax, esi
    mov ebx, BRICK_COLS
    mul ebx
    add eax, edi

    cmp BrickArray[eax], 1
    jne cbc_done

    mov BrickArray[eax], 0

    ; BONUS: Brick break sound
    INVOKE Beep, 800, 5

    ; Score: use PU_GetScoreBonus (handles multi-score + level bonus)
    call PU_GetScoreBonus
    add Score, eax

    ; Calculate screen position of broken brick
    mov ecx, edi
    mov eax, BRICK_WIDTH
    mul ecx
    add eax, BRICK_START_COL
    mov dl, al              ; dl = screen col
    mov ecx, esi
    add ecx, BRICK_START_ROW
    mov dh, cl              ; dh = screen row

    ; BONUS: Visual effect - flash '*' at brick position before erasing
    pushad
    mov eax, white + (red * 16)
    call SetTextColor
    call Gotoxy
    mov al, '*'
    call WriteChar
    mov al, '*'
    call WriteChar
    mov al, '*'
    call WriteChar
    popad

    ; Erase brick from screen
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    call Gotoxy
    mov edx, OFFSET blankBrick
    call WriteString
    popad

    inc BricksBroken

    ; Try to spawn a power-up at this brick's screen position
    movzx ecx, dl           ; ecx = screen col (X for PU_TrySpawn)
    movzx edx, dh           ; edx = screen row (Y for PU_TrySpawn)
    call PU_TrySpawn

    ; Check win: WinTarget > 0 means win after that many bricks;
    ;            WinTarget == 0 means destroy all bricks
    mov eax, WinTarget
    cmp eax, 0
    je cbc_checkAllBricks

    ; WinTarget > 0: compare BricksBroken to WinTarget
    mov eax, BricksBroken
    cmp eax, WinTarget
    jl cbc_notWon
    mov WonGame, 1
    jmp cbc_notWon

cbc_checkAllBricks:
    ; WinTarget == 0: all bricks in BrickArray must be 0
    pushad
    mov ecx, BRICK_ROWS * BRICK_COLS
    mov esi, 0
    mov ebx, 0
cbc_winLoop:
    movzx eax, BrickArray[esi]
    add ebx, eax
    inc esi
    loop cbc_winLoop
    cmp ebx, 0
    popad
    jne cbc_notWon
    mov WonGame, 1

cbc_notWon:
    ; Reverse ball Y
    mov eax, BallDY
    neg eax
    mov BallDY, eax
    mov eax, BallY
    add eax, BallDY
    mov BallY, eax

cbc_done:
    popad
    ret
CheckBrickCollision ENDP

; ==============================================================================
; CheckBallLost
; ==============================================================================
CheckBallLost PROC
    pushad

    mov eax, BallY
    cmp eax, PADDLE_ROW + 1
    jl cbl_done

    ; BONUS: Ball lost sound
    INVOKE Beep, 200, 100

    mov eax, Lives
    dec eax
    mov Lives, eax

    cmp eax, 0
    jle cbl_gameOver

    call EraseTrail            ; BONUS: visually erase trail dots from screen
    call ResetTrail            ; BONUS: clear trail buffer
    call ResetBall
    mov eax, 800
    call Delay
    jmp cbl_done

cbl_gameOver:
    mov GameOver, 1

cbl_done:
    popad
    ret
CheckBallLost ENDP

; ==============================================================================
; ResetBall
; ==============================================================================
ResetBall PROC
    pushad

    mov eax, BallY
    mov dh, al
    mov eax, BallX
    mov dl, al
    call Gotoxy
    mov edx, OFFSET blankBall
    call WriteString

    mov BallX, 40
    mov BallY, 15
    mov BallDX, 1
    mov BallDY, -1
    mov OldBallX, 40
    mov OldBallY, 15

    call DrawBall

    popad
    ret
ResetBall ENDP

; ==============================================================================
; DrawHUD  -  Draw full HUD bar once
; ==============================================================================
DrawHUD PROC
    pushad

    mov eax, yellow + (blue * 16)
    call SetTextColor

    mov dh, HUD_ROW
    mov dl, 0
    call Gotoxy
    mov ecx, 80
dhud_fill:
    mov al, ' '
    call WriteChar
    loop dhud_fill

    ; Player name
    mov dh, HUD_ROW
    mov dl, 2
    call Gotoxy
    mov edx, OFFSET hudPlayer
    call WriteString
    mov edx, OFFSET PlayerName
    call WriteString

    ; Level
    mov dh, HUD_ROW
    mov dl, 24
    call Gotoxy
    mov edx, OFFSET hudLevel
    call WriteString
    mov eax, Level
    call WriteDec

    ; Score
    mov dh, HUD_ROW
    mov dl, 36
    call Gotoxy
    mov edx, OFFSET hudScore
    call WriteString
    mov eax, Score
    call WriteDec

    ; Lives
    mov dh, HUD_ROW
    mov dl, 52
    call Gotoxy
    mov edx, OFFSET hudLives
    call WriteString
    mov eax, Lives
    call WriteDec

    ; Bricks
    mov dh, HUD_ROW
    mov dl, 64
    call Gotoxy
    mov edx, OFFSET hudBricks
    call WriteString
    mov eax, BricksBroken
    call WriteDec

    popad
    ret
DrawHUD ENDP

; ==============================================================================
; UpdateHUDNumbers  -  Only redraw changed values (no flicker)
; ==============================================================================
UpdateHUDNumbers PROC
    pushad

    mov eax, white + (blue * 16)
    call SetTextColor

    ; Score
    mov eax, Score
    cmp eax, LastScore
    je uhn_checkLives
    mov LastScore, eax
    mov dh, HUD_ROW
    mov dl, 45
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    mov dh, HUD_ROW
    mov dl, 45
    call Gotoxy
    mov eax, Score
    call WriteDec

uhn_checkLives:
    mov eax, Lives
    cmp eax, LastLives
    je uhn_checkBricks
    mov LastLives, eax
    mov dh, HUD_ROW
    mov dl, 61
    call Gotoxy
    mov eax, Lives
    call WriteDec

uhn_checkBricks:
    mov eax, BricksBroken
    cmp eax, LastBricks
    je uhn_checkLevel
    mov LastBricks, eax
    mov dh, HUD_ROW
    mov dl, 74
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    mov dh, HUD_ROW
    mov dl, 74
    call Gotoxy
    mov eax, BricksBroken
    call WriteDec

uhn_checkLevel:
    mov eax, Level
    cmp eax, LastLevel
    je uhn_done
    mov LastLevel, eax
    mov dh, HUD_ROW
    mov dl, 33
    call Gotoxy
    mov eax, Level
    call WriteDec

uhn_done:
    popad
    ret
UpdateHUDNumbers ENDP

; ==============================================================================
; DrawPlayFieldBorder
; ==============================================================================
DrawPlayFieldBorder PROC
    pushad

    mov eax, lightGray + (black * 16)
    call SetTextColor

    mov dh, PLAYFIELD_TOP
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET pfTop
    call WriteString

    mov dh, 2
dpf_sideLoop:
    cmp dh, PLAYFIELD_BOTTOM
    jge dpf_sideDone

    mov dl, 0
    call Gotoxy
    mov edx, OFFSET pfSide
    call WriteString

    mov dl, 79
    call Gotoxy
    mov edx, OFFSET pfSide
    call WriteString

    inc dh
    jmp dpf_sideLoop
dpf_sideDone:

    mov dh, PLAYFIELD_BOTTOM
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET pfBot
    call WriteString

    popad
    ret
DrawPlayFieldBorder ENDP

; ==============================================================================
; DrawBricks  -  Draw all alive bricks
; ==============================================================================
DrawBricks PROC
    pushad

    mov esi, 0
    mov dh, BRICK_START_ROW

    mov ecx, BRICK_ROWS
db_rowLoop:
    push ecx

    push edx
    push esi
    movzx eax, dh
    sub eax, BRICK_START_ROW
    movzx eax, BrickColors[eax]
    add eax, black * 16
    call SetTextColor
    pop esi
    pop edx

    mov dl, BRICK_START_COL
    mov ebx, 0

db_colLoop:
    cmp BrickArray[esi], 1
    jne db_skipDraw

    push edx
    call Gotoxy

    push esi
    movzx eax, dh
    sub eax, BRICK_START_ROW
    
    ; Get the brick visual pointer array for current level
    mov edi, Level
    dec edi
    shl edi, 2
    mov edi, LevelBrickVisualPtrs[edi]  ; edi = Level1BrickStrs, Level2BrickStrs, or Level3BrickStrs
    
    ; Get the specific row string from the level's array
    mov edi, [edi + eax*4]              ; edi = pointer to brick string for this row
    mov edx, edi
    call WriteString
    pop esi
    pop edx

db_skipDraw:
    inc esi
    inc ebx
    add dl, BRICK_WIDTH
    cmp ebx, BRICK_COLS
    jl db_colLoop

    inc dh
    pop ecx
    loop db_rowLoop

    popad
    ret
DrawBricks ENDP

; ==============================================================================
; ApplyDelay  -  Speed based on current level + active power-up effects
; ==============================================================================
ApplyDelay PROC
    pushad

    mov eax, Level
    dec eax
    shl eax, 2
    mov eax, LevelDelays[eax]   ; base delay for this level
    call PU_GetDelayAdjust       ; adjust for slow/fast ball
    call Delay

    popad
    ret
ApplyDelay ENDP

; ==============================================================================
; ShowGameOver
; ==============================================================================
ShowGameOver PROC
    pushad

    mov eax, lightGray + (black * 16)
    call SetTextColor
    call Clrscr

    mov ecx, 25
    mov dh, 0
sgo_bgLoop:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET bgLine
    call WriteString
    inc dh
    loop sgo_bgLoop

    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 5
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET goLine1
    call WriteString

    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 6
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET goLine2
    call WriteString

    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dh, 7
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET goLine3
    call WriteString

    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 8
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET goLine4
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 9
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET goLine5
    call WriteString

    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov dh, 10
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET goLine6
    call WriteString

    ; Final score
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 14
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET goScoreLbl
    call WriteString
    mov eax, Score
    call WriteDec

    ; Level reached
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 15
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET hudLevel
    call WriteString
    mov eax, Level
    call WriteDec

    ; Player name
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 16
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET hudPlayer
    call WriteString
    mov edx, OFFSET PlayerName
    call WriteString

    ; Return prompt
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 20
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET goRetMsg
    call WriteString

    mov dh, 24
    mov dl, 79
    call Gotoxy

sgo_waitKey:
    mov eax, 50
    call Delay
    call ReadKey
    jz sgo_waitKey

    popad
    ret
ShowGameOver ENDP

; ==============================================================================
; UpdateHighScores
; ==============================================================================
UpdateHighScores PROC
    pushad

    mov esi, 0
    mov eax, Score
uhs_findLoop:
    cmp eax, HighScores[esi * 4]
    ja uhs_found
    inc esi
    cmp esi, 5
    jl uhs_findLoop
    jmp uhs_done

uhs_found:
    mov edi, 4
uhs_shiftLoop:
    cmp edi, esi
    jle uhs_insert

    mov eax, edi
    dec eax
    mov ebx, HighScores[eax * 4]
    mov HighScores[edi * 4], ebx

    ; Shift levels too
    mov ebx, HighScoreLevels[eax * 4]
    mov HighScoreLevels[edi * 4], ebx

    push esi
    push edi
    mov ecx, 16
    mov esi, OFFSET HighScoreNames
    mov eax, edi
    dec eax
    imul eax, 16
    add esi, eax
    mov edx, OFFSET HighScoreNames
    mov eax, edi
    imul eax, 16
    add edx, eax
uhs_nameShift:
    mov bl, [esi]
    mov [edx], bl
    inc esi
    inc edx
    loop uhs_nameShift
    pop edi
    pop esi

    dec edi
    jmp uhs_shiftLoop

uhs_insert:
    mov eax, Score
    mov HighScores[esi * 4], eax

    ; Store the current level
    mov eax, Level
    mov HighScoreLevels[esi * 4], eax

    mov edi, OFFSET HighScoreNames
    mov eax, esi
    imul eax, 16
    add edi, eax
    mov esi, OFFSET PlayerName
    mov ecx, 16
uhs_copyName:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    loop uhs_copyName

uhs_done:
    popad
    ret
UpdateHighScores ENDP

; ==============================================================================
; ShowWinScreen  -  Shown after clearing all 3 levels
; ==============================================================================
ShowWinScreen PROC
    pushad

    mov eax, white + (black * 16)
    call SetTextColor
    call Clrscr

    mov ecx, 25
    mov dh, 0
sws_bgLoop:
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET bgLine
    call WriteString
    inc dh
    loop sws_bgLoop

    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 5
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET winLine1
    call WriteString

    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dh, 6
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET winLine2
    call WriteString

    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 7
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET winLine3
    call WriteString

    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov dh, 8
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET winLine4
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 9
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET winLine5
    call WriteString

    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 10
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET winLine6
    call WriteString

    ; Final score
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 14
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET goScoreLbl
    call WriteString
    mov eax, Score
    call WriteDec

    ; Player name line
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 16
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET hudPlayer
    call WriteString
    mov edx, OFFSET PlayerName
    call WriteString

    ; All levels completed line
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 17
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET winAllDone
    call WriteString

    ; Return prompt
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 20
    mov dl, 15
    call Gotoxy
    mov edx, OFFSET goRetMsg
    call WriteString

    mov dh, 24
    mov dl, 79
    call Gotoxy

sws_waitKey:
    mov eax, 50
    call Delay
    call ReadKey
    jz sws_waitKey

    popad
    ret
ShowWinScreen ENDP

; ==============================================================================
; BONUS: SaveHighScores  -  Write scores + names to scores.dat  (+3 marks)
; ==============================================================================
SaveHighScores PROC
    pushad

    ; Create / overwrite the file
    mov edx, OFFSET scoreFileName
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je shs_done
    mov fileHandle, eax

    ; Write HighScores array (5 DWORDs = 20 bytes)
    mov eax, fileHandle
    mov edx, OFFSET HighScores
    mov ecx, 20                      ; 5 * 4 bytes
    call WriteToFile

    ; Write HighScoreNames (5 * 16 = 80 bytes)
    mov eax, fileHandle
    mov edx, OFFSET HighScoreNames
    mov ecx, 80
    call WriteToFile

    ; Write HighScoreLevels (5 DWORDs = 20 bytes)
    mov eax, fileHandle
    mov edx, OFFSET HighScoreLevels
    mov ecx, 20
    call WriteToFile

    ; Close the file
    mov eax, fileHandle
    call CloseFile

shs_done:
    popad
    ret
SaveHighScores ENDP

; ==============================================================================
; BONUS: LoadHighScores  -  Read scores + names from scores.dat  (+3 marks)
; ==============================================================================
LoadHighScores PROC
    pushad

    ; Try to open the file
    mov edx, OFFSET scoreFileName
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je lhs_done                      ; file doesn't exist, skip
    mov fileHandle, eax

    ; Read HighScores array (20 bytes)
    mov eax, fileHandle
    mov edx, OFFSET HighScores
    mov ecx, 20
    call ReadFromFile

    ; Read HighScoreNames (80 bytes)
    mov eax, fileHandle
    mov edx, OFFSET HighScoreNames
    mov ecx, 80
    call ReadFromFile

    ; Read HighScoreLevels (20 bytes)
    mov eax, fileHandle
    mov edx, OFFSET HighScoreLevels
    mov ecx, 20
    call ReadFromFile

    ; Close
    mov eax, fileHandle
    call CloseFile

lhs_done:
    popad
    ret
LoadHighScores ENDP

; ==============================================================================
; BONUS: InitMouse  -  Enable mouse input on console  (+2 marks)
; ==============================================================================
InitMouse PROC
    pushad

    ; Get console input handle
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov ConsoleInHandle, eax

    ; Get current console mode
    INVOKE GetConsoleMode, ConsoleInHandle, ADDR ConsoleMode

    ; Enable mouse input + disable Quick Edit Mode (which intercepts mouse)
    ; ENABLE_QUICK_EDIT_MODE = 0040h, ENABLE_EXTENDED_FLAGS = 0080h
    mov eax, ConsoleMode
    or  eax, ENABLE_MOUSE_INPUT      ; enable mouse events
    or  eax, 0080h                   ; ENABLE_EXTENDED_FLAGS (required)
    and eax, NOT 0040h               ; disable ENABLE_QUICK_EDIT_MODE
    INVOKE SetConsoleMode, ConsoleInHandle, eax

    popad
    ret
InitMouse ENDP

; ==============================================================================
; BONUS: ReadMouseInput  -  Peek for mouse events, move paddle  (+2 marks)
; ==============================================================================
ReadMouseInput PROC
    pushad

rmi_loop:
    ; Peek at the next event without consuming it
    INVOKE PeekConsoleInput, ConsoleInHandle, ADDR MouseInputRec, 1, ADDR MouseEventsRead
    cmp MouseEventsRead, 0
    je rmi_done                      ; no events pending

    ; Check event type
    movzx eax, MouseInputRec.EventType
    cmp eax, MOUSE_EVENT
    je rmi_mouse
    cmp eax, KEY_EVENT
    je rmi_done                      ; leave keyboard events for ReadKey
    ; Other event (focus, resize, etc.) - consume and discard
    INVOKE ReadConsoleInput, ConsoleInHandle, ADDR MouseInputRec, 1, ADDR MouseEventsRead
    jmp rmi_loop

rmi_mouse:
    ; Consume the mouse event
    INVOKE ReadConsoleInput, ConsoleInHandle, ADDR MouseInputRec, 1, ADDR MouseEventsRead

    ; Get mouse X position from the MOUSE_EVENT_RECORD
    ; MouseInputRec.Event is a union; for mouse events, first field is COORD (X, Y)
    ; Offset of Event in INPUT_RECORD = 4 bytes (EventType WORD + 2 padding)
    ; dwMousePosition.X is at offset 4 of INPUT_RECORD
    movzx eax, WORD PTR MouseInputRec.Event.dwMousePosition.X

    ; Determine current paddle width for centering and clamping
    mov ebx, PADDLE_WIDTH
    cmp PU_WasWidened, 1
    jne rmi_normalW
    mov ebx, 18                      ; wide paddle width
rmi_normalW:
    ; Calculate target paddle X: center paddle on mouse
    push ebx
    shr ebx, 1
    sub eax, ebx
    pop ebx

    ; Clamp to playfield walls
    cmp eax, LEFT_WALL
    jge rmi_clampR
    mov eax, LEFT_WALL
rmi_clampR:
    ; Max X = RIGHT_WALL - current paddle width
    mov ecx, RIGHT_WALL
    sub ecx, ebx
    cmp eax, ecx
    jle rmi_setPaddle
    mov eax, ecx
rmi_setPaddle:
    ; Only redraw if paddle actually moved
    cmp eax, PaddleX
    je rmi_loop                      ; no change, check for more events

    call ErasePaddle
    mov PaddleX, eax
    call DrawPaddle
    jmp rmi_loop                     ; process remaining mouse events

rmi_done:
    popad
    ret
ReadMouseInput ENDP

; ==============================================================================
; BONUS: ResetTrail  -  Clear ball trail buffer  (+1 mark)
; ==============================================================================
ResetTrail PROC
    pushad
    mov ecx, TRAIL_LEN
    mov esi, 0
rt_loop:
    mov TrailX[esi*4], -1
    mov TrailY[esi*4], -1
    inc esi
    loop rt_loop
    mov TrailIdx, 0
    popad
    ret
ResetTrail ENDP

; ==============================================================================
; BONUS: UpdateTrail  -  Store current ball position in ring buffer  (+1 mark)
; ==============================================================================
UpdateTrail PROC
    pushad
    mov esi, TrailIdx

    ; Store old ball position (before move) into trail slot
    mov eax, OldBallX
    mov TrailX[esi*4], eax
    mov eax, OldBallY
    mov TrailY[esi*4], eax

    ; Advance ring index
    inc esi
    cmp esi, TRAIL_LEN
    jl ut_noWrap
    mov esi, 0
ut_noWrap:
    mov TrailIdx, esi

    popad
    ret
UpdateTrail ENDP

; ==============================================================================
; BONUS: EraseTrail  -  Erase trail positions, skip if on alive brick  (+1 mark)
; ==============================================================================
EraseTrail PROC
    pushad

    ; Erase all trail positions (they will be redrawn with current positions)
    mov ecx, TRAIL_LEN
    mov esi, 0
et_loop:
    mov eax, TrailX[esi*4]
    cmp eax, -1
    je et_skip                       ; slot not yet used

    ; Check it's in playfield bounds
    cmp eax, LEFT_WALL
    jle et_invalidate
    cmp eax, RIGHT_WALL
    jge et_invalidate

    mov ebx, TrailY[esi*4]
    cmp ebx, PLAYFIELD_TOP
    jle et_invalidate
    cmp ebx, PLAYFIELD_BOTTOM
    jge et_invalidate

    ; Don't erase if it's on the paddle row
    cmp ebx, PADDLE_ROW
    je et_invalidate

    ; Don't erase if it's on an alive brick
    push ecx
    push esi
    ; Check brick: row = TrailY - BRICK_START_ROW, col = (TrailX - BRICK_START_COL) / BRICK_WIDTH
    mov eax, ebx                     ; eax = TrailY value
    sub eax, BRICK_START_ROW
    cmp eax, 0
    jl et_doErase                    ; above brick area, safe to erase
    cmp eax, BRICK_ROWS
    jge et_doErase                   ; below brick area, safe to erase
    mov edi, eax                     ; edi = brick row

    mov eax, TrailX[esi*4]
    sub eax, BRICK_START_COL
    cmp eax, 0
    jl et_doErase
    push edx
    mov ebx, BRICK_WIDTH
    cdq
    idiv ebx
    pop edx
    cmp eax, 0
    jl et_doErase
    cmp eax, BRICK_COLS
    jge et_doErase

    ; eax = brick col, edi = brick row
    push eax
    mov eax, edi
    mov ebx, BRICK_COLS
    mul ebx
    pop ebx                          ; ebx = brick col
    add eax, ebx                     ; eax = brick index
    cmp BrickArray[eax], 1
    je et_skipBrick                  ; brick alive, don't erase

et_doErase:
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    mov eax, TrailY[esi*4]
    mov dh, al
    mov eax, TrailX[esi*4]
    mov dl, al
    call Gotoxy
    mov al, ' '
    call WriteChar
    popad

et_skipBrick:
    pop esi
    pop ecx
    jmp et_skip

et_invalidate:
    ; Position is out of bounds or on paddle - invalidate the slot
    mov TrailX[esi*4], -1
    mov TrailY[esi*4], -1

et_skip:
    inc esi
    dec ecx
    jnz et_loop

    popad
    ret
EraseTrail ENDP

; ==============================================================================
; BONUS: DrawTrail  -  Draw ball trail with fading colors  (+1 mark)
; ==============================================================================
DrawTrail PROC
    pushad

    ; Draw each trail position with progressively brighter colors
    ; TrailIdx points to the NEXT slot (oldest), so we draw from oldest to newest
    mov edi, TrailIdx                ; start from oldest
    mov ecx, TRAIL_LEN
    mov ebx, 0                      ; color index

dt_loop:
    push ecx

    mov eax, TrailX[edi*4]
    cmp eax, -1
    je dt_skip                       ; slot empty

    ; Strict bounds check (must be INSIDE walls, not on them)
    cmp eax, LEFT_WALL + 1
    jl dt_skip
    mov ecx, RIGHT_WALL
    dec ecx
    cmp eax, ecx
    jg dt_skip

    mov esi, TrailY[edi*4]
    cmp esi, PLAYFIELD_TOP + 1
    jl dt_skip
    mov ecx, PLAYFIELD_BOTTOM
    dec ecx
    cmp esi, ecx
    jg dt_skip

    ; Don't draw trail on paddle row
    cmp esi, PADDLE_ROW
    je dt_skip

    ; Don't draw trail on current ball position
    cmp eax, BallX
    jne dt_notBall
    cmp esi, BallY
    je dt_skip
dt_notBall:

    ; Don't draw trail on alive bricks
    push eax
    push ebx
    mov eax, esi                     ; eax = trail Y
    sub eax, BRICK_START_ROW
    cmp eax, 0
    jl dt_okDraw
    cmp eax, BRICK_ROWS
    jge dt_okDraw
    ; eax = brick row
    push eax                         ; save brick row
    mov eax, TrailX[edi*4]
    sub eax, BRICK_START_COL
    cmp eax, 0
    jl dt_popOkDraw
    push edx
    mov ecx, BRICK_WIDTH
    cdq
    idiv ecx
    pop edx
    cmp eax, BRICK_COLS
    jge dt_popOkDraw
    ; eax = brick col, [esp] = brick row
    mov ecx, eax                     ; ecx = brick col
    pop eax                          ; eax = brick row
    push ecx
    mov ebx, BRICK_COLS
    mul ebx
    pop ecx
    add eax, ecx                     ; eax = brick index
    cmp BrickArray[eax], 1
    pop ebx
    pop eax
    je dt_skip                       ; brick alive, don't draw trail on it
    jmp dt_doDraw
dt_popOkDraw:
    pop eax                          ; pop saved brick row
dt_okDraw:
    pop ebx
    pop eax

dt_doDraw:
    ; Set trail color (fading: oldest=dim, newest=bright)
    pushad
    mov eax, TrailColors[ebx*4]
    call SetTextColor
    mov eax, TrailY[edi*4]
    mov dh, al
    mov eax, TrailX[edi*4]
    mov dl, al
    call Gotoxy
    mov al, 0F9h                     ; middle dot character for trail
    call WriteChar
    popad

dt_skip:
    ; Advance ring index
    inc edi
    cmp edi, TRAIL_LEN
    jl dt_noWrap
    mov edi, 0
dt_noWrap:
    inc ebx
    cmp ebx, TRAIL_LEN              ; clamp color index
    jl dt_colorOk
    mov ebx, TRAIL_LEN
    dec ebx
dt_colorOk:
    pop ecx
    dec ecx
    jnz dt_loop

    popad
    ret
DrawTrail ENDP

; ==============================================================================
; HideCursor  -  Make console cursor invisible (reduces flicker)
; ==============================================================================
HideCursor PROC
    pushad
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov ConsoleOutHandle, eax
    INVOKE SetConsoleCursorInfo, ConsoleOutHandle, ADDR CursorInfoHide
    popad
    ret
HideCursor ENDP

; ==============================================================================
; ShowCursor  -  Restore console cursor visibility
; ==============================================================================
ShowCursor PROC
    pushad
    INVOKE SetConsoleCursorInfo, ConsoleOutHandle, ADDR CursorInfoShow
    popad
    ret
ShowCursor ENDP