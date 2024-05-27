extends Node2D

@export var asteroid_scene: PackedScene
var playerDeath: bool = false

var randomScaleMult: float = 0
var randomSpeedMult: int = 0
var asteroidSpawnerTimer: float = 2.5
var asteroidSpawned: bool = false

# Use a modifier so the score increases at a moderate pace instead of at delta time
const SCORE_MODIFIER: int = 10

# A signal is emitted from the player script which connects to the main script to start the RestartTimer and stop Asteroids from spawning
func _on_player_player_death():
	playerDeath = true
	$AsteroidSpawner.stop()
	
	# Set and display the high score
	if ScoreTracker.score > ScoreTracker.maxScore:
		ScoreTracker.maxScore = ScoreTracker.score
	@warning_ignore("integer_division")
	$GameOver/HighScore.text = "High Score:\n" + str(ScoreTracker.maxScore / SCORE_MODIFIER)
	$GameOver.visible = true
	
	# Reset the score to 0
	ScoreTracker.score = 0

# Spawns asteroids every time the timer hits 0 and restarts itself
func _on_asteroid_spawner_timeout():
	var asteroid = asteroid_scene.instantiate()
	asteroid.connect("destroyed", _on_asteroid_destroyed)

	# Set random values independent from each other
	var randomPosition = Vector2(randi_range(20, 430), 0)
	var randomScale = randf_range(0.5,1.5) + randomScaleMult
	var randomSpeed = randi_range(350,450) + randomSpeedMult
	
	# Initialise the asteroid with the random values assigned.
	asteroid.initialise(randomPosition, Vector2(randomScale,randomScale), randomSpeed)
	
	# Add the asteroid scene to the current tree
	asteroidSpawned = true
	add_child(asteroid)
	
	# Increase the speed at which the background scrolls to make it look like things are going faster
	$ParallaxBackground.speed += 8

# Restart the game after the player has pressed restart
func _on_restart_button_pressed():
	get_tree().reload_current_scene()

# A connected signal from the instantiated asteroid
func _on_asteroid_destroyed():
	if playerDeath == false:
		# Simple way to make the game progressively harder
		randomScaleMult += 0.04
		randomSpeedMult += 14
		asteroidSpawnerTimer -= 0.07
		asteroidSpawnerTimer = clamp(asteroidSpawnerTimer, 0.25, 2.5)
		$AsteroidSpawner.set_wait_time(asteroidSpawnerTimer)

# Linearly increase the score
func _process(_delta):
	showScore()


func showScore():
	# Start tracking the score when the first asteroid has spawned and stop tracking it when the player has died
	if playerDeath == false and asteroidSpawned == true:
		ScoreTracker.score += 1
		@warning_ignore("integer_division")
		$ScoreText.text = "Score: " + str(ScoreTracker.score / SCORE_MODIFIER)
