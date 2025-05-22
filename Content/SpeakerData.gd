extends Resource

class_name SpeakerData

@export var SpeakerName = "Name"
@export var SpeakerImage : Texture2D
@export var SpeakerSurprised : Texture2D
@export var SpeakerAngry : Texture2D

enum EMOTE_STATE {
	IDLE,
	SURPRISED,
	ANGRY
}
func GetImage(emote : EMOTE_STATE):
	if emote == EMOTE_STATE.SURPRISED:
		if is_instance_valid(SpeakerSurprised):
			return SpeakerSurprised
	elif emote == EMOTE_STATE.ANGRY:
		if is_instance_valid(SpeakerAngry):
			return SpeakerAngry
	return SpeakerImage
	
