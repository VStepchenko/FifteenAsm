.386
.model flat, stdcall
.stack 4096

include WinApiConstants.inc
include WinApiProto.inc

CalculateTileRect    PROTO :DWORD, :BYTE, :BYTE
CalculateTileRectPos PROTO :BYTE,  :DWORD
PaintProc            PROTO :DWORD, :DWORD
SwapTiles            PROTO :DWORD, :DWORD
ProcessArrow         PROTO :DWORD, :DWORD
ProcessPossibleWin   PROTO :DWORD
ProcessClick         PROTO :DWORD, :DWORD

.data
include AppConstants.inc

tilesArray    db 16 dup (0)
hInstance     dd 0
commandLine   dd 0
hWnd          dd 0

.code
start:

    push NULL
    call GetModuleHandleA
    mov hInstance, eax

    call GetCommandLineA
    mov CommandLine, eax

    push SW_SHOWDEFAULT
    push CommandLine
    push NULL
    push hInstance
    call WinMain

    push eax
    call ExitProcess

WinMain proc hInst :DWORD, hPrevInst :DWORD, CmdLine :DWORD, CmdShow :DWORD

    LOCAL wc   :WNDCLASSEX
    LOCAL msg  :MSGSTRUCT

    LOCAL Wwd  :DWORD
    LOCAL Wht  :DWORD
    LOCAL Wtx  :DWORD
    LOCAL Wty  :DWORD

    call InitTilesData

    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc,    offset WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    mov eax,               hInst
    mov wc.hInstance,      eax
    mov wc.hbrBackground,  COLOR_BTNSHADOW
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  offset szClassName

    push 500
    push hInst
    call LoadIconA
    mov wc.hIcon, eax
    
    push IDC_ARROW
    push NULL
    call LoadCursorA
    mov wc.hCursor, eax
    mov wc.hIconSm, 0

    lea eax, wc
    push eax
    call RegisterClassExA

    ; Centre window at following size

    mov Wwd, windowWidth
    mov Wht, windowHeight

    push SM_CXSCREEN
    call GetSystemMetrics

    push eax
    push Wwd
    call TopXY
    mov Wtx, eax

    push SM_CYSCREEN
    call GetSystemMetrics

    push eax
    push Wht
    call TopXY
    mov Wty, eax

    push NULL
    push hInst
    push NULL
    push NULL
    push Wht
    push Wwd
    push Wty
    push Wtx
    push WS_BORDER or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX
    push offset caption
    push offset szClassName
    push WS_EX_OVERLAPPEDWINDOW or WS_EX_COMPOSITED ;magic word WS_EX_COMPOSITED to enable double buffering
    call CreateWindowExA

    mov hWnd,eax

    push 600
    push hInst
    call LoadMenuA

    push eax
    push hWnd
    call SetMenu

    push SW_SHOWNORMAL
    push hWnd
    call ShowWindow

    push hWnd
    call UpdateWindow

    ; Loop until PostQuitMessage is sent
    .WHILE TRUE
    invoke GetMessageA, ADDR msg, NULL, 0, 0
    .BREAK .IF (!eax)
        invoke TranslateMessage, ADDR msg
        invoke DispatchMessageA, ADDR msg
    .ENDW

    mov eax, msg.wParam
    ret

WinMain endp

WndProc proc hWin :DWORD, uMsg :DWORD, wParam :DWORD, lParam :DWORD

    LOCAL Ps     :PAINTSTRUCT
    LOCAL hDC    :DWORD

    .IF uMsg == WM_COMMAND

        .IF wParam == 1000
            invoke SendMessageA, hwin, WM_SYSCOMMAND, SC_CLOSE, NULL
        .ENDIF

        .IF wParam == 1100
            invoke MessageBoxA, hwin, ADDR newGameConfirmationText, ADDR caption, MB_YESNO
            .IF eax == IDYES
                call InitTilesData
            .ELSEIF eax == IDNO
                xor eax, eax
                ret
            .ENDIF
        .ENDIF

        .IF wParam == 1800
            invoke MessageBoxA, hwin, ADDR howToText, ADDR caption, MB_OK
        .ENDIF

        .IF wParam == 1900
            invoke MessageBoxA, hwin, ADDR aboutText, ADDR caption, MB_OK
        .ENDIF

    .ENDIF

    .IF uMsg == WM_KEYDOWN
        .if wParam == VK_LEFT
            invoke ProcessArrow, hWin, wParam
        .elseif wParam == VK_RIGHT
            invoke ProcessArrow, hWin, wParam
         .elseif wParam == VK_UP
            invoke ProcessArrow, hWin, wParam
         .elseif wParam == VK_DOWN
            invoke ProcessArrow, hWin, wParam
        .endif
    .ENDIF

    .IF uMsg == WM_LBUTTONUP
        invoke ProcessClick, hWin, lParam
    .ENDIF

    .IF uMsg == WM_PAINT
        invoke BeginPaint, hWin, ADDR Ps
          mov hDC, eax
          invoke PaintProc, hWin, hDC
        invoke EndPaint, hWin, ADDR Ps
    .ENDIF

    .IF uMsg == WM_CLOSE
        invoke MessageBoxA, hwin, ADDR exitConfirmationText, ADDR caption, MB_YESNO
        .IF eax == IDNO
            xor eax, eax
            ret
        .ENDIF
    .ENDIF

    .IF uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
        xor eax, eax
        ret
    .ENDIF

    invoke DefWindowProcA, hWin, uMsg, wParam, lParam

    ret

WndProc endp

PaintProc proc hWin:DWORD, hDC:DWORD

    LOCAL Rct       : RECT
    LOCAL hBrush    : DWORD
    LOCAL hor       : byte
    LOCAL vert      : byte
    LOCAL rectLeft, rectTop, rectRight, rectBottom : DWORD
    LOCAL buffer[3] : BYTE
    LOCAL hFont:DWORD

    invoke CreateSolidBrush, backgroundColor
    mov hBrush, eax
    invoke SelectObject, hDC, hBrush

    mov Rct.left, 0
    mov Rct.top, 0
    mov Rct.right, windowClientSize
    mov Rct.bottom, windowClientSize
    invoke FillRect, hDC, ADDR Rct, hBrush
    invoke DeleteObject, hBrush

    invoke CreateSolidBrush, tileBackgroundColor
    mov hBrush, eax
    invoke SelectObject, hDC, hBrush

    ;fill tiles with background color
    mov vert, 0
    .WHILE vert < 4
        mov hor, 0
        .WHILE hor < 4
            
            invoke CalculateTileRect, ADDR Rct, hor, vert
            invoke RoundRect, hDC, Rct.left, Rct.top, Rct.right, Rct.bottom, tileRoundedEllipseSize, tileRoundedEllipseSize
            
        inc hor
        .ENDW
        inc vert
    .ENDW

    invoke DeleteObject, hBrush

    ;draw digits and empty tile
    mov vert, 0
    .WHILE vert < 4
        mov hor, 0
        .WHILE hor < 4
            
            mov eax, 4
            mul vert
            add al, hor
            
            mov bl, [tilesArray+eax]

            invoke CalculateTileRect, ADDR Rct, hor, vert

            .IF bl == 0
                ;fill an empty tile with background color
                invoke CreateSolidBrush, emptyTileColor
                mov hBrush, eax
                invoke SelectObject, hDC, hBrush
                invoke RoundRect, hDC, Rct.left, Rct.top, Rct.right, Rct.bottom, tileRoundedEllipseSize, tileRoundedEllipseSize
                invoke DeleteObject, hBrush
            .ELSEIF
                ;draw a number

                mov [buffer+1], 0
                mov [buffer+2], 0

               .IF bl < 10
                    add bl, asciiShift
                    mov [buffer], bl
                    sub bl, asciiShift
               .ELSEIF bl > 9
                    mov al, asciiShift
                    inc al
                    mov [buffer], al

                    xor ax, ax
                    mov al, bl
                    mov cl, 10
                    div cl
                    add ah, asciiShift
                    mov [buffer+1], ah
               .ENDIF

                invoke CreateFontIndirectA, ADDR lgfnt
                mov hFont, eax
                invoke SelectObject, hDC, hFont

                invoke SetTextColor, hDC, tileTextColor
                invoke SetBkMode, hDC, TRANSPARENT
                invoke DrawTextA, hDC, ADDR buffer, -1, ADDR Rct, DT_CENTER or DT_VCENTER or DT_SINGLELINE 

                invoke DeleteObject, hFont
            .ENDIF

        inc hor
        .ENDW
        inc vert
    .ENDW

    ret

PaintProc endp

CalculateTileRect proc rct :DWORD, hor:BYTE, vert:BYTE

    mov edx, rct

    invoke CalculateTileRectPos, hor, 0
    mov (RECT PTR [edx]).left, eax

    invoke CalculateTileRectPos, hor, tileSize
    mov (RECT PTR [edx]).right, eax

    invoke CalculateTileRectPos, vert, 0
    mov (RECT PTR [edx]).top, eax

    invoke CalculateTileRectPos, vert, tileSize
    mov (RECT PTR [edx]).bottom, eax

    ret
CalculateTileRect endp

CalculateTileRectPos proc tilePosition:byte, additionalTileSize:DWORD
    
    mov eax, tileSize
    add eax, tileMargin
    mul tilePosition
    add eax, tileBorderMargin
    add eax, additionalTileSize
    
    ret
    
CalculateTileRectPos endp

InitTilesData proc

    local randSeed : DWORD

    invoke GetTickCount
    mov randSeed, eax

    xor eax, eax
    xor ebx, ebx

    .WHILE eax < 16
        mov bl, al
        inc bl
        mov [tilesArray+eax], bl
        inc eax
    .ENDW

    mov [tilesArray+15], 0

    xor ebx, ebx
    .WHILE ebx < initialSwapCount
        
        mov eax, 4
        push edx
        imul edx, randSeed, prndMagicNumber
        inc edx
        mov randSeed, edx
        mul edx
        mov eax, edx
        pop edx

        add al, VK_LEFT
        push ebx
        invoke ProcessArrow, NULL, al
        pop ebx

        inc ebx
    .ENDW

    ret

InitTilesData endp

ProcessPossibleWin proc hWin:DWORD

    xor eax, eax
    xor ebx, ebx
    
    .WHILE eax < 15
        mov bl, [tilesArray+eax]
        dec bl
        cmp eax, ebx
        jne pass
        inc eax
    .ENDW
        
    invoke MessageBoxA, hwin, ADDR congatulationsText, ADDR caption, MB_OK
    call InitTilesData

    pass:
    ret

ProcessPossibleWin endp

ProcessArrow proc hWin:DWORD, key:DWORD

    call FindEmptyTileIndex

    .IF key == VK_UP
        cmp eax, 12
        ja pass

        ;when tile goes up, new empty tile index (ETI) will be ETI+4,
        mov ebx, eax
        add ebx, 4
    .ENDIF

    .IF key == VK_DOWN
        cmp eax, 4
        jb pass

        ;when tile goes down, new empty tile index (ETI) will be ETI-4,
        mov ebx, eax
        sub ebx, 4
    .ENDIF

    .IF key == VK_RIGHT
        ;empty tile shouldnt be on 0, 4, 8, 12 indexes
        cmp eax, 0
        je pass
        cmp eax, 4
        je pass
        cmp eax, 8
        je pass
        cmp eax, 12
        je pass

        ;when tile goes right, new empty tile index (ETI) will be ETI-1,
        mov ebx, eax
        dec ebx
    .ENDIF

    .IF key == VK_LEFT
        ;empty tile shouldnt be on 3, 7, 11, 15 indexes
        cmp eax, 3
        je pass
        cmp eax, 7
        je pass
        cmp eax, 11
        je pass
        cmp eax, 15
        je pass

        ;when tile goes left, new empty tile index (ETI) will be ETI+1,
        mov ebx, eax
        inc ebx
    .ENDIF

    invoke SwapTiles, eax, ebx
    .IF hWin != NULL ;little trick to simplify initial random data
        invoke RedrawWindow, hWin, NULL, NULL, RDW_INVALIDATE
        invoke ProcessPossibleWin, hWin
    .ENDIF

    pass:
    ret
ProcessArrow endp

ProcessClick proc hWin:DWORD, lParam:DWORD
        
    local hor : byte
    local vert : byte
    local index : byte
    local rct : RECT

    movsx ebx, WORD PTR [ebp+12] ; x coordinate
    movsx ecx, WORD PTR [ebp+14] ; y coordinate

    mov vert, 0
    .WHILE vert < 4
        mov hor, 0
        .WHILE hor < 4
            
            invoke CalculateTileRect, ADDR Rct, hor, vert
            
            cmp ebx, Rct.left
            jb next
            cmp ebx, Rct.right
            ja next
            cmp ecx, Rct.top
            jb next
            cmp ecx, Rct.bottom
            ja next

            mov eax, 4
            mul vert
            add al, hor
            mov index, al

            mov bl, [tilesArray+eax]
            .IF bl != 0
                
                ; the idea is that tile can be moved only if there is a particular diff between its index and empty tile index
                ; -1, +1 ,-4, +4 for different directions, similar to ProcessArrow proc
                call FindEmptyTileIndex

                .IF index > al
                    sub index, al
                    .IF index == 1
                        invoke ProcessArrow, hWin, VK_LEFT
                    .ELSEIF index == 4
                        invoke ProcessArrow, hWin, VK_UP
                    .ENDIF
                .ELSEIF index < al
                    sub al, index
                    .IF al == 1
                        invoke ProcessArrow, hWin, VK_RIGHT
                    .ELSEIF al == 4
                        invoke ProcessArrow, hWin, VK_DOWN
                    .ENDIF
                .ENDIF
                
            .ENDIF

        next:

        inc hor
        .ENDW
        inc vert
    .ENDW

    ret
ProcessClick endp

SwapTiles proc oldIndex:DWORD, newIndex:DWORD

    mov eax, oldIndex
    mov ebx, newIndex

    mov cl, [tilesArray+ebx]
    mov [tilesArray+eax], cl
    mov [tilesArray+ebx], 0
    
    ret
    
SwapTiles endp

FindEmptyTileIndex proc

    xor eax, eax

    .WHILE [tilesArray+eax] != 0
        inc eax
    .ENDW

    ret

FindEmptyTileIndex endp

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    mov eax, sDim
    ret

TopXY endp

END start