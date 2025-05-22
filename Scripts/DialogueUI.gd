extends Control

class_name DialogueUI

var TextToShow = []

var DialogueBoxTextLimit = 80

var DialogueRef : DialogueData

enum STATE {
	SHOW_DIALOGUE,
	ANIMATING,
	DIALOGUE_COMPLETE,
}

var CurrentState = STATE.SHOW_DIALOGUE

var ActionButtonClass = load("res://Prefabs/ActionButton.tscn")

var InPosition = Vector2.ZERO

@export var StartingDialogue : DialogueData
func _enter_tree() -> void:
	$CoverPanel.visible = true
func _ready() -> void:
	InPosition = $CoverPanel.global_position
	print(len($Label.text))
	await AnimateOut()
	InjectDialogue(StartingDialogue)
	
func AnimateOut():	
	var tween = get_tree().create_tween()
	tween.tween_property($CoverPanel, "global_position", InPosition + Vector2(0, $CoverPanel.get_size().y), 1.2)
	await tween.finished
	
func AnimateIn():
	var tween = get_tree().create_tween()
	tween.tween_property($CoverPanel, "global_position", InPosition, .2)
	await tween.finished
	
func AnimateBackground(bShow):
	
	var tween = get_tree().create_tween()
	if bShow:
		tween.tween_property($ObjectOfinterestPanel, "modulate", Color.WHITE, .1)
	else:
		tween.tween_property($ObjectOfinterestPanel, "modulate", Color(0,0,0,0), .1)
		
	await tween.finished
	
func AnimateObjectOfInterest(bShow):
	var tween = get_tree().create_tween()
	if bShow:
		tween.tween_property($ObjectOfInterest, "modulate", Color.WHITE, .3)
	else:
		tween.tween_property($ObjectOfInterest, "modulate", Color(0,0,0,0), .1)
		
	await tween.finished
	
func InjectDialogue(dialogue : DialogueData):
	CurrentState = STATE.ANIMATING
	if dialogue.bAnimate:
		await AnimateIn()
	$ObjectOfInterest.texture = dialogue.ObjectOfInterest
	await AnimateObjectOfInterest(is_instance_valid(dialogue.ObjectOfInterest))
	ClearActions()

	await AnimateBackground(is_instance_valid(dialogue.ObjectOfInterest))
	if dialogue.Background:
		$Background.texture = dialogue.Background


	DialogueRef = dialogue
	
	$LeftOwner.visible = false
	$RightOwner.visible = false
	
	if dialogue.bIsPlayer:
		$LeftPortrait.texture = dialogue.GetSpeakerRef().GetImage(dialogue.EmoteState)
		$LeftOwner.text = dialogue.GetSpeakerRef().SpeakerName
		await $LeftPortrait.Show()
		await $RightPortrait.Hide()
	
		$LeftOwner.visible = true
	else:
		if dialogue.SpeakerRef:
			$RightPortrait.texture = dialogue.GetSpeakerRef().GetImage(dialogue.EmoteState)
			$RightOwner.text = dialogue.GetSpeakerRef().SpeakerName
			await $RightPortrait.Show()
			await $LeftPortrait.Hide()
			
			$RightOwner.visible = true
		else:
			await $LeftPortrait.Hide()
			await $RightPortrait.Hide()
		
	QueueText(dialogue.DialogueToSay)
	if dialogue.bAnimate:
		await AnimateOut()
		
	CurrentState = STATE.SHOW_DIALOGUE
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
		$Label.visible_characters = 0
		var tween = get_tree().create_tween()
		tween.tween_property($Label, "visible_characters", DialogueBoxTextLimit, .5)
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
		await instance.CompleteAnim
	for action in $Actions.get_children():
		action.disabled = false

func ClearActions():
	for child in $Actions.get_children():
		child.queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and CurrentState != STATE.ANIMATING:
		ShowNextText()
