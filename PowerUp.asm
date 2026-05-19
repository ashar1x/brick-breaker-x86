; =============================================================================
; PowerUp.asm  -  Power-Up / Bonus System
; Iteration 3 | Integrated into GameScreen
; =============================================================================
;
; HOW IT WORKS:
;   - Every time a brick is broken, a counter is checked
;   - Every 3rd brick broken spawns a power-up at that brick's position
;   - Power-up falls down one row per game tick
;   - If paddle catches it, effect is applied + notification shown
;   - If it reaches bottom, it disappears
;
; POWER-UP TYPES:
;   1 = SLOW BALL     - Increases delay (slows ball down)
;   2 = WIDE PADDLE   - Extends paddle width temporarily
;   3 = EXTRA LIFE    - Adds 1 life (max 5)
;   4 = FAST BALL     - Decreases delay (speeds ball up - risky!)
;   5 = MULTI SCORE   - Next 5 bricks worth 3x points
;
; =============================================================================

.386
.data

; ── Power-up state ───────────────────────────────────────────────────────────
PU_Active    DWORD 0        ; 1 = a power-up is currently falling
PU_X         DWORD 0        ; current column on screen
PU_Y         DWORD 0        ; current row on screen
PU_Type      DWORD 0        ; 1-5, see types above
PU_MoveTimer DWORD 0        ; counts frames, moves down every N frames

; ── Active effect timers ─────────────────────────────────────────────────────
PU_SlowTimer    DWORD 0     ; frames remaining for slow ball
PU_WideTimer    DWORD 0     ; frames remaining for wide paddle
PU_MultiTimer   DWORD 0     ; bricks remaining for multi-score
PU_WasWidened   DWORD 0     ; 1 = paddle was widened, needs restoring

; ── Brick spawn counter ──────────────────────────────────────────────────────
PU_BrickCount   DWORD 0     ; increments each brick, spawns on every 3rd

; ── Notification state ───────────────────────────────────────────────────────
PU_NotifyTimer  DWORD 0     ; frames to show notification (0 = hidden)
PU_NotifyType   DWORD 0     ; which type was collected

; ── Power-up display characters (one per type) ───────────────────────────────
; Type 1=S(low), 2=W(ide), 3=+(life), 4=F(ast), 5=M(ulti)
PU_Chars BYTE 'S', 'W', '+', 'F', 'M'
PU_Colors DWORD \
    (lightCyan    + black * 16), \   ; 1 slow  - cyan
    (lightGreen   + black * 16), \   ; 2 wide  - green
    (lightRed     + black * 16), \   ; 3 life  - red
    (yellow       + black * 16), \   ; 4 fast  - yellow
    (lightMagenta + black * 16)      ; 5 multi - magenta

; ── Notification strings ─────────────────────────────────────────────────────
puNotify1 BYTE " SLOW BALL activated!   ", 0
puNotify2 BYTE " WIDE PADDLE activated! ", 0
puNotify3 BYTE " EXTRA LIFE gained!     ", 0
puNotify4 BYTE " FAST BALL activated!   ", 0
puNotify5 BYTE " SCORE x3 activated!    ", 0
puNotifyPtrs DWORD OFFSET puNotify1, OFFSET puNotify2, OFFSET puNotify3,
                   OFFSET puNotify4, OFFSET puNotify5
puNotifyBlank BYTE "                        ", 0

; ── Notification position ────────────────────────────────────────────────────
PU_NOTIFY_ROW EQU 23        ; just above bottom border
PU_NOTIFY_COL EQU 28

; ── Wide paddle string (14 chars) ────────────────────────────────────────────
widePaddleStr  BYTE "<================>" , 0   ; 16 chars
blankWidePaddle BYTE "                  ", 0   ; 18 spaces

; ── Slow/fast delta values ───────────────────────────────────────────────────
PU_SLOW_FRAMES  EQU 150     ; frames slow lasts
PU_WIDE_FRAMES  EQU 200     ; frames wide paddle lasts
PU_MOVE_RATE    EQU 4       ; move power-up down every 4 frames

.code

; =============================================================================
; PU_TrySpawn  -  Called after each brick break. Spawns power-up every 3 bricks
; IN: ECX = screen column of broken brick, EDX = screen row of broken brick
; =============================================================================
PU_TrySpawn PROC
    pushad

    ; Save brick position (ECX=col, EDX=row) before idiv clobbers EDX
    push ecx                ; save brick col
    push edx                ; save brick row

    ; Always increment brick counter (even if a power-up is already falling)
    inc PU_BrickCount

    ; Only spawn every 3rd brick
    mov eax, PU_BrickCount
    mov ebx, 3
    cdq
    idiv ebx
    cmp edx, 0
    jne pts_done            ; remainder != 0, skip

    ; Don't spawn if one is already falling
    cmp PU_Active, 1
    je pts_done

    ; Activate power-up at brick position (restore saved coords)
    mov PU_Active, 1
    mov eax, [esp + 4]     ; saved brick col (ECX was pushed second-to-last)
    mov PU_X, eax
    mov eax, [esp]         ; saved brick row (EDX was pushed last)
    mov PU_Y, eax
    mov PU_MoveTimer, 0

    ; Pick random type 1-5 using Irvine32 RandomRange
    mov eax, 5
    call RandomRange        ; eax = 0..4
    inc eax                 ; eax = 1..5
    mov PU_Type, eax

pts_done:
    pop edx                 ; restore saved brick row
    pop ecx                 ; restore saved brick col
    popad
    ret
PU_TrySpawn ENDP

; =============================================================================
; PU_Update  -  Called every frame. Moves power-up down, checks collection
; =============================================================================
PU_Update PROC
    pushad

    cmp PU_Active, 1
    jne pu_checkEffects

    ; Increment move timer
    inc PU_MoveTimer
    mov eax, PU_MoveTimer
    cmp eax, PU_MOVE_RATE
    jl pu_checkEffects      ; not time to move yet

    ; Reset move timer
    mov PU_MoveTimer, 0

    ; Erase at current position
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    mov eax, PU_Y
    mov dh, al
    mov eax, PU_X
    mov dl, al
    call Gotoxy
    mov al, ' '
    call WriteChar
    popad

    ; Move down
    inc PU_Y

    ; Check if reached bottom (lost)
    mov eax, PU_Y
    cmp eax, PADDLE_ROW + 1
    jge pu_deactivate

    ; Check paddle collision
    mov eax, PU_Y
    cmp eax, PADDLE_ROW
    jne pu_drawPU

    ; Check X overlaps paddle
    mov eax, PU_X
    mov ebx, PaddleX
    cmp eax, ebx
    jl pu_deactivate        ; left of paddle
    add ebx, PADDLE_WIDTH
    cmp eax, ebx
    jge pu_deactivate       ; right of paddle

    ; ── COLLECTED ────────────────────────────────────────────
    call PU_ApplyEffect
    jmp pu_deactivate

pu_drawPU:
    ; Draw power-up at new position
    pushad
    mov eax, PU_Type
    dec eax
    shl eax, 2
    mov eax, PU_Colors[eax]
    call SetTextColor
    mov eax, PU_Y
    mov dh, al
    mov eax, PU_X
    mov dl, al
    call Gotoxy
    mov eax, PU_Type
    dec eax
    mov al, PU_Chars[eax]
    call WriteChar
    popad
    jmp pu_checkEffects

pu_deactivate:
    mov PU_Active, 0

pu_checkEffects:
    ; ── Tick slow timer ──────────────────────────────────────
    mov eax, PU_SlowTimer
    cmp eax, 0
    je pu_checkWide
    jl pu_tickFastTimer
    dec PU_SlowTimer
    jnz pu_checkWide
    ; Slow expired - nothing to restore (delay handled in ApplyDelay)
    jmp pu_checkWide

pu_tickFastTimer:
    inc PU_SlowTimer
    jnz pu_checkWide
    ; Fast effect expired (negative timer reached zero)

pu_checkWide:
    ; ── Tick wide timer ──────────────────────────────────────
    mov eax, PU_WideTimer
    cmp eax, 0
    je pu_checkNotify
    dec PU_WideTimer
    jnz pu_checkNotify
    ; Wide expired - restore normal paddle
    cmp PU_WasWidened, 1
    jne pu_checkNotify
    call ErasePaddle                ; erase while still wide (uses wide blank)
    mov PU_WasWidened, 0            ; NOW clear the flag
    call DrawPaddle                 ; draw normal-width paddle

pu_checkNotify:
    ; ── Tick notification timer ──────────────────────────────
    mov eax, PU_NotifyTimer
    cmp eax, 0
    je pu_done
    dec PU_NotifyTimer
    jnz pu_done
    ; Timer just expired - clear notification
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, PU_NOTIFY_ROW
    mov dl, PU_NOTIFY_COL
    call Gotoxy
    mov edx, OFFSET puNotifyBlank
    call WriteString
    popad

pu_done:
    popad
    ret
PU_Update ENDP

; =============================================================================
; PU_ApplyEffect  -  Apply collected power-up effect
; =============================================================================
PU_ApplyEffect PROC
    pushad

    ; BONUS: Power-up collected sound
    INVOKE Beep, 1200, 5

    mov eax, PU_Type

    cmp eax, 1
    je pu_slowBall

    cmp eax, 2
    je pu_widePaddle

    cmp eax, 3
    je pu_extraLife

    cmp eax, 4
    je pu_fastBall

    cmp eax, 5
    je pu_multiScore

    jmp pu_notify

pu_slowBall:
    mov PU_SlowTimer, PU_SLOW_FRAMES
    jmp pu_notify

pu_widePaddle:
    cmp PU_WasWidened, 1    ; don't stack
    je pu_notify
    call ErasePaddle            ; erase normal paddle first
    mov PU_WideTimer, PU_WIDE_FRAMES
    mov PU_WasWidened, 1
    call DrawPaddle             ; DrawPaddle now auto-draws wide when PU_WasWidened=1
    jmp pu_notify

pu_extraLife:
    mov eax, Lives
    cmp eax, 5
    jge pu_notify           ; cap at 5
    inc Lives
    jmp pu_notify

pu_fastBall:
    ; Fast ball: cut slow timer and set negative slow (handled in ApplyDelay)
    ; We store -1 in SlowTimer as "fast mode" flag for 100 frames
    mov PU_SlowTimer, 0     ; cancel any slow
    ; We reuse SlowTimer as -100 to signal fast (negative = fast)
    mov eax, -100
    mov PU_SlowTimer, eax
    jmp pu_notify

pu_multiScore:
    mov PU_MultiTimer, 5    ; next 5 bricks worth 3x

pu_notify:
    ; Show notification
    mov eax, PU_Type
    mov PU_NotifyType, eax
    mov PU_NotifyTimer, 35   ; show for ~3 seconds

    ; Draw notification
    pushad
    mov eax, PU_Type
    dec eax
    shl eax, 2
    mov eax, PU_Colors[eax]
    call SetTextColor
    mov dh, PU_NOTIFY_ROW
    mov dl, PU_NOTIFY_COL
    call Gotoxy
    mov eax, PU_NotifyType
    dec eax
    shl eax, 2
    mov edx, puNotifyPtrs[eax]
    call WriteString
    popad

    popad
    ret
PU_ApplyEffect ENDP

; =============================================================================
; PU_GetDelayAdjust  -  Returns adjusted delay in EAX based on active effects
; Call this from ApplyDelay instead of fixed value
; IN:  EAX = base delay for current level
; OUT: EAX = adjusted delay
; =============================================================================
PU_GetDelayAdjust PROC
    ; Check slow timer
    mov ebx, PU_SlowTimer
    cmp ebx, 0
    jg pad_slow
    jl pad_fast
    ret                     ; no effect, return base as-is

pad_slow:
    ; Slow: add 40ms to base
    add eax, 40
    ret

pad_fast:
    ; Fast: subtract 20ms (but floor at 15ms)
    sub eax, 20
    cmp eax, 15
    jge pad_done
    mov eax, 15
pad_done:
    ret
PU_GetDelayAdjust ENDP

; =============================================================================
; PU_GetScoreBonus  -  Returns score to add for a brick break
; OUT: EAX = score to add (10 base, or 30 if multi-score active)
; =============================================================================
PU_GetScoreBonus PROC
    mov eax, 10
    ; Add level bonus
    mov ebx, Level
    dec ebx
    imul ebx, 5
    add eax, ebx

    ; Check multi-score
    cmp PU_MultiTimer, 0
    je pgsb_done
    dec PU_MultiTimer
    imul eax, 3             ; triple score

pgsb_done:
    ret
PU_GetScoreBonus ENDP

; =============================================================================
; PU_Reset  -  Reset all power-up state (call from InitGame and InitLevel)
; =============================================================================
PU_Reset PROC
    pushad

    mov PU_Active, 0
    mov PU_X, 0
    mov PU_Y, 0
    mov PU_Type, 0
    mov PU_MoveTimer, 0
    mov PU_SlowTimer, 0
    mov PU_WideTimer, 0
    mov PU_MultiTimer, 0
    mov PU_WasWidened, 0
    mov PU_NotifyTimer, 0
    mov PU_NotifyType, 0
    mov PU_BrickCount, 0

    ; Clear notification area
    pushad
    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, PU_NOTIFY_ROW
    mov dl, PU_NOTIFY_COL
    call Gotoxy
    mov edx, OFFSET puNotifyBlank
    call WriteString
    popad

    popad
    ret
PU_Reset ENDP