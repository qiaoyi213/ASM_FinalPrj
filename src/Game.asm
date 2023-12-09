INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

.data
Level	BYTE	0

.code

Game_init PROC
    ; invoke CreateWindowEx
    ; Initialize the window
    ; Load Level
    ; 
    ; invoke CreateMob
Game_init ENDP

Create_Mob PROC

    ; Load Image
    ; Process the data
    ; Save to heap

Create_Mob ENDP

Game_check_status PROC lParam: lParam
    ; Get mouse information
    ; does the mouse hover on the mob 
    ; process
    ; check the mob is dead
    ; If dead, invoke removemob
    ; If not, record and update the status
    ; If the mob is attack player, then update the status

    ; Check the number of mob
    ; if Pass this level
    ; Invoke pass the level and go to next level
    ; Record the score of player
    
Game_check_status ENDP
END