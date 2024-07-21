extends Node

var bullet_hole_decal = preload("res://scenes/misc/bullet_hole_decal.tscn")

enum {
	COLT = 0,
	REMINGTON = 1
}

const weapons = [
	{
		"name": "Pistol",
		"scene": "res://scenes/weapons/pistol.tscn"
	},
	{
		"name": "Shotgun",
		"scene": "res://scenes/weapons/shotgun.tscn"
	}
]
