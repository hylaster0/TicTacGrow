extends Node2D

const powerCost = {
	"Star Crossing Lovers": 5,
	"Paint It Black": 8,
	"Rotate": 1,
	"Meteor": 3,
	"Shinobi Ashi": 4,
	"00X": 4
}

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
		GlobalVars.p1Special1PointsNeeded = powerCost[special1]
		GlobalVars.p1Special2PointsNeeded = powerCost[special2]
		$CharSelect/p1Description.text = characterDescription
	else:
		GlobalVars.p2Special1 = special1
		GlobalVars.p2Special2 = special2
		GlobalVars.p2Special1PointsNeeded = powerCost[special1]
		GlobalVars.p2Special2PointsNeeded = powerCost[special2]
		$CharSelect/p2Description.text = characterDescription
		
func _on_blanc_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Blanc Norman. His powers do nothing.\nRotate: Turns the piece 90 degrees.\nPaint It Black: Turns the placed piece black.", "Rotate", "Paint It Black")
		current_pick = 2
		$CharSelect/p1Sprite.texture = "res://assets/Blanc.png"
	else:
		set_character(2, "Blanc Norman. His powers do nothing.\nRotate: Turns the piece 90 degrees.\nPaint It Black: Turns the placed piece black.", "Rotate", "Paint It Black")
		current_pick = 1
		$CharSelect/p2Sprite.texture = "res://assets/Blanc.png"		


func _on_ninja_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Ninja Girl Denn. Good sneaker (no shoes).\nShinobi Ashi: Does not move pieces.\n00X: Invisible to opposing pieces.", "Shinobi Ashi", "00X")
		current_pick = 2
		$CharSelect/p1Sprite.texture = "res://assets/Ninja.png"
	else:
		set_character(2, "Ninja Girl Denn. Good sneaker (no shoes).\nShinobi Ashi: Does not move pieces.\n00X: Invisible to opposing pieces.", "Shinobi Ashi", "00X")
		current_pick = 1
		$CharSelect/p2Sprite.texture = "res://assets/Ninja.png"		


func _on_cosmo_button_pressed() -> void:
	if current_pick == 1:
		set_character(1, "Cosmo, Space Dino.\nMeteor: Wraps around the board.\nStar-Crossing Lovers: Summons a 2nd piece to the right.", "Meteor", "Star Crossing Lovers")
		current_pick = 2
		$CharSelect/p1Sprite.texture = "res://assets/Cosmo.png"
	else:
		set_character(2, "Cosmo, Space Dino.\nMeteor: Wraps around the board.\nStar-Crossing Lovers: Summons a 2nd piece to the right.", "Meteor", "Star Crossing Lovers")
		current_pick = 1
		$CharSelect/p2Sprite.texture = "res://assets/Cosmo.png"		
