extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var Animation_Player = $AnimationPlayer

signal on_transition_finished

func _ready():
	color_rect.visible = false
	Animation_Player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		Animation_Player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false

func transition():
	color_rect.visible = true
	Animation_Player.play("fade_to_black")
