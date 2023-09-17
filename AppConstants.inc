caption                 db "Fifteen game", 0
aboutText               db "Assembler, Pure & Simple", CR , LF , "Made by Vasiliy Stepchenko 2023", 0
exitConfirmationText    db "Please confirm exit", 0
szClassName             db "Fifteen_Class", 0
howToText               db "Move tiles in grid to order them from 1 to 15", CR , LF , "To move a tile use arrow keys or click a tile.", 0
newGameConfirmationText db "Do you want to start a new game?", 0
congatulationsText      db "You won. Congratulations!", 0

lgfnt                   LOGFONTA <40, 32, 0, 0, FW_NORMAL, 0, 0, 0, 0, 0, 0, 0, 0, "Arial">

tileSize                equ 103
tileMargin              equ 12
tileBorderMargin        equ 26

backgroundColor         equ 00aecaa7h
tileBackgroundColor     equ 00a5ffffh
emptyTileColor          equ 00a0b89ah
tileTextColor           equ 00404040h

windowClientSize        equ 500
windowWidth             equ 520
windowHeight            equ 563

tileRoundedEllipseSize  equ 20

asciiShift              equ 48

prndMagicNumber         equ 08088405H

initialSwapCount        equ 30