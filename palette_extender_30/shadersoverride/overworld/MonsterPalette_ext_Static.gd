extends MonsterPalette

export(bool) var isbootleg: bool = false

func update_palette():
	print("update_palette called for", self.name, "| species:", species)
	if not species:
		return 
	
	var types = MonsterForms.get_type_mapping(species)
	var override_types = []
	var bootleg = false
	var matches_species = false
	
	if not tape_path.is_empty() and has_node(tape_path):
		var tape = get_node(tape_path) as TapeConfig
		var encounter = tape.get_parent().get_parent()
		print("Tape path:", tape_path)
		print("Has node at tape path:", has_node(tape_path))
		assert (encounter is EncounterConfig)
		for mons in encounter.get_children():
			var child = mons.get_child(0)
			if child.type_override.size() > 0:
				print("Child is Bootleg:", child)
				bootleg = true
				if child.form == species:
					print("Child Matches Species:", species)
					types = child.type_override
					break
			else:
				if tape.type_override.size() > 0:
					print ("Child Check Failed Used Fail Safe")
					types = tape.type_override
					bootleg = true
					break
					
		if tape and tape.type_override.size() > 0:
			print ("Check Failed Used Alt Fail Safe")
			types = tape.type_override
			bootleg = true
#			break
					
	else :
		var encounter = BattleAction.get_encounter(get_parent())
		if encounter and (encounter.seed_value != 0 or encounter.unique_id != ""):
			for tape in encounter.get_bootlegs():
				assert (tape.type_override.size() > 0)
				bootleg = true
				print("assert Passed tape has Bootleg")
				if tape.form == species:
					print(tape.form, "Matches", species)
					override_types = tape.type_override
					break
#				else:
##					assert (tape.type_override.size() > 0)
#					print (tape.form, " Failed ", species, " Match")
#					types = tape.type_override
#					bootleg = true
#					break

	print("types:", types, "| override_types:", override_types, "| bootleg:", bootleg)
	if types.size() > 0 or bootleg:
		var sprite = get_node(NodePath("../Sprite"))
		assert (sprite != null)
		if sprite:
			var result = species.create_type_variant(types)
			sprite.swap_colors = result.swap_colors

			if types.size() > 0:
				print("types Assigned:", types)
#				var result = species.create_type_variant(types)
				sprite.swap_colors = result.swap_colors
				sprite.default_palette = result.default_palette
				
			if override_types.size() > 0:
				print("override_types Assigned:", override_types)
				sprite.swap_colors = result.swap_colors
				sprite.default_palette = result.default_palette
		
			if bootleg:
				sprite.set_static_amount(0.1)
				sprite.set_static_speed( - 0.5)
				isbootleg = true
				
			else :
				sprite.set_static_amount(0.0)
				sprite.set_static_speed(0.0)
				isbootleg = false
				
			sprite.sparkle = false
			for type in types:
				if type.sparkle:
					sprite.sparkle = true


