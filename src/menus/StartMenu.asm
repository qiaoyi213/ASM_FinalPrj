INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc


.data
WelcomeMsg      BYTE    "Welcome!", 0
StartMsg        BYTE    "Start", 0
WelcomeRect     RECT    <540,100,740,200>    
StartRect       RECT    <540,150,740,250>    
.code
StartMenu_init PROC hdc: HDC

    invoke DrawText, hdc, OFFSET WelcomeMsg, -1 , OFFSET WelcomeRect,DT_CENTER or DT_VCENTER or DT_SINGLELINE
    

    invoke DrawText, hdc, OFFSET StartMsg, -1 , OFFSET StartRect,DT_CENTER or DT_VCENTER or DT_SINGLELINE
    ret
StartMenu_init ENDP

END