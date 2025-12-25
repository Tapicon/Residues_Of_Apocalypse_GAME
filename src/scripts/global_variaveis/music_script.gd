extends Node
var menu_song_list = [
	{
		"name" : "Wave to Earth - Bonfire",
		"path" : "res://assets/audio/songs/bg_souds/Wave to earth - bonfire.mp3",
		"pitch": "0.9"
	},
	{
		"name" : "Wave to Earth - Seasons",
		"path" : "res://assets/audio/songs/bg_souds/Wave to earth - seasons.mp3",
		"pitch": "0.9"
	},
	{
		"name" : "Tyler, The Creator - IFHY",
		"path" : "res://assets/audio/songs/bg_souds/IFHY.mp3",
		"pitch": "1.0"
	},
	{
		"name" : "LE SSERAFIM - Impurities",
		"path" : "res://assets/audio/songs/bg_souds/LE SSERAFIM (르세라핌) - Impurities.mp3",
		"pitch": "1.0"
	},
	{
		"name" : "JK - Still With You",
		"path" : "res://assets/audio/songs/bg_souds/BTS JUNGKOOK (정국) - Still With You (Instrumental) [CLEAN].mp3",
		"pitch": "1.0"
	},
	{
		"name" : "HYBS - Ride",
		"path" : "res://assets/audio/songs/bg_souds/HYBS - Ride (Instrumental).mp3",
		"pitch": "1.0"
	},
	{
		"name" : "HYBS - Tiptoe",
		"path" : "res://assets/audio/songs/bg_souds/HYBS - TIPTOE (INSTRUMENTAL).mp3",
		"pitch": "1.0"
	},
	{
		"name" : "Love.",
		"path" : "res://assets/audio/songs/bg_souds/wave to earth - love. (Clean Inst.) [Kz9diea_SUI].mp3",
		"pitch": "0.9"
	},
	{
		"name" : "Yves - LOOP",
		"path" : "res://assets/audio/songs/bg_souds/Yves – LOOP (feat. Lil Cherry) ｜ Instrumental.mp3",
		"pitch": "1.0"
	}
	
]
var battle_song_list = [
	{
		"name" : "Supernova",
		"path" : "res://assets/audio/songs/bg_souds/aespa 에스파 'Supernova' (Official Instrumental).mp3",
		"pitch": "1.0"
	},
	{
		"name" : "Whiplash",
		"path" : "res://assets/audio/songs/bg_souds/aespa 에스파 'Whiplash' (Official Instrumental).mp3",
		"pitch": "1.0"
	},
	{
		"name" : "",
		"path" : "res://assets/audio/songs/batle_sounds/Guns N_Roses - Right Next Door To Hell (Instrumental).mp3",
		"pitch": "1.0"
	},
	{
		"name" : "",
		"path" : "res://assets/audio/songs/batle_sounds/Hells Bells AC⧸DC (1980) - Original Instrumental Song.mp3",
		"pitch": "1.0"
	},
	{
		"name" : "",
		"path" : "res://assets/audio/songs/batle_sounds/Linkin Park - One Step Closer [Custom Instrumental].mp3",
		"pitch": "1.0"
	},
	{
		"name" : "",
		"path" : "res://assets/audio/songs/batle_sounds/Skillet - Hero Instrumental.mp3",
		"pitch": "1.0"
	}
]
var current_music_index := -1

func get_random_music_index(song_tipe) -> int:
	if song_tipe.size() <= 1:
		return 0
	var new_index = current_music_index
	while new_index == current_music_index:
		new_index = randi() % song_tipe.size()
	return new_index
