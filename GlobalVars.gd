extends Node

var play_mode: int = 0 # 0 = local pvp, 1 = cpu, 2 = online
var game_type: int = 0 # 0 = standard, 1 = world tour
var cpu_level: int = 2 # affects how they make moves
var p1Special1PointsNeeded = 2
var p1Special2PointsNeeded = 7
var p2Special1PointsNeeded = 4
var p2Special2PointsNeeded = 4
var p1Special1 = "Rotate"
var p1Special2 = "Paint It Black"
var p2Special1 = "Shinobi Ashi"
var p2Special2 = "00X"
var p1Character = "Blanc Norman"
var p2Character = "Ninja Girl Denn"

var characterList = ["Blanc Norman", "Ninja Girl Denn", "John Arcade", "Cosmo", "Felix", "Ernie", "Ren"]
var special1 = {
	"Blanc Norman": "Rotate",
	"Ninja Girl Denn": "Shinobi Ashi",
	"Ren": "Crossup Frog Fist",
	"Ernie": "DD Pad",
	"John Arcade": "BAM!",
	"Felix": "Grid Climber",
	"Cosmo": "Meteor"
}
var special2 = {
	"Blanc Norman": "Paint It Black",
	"Ninja Girl Denn": "00X",
	"Ren": "Combo Quarter Combat",
	"Ernie": "Space Defender",
	"John Arcade": "Knockout",
	"Felix": "Barrel of Monkeys",
	"Cosmo": "Star Crossing Lovers"
}

const powerCost = {
	"Star Crossing Lovers": 5,
	"Paint It Black": 8,
	"Rotate": 1,
	"Meteor": 3,
	"Shinobi Ashi": 4,
	"00X": 4,
	"Combo Quarter Combat": 9,
	"Crossup Frog Fist": 2,
	"DD Pad": 3,
	"Space Defender": 3,
	"BAM!": 4,
	"Knockout": 5,
	"Grid Climber": 4,
	"Barrel of Monkeys": 4,
	"Air Pump": 3,
	"Cheeseater": 8,
	"Gyro Bomb": 5,
	"Gravity Bomb": 7
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
