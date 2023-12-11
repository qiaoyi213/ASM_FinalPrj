
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

_MOB_LIST_MAX_SIZE	= 5


; ---------

Mob STRUCT
	_type	 		DWORD		?
	X				DWORD		?
	Y				DWORD		?
	HP				DWORD		?
	MoveBias		DWORD		?
	AttackClock		DWORD		?
	AnimationClock	DWORD		?
Mob ENDS
