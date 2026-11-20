extends Node2D

const HAND_COUNT = 2
const CARD_SCENE_PATH = "res://Card.tscn"
const BALL_SCENE_PATH = "res://GachaBall.tscn"
const CARD_WIDTH = 200
const HAND_Y_POSITION = 300


var gacha_pon = []
var cheki_reserve = ["sr","sr","sr","sr","sr"]

var player_hand = []
var center_screen_x 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(25):
		gacha_pon.insert(0, "r")
	for i in range(15):
		gacha_pon.insert(0, "sr")
	for i in range(5):
		gacha_pon.insert(0, "ur")
	
	gacha_pon.shuffle()
	
	print(gacha_pon)
	print(gacha_pon.size())
		
	center_screen_x = get_viewport().size.x / 2
	
	print(center_screen_x)
	
	$"../ClearHand".hide()
		
func add_card_to_hand(card):
	player_hand.insert(0, card)
	update_hand_position()

func update_hand_position():
	for i in range(player_hand.size()):
		# set position based on index
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width /  2
	return x_offset
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)


func draw_card():
	var card_drawn = gacha_pon[0]
	gacha_pon.erase(card_drawn)
	print(gacha_pon.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	# Add it to the middle of the screen
	var screen_center = get_viewport_rect().size / 2.0
	new_card.position = screen_center
	
	var card_image_path = str("res://cheki/cheki-" + card_drawn + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	add_card_to_hand(new_card)

func drop_ball():

	var ball_scene = preload(BALL_SCENE_PATH)
	var new_ball = ball_scene.instantiate()
	
	# Add it to the middle of the screen
	var screen_center = get_viewport_rect().size / 2.0
	#new_ball.position = screen_center
	new_ball.position =  Vector2(530.0, 515.0)
	$"../CardManager".add_child(new_ball)
	
	var tweenDrop = create_tween()
	tweenDrop.tween_property(new_ball, "position", Vector2(530.0, 560.0), 0.1)
	await get_tree().create_timer(0.05).timeout
	new_ball.spin(720.0, 0.4)
	var tween = create_tween()
	tween.tween_property(new_ball, "position", screen_center, 0.4)
	var tween2 = create_tween()
	tween2.tween_property(new_ball, "scale", Vector2(1.5, 1.5), 0.3)
	await get_tree().create_timer(0.5).timeout
	new_ball.split(1000, 0.3)
	await get_tree().create_timer(0.3).timeout
	new_ball.queue_free()
	
	
func check_reserve_dump():
	if(gacha_pon.size() < 4 && cheki_reserve.size() > 0):
		gacha_pon.append_array(cheki_reserve)
		cheki_reserve.clear()
		
		gacha_pon.shuffle()
	
func draw_card_three():
	var hand_assess = []
	var hand_good = false
	
	#grab three cards
	for i in range(3):
		var card_drawn_assess = gacha_pon.pop_front()
		hand_assess.push_back(card_drawn_assess)
		
		if(card_drawn_assess != 'r'):
			hand_good = true
	# Make sure one of them is SR or UR
	
	var fix_loops = 0
	
	while !hand_good:
		if cheki_reserve.size() > 0:
			gacha_pon.push_back(hand_assess.pop_front())
			var card_drawn_assess = cheki_reserve.pop_front()
			hand_assess.push_back(card_drawn_assess)
			
			hand_good = true
			gacha_pon.shuffle()
			hand_assess.shuffle()
		else:
			if gacha_pon.size() <= fix_loops:
				gacha_pon.push_back(hand_assess.pop_front())
				var card_drawn_assess = gacha_pon.pop_front()
				hand_assess.push_back(card_drawn_assess)
				
				fix_loops += 1
				
				if(card_drawn_assess != 'r'):
					hand_good = true
					gacha_pon.shuffle()
					hand_assess.shuffle()
			else:
				hand_good = true
				print("Could not fix probability")

	for i in range(hand_assess.size()):
		var card_drawn = hand_assess[i]
		#gacha_pon.erase(card_drawn)
		#print(gacha_pon.size())
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		
		var screen_center = get_viewport_rect().size / 2.0
		new_card.position = screen_center
	
		var card_image_path = str("res://cheki/cheki-" + card_drawn + ".png")
		new_card.get_node("CardImage").texture = load(card_image_path)
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)
	
	print(gacha_pon.size())

func clear_hand():
	for child in $"../CardManager".get_children():
		child.queue_free()
	player_hand.clear()
	print(player_hand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	


func _on_single_pull_pressed() -> void:
	$"../SinglePull".hide()
	$"../TriplePull".hide()
	$"../GachaPon".shake(15.0, 0.5)
	await get_tree().create_timer(0.6).timeout
	drop_ball()
	await get_tree().create_timer(0.7).timeout
	draw_card()
	check_reserve_dump()
	$"../ClearHand".show()
	


func _on_triple_pull_pressed() -> void:
	$"../SinglePull".hide()
	$"../TriplePull".hide()
	$"../GachaPon".shake(15.0, 0.5)
	await get_tree().create_timer(0.6).timeout
	drop_ball()
	await get_tree().create_timer(0.7).timeout
	draw_card_three()
	check_reserve_dump()
	
	$"../ClearHand".show()
	


func _on_clear_hand_pressed() -> void:
	clear_hand()
	if(gacha_pon.size() >= 1):
		$"../SinglePull".show()
	if(gacha_pon.size() >= 3):
		$"../TriplePull".show()
	$"../ClearHand".hide()
