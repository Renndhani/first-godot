extends Area2D
@export var speed = 300
var screen_size
signal hit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO #pergerakan vektor pemain
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1 
	#semua if input diatas akan membaca input tiap usernya
	#jadi velocity y akan turun 1 satuan ketika tombol yang berkaitan dengan move up di tekan


	if velocity.length() > 0: #cek apakah vektor lebih dari 0
		velocity = velocity.normalized() * speed #berfungsi agar kecepatan diagonal tdak lebih cepat dari horizontal
		$AnimatedSprite2D.play() #animasi dijalanlan
	else:
		$AnimatedSprite2D.stop() #animasi dihentikan ketika vektor kuran dari 0
	
	
	position += velocity * delta #baris yang benar benar menggerakkan player
	position = position.clamp(Vector2.ZERO, screen_size) #pembatas agar tidak keluar dari screensize
	
	
	if velocity.x != 0 :
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		#sehingga animasi tetap tidak terbalik ketika berjalan ke kanan
		$AnimatedSprite2D.flip_h = velocity.x < 0
		#akan seketika terbalik jika bergerak ke kiri
	elif velocity.y != 0 :
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 
		
		
func _on_body_entered(body: Node2D) -> void:
	hide() #menyembuyikan player saat terkena hit
	hit.emit() #mengirimkan sinyal hit
	$CollisionShape2D.set_deferred("disabled", true) #collision dimatikan ketika proses selesai


func start(pos):
	position = pos
	show() #menunjukkan player
	$CollisionShape2D.disabled = false
