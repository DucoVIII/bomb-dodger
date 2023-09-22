extends Node

@export var mob_scene: PackedScene
var score
var scoremultiplier

# Called when the node enters the scene tree for the first time.
func _ready():
	# de speler sterft zodra het spel opent om een of andere reden dus we killen alle mobs meteen
	# ik geloof niet dat dit de juiste manier is om dit te fixen maar het werkt
	get_tree().call_group("mobs", "queue_free")
	$Explosion.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Grazebox.position = $Player.position
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	$Grazebox/CollisionShape2D.set_deferred(&"disabled", true)
	add_child($Explosion)
	$Explosion.position = $Player.position



func new_game():
	score = 0
	scoremultiplier = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score, scoremultiplier)
	$HUD.show_message("Readyyyy")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$MobTimer.wait_time = 0.3
	$Grazebox/CollisionShape2D.set_deferred(&"disabled", false)
	$Grazebox.show()

func _on_ScoreTimer_timeout():
	score += 100 * 1 + (scoremultiplier / 5)
	$HUD.update_score(score, scoremultiplier)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	# create mob instance
	var mob = mob_scene.instantiate()
	
	# choose random location
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# set direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set random position
	mob.position = mob_spawn_location.position
	
	# randomize direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# set speed
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn ze mobb
	add_child(mob)
	if $MobTimer.wait_time < 0.05:
		$MobTimer.wait_time = 0.05
	elif $MobTimer.wait_time > 0.05:
		$MobTimer.wait_time -= 0.001
	


func _on_grazebox_body_entered(body):
	$GrazeTimer.start()

func _on_grazebox_body_exited(body):
	$GrazeTimer.stop()


func _on_graze_timer_timeout():
	scoremultiplier += 1
	score += 1 + (scoremultiplier / 10) * 1 + (scoremultiplier / 10)
	$HUD.update_score(score, scoremultiplier)

