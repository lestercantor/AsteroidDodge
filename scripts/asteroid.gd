extends Area2D

@export var player: PackedScene

var rotationSpeed: float
var speed: float
signal destroyed

# Function called when the object is initialised. It gets initialised by the script of the main scene through a timer
func _ready():
	rotationSpeed = randf_range(-5,5)

# Set up initialise function which is called in main.gd
func initialise(randomPosition, randomScale, randomSpeed):
	position = randomPosition # Vector2
	scale = randomScale # Vector2
	speed = randomSpeed
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation +=  rotationSpeed * delta
	position.y += speed * delta

# Destroy the asteroid when it comes off the viewport for memory optimisation
func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("destroyed")
	queue_free()
