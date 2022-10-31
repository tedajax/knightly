@tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Build Sprite Frames", build_all_sprite_frames)

func _exit_tree():
	remove_tool_menu_item("Build Sprite Frames")

func get_valid_frame_files(dir):
	var files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
	return files
	
func get_anim_frame_refs(dir, files):
	var prefix = "Knight_"
	var anims = {}
	for file in files:
		var extension = file.get_extension()

		if extension != "tres":
			continue
		
		var base_name = file.get_basename()
		if file.find(prefix) < 0:
			continue
			
		var no_prefix = base_name.substr(prefix.length())
		
		var find_separator = no_prefix.find('_')
		if find_separator < 0:
			continue
		
		var anim_name = no_prefix.substr(0, find_separator)
		var index_str = no_prefix.substr(find_separator + 1)
		var index = index_str.to_int()
		
		if not anims.has(anim_name):
			anims[anim_name] = []
			
		
		var total_path = dir.get_current_dir() + "/" + file
		var res_path = ProjectSettings.localize_path(total_path)
		var atlas_texture = ResourceLoader.load(res_path, "AtlasTexture")

		var anim_ref = { 
			"res_path": res_path,
			"res": atlas_texture,
			"index": index
		}
		anims[anim_name].append(anim_ref)
		
	for key in anims:
		anims[key].sort_custom(func(a, b): return a["index"] < b["index"])

	return anims

func build_sprite_frames(sprite_dir, sprite_frames_name):
	Resource.new()
	var dir = DirAccess.open(sprite_dir)
	if dir:
		var files = get_valid_frame_files(dir)
		var anim_refs = get_anim_frame_refs(dir, files)
		var reimport_files = []
		
		var sprite_frames = SpriteFrames.new()
		sprite_frames.remove_animation("default")
		
		for key in anim_refs:
			var anim_ref = anim_refs[key]
			sprite_frames.add_animation(key)
			sprite_frames.set_animation_speed(key, 15)
			for frame in anim_ref:
				sprite_frames.add_frame(key, frame.res)
		
		var out_dir_path = "anim_spriteframes"
		var out_file_name = sprite_frames_name + ".tres"
		if not DirAccess.open("res://").dir_exists(out_dir_path):
			DirAccess.open("res://").make_dir(out_dir_path)
		var res_out_dir_path = "res://" + out_dir_path
		var out_dir = DirAccess.open(res_out_dir_path)
		if out_dir:
			if out_dir.file_exists(out_file_name):
				out_dir.remove(out_file_name)
		
			var out_file_path = res_out_dir_path + "/" + out_file_name 
			var err = ResourceSaver.save(sprite_frames, out_file_path)
			reimport_files.append(out_file_path)
			print(err == OK)
	else:
		printerr("Error")
		
func build_all_sprite_frames():
	build_sprite_frames("res://spritesheets/knight_color1_nooutline.sprites", "knight_color1_nooutline_sprite_frames")
	build_sprite_frames("res://spritesheets/knight_color1_outline.sprites", "knight_color1_outline_sprite_frames")
	build_sprite_frames("res://spritesheets/knight_color2_nooutline.sprites", "knight_color2_nooutline_sprite_frames")
	build_sprite_frames("res://spritesheets/knight_color2_outline.sprites", "knight_color2_outline_sprite_frames")
