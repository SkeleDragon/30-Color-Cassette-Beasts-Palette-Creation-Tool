extends MonsterPalette

func update_palette():
	if not species:
		return 
	
	var types = MonsterForms.get_type_mapping(species)
	var bootleg = false
	
	if not tape_path.is_empty() and has_node(tape_path):
		var tape = get_node(tape_path) as TapeConfig
		if tape and tape.type_override.size() > 0:
			types = tape.type_override
			bootleg = true
	else :
		var encounter = BattleAction.get_encounter(get_parent())
		if encounter and (encounter.seed_value != 0 or encounter.unique_id != ""):
			for tape in encounter.get_bootlegs():
				assert (tape.type_override.size() > 0)
				if tape.form == species:
					types = tape.type_override
					bootleg = true
	
	if types.size() > 0:
		var sprite = get_node(NodePath("../Sprite"))
		assert (sprite != null)
		if sprite:
			var result = species.create_type_variant(types)
			sprite.swap_colors = result.swap_colors
			sprite.default_palette = result.default_palette
			
			if bootleg:
				sprite.set_static_amount(0.1)
				sprite.set_static_speed( - 0.5)
			else :
				sprite.set_static_amount(0.0)
				sprite.set_static_speed(0.0)
			sprite.sparkle = false
			for type in types:
				if type.sparkle:
					sprite.sparkle = true
					
