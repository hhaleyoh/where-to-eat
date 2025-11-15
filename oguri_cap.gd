extends Area2D

var mouse_on = false
var animations = ["idle", "oohwee", "headbang", "dancin", "doin2much"]
var animation_index = 0
@onready var sprite = $AnimatedSprite2D
@onready var speech = $Label

var dialogues = [
	"god damn im hungry",
	"feed me",
	"fucj that bitch tamamo cross",
	"stop touching me",
	"put me in coach",
	"and they call me fat",
	"watch my show",
	"im going to kill special week she aint shit on me",
	"im so hungry i could eat a...",
	"more like tm fraudpera o (the o stands for zero wins against me)",
	"who tryna run a career rq",
	"symboli rudolf is my dog",
	"buy my merch",
	"this is your sign to drink 3 beers",
	"holy shit im gonna piss myself with excitement lets go eat",
	"so you just look like that or what",
	"aughhh im shoo drunkl hguvvee me emyyy keyyys",
	"get yo bread up gng",
	"what's your address? i'm interested in sending you animal feces"
	]

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed and mouse_on:
		animation_index = (animation_index + 1) % animations.size()
		sprite.play(animations[animation_index])
		talk()

func _mouse_enter():
	mouse_on = true
		
func _mouse_exit():
	mouse_on = false

func talk():
	var random_int = randi() % dialogues.size()
	speech.text = dialogues[random_int]

func respond(choices, reel_count, checked):
	var random_int = randi()
	if random_int % 2 == 0:
		random_int = randi()
		if random_int % 2 == 0:
			random_int = randi()
			if reel_count > 2 and checked and random_int % 3 == 0:
				random_int = randi()
				match random_int % 7:
					0:
						speech.text = "we gon be here forever :sob:"
					1:
						speech.text = "let me pick for you at this point, just do " + choices[random_int%choices.size()]
					2:
						speech.text = "PLEASE BRO IM GONNA STARVE TO DEATH AT THIS RATE"
					3:
						general_response(choices)
					4:
						speech.text = "is this hell?"
					5:
						speech.text = "kill me kill me kill me"
					6: 
						speech.text = "so you tryna run a career while we wait"
			elif choices.size() > 3:
				match random_int % 6:
					0:
						speech.text = "take " + choices[random_int%choices.size()] + " off the list"
					1: 
						if choices.size() > 5:
							speech.text = "bro do we fr got all that shit on there"
					2: 
							speech.text = "yeah youre just fat at this point man"
					3:
						speech.text = "who thought " + choices[random_int%choices.size()] + " was a good idea"
					4:
						general_response(choices)
					5:
						speech.text = "this a to do list? fat fuck"
			elif choices.size() < 4:
				match random_int % 3:
					0:
						speech.text = "theres nothing on the list dude just pick something"
					1:
						speech.text = "yo all these together arent even a full meal"
					2:
						general_response(choices)
			else:
				general_response(choices)
		else:
			general_response(choices)

func general_response(choices):
	var random_int = randi()
	match random_int % 10:
		0:
			speech.text = "can we do " + choices[random_int%choices.size()]
		1:
			speech.text = "i hope it lands on " + choices[random_int%choices.size()]
		2:
			speech.text = "if its " + choices[random_int%choices.size()] + " i would be so happy"
		3:
			speech.text = "do we deadass got " + choices[random_int%choices.size()] + " on there"
		4:
			speech.text = "we got no self respect if " + choices[random_int%choices.size()] + " on there"
		5: 
			speech.text = "lowkey im mind controlling the reels to specifically pick what yuou want least"
		6: 
			speech.text = "all this spinning got me feeling like doing a ten pull"
		7:
			speech.text = "are you paying? if so imma hit up special week and rice shower"
		8:
			speech.text = "is this my reward for last champs meet?"
		9:
			speech.text = "we hangin at your place after? for you sake i hope you have a bidet"
func _ready() -> void:
	randomize()
