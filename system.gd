extends Node

onready var nav = get_node("/root/game/Navigation2D")
onready var tilemap = get_node("/root/game/Navigation2D/TileMap")
onready var tileset = get_node("/root/game/Navigation2D/TileMap").get_tileset()
onready var map_ysort = get_node("/root/game/YSort")
onready var trolley = get_node("/root/game/YSort/Trolley")
onready var player = get_node("/root/game/YSort/player")

