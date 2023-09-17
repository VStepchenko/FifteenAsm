.386
.model flat, stdcall
.stack 4096

include WinApiConstants.inc
include WinApiProto.inc

.data
include AppConstants.inc

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

    .IF uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
        xor eax, eax
        ret
    .ENDIF

    invoke DefWindowProcA, hWin, uMsg, wParam, lParam

    ret

WndProc endp

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    mov eax, sDim
    ret

TopXY endp

END start