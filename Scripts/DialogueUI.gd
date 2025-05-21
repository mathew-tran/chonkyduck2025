extends Control

class_name DialogueUI

var TextToShow = []

var DialogueBoxTextLimit = 80

var DialogueRef : DialogueData
enum STATE {
	SHOW_DIALOGUE,
	DIALOGUE_COMPLETE,
}

var CurrentState = STATE.SHOW_DIALOGUE

var ActionButtonClass = load("res://Prefabs/ActionButton.tscn")

func _ready() -> void:
	print(len($Label.text))
	InjectDialogue(load("res://Content/Dialogues/Act1/Act1Part1Dialogue.tres"))
	
func InjectDialogue(dialogue : DialogueData):
	ClearActions()
	CurrentState = STATE.SHOW_DIALOGUE
	DialogueRef = dialogue
	QueueText(dialogue.DialogueToSay)
	$DialogueBox/LeftArrow.visible = false
	$DialogueBox/RightArrow.visible = false
	$RightPortrait.visible = false
	$LeftPortrait.visible = false
	
	if dialogue.bIsPlayer:
		$LeftPortrait.texture = dialogue.GetSpeakerRef().SpeakerImage
		$LeftPortrait.visible = true
		$DialogueBox/LeftArrow.visible = true
	else:
		$RightPortrait.texture = dialogue.GetSpeakerRef().SpeakerImage
		$RightPortrait.visible = true
		$DialogueBox/RightArrow.visible = true
		
	
	
	
func QueueText(newText):
	TextToShow.clear()
	var textLeft = Array(newText.split(" "))

	while len(textLeft) != 0:
		var textToAdd = ""
		while len(textToAdd) < DialogueBoxTextLimit and len(textLeft) != 0:
			var constructedString = textLeft[0] + textToAdd
			if len(constructedString) > DialogueBoxTextLimit:
				break
			textToAdd += textLeft.pop_front() + " "
		TextToShow.append(textToAdd)
	print(TextToShow)
	ShowNextText()

func ShowNextText():
	if CurrentState == STATE.DIALOGUE_COMPLETE:
		return
		
	if TextToShow.size() > 0:
		$Label.text = TextToShow.pop_front()
		$ContinueArrow.visible = TextToShow.size() > 0
	else:
		CurrentState = STATE.DIALOGUE_COMPLETE
		PopulateActions()
		
func PopulateActions():
	ClearActions()
	
	await get_tree().process_frame
	
	for action in DialogueRef.GetActions():
		var instance = ActionButtonClass.instantiate()
		instance.Setup(action)
		$Actions.add_child(instance)

func ClearActions():
	for child in $Actions.get_children():
		child.queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		ShowNextText()
