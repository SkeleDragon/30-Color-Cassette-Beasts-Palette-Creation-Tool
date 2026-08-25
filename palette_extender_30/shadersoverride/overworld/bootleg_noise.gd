extends "res://mods/cat_qol/bootleg_noise.gd"


func _init() -> void:
	# Init post preload
	assert(not SceneManager.preloader.singleton_setup_complete)
	yield(SceneManager.preloader, "singleton_setup_completed")
	DLC.mods_by_id.cat_qol.lmodutils.callbacks.connect_class_ready(EncounterConfig, self, "_on_EncounterConfig_ready")

func _on_EncounterConfig_ready(encounter: EncounterConfig) -> void:
	if not DLC.mods_by_id.cat_qol.setting_rare_noise_enabled:
		[print("Noise Disabled")]
		return

	var npc := encounter.get_parent() as NPC

	# We only care about World NPCs
	if not npc:
#		print("not npc")
		return

	# We only care about the displayed sprite.
	if not npc.has_node("MonsterPalette"):
#		print("Missing MonsterPalette")
		return

	# Use the MonsterPalette to get the correct TapeConfig,
	# because the encounter monsters are shuffled.
	var palette: MonsterPalette = npc.get_node("MonsterPalette")

	# tape_path SHOULD be valid on all shiny NPCs, but just in case...
	if palette.tape_path.is_empty() or not palette.has_node(palette.tape_path):
#		print("tape is Empty or Missing Node")
		return

	# Get bootleg from NPC tape
	if palette.has_method("get") and "isbootleg" in palette and palette.get("isbootleg"):
			print("Static Variant Loaded")
	
			var tape: TapeConfig = palette.get_node(palette.tape_path)
#			if not tape or tape.type_override.size() == 0:
#				print("Not a Bootleg Static")
#				return

			var is_bootleg = palette.isbootleg or tape.type_override.size() > 0

			if not is_bootleg:
				print("Still Not a Bootleg Static")
				return
	else:	
		var tape: TapeConfig = palette.get_node(palette.tape_path)
		if not tape or tape.type_override.size() == 0:
			print("Not a Bootleg")
			return

	print("bootleg found attaching noise...")
	# It's a bootleg, attach the noise maker
	var noise: Spatial = BootlegNoise.instance()
	npc.add_child(noise)
	print("Noise Attached")
