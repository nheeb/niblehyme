// NOTE: Shader automatically converted from Godot Engine 4.2.2.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;

varying vec3 world_pos;

uniform vec3 emission_color: source_color;
uniform float time_scale = 8.0;
uniform float noise_strength = 3.0;
uniform float visibility_progress: hint_range(0.0, 1.0) = 1.0;

uniform sampler2D noise;

global uniform float holo_world_scale;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz * holo_world_scale;
	float noise_xz = texture(noise, world_pos.xz * 10.0).r;
	VERTEX += vec3(noise_xz-.5) * 3.0 * (1.0-visibility_progress);
}

void fragment() {
	float noise_xz = texture(noise, world_pos.xz).r;
	float t = TIME * time_scale;
	float holo_value = .5 * sin(world_pos.y * 20.0 - t + noise_xz * noise_strength) + .5;
	ALPHA = pow(holo_value, .7);
	ALBEDO = albedo.rgb;
	vec3 em = mix(emission_color, albedo.rgb, .5);
	EMISSION = em * pow(smoothstep(.5, .9, holo_value), 2.0) * 0.1
			+ em * pow(smoothstep(.8, .99, holo_value), 3.0) * 0.6;
	ALPHA *= pow(texture(noise, SCREEN_UV * 2.0).r, 1.0);
	ALPHA *= visibility_progress;
}
