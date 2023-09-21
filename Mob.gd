extends RigidBody2D
signal mobkilled

func _ready():
	$AnimatedSprite2D.play()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	mobkilled.emit()