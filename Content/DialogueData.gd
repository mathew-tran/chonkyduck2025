extends Resource

class_name DialogueData

enum MUSIC {
	NONE,
	THINKING,
	STEALING,
	RELAXING
}
@export var MusicToPlay = MUSIC.THINKING
@export var bIsPlayer = false
@export var SpeakerRef : SpeakerData
@export var EmoteState = SpeakerData.EMOTE_STATE.IDLE
@export_multiline var DialogueToSay = ""

@export var Background : Texture2D
@export var ObjectOfInterest : Texture2D

@export var Action1 : ActionData
@export var Action2 : ActionData
@export var Action3 : ActionData
@export var Action4 : ActionData

@export var bAnimate = false



func GetSpeakerRef():
	if bIsPlayer:
		return load("res://Content/Speakers/SpeakerDuck.tres")
	else:
		return SpeakerRef

func GetActions():
	var actions = []
	if is_instance_valid(Action1):
		actions.append(Action1)
	if is_instance_valid(Action2):
		actions.append(Action2)
	if is_instance_valid(Action3):
		actions.append(Action3)
	if is_instance_valid(Action4):
		actions.append(Action4)
	return actions
	
func GetMusic():
	match MusicToPlay:
		MUSIC.THINKING:
			return load("res://Audio/espionage.ogg")
		MUSIC.STEALING:
			return load("res://Audio/loadingscreenloop.wav")
		MUSIC.RELAXING:
			return load("res://Audio/story time.ogg")
	return null
