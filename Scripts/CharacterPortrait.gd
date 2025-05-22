extends TextureRect

enum VISIBLITY {
	SHOWN,
	HIDDEN
}

var CurrentVisibility = VISIBLITY.SHOWN

func Show():
	if CurrentVisibility == VISIBLITY.SHOWN:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, .1)
	await tween.finished
	CurrentVisibility = VISIBLITY.SHOWN
	
func Hide():
	if CurrentVisibility == VISIBLITY.HIDDEN:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0,0), .1)
	await tween.finished
	CurrentVisibility = VISIBLITY.HIDDEN
	
