extends Area2D

const SPEED = 300
var velocity:= Vector2(0,0)
@onready var spriteSize = $Sprite2D.texture.get_size()
signal PlayerDeath
@export var DeathParticle: PackedScene

func _physics_process(delta):
	# Simple player movement - only being able to move left and right
	var direction = Input.get_axis("move_left","move_right")
	velocity.x = SPEED * direction
	position += velocity * delta
	
	# Make sure the player stays within the viewport
	var viewportRect := get_viewport_rect()
	# Clamp the x position to stay within the viewport of the screen, accounting for texture size. 
	position.x = clamp(position.x, 0 + (spriteSize.x / 2), viewportRect.size.x - (spriteSize.x / 2))


# Using call_deferred because a collision object is being removed and it will remove it when it is safe to do so
#func _on_area_entered(area):
	#call_deferred("_on_area_entered_deferred", area)


# When something enters the player (only type of collision would be the asteroid)
func _on_area_entered(area):
	if area.is_in_group("asteroid"):
		PlayerDeath.emit() # Sends a signal to a script from another scene (main.gd) to stop the asteroid spawner timer from spawning
		player_death()

# Called when the player dies 
func player_death():
	# Creates a variable from the DeathParticle packed scene 
	var particle = DeathParticle.instantiate()
	particle.position = global_position
	particle.rotation = global_rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	queue_free()
