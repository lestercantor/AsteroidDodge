extends GPUParticles2D

# Gets the time the particle was created
@onready var timeCreated = Time.get_ticks_msec()

func _process(_delta):
	# Destroy the particle system after 2 seconds of being created
	if Time.get_ticks_msec() - timeCreated > 2000:
		queue_free()
