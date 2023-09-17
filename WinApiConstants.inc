MB_OK                                equ 0
MB_ICONEXCLAMATION                   equ 00000030h
MB_YESNO                             equ 00000004h

DT_CENTER                            equ 1h
DT_VCENTER                           equ 4h
DT_SINGLELINE                        equ 20h

TRANSPARENT                          equ 1
OPAQUE                               equ 2

CR                                   equ 13
LF                                   equ 10

NULL                                 equ 0
TRUE                                 equ 1
FALSE                                equ 0

IDC_ARROW                            equ 32512

IDYES                                equ 6
IDNO                                 equ 7

SW_SHOWDEFAULT                       equ 10

COLOR_BTNFACE                        equ 15
COLOR_BTNSHADOW                      equ 16

CS_VREDRAW                           equ 1h
CS_HREDRAW                           equ 2h
CS_BYTEALIGNWINDOW                   equ 2000h

SM_CXSCREEN                          equ 0
SM_CYSCREEN                          equ 1

SW_SHOWNORMAL                        equ 1

SC_CLOSE                             equ 0F060h

WM_COMMAND                           equ 111h
WM_SYSCOMMAND                        equ 112h
WM_DESTROY                           equ 2h
WM_CLOSE                             equ 10h
WM_PAINT                             equ 0Fh
WM_KEYDOWN                           equ 100h
WM_KEYUP                             equ 101h
WM_LBUTTONDOWN                       equ 201h
WM_LBUTTONUP                         equ 202h
WM_LBUTTONDBLCLK                     equ 203h

WS_OVERLAPPED                        equ 0h
WS_POPUP                             equ 80000000h
WS_CHILD                             equ 40000000h
WS_MINIMIZE                          equ 20000000h
WS_VISIBLE                           equ 10000000h
WS_DISABLED                          equ 8000000h
WS_CLIPSIBLINGS                      equ 4000000h
WS_CLIPCHILDREN                      equ 2000000h
WS_MAXIMIZE                          equ 1000000h
WS_CAPTION                           equ 0C00000h
WS_BORDER                            equ 800000h
WS_DLGFRAME                          equ 400000h
WS_VSCROLL                           equ 200000h
WS_HSCROLL                           equ 100000h
WS_SYSMENU                           equ 80000h
WS_THICKFRAME                        equ 40000h
WS_GROUP                             equ 20000h
WS_TABSTOP                           equ 10000h
WS_MINIMIZEBOX                       equ 20000h
WS_MAXIMIZEBOX                       equ 10000h
WS_TILED                             equ WS_OVERLAPPED
WS_ICONIC                            equ WS_MINIMIZE
WS_SIZEBOX                           equ WS_THICKFRAME
WS_OVERLAPPEDWINDOW                  equ WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
WS_TILEDWINDOW                       equ WS_OVERLAPPEDWINDOW
WS_POPUPWINDOW                       equ WS_POPUP OR WS_BORDER OR WS_SYSMENU
WS_CHILDWINDOW                       equ WS_CHILD
WS_EX_DLGMODALFRAME                  equ 1h
WS_EX_NOPARENTNOTIFY                 equ 4h
WS_EX_TOPMOST                        equ 8h
WS_EX_ACCEPTFILES                    equ 10h
WS_EX_TRANSPARENT                    equ 20h
WS_EX_MDICHILD                       equ 00000040h
WS_EX_TOOLWINDOW                     equ 00000080h
WS_EX_WINDOWEDGE                     equ 00000100h
WS_EX_CLIENTEDGE                     equ 00000200h
WS_EX_CONTEXTHELP                    equ 00000400h
WS_EX_RIGHT                          equ 00001000h
WS_EX_LEFT                           equ 00000000h
WS_EX_RTLREADING                     equ 00002000h
WS_EX_LTRREADING                     equ 00000000h
WS_EX_LEFTSCROLLBAR                  equ 00004000h
WS_EX_RIGHTSCROLLBAR                 equ 00000000h
WS_EX_CONTROLPARENT                  equ 00010000h
WS_EX_STATICEDGE                     equ 00020000h
WS_EX_APPWINDOW                      equ 00040000h
WS_EX_OVERLAPPEDWINDOW               equ WS_EX_WINDOWEDGE OR WS_EX_CLIENTEDGE
WS_EX_PALETTEWINDOW                  equ WS_EX_WINDOWEDGE OR WS_EX_TOOLWINDOW OR WS_EX_TOPMOST

WS_EX_DLGMODALFRAME                  equ 1h
WS_EX_NOPARENTNOTIFY                 equ 4h
WS_EX_TOPMOST                        equ 8h
WS_EX_ACCEPTFILES                    equ 10h
WS_EX_TRANSPARENT                    equ 20h
WS_EX_MDICHILD                       equ 00000040h
WS_EX_TOOLWINDOW                     equ 00000080h
WS_EX_WINDOWEDGE                     equ 00000100h
WS_EX_CLIENTEDGE                     equ 00000200h
WS_EX_CONTEXTHELP                    equ 00000400h
WS_EX_RIGHT                          equ 00001000h
WS_EX_LEFT                           equ 00000000h
WS_EX_RTLREADING                     equ 00002000h
WS_EX_LTRREADING                     equ 00000000h
WS_EX_LEFTSCROLLBAR                  equ 00004000h
WS_EX_RIGHTSCROLLBAR                 equ 00000000h
WS_EX_CONTROLPARENT                  equ 00010000h
WS_EX_STATICEDGE                     equ 00020000h
WS_EX_APPWINDOW                      equ 00040000h
WS_EX_OVERLAPPEDWINDOW               equ WS_EX_WINDOWEDGE OR WS_EX_CLIENTEDGE
WS_EX_PALETTEWINDOW                  equ WS_EX_WINDOWEDGE OR WS_EX_TOOLWINDOW OR WS_EX_TOPMOST
WS_EX_COMPOSITED                     equ 02000000h
WS_EX_TRANSPARENT                    equ 20h

LF_FACESIZE                          equ 32

DEFAULT_GUI_FONT                     equ 17

FW_NORMAL                            equ 400
FW_BOLD                              equ 700

VK_DOWN                              equ 28h
VK_LEFT                              equ 25h
VK_RIGHT                             equ 27h
VK_UP                                equ 26h

RDW_INVALIDATE                       equ 1h
RDW_INTERNALPAINT                    equ 2h
RDW_ERASE                            equ 4h
RDW_VALIDATE                         equ 8h

POINT STRUCT
  x  DWORD ?
  y  DWORD ?
POINT ENDS

WNDCLASSEX STRUCT
  cbSize            DWORD ?
  style             DWORD ?
  lpfnWndProc       DWORD ?
  cbClsExtra        DWORD ?
  cbWndExtra        DWORD ?
  hInstance         DWORD ?
  hIcon             DWORD ?
  hCursor           DWORD ?
  hbrBackground     DWORD ?
  lpszMenuName      DWORD ?
  lpszClassName     DWORD ?
  hIconSm           DWORD ?
WNDCLASSEX ENDS

MSGSTRUCT STRUCT
  hwnd      DWORD ?
  message   DWORD ?
  wParam    DWORD ?
  lParam    DWORD ?
  time      DWORD ?
  pt        POINT <>
MSGSTRUCT ENDS

RECT STRUCT
  left    dd ?
  top     dd ?
  right   dd ?
  bottom  dd ?
RECT ENDS

PAINTSTRUCT STRUCT
  hdc           DWORD ?
  fErase        DWORD ?
  rcPaint       RECT <>
  fRestore      DWORD ?
  fIncUpdate    DWORD ?
  rgbReserved   BYTE 32 dup(?)
PAINTSTRUCT ENDS

LOGFONTA STRUCT
  lfHeight          DWORD ?
  lfWidth           DWORD ?
  lfEscapement      DWORD ?
  lfOrientation     DWORD ?
  lfWeight          DWORD ?
  lfItalic          BYTE ?
  lfUnderline       BYTE ?
  lfStrikeOut       BYTE ?
  lfCharSet         BYTE ?
  lfOutPrecision    BYTE ?
  lfClipPrecision   BYTE ?
  lfQuality         BYTE ?
  lfPitchAndFamily  BYTE ?
  lfFaceName        BYTE LF_FACESIZE dup(?)
LOGFONTA ENDS