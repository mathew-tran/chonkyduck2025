extends TextureButton

class_name ActionButton

var ActionRef : ActionData


func Setup(actionRef : ActionData):
	ActionRef = actionRef
	$Label.text = actionRef.ActionName
	
func _on_button_up() -> void:
	Finder.GetDialogueUI().InjectDialogue(ActionRef.DialogueRef)
