INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc


.data

OPEN_NORMAL_BGM     BYTE    "open .\\resources\\assets\\normalBGM.wav alias normalBGM", 0
PLAY_NORMAL_BGM     BYTE    "play normalBGM", 0
CLOSE_NORMAL_BGM    BYTE    "close normalBGM", 0

OPEN_BATTLE_BGM     BYTE    "open .\\resources\\assets\\battleBGM.wav alias battleBGM", 0
PLAY_BATTLE_BGM     BYTE    "play battleBGM", 0
CLOSE_BATTLE_BGM    BYTE    "close battleBGM", 0

OPEN_SLIME_HIT      BYTE    "open .\\resources\\assets\\slime_hit.wav alias slimeHit", 0
PLAY_SLIME_HIT      BYTE    "play slimeHit", 0
CLOSE_SLIME_HIT     BYTE    "close slimeHit", 0

OPEN_SLIME_DEAD     BYTE    "open .\\resources\\assets\\slime_dead.wav alias slimeDead", 0
PLAY_SLIME_DEAD     BYTE    "play slimeDead", 0
CLOSE_SLIME_DEAD    BYTE    "close slimeDead", 0


; OPEN_PLAYER_HIT     BYTE    "open .\\resources\\assets\\.wav alias playerHit", 0
PLAY_PLAYER_HIT     BYTE    "play .\\resources\\assets\\player_hit.wav", 0
CLOSE_PLAYER_HIT    BYTE    "close playerHit", 0

OPEN_VICTORY_BGM    BYTE    "open .\\resources\\assets\\victory.wav alias victoryBGM", 0
PLAY_VICTORY_BGM    BYTE    "play victoryBGM", 0
CLOSE_VICTORY_BGM   BYTE    "close victoryBGM", 0

OPEN_LOSE_BGM       BYTE    "open .\\resources\\assets\\lose.wav alias loseBGM", 0
PLAY_LOSE_BGM       BYTE    "play loseBGM", 0
CLOSE_LOSE_BGM      BYTE    "close loseBGM", 0


.code

normal_bgm_play PROC
    invoke mciSendString, OFFSET OPEN_NORMAL_BGM, NULL, 0, NULL
    invoke mciSendString, OFFSET PLAY_NORMAL_BGM, NULL, 0, NULL
    ret
normal_bgm_play ENDP

normal_bgm_close PROC
    invoke mciSendString, OFFSET CLOSE_NORMAL_BGM, NULL, 0, NULL
    ret
normal_bgm_close ENDP

battle_bgm_play PROC
    invoke mciSendString, OFFSET OPEN_BATTLE_BGM, NULL, 0, NULL
    invoke mciSendString, OFFSET PLAY_BATTLE_BGM, NULL, 0, NULL
    ret
battle_bgm_play ENDP

battle_bgm_close PROC
    invoke mciSendString, OFFSET CLOSE_BATTLE_BGM, NULL, 0, NULL
    ret
battle_bgm_close ENDP

slime_hit_play PROC
    invoke mciSendString, OFFSET OPEN_SLIME_HIT, NULL, 0, NULL
    invoke mciSendString, OFFSET PLAY_SLIME_HIT, NULL, 0, NULL
    ret
slime_hit_play ENDP

slime_hit_close PROC
    invoke mciSendString, OFFSET CLOSE_SLIME_HIT, NULL, 0, NULL
    ret
slime_hit_close ENDP

slime_dead_play PROC
    invoke mciSendString, OFFSET OPEN_SLIME_DEAD, NULL, 0, NULL
    invoke mciSendString, OFFSET PLAY_SLIME_DEAD, NULL, 0, NULL
    ret
slime_dead_play ENDP

slime_dead_close PROC
    invoke mciSendString, OFFSET CLOSE_SLIME_DEAD, NULL, 0, NULL
    ret
slime_dead_close ENDP


player_hit_play PROC
    invoke mciSendString, OFFSET PLAY_PLAYER_HIT, NULL, 0, NULL
    ret
player_hit_play ENDP

victory_bgm_play PROC
    invoke mciSendString, OFFSET OPEN_VICTORY_BGM, NULL, 0, NULL
    invoke mciSendString, OFFSET PLAY_VICTORY_BGM, NULL, 0, NULL
    ret
victory_bgm_play ENDP

victory_bgm_stop PROC

    invoke mciSendString, OFFSET CLOSE_VICTORY_BGM, NULL, 0, NULL
    ret
victory_bgm_stop ENDP

lose_bgm_play PROC
    invoke mciSendString, OFFSET OPEN_LOSE_BGM, NULL, 0, NULL
    invoke mciSendString, OFFSET PLAY_LOSE_BGM, NULL, 0, NULL
    ret
lose_bgm_play ENDP

lose_bgm_stop PROC
    invoke mciSendString, OFFSET CLOSE_LOSE_BGM, NULL, 0, NULL
    ret
lose_bgm_stop ENDP

END