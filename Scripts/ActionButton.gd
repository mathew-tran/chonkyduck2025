extends TextureButton

class_name ActionButton

var ActionRef : ActionData

signal CompleteAnim

@export var bStartDisabled = true
func _ready() -> void:

	
	if bStartDisabled:
		disabled = true
		$AnimationPlayer.play("anim")

func Setup(actionRef : ActionData):
	ActionRef = actionRef
	$Label.text = actionRef.ActionName
	
func _on_button_up() -> void:
	if $Label.text == "Play":
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	elif $Label.text == "Restart Game":
		get_tree().change_scene_to_file("res://Scenes/Title.tscn")
	else:
		Finder.GetDialogueUI().InjectDialogue(ActionRef.DialogueRef)
		Finder.GetDialogueUI().PlaySelectSFX()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	CompleteAnim.emit()
