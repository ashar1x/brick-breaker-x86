INCLUDE Irvine32.inc

; WINDOWS MULTIMEDIA API
mciSendStringA PROTO,
    lpstrCommand:PTR BYTE,
    lpstrReturnString:PTR BYTE,
    uReturnLength:DWORD,
    hwndCallback:DWORD

includelib winmm.lib

Beep PROTO, dwFreq:DWORD, dwDuration:DWORD
MessageBeep PROTO, uType:DWORD

.data

; ========================================
; GAME SETTINGS
; ========================================
WinTarget DWORD 0

; ========================================
; GLOBAL GAME DATA
; ========================================
BricksBroken DWORD 0

PlayerName BYTE 16 DUP(0)
PlayerNameLen DWORD 0

HighScores DWORD 5 DUP(0)
HighScoreNames BYTE 5 * 16 DUP(0)
HighScoreLevels DWORD 5 DUP(0)

; ========================================
; AUDIO COMMANDS
; ========================================
openMusic  BYTE 'open "menu.mp3" type mpegvideo alias bgm',0
;openMusic  BYTE 'open "trumpet.mp3" type mpegvideo alias bgm',0
playMusic  BYTE 'play bgm repeat',0
stopMusic  BYTE 'stop bgm',0
closeMusic BYTE 'close bgm',0

; ========================================
; INCLUDE GAME FILES
; ========================================
INCLUDE HomeScreen.asm
INCLUDE NameScreen.asm
INCLUDE MainMenuScreen.asm
INCLUDE InstructionsScreen.asm
INCLUDE HighScoreScreen.asm
INCLUDE PowerUp.asm
INCLUDE GameScreen.asm

.code

; ========================================
; PLAY MP3
; ========================================
PlayMP3 PROC

    invoke mciSendStringA, ADDR openMusic, 0, 0, 0
    invoke mciSendStringA, ADDR playMusic, 0, 0, 0

    ret

PlayMP3 ENDP

; ========================================
; STOP MP3
; ========================================
StopMP3 PROC

    invoke mciSendStringA, ADDR stopMusic, 0, 0, 0
    invoke mciSendStringA, ADDR closeMusic, 0, 0, 0

    ret

StopMP3 ENDP

; ========================================
; MAIN PROGRAM
; ========================================
main PROC

    call Clrscr

    ; Start music for menus/screens
    call PlayMP3

    ; Load highscores
    call LoadHighScores

    ; Intro Screens
    call HomeScreen
    call NameScreen

menuLoop:

    ; Ensure menu music is playing
    call PlayMP3

    call MainMenuScreen

    cmp eax, 1
    je  goGame

    cmp eax, 2
    je  goInst

    cmp eax, 3
    je  goHighScores

    cmp eax, 4
    je  goExit

    jmp menuLoop

; ========================================
; START GAME
; ========================================
goGame:

    ; Stop music during gameplay
    call StopMP3

    call GameScreen

    ; Restart music after gameplay
    call PlayMP3

    jmp menuLoop

; ========================================
; INSTRUCTIONS
; ========================================
goInst:

    call InstructionsScreen
    jmp menuLoop

; ========================================
; HIGH SCORES
; ========================================
goHighScores:

    call HighScoreScreen
    jmp menuLoop

; ========================================
; EXIT GAME
; ========================================
goExit:

    ; Stop music before exiting
    call StopMP3

    exit

main ENDP

END main