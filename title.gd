extends Node2D

const blancSprite = preload("res://assets/Blanc.png")
const ninjaSprite = preload("res://assets/Ninja.png")
const cosmoSprite = preload("res://assets/Cosmo.png")
const renSprite = preload("res://assets/Ren.png")
const johnSprite = preload("res://assets/John Arcade.png")
const ernieSprite = preload("res://assets/Bert.png")
const felixSprite = preload("res://assets/Felix.png")

var p1Character: String
var p2Character: String
var p1lvl: int
var p2lvl: int
var current_pick: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_pick = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_battle_button_pressed() -> void:
	GlobalVars.play_mode = $CharSelect/p2CPUButton.button_pressed
	GlobalVars.cpu_level = $CharSelect/P2LevelSlider.value
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func set_character(player, characterDescription, special1, special2):
	if player == 1:
		GlobalVars.p1Special1 = special1
		GlobalVars.p1Special2 = special2
		GlobalVars.p1Special1PointsNeeded = GlobalVars.powerCost[special1]
		GlobalVars.p1Special2PointsNeeded = GlobalVars.powerCost[special2]
		$CharSelect/p1Description.text = characterDescription
	else:
		GlobalVars.p2Special1 = special1
		GlobalVars.p2Special2 = special2
		GlobalVars.p2Special1PointsNeeded = GlobalVars.powerCost[special1]
		GlobalVars.p2Special2PointsNeeded = GlobalVars.powerCost[special2]
		$CharSelect/p2Description.text = characterDescription
		
func _on_blanc_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Blanc Norman. His powers do nothing.\nRotate: Turns the piece 90 degrees.\nPaint It Black: Turns the placed piece black.", "Rotate", "Paint It Black")
		current_pick = 2
		$CharSelect/p1Sprite.texture = blancSprite
	else:
		set_character(2, "Blanc Norman. His powers do nothing.\nRotate: Turns the piece 90 degrees.\nPaint It Black: Turns the placed piece black.", "Rotate", "Paint It Black")
		current_pick = 1
		$CharSelect/p2Sprite.texture = blancSprite


func _on_ninja_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Ninja Girl Denn. Good sneaker (no shoes).\nShinobi Ashi: Does not move pieces.\n00X: Invisible to opposing pieces.", "Shinobi Ashi", "00X")
		current_pick = 2
		$CharSelect/p1Sprite.texture = ninjaSprite
	else:
		set_character(2, "Ninja Girl Denn. Good sneaker (no shoes).\nShinobi Ashi: Does not move pieces.\n00X: Invisible to opposing pieces.", "Shinobi Ashi", "00X")
		current_pick = 1
		$CharSelect/p2Sprite.texture = ninjaSprite	


func _on_cosmo_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Cosmo, Space Dino.\nMeteor: Wraps around the board.\nStar-Crossing Lovers: Summons piece right.", "Meteor", "Star Crossing Lovers")
		current_pick = 2
		$CharSelect/p1Sprite.texture = cosmoSprite
	else:
		set_character(2, "Cosmo, Space Dino.\nMeteor: Wraps around the board.\nStar-Crossing Lovers: Summons piece right.", "Meteor", "Star Crossing Lovers")
		current_pick = 1
		$CharSelect/p2Sprite.texture = cosmoSprite


func _on_ren_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Ren. They've been around the block.\nCrossup Frog Fist: Leaps when pushed.\nCombo Quarter Combat: Take another turn.", "Crossup Frog Fist", "Combo Quarter Combat")
		current_pick = 2
		$CharSelect/p1Sprite.texture = renSprite
	else:
		set_character(2,  "Ren. They've been around the block.\nCrossup Frog Fist: Leaps when pushed.\nCombo Quarter Combat: Take another turn.", "Crossup Frog Fist", "Combo Quarter Combat")
		current_pick = 1
		$CharSelect/p2Sprite.texture = renSprite


func _on_john_arcade_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "John Arcade. The Big Boss. \nBAM!: Can move upgraded pieces.\nKnockout: Deletes pieces it can't move.", "BAM!", "Knockout")
		current_pick = 2
		$CharSelect/p1Sprite.texture = johnSprite
	else:
		set_character(2, "John Arcade. The Big Boss. \nBAM!: Can move upgraded pieces.\nKnockout: Deletes pieces it can't move.", "BAM!", "Knockout")
		current_pick = 1
		$CharSelect/p2Sprite.texture = johnSprite


func _on_felix_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Felix, Former Construction Contractor\nGrid Climber: Moves up after opponent's turn.\nMonkey Barrel: Moves down instead", "Grid Climber", "Barrel of Monkeys")
		current_pick = 2
		$CharSelect/p1Sprite.texture = felixSprite
	else:
		set_character(2, "Felix, Former Construction Contractor\nGrid Climber: Moves up after opponent's turn.\nMonkey Barrel: Moves down instead", "Grid Climber", "Barrel of Monkeys")
		current_pick = 1
		$CharSelect/p2Sprite.texture = felixSprite


func _on_ernie_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Ernie. Micro-managing hating micro-manager.\nDD Pad: Can't be moved diagonally.\nSpace Defender: Can't be moved down.", "DD Pad", "Space Defender")
		current_pick = 2
		$CharSelect/p1Sprite.texture = ernieSprite
	else:
		set_character(2, "Ernie. Micro-managing hating micro-manager.\nDD Pad: Can't be moved diagonally.\nSpace Defender: Can't be moved down.", "DD Pad", "Space Defender")
		current_pick = 1
		$CharSelect/p2Sprite.texture = ernieSprite


func _on_world_tour_button_pressed() -> void:
	GlobalVars.game_type = 1
	GlobalVars.cpu_level = 1
	GlobalVars.play_mode = 1
	GlobalVars.characterList.erase(GlobalVars.p1Character)
	var opponent = GlobalVars.characterList.pick_random()
	GlobalVars.characterList.erase(opponent)
	GlobalVars.p2Character = opponent
	GlobalVars.p2Special1 = GlobalVars.special1[opponent]
	GlobalVars.p2Special2 = GlobalVars.special2[opponent]
	get_tree().change_scene_to_file("res://main.tscn")

	pass # Replace with function body.
