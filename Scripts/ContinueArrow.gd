extends TextureRect

var StartPosition = Vector2.ZERO

func _ready() -> void:
	StartPosition = global_position
	Animate()
	
func Animate():
	while true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", StartPosition + Vector2(0, 15), .4)
		await tween.finished
		
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", StartPosition, .2)
		await tween.finished
