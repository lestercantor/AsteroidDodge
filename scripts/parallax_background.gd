extends ParallaxBackground

var speed: float = 70
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset += Vector2(0, speed) * delta


func _on_player_player_death():
	speed /= 2
