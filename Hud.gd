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
	$HelpButton.show()
	$QuitButton.show()

func update_score(score, scoremultiplier):
	$ScoreLabel.text = str(score)
	$ScoreMultiplierLabel.text = str(scoremultiplier)


# Called when the node enters the scene tree for the first time.
func _ready():
	# user interface starten
	$Message.show()
	$StartButton.show()
	$HelpScreen.hide()
	$BackButton.hide()
	$HelpButton.show()
	$QuitButton.show()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	$HelpScreen.hide()
	$HelpButton.hide()
	$QuitButton.hide()
	start_game.emit()


func _on_back_button_pressed():
	$Message.show()
	$StartButton.show()
	$HelpScreen.hide()
	$BackButton.hide()
	$HelpButton.show()
	$QuitButton.show()


func _on_help_button_pressed():
	$HelpScreen.show()
	$BackButton.show()
	$Message.hide()
	$StartButton.hide()
	$HelpButton.hide()
	$QuitButton.hide()



func _on_quit_button_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

