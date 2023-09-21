extends Area2D

signal hit
signal graze


@export var speed = 300 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1
	if Input.is_action_pressed(&"focus"):
		speed = 150
	if Input.is_action_just_released(&"focus"):
		speed = 300
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.play()
	if velocity.length() == 0:
		$AnimatedSprite2D.animation = &"walk"
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.play(&"right")
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		$AnimatedSprite2D.play(&"up")
		$AnimatedSprite2D.flip_v = velocity.y > 0
	# $AnimatedSprite2D.play()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(body):

	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred(&"disabled", true)
