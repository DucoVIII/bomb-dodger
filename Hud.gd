extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("YOU DIED")
	await $MessageTimer.timeout
	
	$Message.text = "BOMB DODGER ULTRA 9001"
	$Message.show()
	# make it a one shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score, scoremultiplier):
	$ScoreLabel.text = str(score)
	$ScoreMultiplierLabel.text = str(scoremultiplier)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
