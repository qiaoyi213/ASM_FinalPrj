
.NOLIST
$GAME_NAME$			= 0

$BUTTON$			= 1

; ----------

_WINDOW_WIDTH		= 1280
_WINDOW_HEIGHT		= 720

_MOB_SLIME_ID		= 0
_MOB_TRUNK_ID		= 1
_MOB_MUSHROOM_ID	= 2

_MOB_ID_SIZE		= 3
_MOB_STATE_SIZE		= 4

_MOB_LIST_MAX_SIZE	= 50


; ---------

Mob STRUCT
	_type	 		DWORD		?

	; 0: normal
	; 1: been hit
	; 2: going to attack
	; 3: attacking
	; 4: DEAD
	state			DWORD		?

	X				DWORD		?
	Y				DWORD		?
	_width			DWORD		?
	_height			DWORD		?

	HP				DWORD		?

	AnimationTick	DWORD		?
	AnimationEdge	DWORD		?
	AttackTick		DWORD		?
	AttackEdge		DWORD		?
	
	isTouched		DWORD		?
	
Mob ENDS

GdiplusStartupInput STRUCT
    GdiplusVersion dword ?
    DebugEventCallback dword ?
    SuppressBackgroundThread dword ?
    SuppressExternalCodecs dword ?
GdiplusStartupInput ENDS

