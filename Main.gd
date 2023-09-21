extends Node

@export var mob_scene: PackedScene
var score
var scoremultiplier

# Called when the node enters the scene tree for the first time.
func _ready():
	# de speler sterft zodra het spel opent om een of andere reden dus we killen alle mobs meteen
	# ik geloof niet dat dit de juiste manier is om dit te fixen maar het werkt
	get_tree().call_group("mobs", "queue_free")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

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

func _on_ScoreTimer_timeout():
	score += 10 * 1 + (scoremultiplier / 10)
	scoremultiplier += 1
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
		$MobTimer.wait_time -= 0.0005
	