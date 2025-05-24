extends TextureButton

class_name ActionButton

var ActionRef : ActionData

signal CompleteAnim

func _ready() -> void:
	$AnimationPlayer.play("anim")
	disabled = true

func Setup(actionRef : ActionData):
	ActionRef = actionRef
	$Label.text = actionRef.ActionName
	
func _on_button_up() -> void:
	if $Label.text == "Restart Game":
		get_tree().reload_current_scene()
	else:
		Finder.GetDialogueUI().InjectDialogue(ActionRef.DialogueRef)
		Finder.GetDialogueUI().PlaySelectSFX()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	CompleteAnim.emit()
