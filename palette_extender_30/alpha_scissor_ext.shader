shader_type spatial;
render_mode blend_mix,depth_draw_alpha_prepass,cull_disabled,diffuse_burley,specular_schlick_ggx,shadows_disabled;
uniform vec4 albedo : hint_color = vec4(1.0);
uniform sampler2D texture_albedo : hint_albedo;
uniform bool flags_albedo_tex_force_srgb = false;
uniform float alpha_scissor_threshold = 0.98;
uniform float specular = 0.0;
uniform float metallic = 0.0;
uniform float roughness : hint_range(0,1) = 1.0;
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_metallic : hint_white;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_white;
uniform vec4 roughness_texture_channel;
uniform sampler2D texture_emission : hint_black_albedo;
uniform vec4 emission : hint_color = vec4(0.0);
uniform float emission_energy = 0.0;
uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset = vec3(0.0);
uniform vec3 uv2_scale = vec3(1.0);
uniform vec3 uv2_offset = vec3(0.0);
uniform vec3 rotation = vec3(0.0);

uniform sampler2D texture_overlay : hint_black_albedo;
uniform vec2 overlay_scroll_rate = vec2(0.0);
uniform float overlay_opacity : hint_range(0,1) = 0.0;

uniform float swap_blend : hint_range(0,1) = 0.0;
uniform vec4 swap_from_0 : hint_color;
uniform vec4 swap_from_1 : hint_color;
uniform vec4 swap_from_2 : hint_color;
uniform vec4 swap_from_3 : hint_color;
uniform vec4 swap_from_4 : hint_color;
uniform vec4 swap_from_5 : hint_color;
uniform vec4 swap_from_6 : hint_color;
uniform vec4 swap_from_7 : hint_color;
uniform vec4 swap_from_8 : hint_color;
uniform vec4 swap_from_9 : hint_color;
uniform vec4 swap_from_10 : hint_color;
uniform vec4 swap_from_11 : hint_color;
uniform vec4 swap_from_12 : hint_color;
uniform vec4 swap_from_13 : hint_color;
uniform vec4 swap_from_14 : hint_color;
uniform vec4 swap_from_15 : hint_color;
uniform vec4 swap_from_16 : hint_color;
uniform vec4 swap_from_17 : hint_color;
uniform vec4 swap_from_18 : hint_color;
uniform vec4 swap_from_19 : hint_color;
uniform vec4 swap_from_20 : hint_color;
uniform vec4 swap_from_21 : hint_color;
uniform vec4 swap_from_22 : hint_color;
uniform vec4 swap_from_23 : hint_color;
uniform vec4 swap_from_24 : hint_color;
uniform vec4 swap_from_25 : hint_color;
uniform vec4 swap_from_26 : hint_color;
uniform vec4 swap_from_27 : hint_color;
uniform vec4 swap_from_28 : hint_color;
uniform vec4 swap_from_29 : hint_color;
uniform vec4 swap_default_0 : hint_color;
uniform vec4 swap_default_1 : hint_color;
uniform vec4 swap_default_2 : hint_color;
uniform vec4 swap_default_3 : hint_color;
uniform vec4 swap_default_4 : hint_color;
uniform vec4 swap_default_5 : hint_color;
uniform vec4 swap_default_6 : hint_color;
uniform vec4 swap_default_7 : hint_color;
uniform vec4 swap_default_8 : hint_color;
uniform vec4 swap_default_9 : hint_color;
uniform vec4 swap_default_10 : hint_color;
uniform vec4 swap_default_11 : hint_color;
uniform vec4 swap_default_12 : hint_color;
uniform vec4 swap_default_13 : hint_color;
uniform vec4 swap_default_14 : hint_color;
uniform vec4 swap_default_15 : hint_color;
uniform vec4 swap_default_16 : hint_color;
uniform vec4 swap_default_17 : hint_color;
uniform vec4 swap_default_18 : hint_color;
uniform vec4 swap_default_19 : hint_color;
uniform vec4 swap_default_20 : hint_color;
uniform vec4 swap_default_21 : hint_color;
uniform vec4 swap_default_22 : hint_color;
uniform vec4 swap_default_23 : hint_color;
uniform vec4 swap_default_24 : hint_color;
uniform vec4 swap_default_25 : hint_color;
uniform vec4 swap_default_26 : hint_color;
uniform vec4 swap_default_27 : hint_color;
uniform vec4 swap_default_28 : hint_color;
uniform vec4 swap_default_29 : hint_color;
uniform vec4 swap_to_0 : hint_color;
uniform vec4 swap_to_1 : hint_color;
uniform vec4 swap_to_2 : hint_color;
uniform vec4 swap_to_3 : hint_color;
uniform vec4 swap_to_4 : hint_color;
uniform vec4 swap_to_5 : hint_color;
uniform vec4 swap_to_6 : hint_color;
uniform vec4 swap_to_7 : hint_color;
uniform vec4 swap_to_8 : hint_color;
uniform vec4 swap_to_9 : hint_color;
uniform vec4 swap_to_10 : hint_color;
uniform vec4 swap_to_11 : hint_color;
uniform vec4 swap_to_12 : hint_color;
uniform vec4 swap_to_13 : hint_color;
uniform vec4 swap_to_14 : hint_color;
uniform vec4 swap_to_15 : hint_color;
uniform vec4 swap_to_16 : hint_color;
uniform vec4 swap_to_17 : hint_color;
uniform vec4 swap_to_18 : hint_color;
uniform vec4 swap_to_19 : hint_color;
uniform vec4 swap_to_20 : hint_color;
uniform vec4 swap_to_21 : hint_color;
uniform vec4 swap_to_22 : hint_color;
uniform vec4 swap_to_23 : hint_color;
uniform vec4 swap_to_24 : hint_color;
uniform vec4 swap_to_25 : hint_color;
uniform vec4 swap_to_26 : hint_color;
uniform vec4 swap_to_27 : hint_color;
uniform vec4 swap_to_28 : hint_color;
uniform vec4 swap_to_29 : hint_color;
uniform vec4 emission_color_0 : hint_color;
uniform vec4 emission_color_1 : hint_color;
uniform vec4 emission_color_2 : hint_color;
uniform vec4 emission_color_3 : hint_color;
uniform vec4 emission_color_4 : hint_color;
uniform vec4 emission_color_5 : hint_color;
uniform vec4 emission_color_6 : hint_color;
uniform vec4 emission_color_7 : hint_color;
uniform vec4 emission_color_8 : hint_color;
uniform vec4 emission_color_9 : hint_color;

uniform float wave_amplitude = 0.0;
uniform float wave_v_frequency = 0.0;
uniform float wave_t_frequency = 5.0;
uniform float wave_min_u = 0.0;
uniform float wave_max_u = 1.0;
uniform float wave_min_v = 0.0;
uniform float wave_max_v = 1.0;

uniform float glow = 0.0;

uniform int billboard_mode = 0;
uniform bool billboard_depth_hack = false;

uniform float static_offset = 0.0;
uniform float static_amount = 0.0;
uniform float static_border = 0.125;
uniform float static_speed = 0.0;

uniform bool sparkle = false;
uniform float sparkle_period = 20.0;
uniform float sparkle_falloff = 100.0;
uniform float sparkle_amplitude = 5.0;
uniform float sparkliness = 2.0;

varying vec2 vertex_pixel;

float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

float rand_from_seed_m1_p1(inout uint seed) {
	return rand_from_seed(seed) * 2.0 - 1.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

mat3 get_rotation_matrix() {
	mat3 yaw = mat3(
		vec3(cos(rotation.z), -sin(rotation.z), 0.0),
		vec3(sin(rotation.z), cos(rotation.z), 0.0),
		vec3(0.0, 0.0, 1.0));
	mat3 pitch = mat3(
		vec3(cos(rotation.y), 0.0, sin(rotation.y)),
		vec3(0.0, 1.0, 0.0),
		vec3(-sin(rotation.y), 0.0, cos(rotation.y)));
	mat3 roll = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cos(rotation.x), -sin(rotation.x)),
		vec3(0.0, sin(rotation.x), cos(rotation.x)));
	return yaw * pitch * roll;
}

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	
	vertex_pixel = vec2(VERTEX.x / 0.125, (VERTEX.y + VERTEX.z) / 0.125);
	VERTEX = get_rotation_matrix() * VERTEX;
	
	if (billboard_mode != 0) {
		
		float magic_z;
		if (billboard_depth_hack) {
			// I don't know why this works¬ ¯\_(ツ)_/¯
			mat4 magic = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],WORLD_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
			vec4 magic_pos = PROJECTION_MATRIX * magic * vec4(VERTEX, 1.0);
			magic_z = magic_pos.z / magic_pos.w;
		}
		
		if (billboard_mode == 1) {
			MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
			MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(WORLD_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(WORLD_MATRIX[1].xyz), 0.0, 0.0),vec4(0.0, 0.0, length(WORLD_MATRIX[2].xyz), 0.0),vec4(0.0, 0.0, 0.0, 1.0));
		} else if (billboard_mode == 2) {
			MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],WORLD_MATRIX[1],vec4(normalize(cross(CAMERA_MATRIX[0].xyz,WORLD_MATRIX[1].xyz)), 0.0),WORLD_MATRIX[3]);
			MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(1.0, 0.0, 0.0, 0.0),vec4(0.0, 1.0/length(WORLD_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0),vec4(0.0, 0.0, 0.0 ,1.0));
		}
		
		POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
		if (billboard_depth_hack) {
			POSITION.z = max(min(POSITION.z, magic_z * POSITION.w), 0.0);
		}
		
	} else {
		POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	}
}

bool is_sparkle_region(vec4 tex_color) {
	if (distance(tex_color, swap_from_0) < 1.0/256.0) return sparkle;
	if (distance(tex_color, swap_from_1) < 1.0/256.0) return sparkle;
	if (distance(tex_color, swap_from_2) < 1.0/256.0) return sparkle;
	if (distance(tex_color, swap_from_3) < 1.0/256.0) return sparkle;
	if (distance(tex_color, swap_from_4) < 1.0/256.0) return sparkle;
	return false;
}

vec4 swap_defaults(vec4 tex_color) {
	if (distance(tex_color, swap_from_0) < 1.0/256.0 && swap_default_0 != vec4(0)) return swap_default_0;
	if (distance(tex_color, swap_from_1) < 1.0/256.0 && swap_default_1 != vec4(0)) return swap_default_1;
	if (distance(tex_color, swap_from_2) < 1.0/256.0 && swap_default_2 != vec4(0)) return swap_default_2;
	if (distance(tex_color, swap_from_3) < 1.0/256.0 && swap_default_3 != vec4(0)) return swap_default_3;
	if (distance(tex_color, swap_from_4) < 1.0/256.0 && swap_default_4 != vec4(0)) return swap_default_4;
	if (distance(tex_color, swap_from_5) < 1.0/256.0 && swap_default_5 != vec4(0)) return swap_default_5;
	if (distance(tex_color, swap_from_6) < 1.0/256.0 && swap_default_6 != vec4(0)) return swap_default_6;
	if (distance(tex_color, swap_from_7) < 1.0/256.0 && swap_default_7 != vec4(0)) return swap_default_7;
	if (distance(tex_color, swap_from_8) < 1.0/256.0 && swap_default_8 != vec4(0)) return swap_default_8;
	if (distance(tex_color, swap_from_9) < 1.0/256.0 && swap_default_9 != vec4(0)) return swap_default_9;
	if (distance(tex_color, swap_from_10) < 1.0/256.0 && swap_default_10 != vec4(0)) return swap_default_10;
	if (distance(tex_color, swap_from_11) < 1.0/256.0 && swap_default_11 != vec4(0)) return swap_default_11;
	if (distance(tex_color, swap_from_12) < 1.0/256.0 && swap_default_12 != vec4(0)) return swap_default_12;
	if (distance(tex_color, swap_from_13) < 1.0/256.0 && swap_default_13 != vec4(0)) return swap_default_13;
	if (distance(tex_color, swap_from_14) < 1.0/256.0 && swap_default_14 != vec4(0)) return swap_default_14;
	if (distance(tex_color, swap_from_15) < 1.0/256.0 && swap_default_15 != vec4(0)) return swap_default_15;
	if (distance(tex_color, swap_from_16) < 1.0/256.0 && swap_default_16 != vec4(0)) return swap_default_16;
	if (distance(tex_color, swap_from_17) < 1.0/256.0 && swap_default_17 != vec4(0)) return swap_default_17;
	if (distance(tex_color, swap_from_18) < 1.0/256.0 && swap_default_18 != vec4(0)) return swap_default_18;
	if (distance(tex_color, swap_from_19) < 1.0/256.0 && swap_default_19 != vec4(0)) return swap_default_19;
	if (distance(tex_color, swap_from_20) < 1.0/256.0 && swap_default_20 != vec4(0)) return swap_default_20;
	if (distance(tex_color, swap_from_21) < 1.0/256.0 && swap_default_21 != vec4(0)) return swap_default_21;
	if (distance(tex_color, swap_from_22) < 1.0/256.0 && swap_default_22 != vec4(0)) return swap_default_22;
	if (distance(tex_color, swap_from_23) < 1.0/256.0 && swap_default_23 != vec4(0)) return swap_default_23;
	if (distance(tex_color, swap_from_24) < 1.0/256.0 && swap_default_24 != vec4(0)) return swap_default_24;
	if (distance(tex_color, swap_from_25) < 1.0/256.0 && swap_default_25 != vec4(0)) return swap_default_25;
	if (distance(tex_color, swap_from_26) < 1.0/256.0 && swap_default_26 != vec4(0)) return swap_default_26;
	if (distance(tex_color, swap_from_27) < 1.0/256.0 && swap_default_27 != vec4(0)) return swap_default_27;
	if (distance(tex_color, swap_from_28) < 1.0/256.0 && swap_default_28 != vec4(0)) return swap_default_28;
	if (distance(tex_color, swap_from_29) < 1.0/256.0 && swap_default_29 != vec4(0)) return swap_default_29;
	return tex_color;
}

vec4 swap(vec4 tex_color, vec4 default_color) {
	if (distance(tex_color, swap_from_0) < 1.0/256.0 && swap_to_0 != vec4(0)) return swap_to_0;
	if (distance(tex_color, swap_from_1) < 1.0/256.0 && swap_to_1 != vec4(0)) return swap_to_1;
	if (distance(tex_color, swap_from_2) < 1.0/256.0 && swap_to_2 != vec4(0)) return swap_to_2;
	if (distance(tex_color, swap_from_3) < 1.0/256.0 && swap_to_3 != vec4(0)) return swap_to_3;
	if (distance(tex_color, swap_from_4) < 1.0/256.0 && swap_to_4 != vec4(0)) return swap_to_4;
	if (distance(tex_color, swap_from_5) < 1.0/256.0 && swap_to_5 != vec4(0)) return swap_to_5;
	if (distance(tex_color, swap_from_6) < 1.0/256.0 && swap_to_6 != vec4(0)) return swap_to_6;
	if (distance(tex_color, swap_from_7) < 1.0/256.0 && swap_to_7 != vec4(0)) return swap_to_7;
	if (distance(tex_color, swap_from_8) < 1.0/256.0 && swap_to_8 != vec4(0)) return swap_to_8;
	if (distance(tex_color, swap_from_9) < 1.0/256.0 && swap_to_9 != vec4(0)) return swap_to_9;
	if (distance(tex_color, swap_from_10) < 1.0/256.0 && swap_to_10 != vec4(0)) return swap_to_10;
	if (distance(tex_color, swap_from_11) < 1.0/256.0 && swap_to_11 != vec4(0)) return swap_to_11;
	if (distance(tex_color, swap_from_12) < 1.0/256.0 && swap_to_12 != vec4(0)) return swap_to_12;
	if (distance(tex_color, swap_from_13) < 1.0/256.0 && swap_to_13 != vec4(0)) return swap_to_13;
	if (distance(tex_color, swap_from_14) < 1.0/256.0 && swap_to_14 != vec4(0)) return swap_to_14;
	if (distance(tex_color, swap_from_15) < 1.0/256.0 && swap_to_15 != vec4(0)) return swap_to_15;
	if (distance(tex_color, swap_from_16) < 1.0/256.0 && swap_to_16 != vec4(0)) return swap_to_16;
	if (distance(tex_color, swap_from_17) < 1.0/256.0 && swap_to_17 != vec4(0)) return swap_to_17;
	if (distance(tex_color, swap_from_18) < 1.0/256.0 && swap_to_18 != vec4(0)) return swap_to_18;
	if (distance(tex_color, swap_from_19) < 1.0/256.0 && swap_to_19 != vec4(0)) return swap_to_19;
	if (distance(tex_color, swap_from_20) < 1.0/256.0 && swap_to_20 != vec4(0)) return swap_to_20;
	if (distance(tex_color, swap_from_21) < 1.0/256.0 && swap_to_21 != vec4(0)) return swap_to_21;
	if (distance(tex_color, swap_from_22) < 1.0/256.0 && swap_to_22 != vec4(0)) return swap_to_22;
	if (distance(tex_color, swap_from_23) < 1.0/256.0 && swap_to_23 != vec4(0)) return swap_to_23;
	if (distance(tex_color, swap_from_24) < 1.0/256.0 && swap_to_24 != vec4(0)) return swap_to_24;
	if (distance(tex_color, swap_from_25) < 1.0/256.0 && swap_to_25 != vec4(0)) return swap_to_25;
	if (distance(tex_color, swap_from_26) < 1.0/256.0 && swap_to_26 != vec4(0)) return swap_to_26;
	if (distance(tex_color, swap_from_27) < 1.0/256.0 && swap_to_27 != vec4(0)) return swap_to_27;
	if (distance(tex_color, swap_from_28) < 1.0/256.0 && swap_to_28 != vec4(0)) return swap_to_28;
	if (distance(tex_color, swap_from_29) < 1.0/256.0 && swap_to_29 != vec4(0)) return swap_to_29;
	return default_color;
}

float get_pixel_emission(vec4 tex_color) {
	if (distance(tex_color, emission_color_0) < 1.0/256.0 && emission_color_0 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_1) < 1.0/256.0 && emission_color_1 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_2) < 1.0/256.0 && emission_color_2 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_3) < 1.0/256.0 && emission_color_3 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_4) < 1.0/256.0 && emission_color_4 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_5) < 1.0/256.0 && emission_color_5 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_6) < 1.0/256.0 && emission_color_6 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_7) < 1.0/256.0 && emission_color_7 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_8) < 1.0/256.0 && emission_color_8 != vec4(0)) return 1.0;
	if (distance(tex_color, emission_color_9) < 1.0/256.0 && emission_color_9 != vec4(0)) return 1.0;
	return 0.0;
}

void fragment() {
	vec2 uv = UV;
	if (wave_amplitude > 0.0) {
		float clip_width = wave_max_u - wave_min_u;
		float clip_height = wave_max_v - wave_min_v;
		uv.x = min(wave_max_u, max(wave_min_u, uv.x + clip_width * wave_amplitude * sin(TIME * wave_t_frequency + (uv.y - wave_min_v) * wave_v_frequency / clip_height)));
	}
	
	vec4 albedo_tex = texture(texture_albedo,uv);
	if (flags_albedo_tex_force_srgb) {
		albedo_tex.rgb = mix(pow((albedo_tex.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),albedo_tex.rgb.rgb * (1.0 / 12.92),lessThan(albedo_tex.rgb,vec3(0.04045)));
	}
	float pixel_emission = 0.0;
	bool pixel_sparkles = false;
	if (albedo_tex.a >= 1.0/256.0) {
		pixel_emission = get_pixel_emission(albedo_tex);
		vec4 default_color = swap_defaults(albedo_tex);
		pixel_sparkles = sparkle && is_sparkle_region(albedo_tex);
		albedo_tex = mix(default_color, swap(albedo_tex, default_color), swap_blend);
	}

	
	vec2 frame_uv = vec2((uv.x - wave_min_u) / (wave_max_u - wave_min_u), (uv.y - wave_min_v) / (wave_max_v - wave_min_v));
	vec2 overlay_uv = vec2(fract(frame_uv.x + overlay_scroll_rate.x * TIME), fract(frame_uv.y + overlay_scroll_rate.y * TIME));
	vec4 overlay_tex = texture(texture_overlay, overlay_uv).rgba;
	float overlay_a = overlay_opacity * overlay_tex.a;
	
	ALBEDO = albedo.rgb * (albedo_tex.rgb * (1.0 - overlay_a) + overlay_tex.rgb * overlay_a);
	
	float pixel_glow = 0.0;
	float static_pos = mod(static_offset + static_speed * TIME + static_amount, 1.0 + 2.0 * static_amount) - static_amount;
	if (abs(frame_uv.y - static_pos) < static_amount) {
		uint seed = hash(uint(vertex_pixel.y + 10000.0)) ^ hash(uint(vertex_pixel.x + 10000.0)) ^ hash(uint(TIME * 1000.0));
		ALBEDO = vec3(rand_from_seed(seed));
		if (abs(frame_uv.y - static_pos - static_amount) < static_border) {
			pixel_glow = static_border/abs(frame_uv.y - static_pos - static_amount) - 1.0;
			ALBEDO += vec3((static_border - abs(frame_uv.y - static_pos - static_amount)));
		}
		if (abs(frame_uv.y - static_pos + static_amount) < static_border) {
			pixel_glow = static_border/abs(frame_uv.y - static_pos + static_amount) - 1.0;
			ALBEDO += vec3((static_border - abs(frame_uv.y - static_pos + static_amount)));
		}
	} else if (pixel_sparkles) {
		uint seed = hash(uint(floor(vertex_pixel.y) * 10000.0 + floor(vertex_pixel.x)));
		float t = mod(TIME + rand_from_seed(seed) * sparkle_period, sparkle_period / sparkliness) / sparkle_period;
		pixel_glow += exp(- t * sparkle_falloff) * sparkle_amplitude;
	}
	
	float metallic_tex = dot(texture(texture_metallic,uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	float roughness_tex = dot(texture(texture_roughness,uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	
	vec3 emission_tex = texture(texture_emission,uv).rgb;
	EMISSION = (emission.rgb+emission_tex)*emission_energy + (glow + pixel_glow + pixel_emission) * ALBEDO;
	
	ALPHA = albedo.a * albedo_tex.a;
	ALPHA_SCISSOR = alpha_scissor_threshold;
}
