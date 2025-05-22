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
	InjectDialogue(load("res://Content/Dialogues/Act1/Act1Part1DialoguePart1.tres"))
	
func InjectDialogue(dialogue : DialogueData):
	$ObjectOfInterest.texture = dialogue.ObjectOfInterest
	ClearActions()
	if dialogue.Background:
		$Background.texture = dialogue.Background
	CurrentState = STATE.SHOW_DIALOGUE
	DialogueRef = dialogue
	QueueText(dialogue.DialogueToSay)
	$LeftOwner.visible = false
	$RightOwner.visible = false
	$RightPortrait.visible = false
	$LeftPortrait.visible = false
	
	if dialogue.bIsPlayer:
		$LeftPortrait.texture = dialogue.GetSpeakerRef().SpeakerImage
		$LeftPortrait.visible = true
		$LeftOwner.text = dialogue.GetSpeakerRef().SpeakerName
		$LeftOwner.visible = true
	else:
		if dialogue.SpeakerRef:
			$RightPortrait.texture = dialogue.GetSpeakerRef().SpeakerImage
			$RightPortrait.visible = true
			$RightOwner.text = dialogue.GetSpeakerRef().SpeakerName
			$RightOwner.visible = true
		
	
	
	
func QueueText(newText):
	TextToShow.clear()
	newText = newText.strip_edges()
	var textInSentences = Array(newText.split("\n"))
	var textLeft = []
	for textInSentence in textInSentences:
		textLeft.append_array(textInSentence.split(" "))
		textLeft.append("<br>")

	while len(textLeft) != 0:
		var textToAdd = ""
		while len(textToAdd) < DialogueBoxTextLimit and len(textLeft) != 0:
			var constructedString = textLeft[0] + textToAdd
			if len(constructedString) > DialogueBoxTextLimit:
				break
			var currentText = textLeft.pop_front()
			if currentText == "<br>":
				break
			else:
				textToAdd += currentText + " "
		textToAdd = textToAdd.strip_edges()
		if len(textToAdd) > 0:
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
