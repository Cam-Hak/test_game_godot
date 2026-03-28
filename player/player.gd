extends CharacterBody2D

# --- Tuning knobs ---
@export var speed := 200.0
@export var dash_speed := 600.0
@export var dash_duration := 0.12

# --- Internal state ---
var is_dashing := false
var dash_timer := 0.0
var dash_direction := Vector2.ZERO

# Preload the bullet scene (we'll create this next)
var BulletScene = preload("res://bullet/bullet.tscn")

@onready var shoot_cooldown: Timer = $ShootCooldown


func _physics_process(delta: float) -> void:
	if is_dashing:
		_process_dash(delta)
	else:
		_process_movement()
		_check_dash()
	
	_check_shoot()
	move_and_slide()


func _process_movement() -> void:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	velocity = input.normalized() * speed


func _check_dash() -> void:
	if Input.is_action_just_pressed("dash") and velocity.length() > 0:
		is_dashing = true
		dash_timer = dash_duration
		dash_direction = velocity.normalized()
		velocity = dash_direction * dash_speed


func _process_dash(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		is_dashing = false
	else:
		velocity = dash_direction * dash_speed


func _check_shoot() -> void:
	if Input.is_action_just_pressed("shoot") and shoot_cooldown.is_stopped():
		shoot_cooldown.start()
		var bullet = BulletScene.instantiate()
		bullet.global_position = global_position
		# Shoot toward the mouse
		var direction = (get_global_mouse_position() - global_position).normalized()
		bullet.set_direction(direction)
		get_tree().current_scene.add_child(bullet)
